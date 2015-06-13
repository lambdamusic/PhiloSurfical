(in-package ocml)

;; ++
;; add a generic function find-appellation, which from any class gives out its appellation!
;; probably we need multiple cond, for different appellation slots...








;; ++++
;; generic ocml functions

#|
(defun subclass-of* (class classes)
  (let ((supers (domain-superclasses class)))
    (when supers
      (some  #'(lambda (class2)
                 (member class2 supers))
             classes))))   
|#

(defun has-granfather? (inst-name granpa)
"From an instance, checks if has a class among its fathers"
(if (find-all-current-instances-named-x inst-name)
    (let* ((inst (first (find-all-current-instances-named-x inst-name)))
           (parent (parent-class inst)))
      (if (or 
           (equal parent (get-ocml-class granpa))
           (subclass-of* parent (list (get-ocml-class granpa))))
          t
        nil))))
  

(defun get-father-from-instance (inst-name)
"From the *name* of an instance it gets the *name* of the father"
(let ((result ""))
  (if (find-all-current-instances-named-x inst-name)
      (let* ((inst (first (find-all-current-instances-named-x inst-name)))
             (parent (parent-class inst)))
        (setq result (format nil "~S" (name parent))))
    (setq result "unknown type"))
  result))


(defun my-slot-values (instance slot)
"wrapper for the ocml original function: mine takes just the instance name and the slot name, returns a list"
  (let ((resulto nil))
    (setf resulto  (get-slot-values (first (find-all-current-instances-named-x instance)) slot))
    resulto))


;; to check whether an instance exists: 
;; (find-all-current-instances-named-x (first (my-slot-values 'pirla 'defined-by-view)))



(defun common-name (instance-name)
"checks if it is an idea, and if it is outputs the common name (if there is one, otherwise NIL) - instead if it is a person, tries to output the <identified-by> value...."
(let ((is-idea (not (not (instance-of? instance-name 'philosophical-idea))))
      (is-person (not (not (instance-of? instance-name 'person))))
      (is-organization (not (not (instance-of? instance-name 'organization))))
      (is-informationobject (not (not (instance-of? instance-name 'information-object))))
      (result nil))
  (if is-idea
      (setf result (first (setofall '?x `(HAS-COMMON-NAME ,instance-name ?x)))))
  (if is-person
      (setf result (first (setofall '?x `(is-identified-by ,instance-name ?x)))))
  (if is-organization
      (setf result (first (setofall '?x `(is-identified-by ,instance-name ?x)))))
  (if is-informationobject
      (setf result (first (setofall '?x `(is-identified-by ,instance-name ?x)))))
  result))


(defun find-ideas-with-name (name)  ;; &optional (view 'first-wittgenstein-philosophy)
"Just returns a LIST of the instances of ideas with a given COMMON-NAME"
(let ((ideas (setofall '?x `(and (philosophical-idea ?x) (has-common-name ?x ,name)))))
  ideas))


(defun string-description (anything)
"Give the string description of an idea - i.e. the value of the has-description slot in most cases, or alternatively the value of the has-note slot"
(let ((desc1 (setofall '?d `(has-description ,anything ?d)))
      (desc2 (setofall '?d `(has-note ,anything ?d)))
      (result nil))
  (if desc1
      (setf result (first desc1))
    (if desc2
        (setf result (first desc2))
      (setf result "No description")))
  result))


(defun exists? (x)
"I like the existential thing more"
(find-all-current-instances-named-x x))



;; (what-url? (first (all-io-about-x "I")))
(defun what-url? (entity)
(if (exists? entity)
    (my-slot-values entity 'HAS-URI)))
















;; +++
;; functions to manipulate sentences and texts
;; +++



;; gets an ordered list of the numbers of the sentences part-of an expression
(defun get-tractatus-paragraphs-numbers ( &optional (expression 'Tractatus-original-english-version))
"Just gets all the numbers of the tractatus sentences -by default-, and orders them"
  (let* ((raw-listt (setofall '?x `(and (sentence ?p) (part-of-expression ?p ,expression) (has-number-reference ?p ?x))))
         (good-listt nil))
    (dolist (item (sort raw-listt #'<))
      (push item good-listt))
    (reverse good-listt)))


(defun get-sentences-numbers (sentences)
"From a list of sentences, outputs as ordered list of their numbers"
  (if (listp sentences)
      (let ((output nil))
        (dolist (sentence sentences)
          (push (first (setofall '?x `(has-number-reference ,sentence ?x))) output))
        (sort output #'<))))




;;  extract the string content of a sentence
(defun sentence-string-content (sentence &optional (expression 'Tractatus-original-english-version))
"Just outputs the string content of a sentence" 
(if (setofall '?x `(sentence ,sentence))  ;;if the sentence exists
    (let ((content ""))
      (setf content (format nil "~a" 
                            (first (setofall '?x `(and (sentence ,sentence) (part-of-expression ,sentence ,expression) (has-string-content ,sentence ?x))))))
      content)))

(defun sentence-string-content-from-number (number &optional (expression 'Tractatus-original-english-version))
"Just outputs the string content of a sentence, from a number (it could be constructed from get-sentence-number + sentence-string-content" 
(if (numberp number)
    (let ((content ""))
      (setf content (format nil "~a" 
                            (first (setofall '?x `(and (sentence ?s) (part-of-expression ?s ,expression) (has-number-reference ?s ,number) (has-string-content ?s ?x))))))
      content)))


(defun get-sentence-from-number (number &optional (expression 'Tractatus-original-english-version))
"gets the sentence instance, from the reference number"
(if (numberp number)
    (let ((sentence nil))
      (setf sentence
            (first (setofall '?x `(and (sentence ?x) (part-of-expression ?x ,expression) (has-number-reference ?x ,number)))))
      sentence)))

;;e.g. (get-sentences-from-numbers (extract-interval (get-tractatus-paragraphs-numbers) 1 2))
(defun get-sentences-from-numbers (numbers &optional (expression 'Tractatus-original-english-version))
"same as above, but for a list of numbers"
 (let ((sentences nil))
   (dolist (number numbers)
     (push (get-sentence-from-number number expression) sentences))
   (reverse sentences)))










;; ++++
;; functions that return an interpretation object
;; +++++



;; returns the interpretation objects  about an information object

(defun find-interpretation-of-io (io &optional (author 'michele-pasin))
"Find the interpretations-objects of a given sentence, given that they are part of an expression"
(if io
    (let ((interpretation (setofall '?i `(and (interpretation ?i) (carried-out-by ?i ,author) (interprets ?i ,io)))))
     interpretation))) 





;; returns the interpretation objects  about a sentence

(defun find-interpretation-of-sentence (sentence &optional (author 'michele-pasin) (expression 'Tractatus-original-english-version))
"Find the interpretations-objects of a given sentence, given that they are part of an expression"
(if sentence
    (let ((interpretation (setofall '?i `(and (interpretation ?i) (carried-out-by ?i ,author) (interprets ?i ,sentence) (part-of-expression ,sentence ,expression)))))
     interpretation))) 


;; returns the interpretations object about an idea

(defun find-interpretation-of-idea (idea &optional (author 'michele-pasin))
"Find the interpretation of a given idea"
(if idea
    (let ((interpretation (setofall '?i `(and (interpretation ?i) (carried-out-by ?i ,author) (interprets ?i ,idea)))))
     interpretation))) 


(defun find-interpretation-of-idea-named (name &optional (author 'michele-pasin))
"Find the interpretation of a given idea, given its common name"
(if name
    (let ((interpretation (setofall '?i `(and (interpretation ?i) (carried-out-by ?i ,author) (interprets ?i ?idea) (has-common-name ?idea ,name)))))
     interpretation)))



;;; ***************
;;+++++ check if used in philosurfical and eliminate!
;; this function is a double: find-interpretation-of-idea already does the job
;;(defun find-idea-interpretations (idea &optional (author 'michele-pasin))
;;"Returns all the interpretations related to an IDEA-INSTANCE NAME"
;;(let ((result nil))
;;  (setf result (setofall '?x `(and (interpretation ?x) (carried-out-by ?x ,author) (interprets ?x ,idea)))
;;  result))
;; ****************



;; returns the whole set of tractatus' sentences interpretations

(defun findall-interpretations (&optional (author 'michele-pasin) (expression 'Tractatus-original-english-version))
"Basically finds all the interpreations-contents related to the tractatus, returns the PROPOSITIONS directly"
(let ((result nil))
  (setf result (setofall '?x `(and (interpretation ?i) (carried-out-by ?i ,author) (interprets ?i ?s)  (part-of-expression ?s ,expression) (has-interpretation ?i ?x))))
  result))

(defun findall-interpretations-of-type (type  &optional (author 'michele-pasin) (expression 'Tractatus-original-english-version))
"Basically finds all the interpreations=metadata related to the tractatus, of a particular type e.g. theory"
(let ((result nil))
  (setf result (setofall '?x `(and (interpretation ?i) (carried-out-by ?i ,author) (interprets ?i ?s)  (part-of-expression ?s ,expression) (has-interpretation ?i ?x) (,type ?x) )))
  result))


;; special case: find all prop contents of given type, belonging to first-witt-philosophy
;;(defun findall-prop-of-type  (type &optional





;; ++++
;; inverse: functions that return the sentence, given the VALUE of an interpretation object
;; +++++

(defun find-sentences-interpreted-as (interpretation  &optional (author 'michele-pasin))
"Find all the sentences where a proposition is defined as interpretation - outputs an ordered list"
(if interpretation ;; (setofall '?x `(propositional-content ,interpretation))  not doable for now
    (let ((sentences (setofall '?x `(and (interpretation ?i) (carried-out-by ?i ,author)  (has-interpretation ?i ,interpretation) (interprets ?i ?x)))))
      (sort sentences #'string-lessp))))

(defun find-sentences-interpreted-as-name (name  &optional (author 'michele-pasin))
"From the COMMON-NAME of an idea/proposition, finds all the sentences where a proposition is defined as interpretation - outputs an ordered list"
(let ((sentences (setofall '?x `(and (interpretation ?i) (carried-out-by ?i ,author)  (has-interpretation ?i ?int) (has-common-name ?int ,name) (interprets ?i ?x)))))
  (sort sentences #'string-lessp)))










;; ++++
;; functions that return the VALUE of an interpretation object
;; +++++


;; given an information object

;; ****** the one to be used with the encyclopedia data
;;e.g. (find-io-whats-about 'DICTIONARY-OF-PHILOSOPHY-PUBLICATION-G7509)
(defun find-io-whats-about (io &optional (author 'michele-pasin))
"The is-about-entity slot is a generic descirption of the content of the object"
(if io
    (let ((aboutof (setofall '?x `(and (interpretation ?i) (carried-out-by ?i ,author) (interprets ?i ,io) (is-about-entity ?i ?x)))))
     aboutof))) 



(defun find-io-interpretation-content (io &optional (author 'michele-pasin))
"Here it gets the propositional content, value of has-interpretation slot"
(if io
    (let ((interpretation (setofall '?x `(and (interpretation ?i) (carried-out-by ?i ,author) (interprets ?i ,io) (has-interpretation ?i ?x)))))
     interpretation)))




;; inverse - from a content
(defun all-io-interpretations-about-x (entity &optional (author 'michele-pasin))
"Return interpretation objects"
(if entity
    (let ((result (setofall '?x `(and (interpretation ?x) (carried-out-by ?x ,author) (is-about-entity ?x ,entity)))))
      result)))


;;(all-io-about-x "I")
(defun all-io-about-x (entity &optional (author 'michele-pasin))
"It's a generic function, but still the about slot-value must MATCH EXACTLY the entity value"
(if entity 
    (let ((interpretations (all-io-interpretations-about-x entity author))
          (result '()))
      (dolist (interpretation interpretations)
        (setf result (append (my-slot-values interpretation 'INTERPRETS) result)))
      result)))


;;{{{{{{{{{{{{{{{{{{{{{{{{
;; ++++++++++++++++++++++++++++ similarity functions

;; this function looks only for the repetition of characters.. not 'semantically' very useful! 
(defun all-aboutvalues-similar-to-x (string limit &optional (author 'michele-pasin))
(if string
    (let ((result nil)
          (potential-x (setofall '?e `(and (interpretation ?x) (carried-out-by ?x ,author) (is-about-entity ?x ?e)))))
      (dolist (i potential-x)
        (if (cl-user::char-word-similarity? string i limit)
            (setf result (append (list i) result))))
      (sort result #'string-lessp))))


;; this function looks for repetitions of the words: makes much more sense
(defun all-aboutvalues-words-similar-to-x (string &optional (limit 0) (author 'michele-pasin))
(if string
    (let ((result nil)
          (potential-x (setofall '?e `(and (interpretation ?x) (carried-out-by ?x ,author) (is-about-entity ?x ?e)))))
      (dolist (i potential-x)
        (if (cl-user::morph-sentence-similarity? string i limit)    ;;cl-user::good-word-similarity? for letter-similarity..
            (setf result (append (list i) result))))
      (sort result #'string-lessp))))



;; ++++++ the LIMIT--> 0 for one word only  ---> 50 for at least two...
;; it's a pathway --> for the moment it just returns stringname+io  
;; we also need the name of the publisher and the URI
(defun word-also-dealt-with-in (string &optional (limit 0) (author 'michele-pasin))
(if (all-aboutvalues-words-similar-to-x string limit author)
    (let ((result nil))
      (dolist (word (all-aboutvalues-words-similar-to-x string limit author))
        (let* ((inf-objs (all-io-about-x word))
              (publisher (setofall '?x `(was-made-by ,(first inf-objs) ?x ))))
          (setf result (append result (list `(,word ,(first inf-objs) ,publisher))))))
      result)))


;;          (setf result (append result (list `(,word ,(first inf-objs) ,(what-url? (first inf-objs))))))))


;; i can have a strinct matching, with limit 50 per cent, and a non-strict matching, with limit 0 (II pathways)


#|
OCML 45 : 2 > (word-also-dealt-with-in "fact")
(("Fact" DICTIONARY-OF-PHILOSOPHY-PUBLICATION-G6437 ("http://www.ditext.com/runes/f.html#Fact")) ("fact /  value" A-DICTIONARY-OF-PHILOSOPHICAL-TERMS-AND-NAMES-PUBLICATION-G6439 ("http://www.philosophypages.com/dy/f.htm#fava")))

|#


;; }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}












;; ++++
;; functions to find out all interpretations-values of an expression (sentence)

;; given a sentence(s)

(defun find-sentence-interpretation (sentence &optional (author 'michele-pasin))
"Find the interpretation-content of a given sentence // if there are more interpretations, it returns all the contents, and gets rid of the double values - e.g. (find-sentence-interpretation 'sentence-1)"
(if sentence
    (let ((interpretation (setofall '?x `(and (interpretation ?i) (carried-out-by ?i ,author) (interprets ?i ,sentence) (has-interpretation ?i ?x)))))
     interpretation))) 


(defun findmany-sentences-interpretations (sentences &optional (author 'michele-pasin))
"Find interpretation-content of a set of sentences - takes a list and outputs a list of lists"
(if (listp sentences)
    (let ((interpretations nil))
       (dolist (sentence sentences)
         (push (setofall '?x `(and (interpretation ?i) (carried-out-by ?i ,author) (interprets ?i ,sentence) (has-interpretation ?i ?x))) interpretations))
       interpretations)))






;; +++
;; functions that gives all the interpretation VALUES of an INTERPRETATION and/or IDEA  (not a sentence!)


;; from an INTERPRETATION
;; this function cannot be accessed from CL-USER without doing the set package thing.... WHY?
(defun find-interpretation-content (interpretation)
"Done especially for idea-interpretations // Outputs a list of pairs, containing the slot and the interpretation value - I DECIDED what are the interpretations to output!!!"
(if (not (not (instance-of? interpretation 'interpretation)))
    (let ((whatidea (get-father-from-instance interpretation))
          (result nil))
      (cond 

       ((equal whatidea "CONCEPT-INTERPRETATION")
             (let ((slots '(IS-RELATED-TO-IDEA HAS-RELATED-CONCEPT HAS-OPPOSITE-CONCEPT SIMILAR-TO CONTRASTS-WITH IS-SPECIALIZATION-OF IS-GENERALIZATION-OF IS-EQUIVALENT-TO REQUIRES-CONCEPT CAUSES-CONCEPT)))
               (dolist (slot slots)
                 (if (my-slot-values interpretation slot)
                     (push (list slot (my-slot-values interpretation slot)) result)))))
                                                                     
            ((equal whatidea "METHOD-INTERPRETATION")
             (let ((slots '(IS-RELATED-TO-IDEA SIMILAR-TO CONTRASTS-WITH SUPPORTS-VIEW )))
               (dolist (slot slots)
                 (if (my-slot-values interpretation slot)
                     (push (list slot (my-slot-values interpretation slot)) result)))))

        
            ((equal whatidea "RHETORICAL-FIGURE-INTERPRETATION")
             (let ((slots '(IS-RELATED-TO-IDEA SIMILAR-TO CONTRASTS-WITH ASSOCIATED-WITH )))
               (dolist (slot slots)
                 (if (my-slot-values interpretation slot)
                     (push (list slot (my-slot-values interpretation slot)) result)))))
           
            ((equal whatidea "ARGUMENT-INTERPRETATION")
             (let ((slots '(IS-RELATED-TO-IDEA SIMILAR-TO CONTRASTS-WITH DEFINES-PROBLEM TACKLES-PROBLEM CONTRASTS-IDEA SUPPORTS-IDEA )))
               (dolist (slot slots)
                 (if (my-slot-values interpretation slot)
                     (push (list slot (my-slot-values interpretation slot)) result)))))
            
            ((equal whatidea "PROBLEM-AREA-INTERPRETATION")
             (let ((slots '(IS-RELATED-TO-IDEA SIMILAR-TO CONTRASTS-WITH HAS-SUB-AREA SUB-AREA-OF RELATED-TO-AREA )))
               (dolist (slot slots)
                 (if (my-slot-values interpretation slot)
                     (push (list slot (my-slot-values interpretation slot)) result)))))
             
            ((equal whatidea "PROBLEM-INTERPRETATION")
             (let ((slots '(IS-RELATED-TO-IDEA SIMILAR-TO CONTRASTS-WITH HAS-RESOLUTIVE-METHOD HAS-EQUIVALENT-MEANING-AS DERIVES-FROM-PROBLEM RELATED-TO-PROBLEM IS-TACKLED-BY-ARGUMENT DEFINED-BY-ARGUMENT IS-TACKLED-BY-VIEW HAS-SUPPORTIVE-VIEW ATTACKS-VIEW LINKED-TO-FACT  EXISTS-IN-AREA HAS-PROBLEM-TYPE)))
               (dolist (slot slots)
                 (if (my-slot-values interpretation slot)
                     (push (list slot (my-slot-values interpretation slot)) result)))))
             
            ((equal whatidea "DISTINCTION-INTERPRETATION")
             (let ((slots '(IS-RELATED-TO-IDEA SIMILAR-TO CONTRASTS-WITH RELATED-TO-PROBLEM )))
               (dolist (slot slots)
                 (if (my-slot-values interpretation slot)
                     (push (list slot (my-slot-values interpretation slot)) result)))))
             
            ((equal whatidea "SCHOOL-OF-THOUGHT-INTERPRETATION")
             (let ((slots '(IS-RELATED-TO-IDEA SIMILAR-TO CONTRASTS-WITH HAS-MAIN-EXPONENT HAS-EXEMPLAR-THEORY CLASSIFIES-VIEW HAS-MAIN-THESIS HAS-EXEMPLAR-DOCUMENT HAS-OPPOSING-ARGUMENT HAS-SUPPORTING-ARGUMENT OPPOSES-VIEW SUPPORTS-VIEW INFLUENCED-BY-VIEW  INFLUENCES-VIEW  ATTACKED-BY-PROBLEM TACKLES-PROBLEM TYPIFIES INTERPRETS-FACT USES-IDEA  DEFINES-CONCEPT )))
               (dolist (slot slots)
                 (if (my-slot-values interpretation slot)
                     (push (list slot (my-slot-values interpretation slot)) result)))))
             
            ((equal whatidea "PHILOSOPHICAL-SYSTEM-INTERPRETATION")
             (let ((slots '(IS-RELATED-TO-IDEA SIMILAR-TO CONTRASTS-WITH HAS-THESIS HAS-THEORY DEFINES-METHOD PART-OF-SCHOOL HAS-EXEMPLAR-DOCUMENT HAS-OPPOSING-ARGUMENT HAS-SUPPORTING-ARGUMENT OPPOSES-VIEW SUPPORTS-VIEW INFLUENCED-BY-VIEW  INFLUENCES-VIEW  ATTACKED-BY-PROBLEM TACKLES-PROBLEM TYPIFIES INTERPRETS-FACT USES-IDEA DEFINES-CONCEPT)))
               (dolist (slot slots)
                 (if (my-slot-values interpretation slot)
                     (push (list slot (my-slot-values interpretation slot)) result)))))
             
            ((equal whatidea "THEORY-INTERPRETATION")
             (let ((slots '(IS-RELATED-TO-IDEA SIMILAR-TO CONTRASTS-WITH HAS-THESIS DEFINES-METHOD PART-OF-SYSTEM PART-OF-SCHOOL PART-OF-THEORY HAS-EXEMPLAR-DOCUMENT HAS-OPPOSING-ARGUMENT HAS-SUPPORTING-ARGUMENT OPPOSES-VIEW SUPPORTS-VIEW INFLUENCED-BY-VIEW  INFLUENCES-VIEW  ATTACKED-BY-PROBLEM TACKLES-PROBLEM TYPIFIES INTERPRETS-FACT USES-IDEA DEFINES-CONCEPT  )))
               (dolist (slot slots)
                 (if (my-slot-values interpretation slot)
                     (push (list slot (my-slot-values interpretation slot)) result)))))
            
            ((equal whatidea "THESIS-INTERPRETATION")
             (let ((slots '(IS-RELATED-TO-IDEA SIMILAR-TO CONTRASTS-WITH PART-OF-SYSTEM PART-OF-SCHOOL PART-OF-THEORY PART-OF-THESISHAS-EXEMPLAR-DOCUMENT HAS-OPPOSING-ARGUMENT HAS-SUPPORTING-ARGUMENT OPPOSES-VIEW SUPPORTS-VIEW INFLUENCED-BY-VIEW  INFLUENCES-VIEW  ATTACKED-BY-PROBLEM TACKLES-PROBLEM TYPIFIES INTERPRETS-FACT USES-IDEA DEFINES-CONCEPT  )))
               (dolist (slot slots)
                 (if (my-slot-values interpretation slot)
                     (push (list slot (my-slot-values interpretation slot)) result))))))
            
            result)))



;; from an IDEA
(defun find-idea-interpretation-content (idea &optional (author 'michele-pasin))
"Reifies find-interpretation-content in a function which takes an idea as input"
(let ((interpretations (find-interpretation-of-idea idea author))
      (*package* (find-package "OCML")) ;; misterious HACK 
      (result nil))
  (dolist (interpretation interpretations)
    (push (find-interpretation-content interpretation) result))
  result))
    

















;;+++
;; functions for philosophy-tree related information


(defun next-advisor-up (person &optional (list nil))
"Takes the instance-name of a person, and outputs a list of the advisors tree"
  (if person
      (let ((advisor (first (setofall '?x `(and (person ,person) (learning-at-institution ?l) (degree-of-study ?l PHD) (has-learner ?l ,person) (has-teacher ?l ?x))))))
        (push advisor list)  
        (next-advisor-up advisor list))
    (reverse (rest list)))) ;; rest for eliminating the final nil



(defun all-phd-students (person)
"Takes the instance-name of a person, and outputs a list of its students"
  (if person
      (let ((students (setofall '?x `(and (person ,person) (learning-at-institution ?l) (degree-of-study ?l PHD) (has-teacher ?l ,person) (has-learner ?l ?x)))))
        students)))







;; +++++
;; functions for creating instances of  tractatus interpretations
;; ++++

;; e.g. also (interpret-tract-sentences 1 1 '(value1))
(defun interpret-tract-sentences (bottom top values)
"Useful wrapper: gets two numbers and a list of values to be used for interpreting the interval of sentences'numbers - specific for the tractatus"
(interpret-sentences-as 
 (get-sentences-from-numbers (extract-interval (get-tractatus-paragraphs-numbers) bottom top))
 values))

  
;; this can be used for non-continuous sentences ---> (interpret-sentences-as '(1 2) '(fact))
(defun interpret-sentences-as (sentences values &optional (author 'michele-pasin))
"Accepts a list of sentences, and a list of values, and outputs a string with the instantions of every sentence interpreted with ALL the values"
  (let ((result ""))
    (dolist (sentence sentences)
      (setq result (format nil "~A~2%(def-instance int-~A-~A  expression-interpretation ~%((carried-out-by ~a)~% (interprets sentence-~A)~% (has-interpretation  ~A)))"     
                           result 
                           sentence
                           (gensym)
                           author
                           sentence
                           (let ((result ""))
                             (dolist (value values)
                               (setq result (format nil "~a ~a" result value)))
                             result))))
    result))


;; howto:   (extract-interval (get-tractatus-paragraphs-numbers) 1 2)
(defun extract-interval (orderedlist bottom up)
"Given an ordered list and two limits, outputs a new list with all the elements within those limits"
  (let ((newlist nil))
    (dolist (el orderedlist)
      (if (and (>= el bottom)
               (<= el up))
          (push el newlist)))
    (reverse newlist)))




