(in-package cl-user)

;; this was uncommented in the live version
;;(defvar *location* "/homes/mp4239/PhiloSURFical/")
(defvar *location* "/Users/michelepasin/Desktop/from-live-philosurfical/")


;; if you want to load the KB too
(load (concatenate 'string cl-user::*location* "ocml-my-library/domains/philosurfical-crm-kb2/load.lisp"))

;;(use-package 'hunchentoot)

;;; +++++++++++++++++++++++++
;;; ++++++     PHILOSURFICAL stuff 

(in-package "COMMON-LISP-USER")


;;;  server settings: edit the file depending on location!  
(load (concatenate 'string *location* "philosurfical2/server-settings.lisp"))


;; unfortunately we cannot do the same with cl-who
(use-package 'hunchentoot)



;;; loads contents for the website
(load (concatenate 'string cl-user::*location* "philosurfical2/page-generation/component-navigation-bar.lisp"))
(load (concatenate 'string cl-user::*location* "philosurfical2/page-generation/component-header-footer.lisp"))
(load (concatenate 'string cl-user::*location* "philosurfical2/page-generation/component-help.lisp"))
(load (concatenate 'string cl-user::*location* "philosurfical2/page-generation/component-popup.lisp"))
(load (concatenate 'string cl-user::*location* "philosurfical2/page-generation/component-tab0.lisp"))
(load (concatenate 'string cl-user::*location* "philosurfical2/page-generation/component-tab1.lisp"))
(load (concatenate 'string cl-user::*location* "philosurfical2/page-generation/component-tab2.lisp"))
(load (concatenate 'string cl-user::*location* "philosurfical2/page-generation/component-tab3.lisp"))
(load (concatenate 'string cl-user::*location* "philosurfical2/page-generation/component-tab4.lisp")) 


  ;; loads the main-page with the dispatcher
(load (concatenate 'string cl-user::*location* "philosurfical2/page-generation/main-page.lisp"))
(format *standard-output* "~3% ******* The main pages of the website are also loaded! ******* ~2%")




;; ----> online path
;;  :default-pathname  #P"/homes/mp4239/PhiloSURFical/philosurfical2/"



;; need to change this MANUALLY
(defsystem my-system 
  (
  :default-pathname  #P"/Users/michelepasin/Desktop/from-live-philosurfical/philosurfical2/"
  :package cl-user
  :default-type :lisp-file)
  :members ("start-up-functions"
            "functions/support-functions"
            "functions/system-functions"      
            )

  :rules ((:in-order-to :compile :all
           (:requires (:load :previous)))))





(compile-system 'my-system :load t)

