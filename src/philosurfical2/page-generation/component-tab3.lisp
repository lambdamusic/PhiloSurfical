(in-package cl-user)


;; +++++++++++++++
;; third tab----> the narratives
;; ++++++++++++++++



(defun generate-third-tab ()
"Generates the third tab when philosurfical is run"
(with-html-np
  (:div :class "tabbertab"  :title "Browse the pathways" :id "learning_paths"
   (:div :id "left_box" 
 
    (:div :class "tabber" :id "selection-tabber" 
     (:div :class "tabbertab" :title "Starting point" :id "selection"
      (cl-who::str (create-helpbar 'help6trigger 'help6))  ;;to be changed

      (:div :id "selection_box"
       
      ;; (:h2 :style "background: lavender; font-size: 20px;"  (cl-who::str (format nil "Selection box (<a href='#' onclick='hideSelectionBox()'>Close</a>)")))
      (:div :class "narrative_start" 
        (:b "The most recent content you have selected is:")
        (:form 
         (:input :size "25" :type "text" :id "selection" :value "nothing selected" :onKeyPress "return false")
         (cl-who::str (format nil "<input type=\"button\" value=\"See available pathways\" onclick=\"startNewPathway()\"> "))
         (cl-who::str (format nil "<input type=\"button\" value=\"Save it for later\" onclick=\"addNarrativeStep()\"> ")))
        (:b (cl-who::str (format nil "or <a href=\"#\" onclick=\"return popitup('choosecontent')\">choose another content </a>")))))

     (:div :id "instance_info" 
      (:h2 "All information about instance: <em> unselected </em>")))  
  
     (:div :class "tabbertab" :title "Pathways" :id "focus"
      (cl-who::str (create-helpbar 'help7trigger 'help7))
      (:div :id "focus_box"   
       (:div :id "narrative_roll"
        (:h2 "Item in focus: <em>nothing selected</em>" ))))
      ;;(:b "Select a content and move it into focus to see it here!")
     ;; many other things added here
   
   
     (:div :class "tabbertab" :title "Recent items" :id "save"
      (cl-who::str (create-helpbar 'help8trigger 'help8))

      (:div :id "pathways_list"
       (:h2 :style "background: lavender; font-size: 20px;" (cl-who::str (format nil "Saved topics box (<a href='#' onclick='clearNarrativeSteps()'>Empty it!</a>)")))
       (:div :class "activePathways"
       "Here you can store the connections you like")))))
       
   
   (:div :id "right_box"
    (:div :id "graphbox" 
     (cl-who::Str (generate-graph-specs))
     ;; here we load the applet
     )))))


;; triggered whenever we select one new content
(defun generate-instance-info ()
  (let* ((raw-instance (get-parameter "instance"))
         (instance (read-from-string (make-it-ocml raw-instance)))
         (*package* (find-package "OCML")))
    (with-html-np
      (:h2 (cl-who::str (format nil "All information about instance: <em>~a</em>" 
                                (if (ocml::common-name instance)
                                    (pretty-look (sym2lcstr (ocml::common-name instance)))
                                  (pretty-look (sym2lcstr instance))))))
      (:div :id "desc_instance" 
       (cl-who::str (format nil "~a" 
                            (gen-html-desc-instance (read-from-string raw-instance))))))))

;;:b (cl-who:str (format nil "Many info about ~a" instance))))))



(defun gen-html-desc-instance (inst-name)
"Retrieves the instance description"
  (let* ((inst (first (ocml::find-all-current-instances-named-x (read-from-string (make-it-ocml inst-name)))))
         (parent (ocml::parent-class inst))
         (empty-slots)
         (html ""))
    (setq html (format nil "<b>Instance  <a name=\"~a\"> ~a</a>  of class ~S</b><p>"
            inst-name inst-name (ocml::name parent)))
    (loop for slot in (ocml::domain-slots parent)
          for values = (ocml::get-slot-values inst slot)
          ;;;;;when values
          do
          (if values
            (setq html (format nil "~a <li>    ~S: <span class='value'> ~S~{, ~S~}</span></li>"
                    html slot (car values)(cdr values)))
            (push slot empty-slots))
          finally
          (when empty-slots
            (setq html (format nil "~a <li>   The following slots have no value: <span class='value'> ~S~{, ~S~}</span></li>"
                    html (car empty-slots)(cdr empty-slots)))))
    (values html)))










(defun start-new-pathway ()
"Updates the learning narratives tab, depending on the metadata selected"
  (let* ((m-data (get-parameter "instance"))
        )
    (with-html-np
      (:h4 (cl-who::str (format nil "Item in focus: <span class=\"focusitem\">~a</span>" (string-capitalize (sym2str m-data)))))

      (:h3 "Available Pathways") 
      (:div :class "narrative_choices" (cl-who::Str (generate-pathways-info m-data)))
      (:div :class "narrative_choices2" "" )


      (:h3 "Generated Links" )
      (:div :class "narrative_links" (cl-who::Str (generate-narrative-links m-data)))))) 

#|
       (:div :class "narrative_step"
        (:b (cl-who::str (format nil "~a" (pretty-look (sym2str m-data ))))))

       (:div :class "toggler-d" :title "Info on Instance" 
        (:div :class "instance_info" (cl-who::Str (generate-instance-info m-data))))

       (:div :class "toggler-d" :title "Available Pathways" 
        (:div :class "narrative_choices" (cl-who::Str (generate-pathways-info m-data))))

       (:div :class "toggler-d" :title "Generated Links" 
        (:div :class "narrative_links" (cl-who::Str (generate-narrative-links m-data))))))))    
   
|#






;;style=\"cursor: pointer; cursor: hand;\"
(defun generate-narrative-links (item)
  (let ((scholar-link (format nil "http://scholar.google.com/scholar?num=20&hl=en&lr=&q=~a&btnG=Search&as_subj=soc"   (pretty-link (sym2str item))))
        (sep-link (format nil "http://plato.stanford.edu/search/searcher.py?query=~a" 
                          (pretty-link (sym2str item))))
        (noesis-link (format nil "http://noesis.evansville.edu/results.htm?cof=FORID%3A11&cx=001558599338650237094%3Ad3zzyouyz0s&as_q=more%3Anoesis&q=~a&sa=Search" 
                             (pretty-link (sym2str item)))))

    (with-html-np
      (:b "Search on:")
      (:br (:a :href scholar-link :target "_BLANK" "Google Scholar"))
      (:br (:a :href sep-link :target "_BLANK" "SEP"))
      (:br (:a :href noesis-link :target "_BLANK" "NOESIS")))))





;; will have to add some onlick functions, for bringing back into focus some selected stuff
(defun add-new-step ()
"Updates the My-pathways box content, depending on the metadata selected"
  (let* ((m-data (get-parameter "instance"))
         (ocml-data (read-from-string (make-it-ocml m-data))))
    (if (ocml::instance-of? ocml-data 'ocml::electronic-publication)
        ;;if it's a uri
        (format nil "<li ondblclick=\"updateSelectionFromSaved('~a');\"  onClick=\"window.open('~a','window name','width=900,height=400,toolbar=no,directories=no, status=no, scrollbars=yes, resizable=yes')\">Step     :  <b>~a</b>    (instance of <i>~a</i>)</li>"
            m-data
            (first (ocml::what-url? ocml-data))
            (if (ocml::common-name ocml-data)
                                    (pretty-look (sym2lcstr (ocml::common-name ocml-data)))
                                  (pretty-look (sym2lcstr ocml-data)))
            (let ((*package* (find-package "OCML")))
              (pretty-look (sym2lcstr (ocml::get-father-from-instance ocml-data)))))
      ;;if not
      (format nil "<li onclick=\"updateSelectionFromSaved('~a');\">Step     :  <b>~a</b>    (instance of <i>~a</i>)</li>"
              m-data
              (if (ocml::common-name ocml-data)
                  (pretty-look (sym2lcstr (ocml::common-name ocml-data)))
                (pretty-look (sym2lcstr ocml-data)))
              (let ((*package* (find-package "OCML")))
                (pretty-look (sym2lcstr (ocml::get-father-from-instance ocml-data))))))))


            




(defun generate-graph-specs () 
(format nil "  <APPLET
						id=\"cohereGraphApplet\"
						name=\"cohereGraphApplet\"
						archive=\"/static/lib/cohere.jar, /static/lib/prefuse.jar, /static/lib/plugin.jar\"
						code=\"cohere.CohereApplet.class\"
						width=\"100%\" 
						height=\"100%\"
						mayscript=\"true\"
						scriptable=\"true\"
						alt=\"(Your browser recognizes the APPLET element but does not run the applet.)\">						<EM>Your browser either has no Java support at all or it has Java support disabled.</EM>					
              </APPLET>"))






        

(defun generate-pathways-info (instance)
"Checks what are the avaliable pathways, and output html with the correct js calls for updating the graph"
  (let* ((ocml-instance (read-from-string (make-it-ocml instance)))
         (pathways (ocml::check-available-pathways ocml-instance))
         (result "")) 
    (with-html-np
      (dolist (pathway pathways)
        (setf result (format nil "~a <li><span onclick=\"loadGraph('~a' , '~a');\"  onmouseover=\"describePathway('~a');\"  onmouseout=\"describePathway('');\">  ~a </span> </li>" 
                            result
                            pathway
                            instance
                            pathway 
                            (pathway-name (sym2lcstr pathway))))))
    result))
  



;; just returns the pretty name of a pathway - will have to add all of them!
(defun pathway-name (shortname)
"Returns the "
  (let ((result ""))
    (dolist (pathway ocml::*pathways-list*)
      (if (equal shortname (sym2lcstr (first pathway)))
          (setf result (second pathway))))
    result))


(defun pathway-info ()
"returns the info associated with a pathway"
  (let ((pathname (get-parameter "name"))
        (result ""))
    (dolist (pathway ocml::*pathways-list*)
      (if (equal (string-downcase pathname) (sym2lcstr (first pathway)))
          (setf result (third pathway))))
    result))



(defun build-graph-components ()
"Retrieves the path and instance from javascript, use that to get the path-explosion result and formats that into the right applet construction code. In order for the applet to load properly the values, we must format them by listing 1) all the nodes - we do this through the <allnodes> routine, and 2) all the connections among the nodes - we do this iterating on the <exploded-path> value.... the output of <ocml::explode-pathway> is a list of lists with <relation><value1 - value2>. "
  (let* ((path (get-parameter "narrativetype"))
         (instance (get-parameter "narrativeitem"))
         (ocml-instance (read-from-string (make-it-ocml instance)))
         (ocml-path (read-from-string (make-it-ocml path)))
         (exploded-path (ocml::explode-pathway (funcall ocml-path ocml-instance) ocml-path))
         (allnodes (let ((group '()))
                     (dolist (item exploded-path)
                       (push (second item) group))
                     (remove-duplicates (breakdown-list2 group))))
         (result ""))
    (dolist (item allnodes)
      (setq result (format nil "~a~% applet.addNode(\"~a\", \"~a\", \"\", \"\", 0)"  
                           result 
                           item   ;; <---- only this is what is sent OUT by the applet
                           (cond ((equal (read-from-string path) 'TH-WITT-IDEAS-MAP)
                                  (let ((commonname  (ocml::common-name (read-from-string (make-it-ocml item)))))
                                    (if commonname
                                        commonname 
                                      (string-capitalize (sym2str item)))))
                                 ((equal (read-from-string path) 'txt-strict-string-matching)
                                  (let ((commonname  (ocml::common-name (read-from-string (make-it-ocml item)))))
                                    (if commonname
                                        commonname 
                                      (string-capitalize (sym2str item)))))
                                 
                                 ((equal (read-from-string path) 'txt-non-strict-string-matching)
                                  (let ((commonname  (ocml::common-name (read-from-string (make-it-ocml item)))))
                                    (if commonname
                                        commonname 
                                      (string-capitalize (sym2str item)))))
                                 (t (string-capitalize (sym2str item)))))))

    (dolist (item exploded-path)
      (setq result (format nil "~a~%   	applet.addEdge(\"~a\", \"~a\", \"~a\", \"Positive\", \"~a\", 0, \"\", \"~a\", \"~a\");"
                           result 
                           (gensym) 
                           (first (second item)) (second (second item))
                           (string-downcase (sym2str (first item))) 
                           ;;'type1 'type2)))
                           ;; this leaves the ocml:: prefix, but it seems ok to specify that they are classes!
                          (ocml::get-father-from-instance (read-from-string (make-it-ocml (first (second item)))))

                          ;;'blsbls)))
                          (ocml::get-father-from-instance (read-from-string (make-it-ocml (second (second item))))))))
    result))





(defun breakdown-list2 (l)
"breaks down a complex list  - could be improved"
(let ((l1 nil))
  (dolist (item l)
    (if (atom item)
        (push item l1)
      (dolist (element item)
        (push element l1))))
  (reverse l1)))





;;; for debug
(defun buildtry (path instance)
  (let* ((ocml-instance (read-from-string (make-it-ocml instance)))
         (ocml-path (read-from-string (make-it-ocml path)))
         (exploded-path (ocml::explode-pathway (funcall ocml-path ocml-instance) ocml-path))
         (allnodes (let ((group '()))
                     (dolist (item exploded-path)
                       (push (second item) group))
                     (remove-duplicates (breakdown-list2 group))))
                     
         (result ""))
    (dolist (item allnodes)
      (setq result (format nil "~a~% applet.addNode(\"~a\", \"~a\", \"\", \"\", 0)"  result item item)))
    (dolist (item exploded-path)
      (setq result (format nil "~a~%   	applet.addEdge(\"~a\", \"~a\", \"~a\", \"Positive\", \"~a\", 0, \"\", \"~a\", \"~a\");"    result (gensym) (first (second item)) (second (second item)) (first item) 'type1 'type2)))
    result))


















;;;;;;;;++++++++++++++++++
;;;;;;;;++++++++++++++++++
;;;;;;;;++++++++++++++++++
;;;;;;;;;;*****************  UNUSED ***********
;;;;;;;;++++++++++++++++++







;; doesnt work
(defun break-list (l)
(let ((out nil))
  (dolist (item l)
    (if (atom item)
        (push item out)
      (push (break-list item) out)))
  (reverse out)))



#|
(defun build-graph-components-OLD ()
  (let* ((path (get-parameter "narrativetype"))
         (instance (get-parameter "narrativeitem"))
         (ocml-instance (read-from-string (make-it-ocml instance)))
         (ocml-path (read-from-string (make-it-ocml path)))
         (exploded-path (ocml::explode-pathway (ocml-path ocml-instance) ocml-path))
         (result ""))
(format nil "

	applet.addNode(\"concept1\", \"concept1\", \"\", \"\", 0);
	applet.addNode(\"1\", \"concept2\", \"\", \"\", 0);		
	applet.addNode(\"2\", \"view1\", \"\", \"\", 0);
	applet.addNode(\"3\", \"view2\", \"\", \"\", 0);	
	applet.addNode(\"4\", \"name1\", \"\", \"\", 0);
	
	applet.addEdge(\"5\", \"concept1\", \"2\", \"Positive\", \"defined-by-view\", 0, \"\", \"Idea\", \"View\");	
	applet.addEdge(\"6\", \"1\", \"3\", \"Positive\", \"defined-by-view\", 0, \"\", \"Idea\", \"View\");	
	applet.addEdge(\"7\", \"concept1\", \"4\", \"Positive\", \"hasCommonName\", 0, \"\", \"Idea\", \"Name\");	
	applet.addEdge(\"8\", \"1\", \"4\", \"Positive\", \"hasCommonName\", 0, \"\", \"Idea\", \"Name\"); 
")))
|#


(defun html-arrow ()
  (with-html-np
    (:br "|")
    (:br "|")
    (:br "|")
    (:br "+++")))




;; called from javascript
(defun new-narrative-step ()
"Called when an element within the narrative results is clicked - updates the tab3"
  (let ((metadata (get-parameter "metadata"))
        (narrative (get-parameter "path")))
    (with-html-np
      (cl-who::Str (html-arrow))
      (:br (cl-who::str (generate-narrative-step (read-from-string metadata)))))))

 




(defun generate-narrative-step (item)
"Creates the actual html for the narrative step"
  (with-html-np
    (:div :class "narrative_step" 
     (:b (cl-who::str (format nil "~a" (pretty-look (sym2str item)))))
     (:br (:span :class "info_instance" (cl-who::Str (format nil "...instance of ~a" 
                                                        (ocml::get-father-from-instance (read-from-string (make-it-ocml item)))))))  
     (:div :class "narrative_choices" (cl-who::Str (generate-narrative-choice item)))
     (:div :class "narrative_links" (cl-who::Str (generate-narrative-links item))))))




(defun generate-narrative-choice (item)
  (let ((choices '("textual" "theoretical" "historical" "geographical" "interpretative"))
        (result ""))
    (dolist (choice choices)
      (setf result (format nil "~a <span class='choice' onclick=\"getnarrativeresults('~A', '~A');\">   ~A   </span>" result item choice choice)))
    (with-html-np
      (:b "Pathway:")
      (:br (cl-who::str (format nil "~a" result))))))
 
        
 
 





;; UNUSED:



;;+++++ 
;;; fucntions for the small narrative results BOX
;;+++++



;; referenced from javascript
(defun init-narratives-box ()
"Called whenever the third tab is clicked - updates the right narratives tab"
  (with-html-np
      (:div :id "narrative_results"
       (:h1 "Query Results:"))))


;;called from javascript
(defun update-narratives-box ()
"Called when a narrative is clicked - shows the results of a narrative on the right"
  (let ((metadata (get-parameter "metadata"))
        (narrative (get-parameter "path")))
    (with-html-np
      (:div :id "narrative_results"
       (:h1 "Query Results:")
       (:p (cl-who::str (format nil "data: ~a" (read-from-string metadata))))
       (:p (cl-who::str (format nil "path: ~a" (read-from-string narrative))))
       (:p (cl-who::str (format nil "<span class='try' onclick=\"updatenarrativestep('~A', '~A');\"> click here to test the narr-step  </span>" (read-from-string metadata) (read-from-string narrative))))))))
      

