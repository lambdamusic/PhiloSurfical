;;; start-up functions
(in-package :cl-user)



(defun start-system ()

  ;;; wait - for security reasons; the server doesn't work properly if started
  ;;; simultaneously with another instance of the server
  (format *standard-output* "Waiting ~D seconds for security reasons." *sleep-time*)
  (sleep *sleep-time*)
  ;;; modification of the action list when quitting the image
  (define-action "When quitting image" "Stop subtle server" 'stop-system)
  ;;; set up session timeout
  (setf hunchentoot::*session-max-time* *session-timeout*)


  ;;; start up Apache listener
  (setf *hunchentoot-port* +apache-port+)

    ;; mikele added the :use-apache-log-p nil for not logging into apache log!!
  (setq *server* (hunchentoot:start-server :port *hunchentoot-port* ))
  (setf (log-file) mylogfile)
  (setf *show-access-log-messages* t)
  (format *standard-output* "~2% .......***** Hunchentoot server started successfully................***** ~2%")
  (format *standard-output* "~1% .......................... caching up web contents.... ~1%")

  ;; cache some stuff 
  (defvar *idx* (format nil "~a" (index)))
  (defvar *tab1* (format nil "~a" (init-tab1)))
  (defvar *tab2* (format nil "~a" (init-tab2)))

  ;; loads the DISPATCHER
  (update-dispatcher)
  (format *standard-output* "~1% *****   ...........Philosurfical contents loaded !           ***** ~2%")

  

  ;;; output value
  t)





(defun stop-system ()
"function for stopping of the server"
  ;(sql:disconnect :database *database*)
  (hunchentoot:stop-server *server*)
  (format *standard-output* "~2%Well done! The server was stopped and we can go home now!"))
