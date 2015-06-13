(in-package cl-user)


;; +++++++++++++++
;; fourth tab----> have a glance at the ontology!
;; ++++++++++++++++




(defun generate-fourth-tab ()
"Generates the third tab when philosurfical is run"
(with-html-np
  (:div :class "tabbertab"  :title "Browse the ontology" :id "ontology"
     (:div :id "browser_left_navigation"
      (cl-who::str (format nil ".......<img src='/static/img/busy.gif' alt='loading' />")))
     (:div :id "browser_middle"
      (:b "Select a class on the left to see its description here")))))







(defun init-fourth-tab()
(with-html-np
 (cl-who::str (create-helpbar 'help9trigger 'help9))
  (:h2 "PhiloSURFical Ontology:")
  (cl-who::str (format nil (blank-lines 1))) ;; just to check how it's spaced out
          
     
  (cl-who::str (ontology-navigation-header))  ;; doesnt work
  (cl-who::str (ontology-navigation-pane))))
        
 ;;(:div :id "browser_middle" 





;; ++++
;; treeview stuff
;; ++++


(defun ontology-navigation-header ()
"Generates control commands for the tree navigation panel"
            ;; raw html - just to try out the working javascript!!
         (format nil "<div id=\"treecontrol\"> 	</div>"))

	;;	<a href=\"#\">Collapse All</a>
	;;	<a href=\"#\">Expand All</a>
	;;	<a href=\"#\">Toggle All</a>




(defun ontology-navigation-pane ()
"Generates the multi level list of the navigation pane with the kb data about the paragraphs and sub-paragraphs"
(ontotree1 'PhiloSURFical-entity))

;;philosophical-idea))
 



(defparameter *the-old-level* 0)

(defun ontotree1 (top-class)
"Caller function for "
  (let ((result ""))
    (setf *the-old-level* 0)
    (setf result (format nil "<ul>  <li> <span class=\"item\" onclick=\"ontotabinfo('~a');\" >~a</span>~%~a   ~%</li>  </ul>" top-class top-class (ontotree2 top-class)))
    result))
    


(defun ontotree2 (top-class &optional (level 1)) ;; oldlevel)
"Main function that explores the tree"
  (let ((result ""))
    (if top-class
     ;;   (if flag
     ;;       (progn (setq the-old-level 0)
      ;;        (calcont top-class nil)))

          (loop for class in 
                (ocml::direct-subclasses (ocml::get-ocml-class (read-from-string (make-it-ocml top-class))))
                do 
              
                (setq result (format nil "~a ~a <span class=\"item\" onclick=\"ontotabinfo('~a');\" > ~a  </span>"  ;; debug " ---level:~a  ---oldlevel:~a"
                                   result 
                                   (onto-add-opening-stuff level *the-old-level*)
                                   (ocml::name class)
                                   (ocml::name class)))
                                 ;;  level
                                 ;;  *the-old-level*))
                                 
                
                (setq *the-old-level* level)
                (setq result (format nil "~a~a"
                                     result     ;; (html level oldlevel)
                                     (ontotree2 (ocml::name class) (+ 1 level) )))))
      result))




(defun onto-close-node (n)
  (let ((result ""))
    (dotimes (i n)
      (setf result  (format nil "~a</li>~% </ul>" result)))
    (setf result (format nil "~a </li> ~% <li> " result))  ;; close and opens for the next one
    result))

(defun onto-open-node (n)
  (let ((result ""))
    (dotimes (i n)
      (setf result (format nil "~a~%<ul>  <li>" result)))
    result))

(defun onto-same-node ()
  (format nil "</li>~%<li>"))



(defun onto-add-opening-stuff (new old)
  (cond 
   ((> new old)
    (onto-open-node (- new old)))
   ((= new old)
    (onto-same-node))
   ((< new old)
    (onto-close-node (- old new)))))


   




;;; functions to update the description of classes

(defun onto-descclass ()
  (let* ((m-data (get-parameter "metadata")))
    (with-html-np
     ;; (:h1 (cl-who::str (format nil "Class: ~a" (read-from-string m-data))))
      (:br (cl-who::str (onto-DESCRIBE-CLASS-INFO m-data))))))



(defun onto-describe-class-info (raw-name)
"Function specular to the original ocml describe-class-info ... "
  (Let* ((name (read-from-string (make-it-ocml raw-name)))
         (class (ocml::get-ocml-class name))
         (supers (mapcar #'ocml::name (ocml::domain-superclasses class)))
         (subs (mapcar #'ocml::name (ocml::current-subclasses class)))
         (*package* (find-package "OCML"))
         (html ""))
    (when class
      (setq html (format nil "<div  id='desc_container'> <div class='main_info'> <ul>"))
      (setq html (format nil "~a <li> Class <span class='value'> ~S </span> </li>" html name))
      (setq html (format nil "~a <li> Ontology: <span class='value'> ~s</span></li> " html (ocml::name (ocml::home-ontology class))))
      (setq html (format nil "~a <li> Superclasses: <span class='value'> ~S~{, ~S~}</span> </li>"
                         html
                         (car supers)
                         (cdr supers)))
      (setq html (format nil "~a <li> Subclasses: <span class='value'> ~S~{, ~S~}</span> </li>"
                         html
                         (car subs)
                         (cdr subs)))
      (setq html (format nil "~a <li> Documentation:  <span class='value'> ~a </span></li> " 
                         html
                         (ocml::ocml-documentation class)))
      (setq html (format nil "~a </ul> </div>" html))
      (setq html (format nil "~a <p> SLOTS </p>" html))
      (setq html (format nil "~a <div class='slots'> <ul>" html))
      (loop with chains = (ocml::renaming-chains class)
            for slot in (ocml::domain-slots class)
            do
            (unless (ocml::slot-renamed? slot chains)
              (setq html (format nil "~a <li> ~s" html slot))
              (multiple-value-bind (values defaults)
                                   (ocml::get-slot-values-from-class-structure
                                    class slot )
                (if values
                    (setq html (format nil "~a  ~S: <span class='value'> ~S~{, ~S~}</span> </li>"
                                     html
                                     :value
                                     (car values)
                                     (cdr values)))
                  (when defaults
                    (setq html (format nil "~a ~S: <span class='value'> ~S~{, ~S~}</span> </li>"
                                       html
                                       :default-value
                                       (car defaults)
                                       (cdr defaults))))))
              (let ((type-info (remove-duplicates 
                                (ocml::find-option-value class slot :type))))
                (when type-info
                  (setq html (format nil "~a  ~S: <span class='value'> ~S~{, ~S~}</span> </li>"
                                     html
                                     :type
                                     (car type-info)
                                     (cdr type-info)))))
              (loop for option in '(:min-cardinality
                                    :max-cardinality
                                    :inheritance)
                    for value = (ocml::find-option-value class slot option)
                    when value
                    do
                    (setq html (format nil "~a ~S: <span class='value'> ~S </span> </li>"
                            html option value)))
              (let ((doc (ocml::find-slot-documentation class slot)))
                (when doc
                  (setq html (format nil "~a   ~S: <span class='value'> ~S</span> </li>"
                          html :documentation doc)))))
            finally
            (when chains
              (setq html (format nil "~a <li>The following renaming chains apply: <span class='value'> ~{ ~s ~%~}</span> </li>"
                      html chains)))))
    (setq html (format nil "~a </ul> </div> </div>" html))
    html))