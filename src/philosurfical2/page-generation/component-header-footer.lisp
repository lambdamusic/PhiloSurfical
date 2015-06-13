;;; +++++++++++++++++++++++++++++++++++++
;;; functions to generate the html content
;;; +++++++++++++++++++++++++++++++++++++




(defun generate-header (user-id)
"Function to generate the header of the page"
    (with-html-np
      ;;; tool name
      (:div :id "header_top_left_image" (cl-who::str (format nil "<img src='/static/img/surfer.jpg' height=70px width=60px />"))) 
      (:div :id "header_top_left"
       (:div :class "header_top_item"
        (:span :id "header_tool_name_1" (cl-who::str *tool-name-line-1*))
        (:br)
        (:span :id "header_tool_name_2" (cl-who::str *tool-name-line-2*))
        (:span :id "header_top_right" (cl-who::str (format nil ""))))) 
      ))




(defun generate-stylesheet-links (args)
"Loops through the css fils passed as arguments, and generates the header calls"
  (let ((result ""))
    (if args
        (loop for arg in args
              do 
              (setf result (format nil "~a~a" 
                                   result
                                   (with-html-np
                                     (:link :rel "stylesheet" :type "text/css" :href (format nil "~acss/~a" "static/" arg) (format nil "")))))))
  result))




(defun generate-top-javascript ()
"Fucntion to create the javascipt to be loaded BEFORE loading the other libraries"
(with-html-np
  (:script :type "text/javascript" (cl-who::str (format nil "

         var tabberOptions = {
   
           'onClick':function(argsObj) {
            var t = argsObj.tabber;
            var id = argsObj.id;
            var i = argsObj.index;
            var e = argsObj.event; }};")))))
         ;;   if (i == '1') {inittab1();} 
         ;;   if (i == '2') {inittab2();} 
         ;;   if (i == '3') {inittab3();}   
         ;;   if (i == '4') {initontology();}}};

           ;;      alert('Finished loading tab2!'); } }};")))))



 #| WORKS          (format nil "var tabberOptions = {

                  'onClick':function(argsObj)

                        {showallmetadata();}};")))))

|#

                   ;;     {alert(\"clicky!\");}};")))))

#|
---> add also this:
    var i = argsObj.index; /* Which tab was clicked (0 is the first tab) */
    var e = argsObj.event; /* Event object */


            var t = argsObj.tabber; /* Tabber object */
            var id = t.id; /* ID of the main tabber DIV */
            if (id == 'learning_paths') {alert(\"clicky!\");}}};")))))
|#



(defun generate-middle-javascript (args)
"Loops through the jscript libraries passed as arguments, and generates the header calls"
  (let ((result ""))
    (if args
        (loop for arg in args
              do 
              (setf result (format nil "~a~a" 
                                   result
                                   (with-html-np
                                     (:script :type "text/javascript" :src (format nil "~ajs/~a" "static/" arg) (format nil "")))))))
  result))



;;not used anymore
(defun generate-bottom-javascript()
"Function to generate the javascript contained in the page-header"
(with-html-np
  (:script :type "text/javascript" (cl-who::str    (format nil " 


    ")))))	



#|
  window.resizeTo(1250,950);  
 
        setTimeout(\"inittab1();\", 200);
  	setTimeout(\"inittab2();\", 600);
  	setTimeout(\"inittab3();\", 2000);
  	setTimeout(\"initontology();\", 3000);
|#




(defun generate-footer ()
"Function to generate the footer of the page"
  (with-html-np
    (:div :id "footer_content"
     (:span :class "footer_text"
      "&nbsp;&nbsp;" (cl-who::str (page-title)))
     (:span :class "footer_img"
    ;;  (:a :href "http://del.icio.us/mpasin/lisp"
       (:img :src (format nil "~Aimg/logo-small.jpg" "static/"))))))
 








