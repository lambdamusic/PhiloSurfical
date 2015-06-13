;;; Package: Enrico-Utilities, Mode: Lisp

(in-package "EU")


;;;EQUAL* --- Checks that all elements of a list are equal
(defmacro equal* (l)
  `(every #'(lambda (el)(equal el (car ,l)))
	  (cdr ,l)))

    
(defmacro filter (l test)
  `(remove-if-not ,test ,l))

(defun filter* (tree test)
  (cond ((atom tree)
          (and (funcall test tree)(list tree)))
         (t
          (union (filter* (car tree) test)
	         (filter* (cdr tree) test)))))

(defun order-filter (tree test)
  (cond ((atom tree)
          (and (funcall test tree)(list tree)))
         (t
          (delete-duplicates (append (order-filter (car tree) test)
                                     (order-filter (cdr tree) test))))))

;;;FILTER-ORDERED-LIST --- Takes a sequence where the elements are
;;;sorted according to some criterion, finds the first element which 
;;;fails <test>, and then returns the subseq comprising all the elements 
;;;of the sequence up to the element which failed the test.
;;;Example: (filter-ordered-list '(1 2 5 f r) #'numberp) -> (1 2 5)
(defun filter-ordered-list (list test)
  (when list 
    (subseq list 0 (position-if-not test list))))

(defun translate-tree (query &key ok action condition)
  (cond ((funcall ok query)
         query)
        ((funcall condition query)
	 (funcall action query))
        (t (let ((a (translate-tree (car query)
                                    :ok ok
                                    :action action :condition condition))
                 (b (translate-tree (cdr query)
                                    :ok ok
                                    :action action :condition condition)))
             (if (and (eq a (car query))
                      (eq b (cdr query)))
                 query
                 (cons a b))))))



(defun right-value (key l &key (test #'eql))
  (cdr (assoc key l :test test)))

(defun (setf right-value) (value key l &key (test #'eql))
  (setf (cdr (assoc key l :test test)) value))

(defun right-value* (item l &key (test #'eql))
  (cadr (Assoc item l :test test)))

(defun left-value (item alist &key (test #'equal))
  (car (rassoc item alist :test test)))

(defun left-value* (item alist &key (test #'equal))
  (car (rassoc (list item) alist :test test)))



(defun push-into-alist (alist key value &key (test #'eql))
  (if (assoc key alist :test test)
      (push value (cdr (assoc key alist :test test)))
      (push (list key value) alist))
  alist)


;;;The function cons* takes a list of elements and a list of lists,
;;;;conses each element to each list and then
;;;appends the results into one list.
(defun cons* (elements lists)
  (mapcan #'(lambda (el)
	    (mapcar #'(lambda (list)
		      (cons el list))
		 lists))
             elements))

(defun append* (list-of-lists list)
  (mapcar #'(lambda (l)
	    (append l list))
             list-of-lists))

(defmacro last-element (l)
  `(car (last ,l)))

(defun pairify (l)
  (when l
    (if (cddr l)
        (cons (subseq l 0 2) (pairify (cddr l)))
        (list l))))

(defun substitute-el (sequence index value)
  (substitute value (elt sequence index) sequence :start index :count 1 :test 'equal))

(defmacro mapcan* (f list &rest more-lists)
  `(apply #'append
          (apply #'mapcar (list ,f ,list ,@more-lists))))

(defun union* (lists &key (test #'eql))
  (when lists
    (union (car lists)
	   (union* (cdr lists) :test test)
	   :test test)))

(defmacro map-over-hash-table (function hash-table)
  `(let (result)
     (maphash #'(lambda (key value)
		  (push (funcall ,function key value)
			result))
	      ,hash-table)
     result))



(defun list-hash-table (hash &optional list-values)
  (map-over-hash-table #'(lambda (key value)
		           (cond ((eq list-values :all)
			          (cons key value))
			         (list-values
			          value)
			         (t
			          key)))
		       hash))



;;;MAP-IF ---This function is like mapcar except that if the application of fun to
;;;a particular element of list does not satisfy test, then nil is returned.
(defun map-if (fun list &optional (test #'identity))
  (loop for el in list
        for value = (funcall fun el)
        for check = (funcall test value)
        while check
	collecting value into result
           finally
            (return
              (when check
                result))))

;;;SET-EQUAL
(defun set-equal (set1 set2 &key (test #'eql))
  (not (set-exclusive-or set1 set2 :test test)))


;;;SAME-SYMBOL --Checks whether two symbols are the same (ignoring package info)
(defun same-symbol (x y)
  (and (symbolp x) (symbolp y)
        (string= (symbol-name x) (symbol-name y))))


(defun minimal-set (instantiations f )
  (let* ((values-map (mapcar f instantiations));;;First, we create a map of values
         (min-value (apply #'min values-map)))  ;;;Then, we find the minimum.
    (mapcan* #'(lambda (i value)
	         (when (= value min-value)   ;;;Finally, we filter the ones that have
                     (list i)))
	     instantiations values-map)))

(defun maximal-set (instantiations f )
  (let* ((values-map (mapcar f instantiations));;;First, we create a map of values
          (max-value (apply #'max values-map)))  ;;;Then, we find the minimum.
    (mapcan* #'(lambda (i value)
	         (when (= value max-value)   ;;;Finally, we filter the ones that have
                     (list i)))
	     instantiations values-map)))


(defun permute (list fun)
  (permuter (car list)(cdr list)fun))

(defun permuter (first rest fun)
  (if rest
      (loop for el in (permute2 first (car rest)fun)
             appending (permuter el (cdr rest) fun))
      (list first)))

(defun permute2(el1 el2 fun)
  (funcall fun el1 el2))


(defun spaces (&optional (n 1) (stream *standard-output*))
  (dotimes (i n)
    (write-char #\space stream)))

(defun lines (&optional (n 1) (stream *standard-output*))
  (dotimes (i n)
    (terpri stream)))


(defun print-with-spaces(n string &rest format-args)
  (format t "~2%")
  (dotimes (i n)
    (princ "-"))
  (spaces)
  ;;;(spaces n)
  (apply #'format `(t ,string ,@format-args)))


(defun notify (string &rest format-args)
  (apply #'format *standard-output* (cons string format-args)))


(defun yes-or-no-menu (title)
  (y-or-n-p title))


;;;STRING-APPEND  ---Appends a number of strings.  When called with no arguments
;;;it returns an empty string
(defun string-append (&rest strings)
  (apply #'concatenate 'string strings))

(defun substring (sub super)
  (Search sub super))


;;;REPLACE-CHAR-WITH-STRING - replaces all occurrences of a character in a string
;;;with another string (new-string)
(defun replace-char-with-string (string char new-string)
  (let ((s-char (format nil "~a"  char)))
    ( replace-char-with-string2 string s-char new-string )))

(defun replace-char-with-string2 (string s-char new-string )
  (let ((pos (search  s-char string )))
    (if pos
      (string-append (subseq  string 0 pos)
                     new-string
                     (replace-char-with-string2 (subseq string (+ 1 pos))
                                             s-char
                                             new-string))
      string)))


(defun url? (string)
  (Let ((l (length string)))
    (when (> l 5)
     (or (string-equal (subseq  string 0 6) "ftp://")
         (when (> l 6)
           (or (string-equal (subseq  string 0 7) "http://")
               (when (> l 7)
                 (string-equal (subseq  string 0 8) "https://"))))))))

;;;;;;;;;;;;;;;;;;;;;;;;;CLOS UTILITIES;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;ENSURE-VANILLA-CLASS --- This function ensures that all classes in <classes> are
;;;specializations of <vanilla-class>
(defun ensure-vanilla-class (classes vanilla-class)
  (Let ((class (find-class vanilla-class)))
    (unless (listp classes)
      (Setf classes (List classes)))
    (if (member-if 
           #'(lambda (x)
                (member class 
                   #+:LISPWORKS(clos::class-precedence-list (find-class x))
                   #+:mcl(ccl::class-precedence-list (find-class x))
                   #+:franz-inc (class-precedence-list (find-class x))
                   ))
                   classes)
      classes
      (append classes (list  vanilla-class)))))


;;;ENSURE-VANILLA-CLASS2 ---Does the same job as the one above, 
;;;but classes are class objects,
;;;rather than names, vanilla-class is the name of a class
(defun ensure-vanilla-class2 (classes  vanilla-class)
  (Let ((class (find-class vanilla-class)))
    (if (some #'(lambda (x)
                  (member class 
                     #+:franz-inc (class-precedence-list x)
                     #+:LISPWORKS(clos::class-precedence-list x)
                     #+:mcl(ccl::class-precedence-list x)
                               ))
              classes)
      (mapcar #'class-name  classes)
      (append (mapcar #'class-name classes) (list  vanilla-class)))))


(defun subclass-of? (class superclass)
  (member superclass 
     #+:franz-inc (class-precedence-list class)
     #+:LISPWORKS(clos::class-precedence-list class)
     #+:mcl(ccl::class-precedence-list class)
          ))

(defun direct-subclasses (class)
   #+:franz-inc (clos:class-direct-subclasses class)
   #+:LISPWORKS(clos::class-direct-subclasses class)
   #+:mcl (ccl::class-direct-subclasses class))

(defun (setf direct-subclasses) (value class)
  #+:franz-inc (setf (clos:class-direct-subclasses class) value)
   #+:LISPWORKS(setf (clos::class-direct-subclasses class) value)
   #+:mcl (setf (slot-value class 'CCL::DIRECT-SUBCLASSES) value))




;;;SUBCLASSES ---Returns all subclasses (direct and indirect) of a class
(defun subclasses (class)
  (let ((subclasses 
         #+:franz-inc (clos:class-direct-subclasses class)
         #+:LISPWORKS (clos::class-direct-subclasses class)
         #+:mcl (ccl::class-direct-subclasses class)
         ))
    (mapcan #'(lambda (x)
                (cons x (subclasses x)))
            subclasses)))

(defun clear-subclasses-slot (class)
    #+:mcl (setf (slot-value class 'CCL::DIRECT-SUBCLASSES) nil)
    #+:LISPWORKS (setf (clos::class-direct-subclasses class) nil))

(defun direct-superclasses (class &optional (structure (find-class class)))
    #+:franz-inc (clos:class-direct-superclasses structure)
  #+:LISPWORKS(clos::class-direct-superclasses structure)
  #+:mcl (ccl::class-direct-superclasses structure))

;;(defun create-directory  (directory) 
;;  #+:mcl (if (CCL::DIRECTORY-EXISTS-P directory)
;;          directory
;;          (ccl:create-directory directory)))
                       

(defun create-directory (directory) 
 #+:lispworks
 (ensure-directories-exist directory)
 #+:mcl (if (CCL::DIRECTORY-EXISTS-P directory)
 directory
 (ccl:create-directory directory)))




(defun remove-subclass (class superclasses)
  (loop for super in superclasses
        do
        #+:franz-inc (setf (class-direct-subclasses super)
                           (remove class (class-direct-subclasses super)))
        
        #+:LISPWORKS (setf (clos::class-direct-subclasses super)
                           (remove class (clos::class-direct-subclasses super)))
        
        
        #+:mcl (setf (slot-value super 'CCL::DIRECT-SUBCLASSES)
                     (remove class (slot-value super 'CCL::DIRECT-SUBCLASSES)))))

(defun class-precedence-list (class)
  #+:LISPWORKS(clos::class-precedence-list class)
  #+:mcl(ccl::class-precedence-list class)
  #+franz-inc (slot-value class 'clos:class-precedence-list)
  )

(defun init-arg-value (key init-alist)
  (let ((pos (Position key init-alist)))
    (when pos
      (elt  init-alist (1+ pos)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;Macro SUPPRESSING-WARNINGS
;(defmacro suppressing-warnings (&body forms)
;  `(flet ((warn (datum &rest args) (cons datum args)))
;     ,@forms))

  

;;;RECORD-SOURCE-FILE
(defun record-source-file (name type)
  (let ((*error-output* nil))
    (record-source-file-int name type)))

(defun record-source-file-int (name type)
  #+:mcl (CCL:RECORD-SOURCE-FILE name type)
  #+:lispworks (eval `(lw::top-level-form (,type ,name) nil))
  #+:allegro(cl-user::record-source-file name :type type))

(defun source-files (name type)
    #+:mcl (ccl::get-source-files name type))

(defun current-file ()
  #+:mcl (ccl::loading-file-source-file))
;;  (if (boundp '*load-pathname*)
;;    *load-pathname*))

 ;;;; #+:mcl (ccl::loading-file-source-file))

