(in-package cl-user)





;; +++
;; tractatus html generation
;; ++

    
;; init
(defun generate-first-tab ()
"Generates the original sequence tab"
(with-html-np
  (:div :class "tabbertab" :title "Browse the text" :id "original_text"


       (:div :id "content_left_navigation" 

        (cl-who::str (create-helpbar 'help1trigger 'help1))

        (:p (:b "Book Outline:"))
   
     
        (cl-who::str (generate-navigation-header))
        (cl-who::str (generate-navigation-pane)))

       

       (:div :id "content_middle1" 
        ;(cl-who::Str (init-tab1))))))

         (:p :class "three" "Loading the text...."
          (:img :src "/static/img/busy.gif" :alt "loading"))))))
  
        
       
;; serves the cached contents to js
(defun give-tab1 ()
(format nil "~a" *tab1*))



(defun init-tab1 ()
"Just creates the main text contents"
(with-html-np
  (:p (cl-who::str (spread-out-html1 (ocml::get-tractatus-paragraphs-numbers))))))





;; the onclick function doesnt make sense anymore!
(defun spread-out-html1 (p)
"Function to be used with get-paragraphs-number as argument, which creates the html content for the tab1"
(let ((result ""))
    
    (dolist (item p)
      (setf result (format nil "~a <p class=\"~a\" title=\"Satz ~A\" tooltip=\"german-tooltip.html?prop=~A\"> <b> <a name =\"~A\">~A</a></b><br />~A</p><br />" 
                           result 
                           (format nil "~r" (number-length item)) 
                           item
                           item
                           item item (ocml::sentence-string-content-from-number item))))
    result))




(defun german-tooltip ()
"Function to output the german tooltip of a proposition"
  (let* ((proposition (get-parameter "prop"))
         (ocml-prop (read-from-string proposition))
         (expr (read-from-string (make-it-ocml "Tractatus-original-german-version"))))

  ;; formats the symbol as an ocml::internal one
     ;;    (contents (ocml::get-sentences-numbers (ocml::find-sentences-interpreted-as ocml-data))))
    (with-html
      (:body
       (:p (cl-who::str (format nil "~A" 
                                (ocml::sentence-string-content-from-number ocml-prop expr)))))))) 
             



;;;;;   title="Satz 1" tooltip="tooltiptry.html"    german-tooltip.html?prop=1


