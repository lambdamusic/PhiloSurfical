(in-package ocml)

;; +++++++++++++
;; the PATHWAYS : generic functions
;; +++++++++++++



(defvar *pathways-list* 
;;"Here we manually add all the info about the pathways created"

  '((th-ideas-with-same-names "Ideas having the same name" 
                              "<b>Type of pathway</b>: THEORETICAL <br><b>Description</b>    : This pathway populates the graph with ideas having the same name but a different meaning than the selected one")

    (th-witt-ideas-map "Map of the other related ideas in the Tractatus" 
                       "<b>Type of pathway</b>: THEORETICAL <br><b>Description</b>    : This pathway at the moment works only with ideas related to the Tractatus, by giving an graphical representation of the how various ideas relate to each other")
    
    (txt-also-has-idea-as-subject "Other documents about the same idea"  
                                  "<b>Type of pathway</b>: THEORETICAL <br><b>Description</b>    : This pathway retrieves other information objects (beyond the tractatus) which deal with a specific idea, only by using stored semantic relationships" )

    (txt-strict-string-matching "Strict string-matching on other resources"  
                                "<b>Type of pathway</b>: TEXTUAL <br><b>Description</b>    : This pathway combines semantic and syntactic data; it displays other resources where the value of the <i>is about</i> attribute matches <i>almost exactly</i> the content searched. For this reason, results are not always relevant.." )

    (txt-non-strict-string-matching "Non-strict string-matching on other resources"  
                                    "<b>Type of pathway</b>: TEXTUAL <br><b>Description</b>    : This pathway combines semantic and syntactic data; it displays other resources where the value of the <i>is about</i> attribute matches <i>at least 50 per cent</i> of the content searched. This pathway may produce a large number of unwanted results." )
    
    (hs-advisors-tree  "Phd advisors" 
                       "<b>Type of pathway</b>: HISTORICAL <br><b>Description</b>    : This pathway shows the chain of phd-advisors starting from a selected philosopher or scientist")

    (hs-phd-students  "PhD students"   
                      "<b>Type of pathway</b>: HISTORICAL  <br><b>Description</b>    : This pathway shows the chain of phd-students starting from a selected philosopher or scientist" )
    
    (geo-persons-birthplace-same   "Scholars born in same area"  
                                   "Type: GEOGRAPHICAL <br>Description    : .....")
))



(defun check-available-pathways (instance)
"Check well my friend"
  (let ((result '()))
    (dolist (pathway *pathways-list*)
      (if (funcall (first pathway) instance)
          (push (first pathway) result)))
    result))
          
 


(defun explode-pathway (implicit-pathway type)
"For every pathway, explodes all the implicit information represented in the output of one of the main pathway-generation functions. The 'explosion' format must be a list of lists with the structure <relation> <term1 term2>. This is needed so to guarantee the functioning of the <build-graph-components> function which provides the right input to the applet. Another IMPORTANT thing to remember is that we should avoid to output common-names or strings, cause then they cannot be re-used as instances by selecting them on the graph!!!!!"
  (let ((out '()))
  (cond

   ((eq type 'th-ideas-with-same-names)
    (dolist (item implicit-pathway)
      (push (list 'has-common-name (list (first item) (common-name (first item)))) out)
      (push (list 'defined-by-view (list (first item) (second item))) out)))

   ((eq type 'th-witt-ideas-map)
    (let ((original-idea (first implicit-pathway)))
      (dolist (item (rest implicit-pathway))
        (dolist (item2 (second item))
          (push (list (first item)  (list original-idea item2)) out)))))
          
   ((eq type 'txt-strict-string-matching)
    (let ((original-string (first implicit-pathway)))
      (dolist (item (rest implicit-pathway))
        ;;(push (list 'has-uri    (list (common-name (second item)) (first (third item)))) out)  --> confuses the system
        (push (list 'has-publisher (list (second item) (first (third item)))) out)
        (push (list 'similar-to (list original-string (second item))) out))))

   ((eq type 'txt-non-strict-string-matching)  ;;same as above, for now
     (let ((original-string (first implicit-pathway)))
      (dolist (item (rest implicit-pathway))
        ;;(push (list 'has-uri    (list (common-name (second item)) (first (third item)))) out)
        (push (list 'has-publisher (list (second item) (first (third item)))) out)
        (push (list 'similar-to (list original-string (second item))) out))))

   ((eq type 'hs-advisors-tree)
    (dotimes (n (length implicit-pathway))  ;;they are persons
      (if (not (equal (nth n implicit-pathway) (first (last implicit-pathway))))
          (push (list 'had-PhD-advisor (list (nth n implicit-pathway) (nth (+ 1 n) implicit-pathway))) out))))

   ((eq type 'hs-phd-students)
    (dotimes (n (length implicit-pathway))  ;;they are persons
      (if (not (equal (nth n implicit-pathway) (first (last implicit-pathway))))
          (push (list 'had-PhD-student (list (nth n implicit-pathway) (nth (+ 1 n) implicit-pathway))) out)))))
  out))
          






;;++++
;; pathway generation functions   
;; rationale: the output has just the minimum/critical info, leaving implicit for the exploding function all the rest
;;++++


;; {{{{{{{{{{{{ theoretical
(defun th-ideas-with-same-names (idea)
"Works mostly for concepts (but not only - it could be expanded with some regex function that looks a similar theories names..): from an idea-instance ----> outputs other ideas having the same name, with the respective defining views"
(if (has-granfather? idea 'propositional-content)
    (let ((other-ideas (find-ideas-with-name (common-name idea)))
          (p '()))
      (if other-ideas
          (dolist (eachone other-ideas)
            (push (list eachone (first (my-slot-values eachone 'defined-by-view))) p)))
      p)))
    


(defun th-witt-ideas-map (idea)
  (if (has-granfather? idea 'propositional-content)
      (let ((related-ideas (find-idea-interpretation-content idea)))
        (if related-ideas
            (append (list idea)
                    (cl-user::reorder-list (cl-user::breakdown-list related-ideas)))))))





;; {{{{{{{{{{{{{  textual
(defun txt-also-has-idea-as-subject (idea)
"Retrieves other information objects (beyond the tractatus) which deal with a specific idea"
(if (has-granfather? idea 'propositional-content)
    (let ((other-docs (setofall '?x `(and (io-interpretation ?i) (has-interpretation ?i ,idea) (interprets ?i ?x) (not (PART-OF-EXPRESSION ?x TRACTATUS-ORIGINAL-ENGLISH-VERSION )))))
          (out '()))
      (if other-docs
          (setf out (list idea other-docs)))
      out)))
  
  




;; the following two have this type of output: 
;; e.g. (FACT ("Act" DICTIONARY-OF-PHILOSOPHY-PUBLICATION-G2741 (DICTIONARY-OF-PHILOSOPHY-WEBSITE)) ("Act  Psychology" DI....
(defun txt-strict-string-matching (idea)
  (let* ((idea-name (if (common-name idea)
                       (common-name idea)
                     (string idea))) ;; double check
        (results (word-also-dealt-with-in idea-name 50)))
    (if results
        (push idea-name results))))


(defun txt-non-strict-string-matching (idea)
  (let* ((idea-name (if (common-name idea)
                       (common-name idea)
                     (string idea)))
        (results (word-also-dealt-with-in idea-name 0)))
      (if results
          (push idea-name results))))














;; {{{{{{{{{{{{  historical

;; you need to load the people KB first...
(defun hs-advisors-tree (person)
"Will have to extend it: now it outputs a list, first the starting person, then the ascending tree"
(if (has-granfather? person 'person)
    (let ((tree (next-advisor-up person))
          (out nil))
      (if tree
          (setf out (append (list person) tree)))
      out)))


(defun hs-phd-students (person)
"To be extended"
(if (has-granfather? person 'person)
    (let ((students (all-phd-students person))
          (out nil))
      (if students
          (setf out (append (list person) students)))
      out)))







;; {{{{{{{{{{{{  geographical


(defun geo-persons-birthplace-same (person)
  (if (has-granfather? person 'person)
      (let ((birthplace (first (my-slot-values person 'has-birth-place)))
            (out nil))
        (if birthplace
            (let ((neighbours (setofall '?x `(and (person ?x) (has-birth-place birthplace)))))
              (if neighbours
                  (setf out neighbours))))
        out)))
