
(in-package :cl-user)



;;; ------------------------------------------------------------------------------------------------------
;;; extended tbnl functionality

;;; html macro
(defmacro with-html (&body body)

  `(cl-who:with-html-output-to-string (*standard-output* nil :prologue t :indent ,*indent-html-p*)
     ,@body))


;;; html macro without prologue
(defmacro with-html-np (&body body)

  `(cl-who:with-html-output-to-string (*standard-output* nil :prologue nil :indent ,*indent-html-p*)
     ,@body))


;;; authorisation macro
(defmacro with-authorisation (&body body)

  `(cond ;;; user is already authorised
         ((session-value 'user-authorised)
          ,@body)

         ;;; user is being authorised
         ((login-check (parameter "user-id") (parameter "password"))
          (setf (session-value 'user-authorised) t
                (session-value 'user-id) (str2sym (parameter "user-id"))
                )
          ,@body)

         ;;; keyword - user is being authorised as a guest
         ((keyword-check (parameter "keyword"))
          (setf (session-value 'user-authorised) t
                (session-value 'user-id) 99
                )
          ,@body)

         ;;; user is not authorised -> redirection
         (t (delete-session-value 'user-authorised)
            (redirect (format nil "~Aindex?not-authorised=t" *bin-root*)))))




;;; ------------------------------------------------------------------------------------------------------
;;; system specific functions (login, action retrieval)

#|
;;; login check
(defun login-check (user-id password)

  ;;; authorisation of an user
  (authorise-user user-id password))
|#



;;; generation of page title
(defun page-title ()

  (concatenate 'string *tool-name-line-1* " - " *tool-name-line-2*))



(defun blank-lines (n)
"Simple function to output a defined number of blank lines"
(with-html-np
  (dotimes (i n)
    (cl-who:htm (:br)))))








;;; ------------------------------------------------------------------------------------------------------
;;;
;; cache some stuff 
(defvar *idx* (format nil "~a" (index)))
(defvar *tab1* (format nil "~a" (init-tab1)))
(defvar *tab2* (format nil "~a" (init-tab2)))



