(in-package cl-user)

(load-package 'cffi)
(load-package 'md5)

(load-package 'cl-base64)
(load-package 'rfc2388)
(load-package 'cl-ppcre)
(load-package 'flexi-streams)
(load-package 'chunga)
(load-package 'url-rewrite)
(load-package 'cl-who)
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
	  ("ocml:library;**;*" "/Users/michelepasin/Desktop/from-live-philosurfical/ocml-my-library/**/*"))))



;; choose the right one for the location...
; --> for the livesite
;; ("ocml:library;**;*" "/homes/mp4239/PhiloSURFical/ocml-my-library/**/*")

;; e.g. others
;; ("ocml:library;**;*" "/Users/michelepasin/Desktop/from-live-philosurfical/ocml-my-library/**/*")