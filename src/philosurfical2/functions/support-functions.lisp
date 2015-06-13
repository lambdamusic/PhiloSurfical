;;; definition of general string conversion functions
(in-package :cl-user)




;;-michele's functions
;;; ------------------------------------------------------------------------------------------------------


(defun make-it-ocml (s)
  (format nil "ocml::~A" s))


(defun number-length (z)
"Simple function that gives the length of a number expressed in decimal form"
  (length (remove #\. (write-to-string z))))


(defun list-to-vector (list)
"Give out a vector from a list"
  (let* ((length (length list))
         (vec (make-array length)))
    (dotimes (i length)
      (setf (aref vec i) (pop list)))
    vec))         


;; need also a function to take away the ocml:: ??

(defun pretty-look (str)
"Fucntion to make the ugly OCML names look pretty - for now it just eliminates hyphens"
    (if str
        (let ((new-string (make-string (length str))))   ;; if u dont create a new string, it always modifies the original one!!!
          (dotimes (i (length str))
            (if (char= (aref str i) #\-)
                (setf (aref new-string i) #\Space)
              (setf (aref new-string i) (aref str i))))
          (format nil "~a" new-string))))    ;; format nil or format t ???



(defun pretty-link (str)
"Sets any - into an + .. useful for the links generation"
    (if str
        (let ((new-string (make-string (length str))))  
          (dotimes (i (length str))
            (if (char= (aref str i) #\-)
                (setf (aref new-string i) #\+)
              (setf (aref new-string i) (aref str i))))
          (format nil "~a" new-string))))    ;; format nil or format t ???





;; {{{{{{{{{{{{{{{{{{{{{
;; STRING SIMILARITY FUNCTIONs
;; ++++++++++++++


;;=============== this is the one to use =====================

;;this one is based on morphological similarity
(defun morph-sentence-similarity? (x y limit)
  (let ((similarity (similar-sentences? x y)))
    (values  (if (> similarity limit)
                    t
                  nil))))
;; ----------------------------------------------------------


;;character based, for words
(defun char-word-similarity? (x y limit)
  (multiple-value-bind (strict nostrict)
    (similar? x y)
    (values    (if (>= nostrict limit)
                    t
                  nil))))
;;character based, for sentences
(defun char-sentence-similarity? (x y limit)
  (let ((similarity (similar-words? x y)))
    (values  (if (> similarity limit)
                    t
                  nil))))







(defun simple-tokenizer (s)
"ELIMINATES PUNCTUATION AND SPACES AT THE BEGINNING"
  (remove-if #'(lambda (x) (or (equal x "of")
                               (equal x "by")
                               (equal x "the")
                               (equal x "a")
                               (equal x "an")
                               (equal x "from")))
                 (cl-ppcre:split "\\s+" 
                                 (string-left-trim " " 
                                                   (remove-if-not #'(lambda (x) (or (char= x #\Space)  ;; SPACE IS GOOD TOO
                                                                                    (both-case-p x)))
                                                                  (string-downcase s))))))




;; for two words
(defun similar? (s1 s2)
"Tests two strings on the level of charachter similarity, and outputs the ratio of similar letters to total of letters"
(let* ((temp (if (> (length s1) (length s2))
                   s2
                  s1))
       (minor-s (string-downcase temp))
       (major-s (string-downcase (first (remove temp (list s1 s2)))))
       (store "")
       (difference major-s)) ;; at the beginning
  (loop for char across minor-s
        do
        (let ((times (length difference)))
          (dotimes (i times)
            (if (char= char (elt difference i))
                (return (setf difference (remove char difference :end (+ i 1)))))
            (if (equal i (- times 1))
                (return (setf store (with-output-to-string (s) 
                               (princ char s)
                               (format s "~a" store))))))))
  (let* ((bigdiff (concatenate 'string difference store))
        (total (+ (length minor-s) (length major-s)))
        (clean-diff (remove-if-not #'alpha-char-p (remove #\Space bigdiff)))
        (clean-total (length (remove-if-not #'alpha-char-p (remove #\Space (concatenate 'string minor-s major-s))))))
    (values (float (* (- total (length bigdiff)) ;; with punctuation
                     (/ 100 total)))
            (float (* (- clean-total (length clean-diff))   ;;without punctuation
                     (/ 100 clean-total)))))))
        
;; for two sentences....use it with result > 0
(defun similar-words? (x y)
"Applies the similarity comparison only at the word level!
If the output if major than 0 at lest one word is equal (or similar at the 80%) to the other ones"
(let* ((temp (if (> (length (simple-tokenizer x)) (length (simple-tokenizer y)))
                    x
                   y))
       (major (simple-tokenizer temp))
       (diff major)
       (minor (simple-tokenizer (first (remove temp (list x y))))))
  (loop for el1 in minor
        do
        (let ((times (length diff)))
          (dotimes (n times)
            (if (char-word-similarity? el1 (nth n diff) 90)    ;; we try with 90%  
                (return (setf diff (remove-if #'(lambda (x) 
                                                  (char-word-similarity? el1 x 80))                                                                                               diff :count 1)))))))
  (values (float (* (- (length major) (length diff))
                    (/ 100 (length major)))))))










;; --> this one checks the SEQUENCE of characters too
(defun morphologically-similar? (word1 word2)
"Outputs a list (= yes) if two words contain each other at least for the 50percent of the longest one"
(let* ((temp (if (> (length word1) (length word2))
                   word2
                  word1))
       (minor-s (string-downcase temp))
       (major-s (string-downcase (first (remove temp (list word1 word2)))))
       (out '()))
  (if (> (length minor-s) (/ (length major-s) 2))
      (if (search minor-s major-s)
          (setf out (append (list minor-s) out))
        (setf out (append (morphologically-similar? (subseq minor-s 1) major-s) out))))
  out))
  


;; used with morphological similarity
(defun similar-sentences? (x y)
"Applies the similarity comparison only at the word level!
If the output if major than 0 at lest one word is equal (or similar at the 80%) to the other ones"
(let* ((temp (if (> (length (simple-tokenizer x)) (length (simple-tokenizer y)))
                    x
                   y))
       (major (simple-tokenizer temp))
       (diff major)
       (minor (simple-tokenizer (first (remove temp (list x y))))))
  (loop for el1 in minor
        do
        (let ((times (length diff)))
          (dotimes (n times)
            (if (morphologically-similar? el1 (nth n diff))
                ;; debug--> (progn (format t "~%~a sim-to-->~a "el1 (nth n diff) )
                  (return (setf diff (remove-if #'(lambda (x) 
                                                  (morphologically-similar? el1 x))                                                                                               diff :count 1)))))))
  (values (float (* (- (length major) (length diff))
                    (/ 100 (length major)))))))






;; }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}






















;;;;;;;;;; OTHER  FUCNTIONS
;;; ------------------------------------------------------------------------------------------------------
;;; string conversions

;;; function for conversion of a string into a symbol
(defun str2sym (str &optional start)

  (if start (with-input-from-string (s str :start start) (read s))
    (with-input-from-string (s str) (read s))))

;;; function for conversion of a symbol to a string
(defun sym2str (sym) (format nil "~A" sym))

;;; function for conversion of a symbol to a lowercase string
(defun sym2lcstr (sym) (format nil "~(~A~)" sym))

;;; sym2ucstr
(defun sym2ucstr (sym)

  (let* ((str (format nil "~A" sym))
         (m (- (length str) 1)))
    (loop for i from 0 to m
          
          ;;; variable initialization
          with filtered-string = ""
          
          do (cond
              ;;; #\- -> #\Space
              ((equal (char str i) '#\-)
               (setf filtered-string (concatenate 'string filtered-string " ")))
              
              ;;; no need to filter
              (t 
               (setf filtered-string (concatenate 'string filtered-string (string (char str i)))))
              )
          finally return (string-downcase filtered-string :start 1)
          )))


;;; list to string
(defun list2str (list &optional (separator " "))

  (let ((result nil))

    (dolist (item list)
      (setf result (concatenate 'string result (format nil "~S"  item) separator)))

    (if result (string-right-trim " " result) result)))


;;; conv-2_
(defun conv-2_ (str)

  (let* ((m (- (length str) 1)))
    (loop for i from 0 to m
          
          ;;; variable initialization
          with filtered-string = ""
          
          do (cond
              ;;; #\- -> #\_
              ((equal (char str i) '#\-)
               (setf filtered-string (concatenate 'string filtered-string "_")))
              
              ;;; no need to filter
              (t 
               (setf filtered-string (concatenate 'string filtered-string (string (char str i)))))
              )
          finally return  filtered-string
          )))


;;; convsp2_
(defun convsp2_ (str)

  (let* ((m (- (length str) 1)))
    (loop for i from 0 to m
          
          ;;; variable initialization
          with filtered-string = ""
          
          do (cond
              ;;; ' ' -> #\_
              ((equal (char str i) '#\ )
               (setf filtered-string (concatenate 'string filtered-string "_")))
              
              ;;; no need to filter
              (t 
               (setf filtered-string (concatenate 'string filtered-string (string (char str i)))))
              )
          finally return  filtered-string
          )))


;;; conv_2-
(defun conv_2- (str)

  (let* ((m (- (length str) 1)))
    (loop for i from 0 to m
          
          ;;; variable initialization
          with filtered-string = ""
          
          do (cond
              ;;; #\_ -> #\-
              ((equal (char str i) '#\_)
               (setf filtered-string (concatenate 'string filtered-string "-")))
              
              ;;; no need to filter
              (t 
               (setf filtered-string (concatenate 'string filtered-string (string (char str i)))))
              )
          finally return  filtered-string
          )))


;;; str2strs
(defun str2strs (str &optional (separator '#\Space))

  (let* ((m (- (length str) 1)))
    (loop for i from 0 to m
          
          ;;; variable initialization
          with result = nil and sub-string = ""
          
          do (progn
              
              ;;; not seperator
              (if (not (equal (char str i) separator))
                  (setf sub-string (concatenate 'string sub-string (string (char str i)))))

              ;;; separator
              (if (or (equal (char str i) separator) (= i m))
                  (progn
                    (setf result (append result (list sub-string)))
                    (setf sub-string ""))))
          finally return  result
          )))


;;; converts nil into '' string
(defun nil2str (str)

  (if str str ""))


;;; converts nil into 'None' string
(defun nil2none (str)

  (if str str "None"))

;;; converts '' into nil
(defun str2nil (str)

  (if (string-equal str "") nil str))


;;; java applet decode string
(defun decode-applet-string (str)

  (let* ((m (- (length str) 1)))
    (loop for i from 0 to m
          
          ;;; variable initialization
          with filtered-string = ""
          
          do (cond
              ;;; special sequences
              ((and (equal (char str i) '#\\) (< i m))
               (case (char str (+ i 1))
                 ('#\/ (setf filtered-string (concatenate 'string filtered-string "\\\\"))
                       (incf i))
                 ('#\" (setf filtered-string (concatenate 'string filtered-string "\\\""))
                       (incf i))
                 ('#\! (setf filtered-string (concatenate 'string filtered-string "|"))
                       (incf i))
                 ('#\{ (setf filtered-string (concatenate 'string filtered-string ")"))
                       (incf i))
                 ('#\} (setf filtered-string (concatenate 'string filtered-string "("))
                       (incf i))
                 ('#\- (setf filtered-string (concatenate 'string filtered-string " "))
                       (incf i))))

              ((equal (char str i) '#\_)
               (setf filtered-string (concatenate 'string filtered-string "-")))
              
              ;;; no need to filter
              (t (setf filtered-string (concatenate 'string filtered-string (string (char str i))))))
          finally return filtered-string)))


;;; is-substring test function
(defun is-substring (substring string)
  
  (let ((string-length (length string))
        (substring-length (length substring)))

    (loop for i from 0 to (- string-length substring-length)
          
          ;;; variable initialization
          with result = nil
          ;;; the main test
          do (cond
              ((not (member (string-equal substring string
                                          :start2 i
                                          :end2 (+ i substring-length))
                            (list 0 nil) :test #'eq))
               (setf result i))
              ((= string-length substring-length 0)
               (setf result t)))
          ;;; output
          finally return result
          )))


;;; filtration of #\Newline
(defun filtrate-newline (str)

  (let ((m (- (length str) 1)))
    (loop for i from 0 to m
          
          ;;; variable initialization
          with filtered-string = ""
          
          do (cond
              
              ;;; #\Newline -> %0D%0A
              ((equal (char str i) '#\Newline))

              ;;; no need to filter
              (t 
               (setf filtered-string (concatenate 'string filtered-string (string (char str i)))))
              )
          finally return filtered-string
          )))


;;; parse strings enclosed in brackets
(defun parse-bracketed-string (str &optional (remove-char-n 0))

  (let ((m (- (length str) 1)))

    (loop for i from (+ 0 remove-char-n) to (- m remove-char-n)
          
          ;;; variable initialization
          with result = nil and sub-string = "" and bracket-n = 0
          
          do (progn

               ;;; string is added into sub-string
               (setf sub-string (concatenate 'string sub-string (string (char str i))))

               ;;; left bracket
               (if (equal (char str i) '#\() (incf bracket-n))

               ;;; right bracket
               (if (equal (char str i) '#\)) (decf bracket-n))

               ;;; bracketed substring finished
               (if (and (equal (char str i) '#\)) (= bracket-n 0))
                   (progn
                    (setf result (append result (list sub-string)))
                    (setf sub-string ""))))

          finally return  result
          )))


;;; replaces (:rel ?x ?x) with (rel ?x) - recursion
(defun replace-defined-relations (str)

  (let ((m (- (length str) 1))
        (one-char nil))

    (loop for i from 0 to m
          
          ;;; variable initialization
          with result = "" and sub-string = "" and is-colon-p = nil
          
          do (progn

               ;;; retrieve character
               (setf one-char (char str i))

               ;;; beginning of the defined relation
               (if (and (equal one-char '#\() (equal (char str (+ i 1)) '#\:))
                   (setf is-colon-p t))

               ;;; storage of the string
               (if is-colon-p
                   (setf sub-string (concatenate 'string sub-string (string one-char)))
                 (setf result (concatenate 'string result (string one-char))))

               ;;; end of the defined relation
               (if (and (equal one-char '#\)) is-colon-p)
                   (setf is-colon-p nil
                         result (concatenate 'string result (parse-defined-relation sub-string))
                         sub-string "")))

          finally return result
          )))


;;; parse defined relation
(defun parse-defined-relation (str)

  (let* ((filtered-str (remove-if #'(lambda (x) (if (or (equal x '#\:) (equal x '#\*)) t nil))
                                  str))
         (str-symbol (str2sym filtered-str))
         (i 0)
         (result nil))

    ;;; removal of original variables
    (dolist (term str-symbol)

      (if (oddp (incf i)) (setf result (append result (list term)))))

    ;;; output value
    (format nil "~S" result)))


;;; parse called runner relation
(defun parse-runner-relation (str)

  (let* ((filtered-str (remove-if #'(lambda (x) (if (or (equal x '#\:) (equal x '#\*)) t nil))
                                  (format nil "~S" str)))
         (str-symbol (str2sym filtered-str))
         (i 0)
         (result (list (car str-symbol))))

    ;;; removal of original variables
    (dolist (term (cdr str-symbol))

      (if (evenp (incf i)) (setf result (append result (list term)))))

    ;;; output value
    (format nil "~S" result)))


;;; retrieve output variable of the runner relation
(defun retrieve-runner-output (query)

  (let* ((query-variables (cdr (str2sym query)))
         (result (mapcan #'(lambda (x) (when (equal '#\? (char (sym2str x) 0)) (list x)))
                         query-variables)))

    (string-trim "()" (sym2str result))))


;;; replace #\- with #\Space and capitalize the first letter
(defun replace-and-capitalize (str)

  (string-capitalize (string-downcase (substitute #\Space #\- str)) :end 1))


#|  
i commented this out on 28/1/07 cause it conflicts with the new hunchentoot server!!! - mikele 
(the new url-decode is defined on hunchentoot/util

;;; string decoding
(defun url-decode (str)

  (let ((m (- (length str) 1)))
    (loop for i from 0 to m
          
          ;;; variable initialization
          with filtered-string = ""
          
          do (cond
              ;;; + -> #\Space
              ((equal (char str i) '#\+) 
               (setf filtered-string (concatenate 'string filtered-string (string #\Space))))
              
              ;;; %0D%0A -> #\Newline
              ((and (plusp (- m i 4)) 
                    (equal (char str i) '#\%) 
                    (equal (char str (+ i 1)) '#\0) 
                    (equal (char str (+ i 2)) '#\D) 
                    (equal (char str (+ i 3)) '#\%) 
                    (equal (char str (+ i 4)) '#\0) 
                    (equal (char str (+ i 5)) '#\A)) 
               (setf filtered-string (concatenate 'string filtered-string (string #\Newline)) 
                     i (+ i 5)))

              ;;; filter character "~"
              ((and (plusp (- m i 1)) 
                    (equal (char str i) '#\%) 
                    (equal (char str (+ i 1)) '#\7) 
                    (equal (char str (+ i 2)) '#\E))
               (setf i (+ i 2)))
              
              
              ;;; %HH -> ASCII character defined by hexa number (HH)
              ((and (plusp (- m i 1)) 
                    (equal (char str i) '#\%)) 
               (setf filtered-string (concatenate 'string filtered-string 
                                                  (string (int-char 
                                                           (+ (* (x-to-x (char str (+ i 1))) 16) 
                                                              (x-to-x (char str (+ i 2))))))) 
                     i (+ i 2)))

              ;;; no need to filter
              (t 
               (setf filtered-string (concatenate 'string filtered-string (string (char str i)))))
              )
          finally return filtered-string)))
|#

;;; 'hexadecimal number as a character' to 'decimal number'
(defun x-to-x (str)
  (let ((aux (char-int str)))
    (cond
     ((and (>= aux 48) (<= aux 57)) (- aux 48))
     ((and (>= aux 65) (<= aux 70)) (- aux 55))
     (t 0))))



;;; ------------------------------------------------------------------------------------------------------
;;; list manipulation

;;; adds a new list to an existing llist
(defun add-to-llist (existing-llist new-list)
  (append existing-llist (list new-list)))


;;; process an and llist
(defun process-and-llist (and-llist)
  (let ((result nil))
    (setf result (car and-llist))
    (dolist (item (cdr and-llist))
      (setf result (intersection result item :key #'car)))
    result))


;;; process an or llist
(defun process-or-llist (or-llist)
  (let ((result nil))
    (setf result (car or-llist))
    (dolist (item (cdr or-llist))
      (setf result (union result item :key #'car)))
    result))


;;; intersection of list of lists
(defun lol-intersection (list)

  (if (not (cdr list)) (car list) (intersection (car list) (lol-intersection (cdr list)))))


;;; union of list of lists
(defun lol-union (list)

  (if (not (cdr list)) (car list) (union (car list) (lol-union (cdr list)))))


;;; find value in a list of values according to position of a string in a list of strings
(defun find-coupled-value (str value-list string-list)
  
  (nth (- (length string-list) (length (member str string-list :test #'string-equal))) value-list))


;;; find next item in a list according to a reference item
(defun next-item-from-list (reference list &optional (test #'equal))

  (if (and (member reference list :test test) (<= (position reference list :test test)
                                                  (length list)))

      (nth (+ (position reference list :test test) 1) list)

    nil))


;;; find previous item in a list according to a reference item
(defun previous-item-from-list (reference list &optional (test #'equal))

  (if (and (member reference list :test test) (> (position reference list :test test) 0))

      (nth (- (position reference list :test test) 1) list)

    nil))


;;; create list of length 'length' where values are increments of 'number'
;;; (create-incf-numbers-list 1 5) -> '(1 2 3 4 5)
(defun create-incf-number-list (first-number list-length &key (increment 1))

  (let ((number first-number)
        (output (list first-number)))

    (dotimes (i (decf list-length) output)
      (setf output (append output (list (incf number increment)))))))


;;; decomposition of list into number of lists according to elements' positions
(defun decompose-list (original-list decomposition-number &optional (nth-sublist nil))

  (if (and (plusp decomposition-number) (integerp decomposition-number))

      (let ((output-list (make-list decomposition-number))
            (i 0))
        
        (dolist (item original-list)
          (push item (nth i output-list))
          (if (= (- (incf i) decomposition-number) 0) (setf i 0)))

        ;;; reverse each sublist
        (setf output-list (mapcar #'reverse output-list))
        
        ;;; decomposed lists
        (if nth-sublist (nth nth-sublist output-list) output-list))
    
    ;;; otherwise
    nil))


;;; maximal number in a list
(defun max-list (list)

  (if list (eval `(max ,@list)) 0))

        
;;; find hashtable key according to presence of a value in a corresponding hashtable value
(defun find-hash-key (item table)
  
  (loop for key being each hash-key of table using (hash-value value)

      with output = nil

      do (when (member item value) (setf output key))

      finally return output))


;;; find all hash keys
(defun get-all-hash-keys (table)

  (loop for key being each hash-key of table collect key))


;;; unnecessary parenthese are removed from an expression
(defun remove-unnecessary-parentheses (expression)

  (first (rup-recursion (list expression))))


;;; recursive function for a removal of unnecessary parentheses
(defun rup-recursion (expression)

  (let ((result nil)
        (temp nil))

    (if (listp expression)
        ;;; expression is a list of atoms
        (setf result
              (mapcar #'(lambda (x)
                          ;;; recursion
                          (setf temp (rup-recursion x))
                          ;;; if expression looks like '((a)), than (a) only, otherwise all
                          (if (and (listp temp) (= 1 (length temp)) (listp (first temp)))
                              (first temp) temp))
                      expression))

      ;;; expression is an atom
      (setf result expression))

    ;;; output
    result))


;;; join list of strings together as one string
(defun join-string-list (string-list)
    (format nil "~{~A~^ ~}" string-list)) 


;;; coversion of t/nil to yes/no
(defun tnil2yesno (logical-value)

  (if logical-value "yes" "no"))


;;; non-destructive mapcan
(defmacro nd-mapcan (&body body) `(apply #'append (mapcar ,@body)))


;;; obtain parameter multiple values
(defun parameter-mv (parameter-name parameters)

  (loop for parameter in parameters
        when (string-equal (car parameter) parameter-name) collect (cdr parameter)))


;;; concatenate list of string
(defun conc-s (&rest args)

  (apply #'concatenate (append '(string) args)))


;;; test whether a file is a pictoral file (tests a file's extension only)
(defun picture-p (file &aux (extensions '(".jpg" ".gif")))

  (some #'(lambda (x) (string-equal x file :start2 (- (length file) (length x)))) extensions))


;;; ----------------------------------------------------------------------------------------------

;; TDC


(defun format-datetime-long (&optional (datetime (get-universal-time)) 
                                &aux result second minute hour date month year day-of-week)

  (let ((day-names-list '("Monday" "Tuesday" "Wednesday" "Thursday" "Friday" "Saturday" "Sunday"))
        (month-names-list '("January" "February" "March" "April" "May" "June" "July" 
                                      "August" "September" "October" "November" "December"))
        (date-postfix-list '("st" "nd" "rd" "th" "th" "th" "th" "th" "th" "th" 
                                  "th" "th" "th" "th" "th" "th" "th" "th" "th" "th" 
                                  "st" "nd" "rd" "th" "th" "th" "th" "th" "th" "th"
                                  "st")))

      ;; today
      (multiple-value-bind
          (second-1 minute-1 hour-1 date-1 month-1 year-1 day-of-week-1 dst-p-1 tz-1)
          (decode-universal-time datetime)
        (setq second second-1)
        (setq minute minute-1)
        (setq hour hour-1)
        (setq date date-1)
        (setq month month-1)
        (setq year year-1)
        (setq day-of-week day-of-week-1))
      
      (setq result (format nil "~A, ~D~A ~A ~D @ ~D:~2,'0D."
                           (nth day-of-week day-names-list) 
                           date (nth (- date 1) date-postfix-list) (nth month month-names-list) year
                           hour minute))

  )

  (values result))


(defun format-date-long (&optional (datetime (get-universal-time)) 
                                &aux result date month year day-of-week)

  (let ((day-names-list '("Monday" "Tuesday" "Wednesday" "Thursday" "Friday" "Saturday" "Sunday"))
        (month-names-list '("January" "February" "March" "April" "May" "June" "July" 
                                      "August" "September" "October" "November" "December"))
        (date-postfix-list '("st" "nd" "rd" "th" "th" "th" "th" "th" "th" "th" 
                                  "th" "th" "th" "th" "th" "th" "th" "th" "th" "th" 
                                  "st" "nd" "rd" "th" "th" "th" "th" "th" "th" "th"
                                  "st")))

      ;; today
      (multiple-value-bind
          (second-1 minute-1 hour-1 date-1 month-1 year-1 day-of-week-1 dst-p-1 tz-1)
          (decode-universal-time datetime)
        (setq date date-1)
        (setq month month-1)
        (setq year year-1)
        (setq day-of-week day-of-week-1))
      
      (setq result (format nil "~A, ~D~A ~A ~D."
                           (nth day-of-week day-names-list) 
                           date (nth (- date 1) date-postfix-list) (nth month month-names-list) year))
      
      )
  
  (values result))


(defun format-time (&optional (time (get-universal-time)) 
                              &aux result minute hour postfix)
  
  (multiple-value-bind
      (second-1 minute-1 hour-1 date-1 month-1 year-1 day-of-week-1 dst-p-1 tz-1)
      (decode-universal-time time)
    (setq minute minute-1)
    (setq hour hour-1))
  
  (cond ((< hour 12) 
         (setq postfix "am"))
        (t 
         (setq hour (- hour 12))
         (setq postfix "pm")))

  (setq result (format nil "~D:~2,'0D~A"
                       hour minute postfix))
  
  (values result))



(defun get-date-from-datetime (&optional (datetime (get-universal-time))
                                         &aux date month year)

  (multiple-value-bind
      (second-1 minute-1 hour-1 date-1 month-1 year-1 day-of-week-1 dst-p-1 tz-1)
      (decode-universal-time datetime)
    (setq date date-1)
    (setq month month-1)
    (setq year year-1)
    (setq dst-p dst-p-1)
    (setq tz tz-1))

  (encode-universal-time 0 0 0 date month year tz)

)


(defun get-time-from-datetime (&optional (datetime (get-universal-time))
                                         &aux second minute hour dst-p tz)

  (multiple-value-bind
      (second-1 minute-1 hour-1 date-1 month-1 year-1 day-of-week-1 dst-p-1 tz-1)
      (decode-universal-time datetime)
    (setq second second-1)
    (setq minute minute-1)
    (setq hour hour-1)
    (setq dst-p dst-p-1)
    (setq tz tz-1))

  (when dst-p (setq hour (- hour 1)))
  (encode-universal-time second minute hour 1 1 1900 tz)

)



