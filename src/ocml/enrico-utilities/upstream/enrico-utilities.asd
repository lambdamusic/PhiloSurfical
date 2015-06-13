(defpackage enrico-utilities-system
  (:use :common-lisp :asdf))

(in-package :enrico-utilities-system)

(defsystem :enrico-utilities
  :description "Enrico Motta's Common Lisp Bat-Utility-Belt."
  :components
  ((:module :src
	    :components
	    ((:file "defpackage")
	     (:file "utilities" :depends-on ("defpackage"))))))
