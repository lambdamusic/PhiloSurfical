(in-package cl-user)




(defun generate-second-tab ()
"Generates the second tab"
(with-html-np
  (:div :class "tabbertab" :title "Browse the annotations" :id "metadata_sequence"

   (:div :id "left_tabber"
    (:div :class "tabber" :id "topics-tabber" 
     (:div :class "tabbertab" :title "By category" :id "alltopics"
      (:div :id "content_left" 
       (cl-who::str (create-helpbar 'help2trigger 'help2))
       (cl-who::str (init-alltopiclist))))   

     (:div :class "tabbertab" :title "By proposition" :id "localtopics"
      (:div :id "content_top_right"     
       (cl-who::str (create-helpbar 'help4trigger 'help4))
       (:h1 "Local Annotations :")
      ;; (cl-who::str (init-localtopics-tab))                        
       (cl-who::str (format nil (blank-lines 1)))))))


   (:div :id "content_middle2" 
   ;; (cl-who::str (init-tab2)))
    (:p :class "three" "Loading the text...."
     (:img :src "/static/img/busy.gif" :alt "loading")))


   (:div :id "right_tabber"
    (:div :class "tabber" :id "inspect-tabber" 
     (:div :class "tabbertab" :title "Describe" :id "describe"
      (:div :id "instance_desc"
       (cl-who::str (create-helpbar 'help5trigger 'help5))
       (:h1 "Annotation")))
         
     (:div :class "tabbertab" :title "Inspect" :id "map"
      (:div :id "content_bott_right"   
       (cl-who::str (create-helpbar 'help5trigger 'help5))
       (:h1 "Inspect Annotation:")
       ;;(cl-who::str (init-map-tab))                        
       (cl-who::str (format nil (blank-lines 1))))))))))
          
       
;;; <a href="#2.011" class="item">2.011</a>



;; serves the cached contents
(defun give-tab2 ()
(format nil "~a" *tab2*))



(defun init-tab2 ()
"Loads the whole text in tab 2, when the user activates  the tab"
(with-html-np
  (:p 
   (cl-who::str (spread-out-html2 (ocml::get-tractatus-paragraphs-numbers))))))






(defun spread-out-html2 (p)
"Function to be used with get-paragraphs-number as argument, which creates the html content for the tab2"
(let ((result ""))
    
    (dolist (item p)
      (setf result (format nil "~a <p onclick=\"metadataLoad('~A');\" class=\"~a\"><b><a name =\"sent~A\">~A</a></b><br />~A</p><br />" result item 
                           (format nil "~r" (number-length item)) 
                           item item (ocml::sentence-string-content-from-number item))))
    result))






;; called by javascript
(defun update-tab2 ()
"Function to update the main text in the second tab, once a metadata is clicked"
  (let* ((m-data (get-parameter "metadata"))
         (ocml-data (read-from-string (make-it-ocml m-data)))  ;; formats the symbol as an ocml::internal one
         (contents (ocml::get-sentences-numbers (ocml::find-sentences-interpreted-as ocml-data))))
    (with-html-np
      (:div :id "content_middle_cloud"
       (cl-who::str (format nil 
                            (let ((result ""))
                              (dolist (number contents)
                                (setf result (format nil "~a  <a class=\"item\" href=\"#sent~a\">~a</a>" 
                                                     result number number)))
                              result))))
  
      (cl-who::str (format nil (blank-lines 1)))
      (:p (cl-who::str (spread-out-html2 contents))))))









;; called by javascript
(defun update-metadata-tab ()
"Function to display the associated metadata of a sentence, after it's clicked"
  (let* ((id (get-parameter "id"))
         (metadata 
          (ocml::find-sentence-interpretation (ocml::get-sentence-from-number (read-from-string id)))))
;;(all-metadata (read-from-string id)))))
    (with-html-np  
      (cl-who::str (create-helpbar 'help4trigger 'help4))
      (:h1 "Local Annotations :")
      (:h2 (cl-who::str (format nil "Satz ~a" id)))
     ;;  (:span :onclick "showallmetadata();" :style "cursor: pointer; cursor: hand;" (cl-who::str "(show all) ")))
      (if metadata
          (dolist (i metadata)
            (cl-who::str 
             (format nil "<li><img src='/static/img/buttons/expand.gif' align=absmiddle  onclick=\"updateTab2('~A');\" style=\"cursor: pointer; cursor: hand;\" />~A</li>" i  
                     (if (ocml::common-name i)
                         (pretty-look (sym2lcstr (ocml::common-name i)))
                       (pretty-look (sym2lcstr i)))
;;(pretty-look (sym2lcstr i))  <--- previous.. but the new one seems to work
    )))))))







;; ++++
;; the super cool all topic list (top tab)
;; +++

(defun init-alltopiclist ()
(with-html-np  
  (:h1 "All Categories:")
  (cl-who::str (generate-all-topics-list '( view argument distinction concept method problem field-of-study rhetorical-figure)))))



(defun generate-all-topics-list (classes)
  (with-html-np
    (:div :class "accordion" (cl-who::str (format nil "~a"
                              (let ((result ""))
                                (dolist (item classes)
                                  (setq result (format nil "~a~%<h3>~a</h3>~%<div><ul>~%~A~%</ul></div>" 
                                                       result
                                                       item
                                                       (let ((ints (ocml::findall-interpretations-of-type (read-from-string (make-it-ocml item)))) (risult ""))
                                                         (dolist (int (sort ints #'string-lessp))
                                                           (setq risult (format nil "~A<li><img src='/static/img/buttons/expand.gif' align=absmiddle  onclick=\"updateTab2('~A');\" style=\"cursor: pointer; cursor: hand;\" />~A</li>~%"

                                                                               risult
                                                                                int
                                                                                (if (ocml::common-name int)
                                                                                    (pretty-look (sym2lcstr (ocml::common-name int)))
                                                                                  (pretty-look (sym2lcstr int))))))
                                                                           ;;     (pretty-look (sym2lcstr int)))))
                                                         risult))))
                                result))))))







(defun update-info ()
"Updates the generic description tab of a metadata, once it's clicked"
 (let* ((m-data (get-parameter "metadata"))
        (ocml-data (read-from-string (make-it-ocml m-data)))
        (contents (ocml::get-sentences-numbers (ocml::find-sentences-interpreted-as ocml-data))))
   (with-html-np
     (cl-who::str (create-helpbar 'help3trigger 'help3))
     (:h1 (cl-who::str (format nil "Annotation: <h2><span id=\"highlighted1\">~a</span></h2>" 
                               (if (ocml::common-name ocml-data)
                                   (string-upcase (pretty-look (sym2lcstr (ocml::common-name ocml-data))))
                                 (string-upcase (pretty-look (sym2lcstr (read-from-string m-data))))))))
     (if (= 0 (length contents))
         (cl-who::htm
          (:h3 "Ops.. there are no paragraphs annotated as such... you may find more information about this topic using the third tab"))
       (cl-who::htm (:h3 (cl-who::str (format nil "(~a paragraphs)" (length contents))))))
     (:div :id "abstract"  (cl-who::str (format nil "ABSTRACT: <br />~a" (ocml::string-description ocml-data)))))))









;; +++
;; the map of neighbouring concepts
;; +++


;; funny behaviour... ocml::find-interpretation-content doesnt work well from outside ocml!!!!!
(defun update-map-tab ()
"Gets the latest proposition in focus, and updates accordingly the small tab showing the related slots"
(let* ((m-data (get-parameter "metadata"))
      (ocml-data (read-from-string (make-it-ocml m-data)))
      (*package* (find-package "OCML"))
      (contents (reorder-list (breakdown-list (ocml::find-idea-interpretation-content ocml-data))))
      (result ""))
;;  (dolist (content contents)
    (dolist (interpretation contents)
      (setf result (format nil "~a<br /><li class='slots'>~a  : </li>"
                           result
                           (first interpretation)))  ;;the slot
      (dolist (value (second interpretation))
        (setf result (format nil "~a <li><img src='/static/img/buttons/expand.gif' align=absmiddle  onclick=\"updateTab2('~A');\" style=\"cursor: pointer; cursor: hand;\" />~a</li>~%"
                           result
                        
                           value
                           (if (ocml::common-name value)
                               (pretty-look (sym2lcstr (ocml::common-name value)))
                             (pretty-look (sym2lcstr value)))))))
                        ;;   (pretty-look (sym2lcstr value))


           ;; )
  (format nil "~a<h1>Annotation:</h1>~%<h2><span id=\"highlighted1\">~a</span></h2><h3>(instance of ~a)</h3>~%~A" 
          (create-helpbar 'help5trigger 'help5)
          (if (ocml::common-name ocml-data)
              (string-upcase (pretty-look (sym2lcstr (ocml::common-name ocml-data))))
            (string-upcase (pretty-look m-data)))
          (ocml::get-father-from-instance ocml-data)
 
          (if (equal result "")
              "...no result"
            result))))


;; wonderful functions to support the creation of a tidy and ordered map

(defun breakdown-list (l)
"breaks down the complex list coming out of ocml::find-interpretation-content"
(let ((l1 nil))
  (dolist (item l)
    (dolist (element item)
      (push element l1)))
  l1))




(defun reorder-list (l)
"receives the list of slots-values , orders and eliminates duplicates for both of them"
(let ((l1 nil)
      (slots (let ((l2 nil))
               (dolist (item l)
                 (push (first item) l2))
               (sort (remove-duplicates l2) #'string-lessp ))))
  (dolist (slot slots)
    (let ((valori nil))
      (dolist (item l)
        (if (equal (first item) slot)
            (setf valori (append (second item) valori))))
      (push (list slot (sort (remove-duplicates valori) #'string-lessp)) l1)))
  (reverse l1)))
            
          
  





