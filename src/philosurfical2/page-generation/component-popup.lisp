;;; +++++++++++++++++++++++++++++++++++++
;;; functions to generate the html HELP files
;;; +++++++++++++++++++++++++++++++++++++



(defvar *main-entities* '((ACTOR (PERSON GROUP-OF-PEOPLE ORGANIZATION))
                          (IDEA  (CONCEPT VIEW  DISTINCTION  PROBLEM-AREA PROBLEM ARGUMENT METHOD RHETORICAL-FIGURE))
                          (WORK  (TEXT PAINTING PIECE-OF-MUSIC DIGITAL-WORK))
                          (PLACE (CONTINENT REGION COUNTRY CITY))
                          (EVENT (BIRTH DEATH SOCIAL-ACTIVITY PUBLICATION INTELLECTUAL-MOVEMENT))
                          ))


(defvar *alphabet*  '(A B C D E F G H J K L M N O P Q R S T V W X Y Z))



(defun choose-content-popup ()
  (with-html
    (:html
     (:head
      (:title "Choose an instance") 
      (cl-who::str (generate-stylesheet-links 
                    '("style-18-10.css" )))
      (cl-who::str (format nil "~a~a" 
                           (generate-middle-javascript 
                            '("jquery.pack.js" "jquery.treeview.js" "jquery.history.pack.js"))
                           (generate-popup-bottom-javascript)))
      )

     (:body
      (:div :id "popup"
       (:div :id "firstcolumn"
        (:div :class "title"  "Please select the main TYPE of entity you are searching for:")
        (:div :class "tree"
        (:ul 
         (cl-who::Str 
          (let ((result ""))
            (dolist (i *main-entities*)
              (setf result (format nil "~a~%<li class=\"main-type\">~a</li>~A" 
                                   result 
                                   (first i)
                                   (let ((result ""))
                                     (dolist (j (second i))
                                       (setf result (format nil "~a~%<li onClick=\"upd2popcolumn('~a')\" class=\"low-type\">~a</li>" 
                                                            result
                                                            j
                                                            (pretty-look (sym2str j)))))   ;;take away -
                                     (setf result (format nil "~%<ul>~a~%</ul>" result)))  
                                                            

                                       )))
            result))))
        (cl-who::str (blank-lines 1))
        (:p "...or " (cl-who::str (format nil "<a href=\"javascript:self.close()\">close</a> the popup"))))

       (:div :id "secondcolumn"))))))
            








(defun update-2-popup ()
"Function that updates the second column the first time: if the results are more than 500, it just shows the clickable alphabet list"
 (let* ((m-data (get-parameter "cchoice")))
   (if (> 500 (length (my-all-instances (read-from-string m-data))))
       (let ((bigset (sort (my-all-instances (read-from-string m-data)) #'string-lessp )))
         (with-html-np
           (:div :class "title" (cl-who::Str (format nil "Showing ~a instances of ~a" (length bigset) m-data)))
           (:ul
            (cl-who::Str
             (let ((result ""))
               (dolist (i bigset)
                 (setf result (format nil "~a <li onClick=\"to_old_win('~a')\"> ~a </li>~%" 
                                      result
                                      i
                                      (if (ocml::common-name i)
                                          (string-upcase (sym2lcstr (ocml::common-name i)))
                                        (string-upcase (pretty-look (sym2lcstr i))))
                                      )))
               result)))))
     (with-html-np
       (:div :class "title" (cl-who::Str (format nil "Too many (~a) instances of ~a to visualize..! Please specify.." 
                                                 (length (my-all-instances (read-from-string m-data))) m-data)))
       (:ul
            (cl-who::Str
             (let ((result ""))
               (dolist (letter *alphabet*)
                 (setf result (format nil "~a <li onClick=\"update_letter('~a', '~a')\"> ~a </li>~%" 
                                      result
                                      letter m-data
                                      letter
                                      )))
               result)))))))
         
        
 

(defun update-letter-popup ()
"Function that updates the second column only with the instances starting with a given letter"
  (let* ((m-data (get-parameter "cchoice"))
        (letter (get-parameter "letterr"))
        (bigset (my-all-instances (read-from-string m-data)))
        (smallset (sort (only-inst-starting-with-letter letter bigset) #'string-lessp)))
    (if smallset
        (with-html-np
          (:div :class "title" (cl-who::Str (format nil "Showing ~a instances of ~a" (length smallset) m-data)))
          (:ul
           (cl-who::Str
            (let ((result ""))
              (dolist (i smallset)
                (setf result (format nil "~a <li onClick=\"to_old_win('~a')\"> ~a </li>~%" 
                                     result
                                     i
                                     (if (ocml::common-name i)
                                         (string-upcase (sym2lcstr (ocml::common-name i)))
                                       (string-upcase (pretty-look (sym2lcstr i))))
                                     )))
               result)))))))


(defun only-inst-starting-with-letter (letter big-group)
(let ((out nil))
  (dolist (instance big-group)
    (let ((name (if (ocml::common-name instance)
                    (string-upcase (sym2lcstr (ocml::common-name instance)))
                  (string-upcase (pretty-look (sym2lcstr instance))))))
      (if (or (equal (string (elt name 0)) (string-upcase letter))
              (equal (string (elt name 0)) (string-downcase letter)))
          (push instance out))))
  out))






;; need to figure out when to call refresh topic list (when we click tab 0, coming from tab 2??)
(defun generate-popup-bottom-javascript()
"Function to generate the javascript contained in the page-header of the POPUP window"
(with-html-np
  (:script :type "text/javascript" (cl-who::str    (format nil " 



	function to_old_win(choice)
	{
	     
                opener.$(\"#selection_box #selection\").attr(\"value\", choice);
                opener.genInstanceInfo(choice);

                // if i dont set the timeout, the function above gives an error!
                setTimeout(\"self.close();\", 100);
	}
	


	
	function upd2popcolumn(choice)
	{        
                 loadingdata = \"<h2>Loading data...</h2>\";
                 $(\"#secondcolumn\").empty().append(loadingdata);
		 $.get(\"update-2-popup\",
	             { cchoice: choice },
	                  function(data){
	                     $(\"#secondcolumn\").empty().append(data);
	                  }
	       );
		
	}



	function update_letter(letter, choice)
	{
                 loadingdata = \"<h2>Loading data...</h2>\";
                 $(\"#secondcolumn\").empty().append(loadingdata);
		 $.get(\"update-letter-popup\",
	             { letterr: letter, cchoice: choice },
	                  function(data){
	                     $(\"#secondcolumn\").empty().append(data);
	                  }
	       );
		
	}
	
")))))	






;; {{{{{{{{{{{{
;; the faq popup


(defun gen-faq-popup ()
  (with-html
    (:html
     (:head
      (:title "Frequently Asked Questions") 
      (cl-who::str (generate-stylesheet-links 
                    '("style-18-10.css" )))
      (cl-who::str (format nil "~a~a" 
                           (generate-middle-javascript 
                            '("jquery.pack.js" "jquery.treeview.js" "jquery.history.pack.js"))
                           (generate-popup-bottom-javascript)))
      )

     (:body
      (:div :id "faq_popup"
       (:div :class "close-popup" :onclick "self.close();"  "Close this popup" )
       (:h1 "F. A. Q. about PhiloSURFical..")

 
       (:div :class "question" "Are you going to develop more the tool?")
       (:div :class "answer"  "Well.. I hope so! PhiloSURFIcal is the result of my <a href=\"http://kmi.open.ac.uk/people/mikele/blog/?page_id=79\" target=_blank >phd work</a> and as such it's been designed and implemented mainly by me. It's a <b>prototype</b>, it just shows some possible functionalities students could benefit from. In order to develop it further and maybe extend it to be a more reusable and social platform, I'd like to collaborate with other people who share the vision of a future for humanities computing!")

      (:div :class "question" "Have you really done everything alone?")
       (:div :class "answer"  "Not really - this work would not be existing if it wasn't for some people who's been inspiring and supporting me all along the way, that is, all the researchers at <a href=\"http://kmi.open.ac.uk/\" target=\"_blank\" >KMi</a> I've been bothering since the day I got there. In particular thanks to my supervisors E.Motta and Z.Zdrahal for the discussions on knowledge modeling issues and the continuous feedback, to Tom Heath for suggesting the name 'philosurfical' and for several late night brainstorming sessions, to Laurian Gridinoc for the first-class javascript consultancies and, last but not least, Dave Lambert for being such a hard-core lisp guru." )

       ;; the last one
       (:div :class "question" "Are you going to add more faqs?")
       (:div :class "answer"  "Certainly! At the moment I'm just very busy fixing a few bugs in the application and inserting more resources in the knowledge base. If you have some urgent question or suggestion please email me (<b>m.pasin at open.ac.uk</b>) and I'll be happy to answer!")
       )))))






;; +++++++++++++++++
;; helper functions
;; +++++++++++++++++



(defun my-direct-instances (classname)
"Outputs the list of the direct instances of a class, in string form"
(let* ((class (read-from-string (make-it-ocml classname)))
       (bigset (ocml::all-current-direct-instances class))
       (*package* (find-package "OCML"))
       (p nil))
  (dolist (item bigset)
    (push (ocml::name item) p))
  p))


(defun my-all-instances (classname)
"Outputs the list of all the instances of a class, in string form"
(let* ((class (read-from-string (make-it-ocml classname)))
       (bigset (ocml::all-current-instances class))
       (*package* (find-package "OCML"))
       (p nil))
  (dolist (item bigset)
    (push (ocml::name item) p))
  p))

