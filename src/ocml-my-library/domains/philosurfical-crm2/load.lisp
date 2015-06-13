;;; Mode: Lisp; Package: ocml

;;; The Open University

(in-package "OCML")



;;(ensure-ontology akt-support-ontology domain
;;                 "OCML:LIBRARY;domains;akt-support-ontology;load.lisp")

(def-ontology philosurfical-crm2
  :author "michele"
;;  :includes (akt-support-ontology)
  :allowed-editors ("")
 
;;  :do-not-include-base-ontology? t
  :files ("top-primitives"  "persistent-item" 
           "temporal-entity" "intellectual-activity" "conceptual-object" 
           "akt-imported" "time-specification"  "philosophical-idea"  
           "-functions" "-pathways" "new")
  :version 1.0)

;; taken out for the translation: "rules-otherstuff"