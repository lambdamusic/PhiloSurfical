;;; -*- Mode: LISP; Syntax: Common-lisp; Base: 10; Package: OCML;   -*-

;; Philosurfical-CRM ontology

;; here i put rules and similar stuff


(in-package "OCML")



(enable-fc-watcher-mode)   


(def-rule people-appellations 
  (and (person ?x) (is-identified-by ?x ?y) (not (actor-appellation ?y)))
  then 
  (exec (tell (actor-appellation ?y))))


(DEF-RULE CREATE-COMMON-NAMES 
"If we do not want to bother creating all the common names....."
  (and (has-common-name ?c ?n) (not (concept-appellation ?n)))
  then 
  (exec (tell (concept-appellation ?n))))



