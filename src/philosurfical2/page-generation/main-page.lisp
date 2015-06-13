




;; ++++++++++
;; main page
;; ++++++++++

(defun index (&aux name)

  (let ((name "Michele"))

    (with-html
      (:html
       (:head
        (:title (cl-who:str (page-title)))  
        (cl-who::str (generate-stylesheet-links 
                      '("style-18-10.css" "tabber.css" "jqmodal.css" "superfish.css" "toggle-elements.css" "cluetip.css")))
        (cl-who::str (format nil "~a~a~a" 
                             (generate-top-javascript)
                             (generate-middle-javascript 
                              '("jquery.pack.js" "jquery.treeview.js" "jquery.history.pack.js"  "tabber.js" "jquery.toggle-elements.js" "superfish.js"  "jqmodal-r9.js" "jquery.dimensions.js" "jquery.cluetip.js" "philosurfical.js" ))
                             (generate-bottom-javascript)))

        (:body
               
         (:div :id "header" 
          (cl-who::str (generate-header nil)))
      
         (:div :id "body"   
          (:div :id "bigtab"
           (:div :class "tabber"  :id "main-tabber"
            (cl-who::str (generate-zero-tab))
            (cl-who::str (generate-first-tab))
            (cl-who::str (generate-second-tab))
            (cl-who::str (generate-third-tab))
            (cl-who::str (generate-fourth-tab)))))

         (:div :id "footer" 
          (cl-who:str (generate-footer)))))))))








;; +++++++
;; dispatcher section
;; ++++++


(defun update-dispatcher ()
  (progn
    (setf *default-handler* #'index)
    (setq *dispatch-table* 
          (nconc
           (mapcar (lambda (args)
                     (apply #'hunchentoot:create-prefix-dispatcher args))
                               ;;static files
                                   '(( "/static/" serve-static)
                                  ;;philosurfical

                                     ("/german-tooltip.html" german-tooltip)
                                     ("/update2"  update-tab2)
                                     ("/update-info" update-info)
                                     ("/init-tab1" give-tab1)  ;;cached
                                     ("/init-tab2" give-tab2)  ;;not needed anymore 
                                     ("/update3" update-tab3)
                                     ("/update-map" update-map-tab)
                                     ("/load-metadata" update-metadata-tab)
                                     ("/refresh-topics" init-alltopiclist)
                                     ("/faq" gen-faq-popup)
                                     ;;pathways
                                     ("/choosecontent" choose-content-popup)
                                     ("/start-new-pathway" start-new-pathway)
                                     ("/new-step" add-new-step)
                                     ("/update-2-popup" update-2-popup)
                                     ("/update-letter-popup" update-letter-popup)
                                     ("/build-graph-components" build-graph-components) 
                                     ("/pathway-info" pathway-info)
                                     ("/get-instance-info" generate-instance-info)
                                     ("/init-ontology" init-fourth-tab)
                                     ("/onto-class-info" onto-descclass)
                                     ;;help section
                                     ("/help1" html-help1)
                                     ("/help2" html-help2)
                                     ("/help3" html-help3)
                                     ("/help4" html-help4)
                                     ("/help5" html-help5)
                                     ("/help6" html-help6)
                                     ("/help7" html-help7)
                                     ("/help8" html-help8)
                                     ("/help9" html-help9)
                                     ;;index
                                     ("/index" *idx*)))

                                     (list #'hunchentoot:default-dispatcher)))))





(defun serve-static ()
  (let* ((uri (hunchentoot:request-uri))
         (file (subseq uri (length "/static/"))))
    (format *error-output* "serve-static: file=~S~%" file)
    (http-write-file file (mime-types file))))

(defun http-write-file (filename mime-type)
  "Send contents of FILENAME to the HTTP stream, along with its MIME-TYPE."
      (setf (hunchentoot:content-type) mime-type)
  (let* ((stream (hunchentoot:send-headers))
	 (buffer (make-array 1024 :element-type '(unsigned-byte 8)))
         (local-filename (format nil "~astatic/~a" *location* filename)))
    (with-open-file (in local-filename :element-type '(unsigned-byte 8))
      (loop for pos = (read-sequence buffer in)
	 until (zerop pos) 
	 do (write-sequence buffer stream :end pos)))))


(defun mime-types (filename)
  (let ((ext (subseq filename (+ 1 (position #\. filename :from-end t)))))
    (second (assoc ext '(("txt" "text/plain")
                         ("css" "text/css")
                         ("lisp" "text/plain")
                         ("html" "text/html")
                         ("js" "text/javascript")
                         ("png" "image/png"))
                   :test #'string=))))

(defun write-http-stream (mime-type payload)
  (setf (hunchentoot:content-type) mime-type)
  (write-sequence payload (hunchentoot:send-headers)))








#|
(list 
;; philosurfical pages
                        (hunchentoot:create-prefix-dispatcher (conc-s *bin-root* "german-tooltip.html") #'german-tooltip)
                        (hunchentoot:create-prefix-dispatcher (conc-s *bin-root* "update2") #'update-tab2)
                        (hunchentoot:create-prefix-dispatcher (conc-s *bin-root* "update-info") #'update-info)
                        (hunchentoot:create-prefix-dispatcher (conc-s *bin-root* "init-tab1") #'init-tab1)
                        (hunchentoot:create-prefix-dispatcher (conc-s *bin-root* "init-tab2") #'init-tab2)
                    ;;    (hunchentoot:create-prefix-dispatcher (conc-s *bin-root* "update3") #'update-tab3)
                        (hunchentoot:create-prefix-dispatcher (conc-s *bin-root* "update-map") #'update-map-tab)
                        (hunchentoot:create-prefix-dispatcher (conc-s *bin-root* "load-metadata") #'update-metadata-tab)           
                        (hunchentoot:create-prefix-dispatcher (conc-s *bin-root* "refresh-topics") #'init-alltopiclist)

                        (hunchentoot:create-prefix-dispatcher (conc-s *bin-root* "faq") #'gen-faq-popup)

       ;; pathway generation
                        (hunchentoot:create-prefix-dispatcher (conc-s *bin-root* "choosecontent") #'choose-content-popup)
                        (hunchentoot:create-prefix-dispatcher (conc-s *bin-root* "start-new-pathway") #'start-new-pathway)
                        (hunchentoot:create-prefix-dispatcher (conc-s *bin-root* "new-step") #'add-new-step)
                        (hunchentoot:create-prefix-dispatcher (conc-s *bin-root* "update-2-popup") #'update-2-popup)
                        (hunchentoot:create-prefix-dispatcher (conc-s *bin-root* "update-letter-popup") #'update-letter-popup)

                        (hunchentoot:create-prefix-dispatcher (conc-s *bin-root* "build-graph-components") #'build-graph-components) 
                        (hunchentoot:create-prefix-dispatcher (conc-s *bin-root* "pathway-info") #'pathway-info)
                        (hunchentoot:create-prefix-dispatcher (conc-s *bin-root* "get-instance-info") #'generate-instance-info)



        ;; ontology tab
                        (hunchentoot:create-prefix-dispatcher (conc-s *bin-root* "init-ontology") #'init-fourth-tab)
                        (hunchentoot:create-prefix-dispatcher (conc-s *bin-root* "onto-class-info") #'onto-descclass)


        ;; help section
                        (hunchentoot:create-prefix-dispatcher (conc-s *bin-root* "help1") #'html-help1)
                        (hunchentoot:create-prefix-dispatcher (conc-s *bin-root* "help2") #'html-help2)
                        (hunchentoot:create-prefix-dispatcher (conc-s *bin-root* "help3") #'html-help3)
                        (hunchentoot:create-prefix-dispatcher (conc-s *bin-root* "help4") #'html-help4)
                        (hunchentoot:create-prefix-dispatcher (conc-s *bin-root* "help5") #'html-help5)
                        (hunchentoot:create-prefix-dispatcher (conc-s *bin-root* "help6") #'html-help6)
                        (hunchentoot:create-prefix-dispatcher (conc-s *bin-root* "help7") #'html-help7)
                        (hunchentoot:create-prefix-dispatcher (conc-s *bin-root* "help8") #'html-help8)
                        (hunchentoot:create-prefix-dispatcher (conc-s *bin-root* "help9") #'html-help9)

                        (hunchentoot:create-prefix-dispatcher (conc-s *bin-root* "index") #'index)



                        #'hunchentoot:default-dispatcher))))


|#



;; start
;;(update-dispatcher)   <---- this is now done in (start-system)








