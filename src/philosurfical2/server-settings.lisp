;;; global settings
(in-package :cl-user)



;;; ------------------------------------------------------------------------------------------------------
;;; change settings bellow accordingly

;;; communication port between Apache server and Lisp
(setf +apache-port+ 3000)

;;; session timeout
(setf *session-timeout* 1800)

;;; sleep time; If more than one server runs on a single machine, some time has to be
;;; allowed in between starting servers
(setf *sleep-time* 0)

;;; indentation of a generated html pages
(setf *indent-html-p* t)

;; logging
(setf mylogfile  #P"~/tmp/hunch-log.txt")


;;; apache server address
(setf *apache-server-address* "http://localhost")

;;; apache root folder --> where the static files are located!
(setf *apache-root* "/homes/mp4239/PhiloSURFIcal/static/")


;;; lisp  root folder in the url 
(setf *bin-root* "/")



;;; the first line of tool's name (the most important)
(setf *tool-name-line-1* "PhiloSurfical")

;;; the second line of tool's name (less important)
(setf *tool-name-line-2* "Browse Thematically Wittgenstein's Tractatus Logico-Philosophicus")

;;; up the default buffer size - required for ocml processing
(setq system:*sg-default-size* 32000)
