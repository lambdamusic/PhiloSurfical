

(in-package ocml)

(initialize-ocml)

;; sets the position of the ocml library...
(when (asdf:find-system :ocml nil)
 (setf (logical-pathname-translations "ocml")
	`(("ocml:library;basic;**;*"
	   ,(format nil "~A/library/basic/" (asdf:component-pathname
(asdf:find-system :ocml))))
	  ("ocml:library;**;*" "/Users/michelepasin/Documents/Ontologies/OCML-7-3-LW/ocml/library/v5-0/**/*"))))
