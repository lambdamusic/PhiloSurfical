

(in-package cl-user)

(defvar *location* "/homes/mp4239/PhiloSURFical/")

(load (concatenate 'string *location* "asdf/asdf"))




(defun load-package (package)
                   (let ((p (read-from-string (format nil ":~a" package))))
           (asdf:operate 'asdf:load-op p)))




;; we manually load everything. so no need to redo symlinks every time
(pushnew (concatenate 'string *location* "asdf/asdf-libraries/cffi-061012/") asdf:*central-registry* :test #'equal)
(pushnew (concatenate 'string *location* "asdf/asdf-libraries/md5-1.8.5/") asdf:*central-registry* :test #'equal)
(pushnew (concatenate 'string *location* "asdf/asdf-libraries/cl-base64-3.3.2/") asdf:*central-registry* :test #'equal)
(pushnew (concatenate 'string *location* "asdf/asdf-libraries/cl-ppcre-1.3.1/") asdf:*central-registry* :test #'equal)
(pushnew (concatenate 'string *location* "asdf/asdf-libraries/trivial-gray-streams-2006-09-16/") asdf:*central-registry* :test #'equal)
(pushnew (concatenate 'string *location* "asdf/asdf-libraries/flexi-streams-0.12.0/") asdf:*central-registry* :test #'equal)
(pushnew (concatenate 'string *location* "asdf/asdf-libraries/chunga-0.3.1/") asdf:*central-registry* :test #'equal)
(pushnew (concatenate 'string *location* "asdf/asdf-libraries/url-rewrite-0.1.1/") asdf:*central-registry* :test #'equal)
(pushnew (concatenate 'string *location* "asdf/asdf-libraries/cl-who-0.11.0/") asdf:*central-registry* :test #'equal)
(pushnew (concatenate 'string *location* "asdf/asdf-libraries/rfc2388/") asdf:*central-registry* :test #'equal)
(pushnew (concatenate 'string *location* "asdf/asdf-libraries/cffi-061012/") asdf:*central-registry* :test #'equal)
(pushnew (concatenate 'string *location* "asdf/asdf-libraries/hunchentoot-0.12.0/") asdf:*central-registry* :test #'equal)
(pushnew (concatenate 'string *location* "ocml/upstream/") asdf:*central-registry* :test #'equal)
(pushnew (concatenate 'string *location* "ocml/enrico-utilities/upstream/") asdf:*central-registry* :test #'equal)





(load-package 'md5)
(load-package 'cl-base64)
(load-package 'rfc2388)
(load-package 'cl-ppcre)
(load-package 'flexi-streams)
(load-package 'chunga)
(load-package 'url-rewrite)
(load-package 'cl-who)
(load-package 'cffi)

(load-package 'hunchentoot)





(load-package 'ocml)

(in-package ocml)

(initialize-ocml)

;; sets the position of the ocml library... we cannot use the *location* variable here
;; MANUALLY RE-SET IT!
(when (asdf:find-system :ocml nil)
 (setf (logical-pathname-translations "ocml")
	`(("ocml:library;basic;**;*"
	   ,(format nil "~A/library/basic/" (asdf:component-pathname  (asdf:find-system :ocml))))
	  ("ocml:library;**;*" "/homes/mp4239/PhiloSURFIcal/ocml-my-library/**/*"))))


;; if you want to load the KB too
(load (concatenate 'string cl-user::*location* "ocml-my-library/domains/philosurfical-crm-kb2/load.lisp"))











