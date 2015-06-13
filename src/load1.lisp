
(in-package cl-user)

(defvar *location* "/Users/michelepasin/Desktop/from-live-philosurfical/")
;;(defvar *location* "/homes/mp4239/PhiloSURFical/")

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

;;; XXX Dave replaced these out-dated ones here...
(pushnew (concatenate 'string *location* "ocml/upstream/") asdf:*central-registry* :test #'equal)
(pushnew (concatenate 'string *location* "ocml/enrico-utilities/upstream/") asdf:*central-registry* :test #'equal)
;;; with the latest version here...
;;(pushnew (concatenate 'string *location* "asdf/asdf-libraries/ocml/") asdf:*central-registry* :test #'equal)
