;;; -*- Mode: LISP; Syntax: Common-lisp; Base: 10; Package: OCML;   -*-

;; Philosurfical-CRM ontology

;; here i put the top classes and the primitive values



(in-package "OCML")


(def-class PhiloSURFical-entity ()
"The top class for the philosurfical ontology - gathers together the CRM specifications and the primitive values used by them ad the other integrated ontologies. We have not defined any slot at this level, since it serves mostly for organizational needs")


(def-class crm-entity (PhiloSURFical-entity)
   "E1 - CIDOC - This class comprises all things in the universe of discourse. It is an abstract concept providing for three general properties: 1. Identification by name or appellation 2. Classification by type, allowing further refinement of the specific subclass an instance belongs to  3. Attachment of free text for the expression of anything not captured by formal propertieS 
++Philosurfical: We have renamed this class, which was originally the crm-entity. we have commented the belongs-to relation. Appellation is again the value of identified slot, cause we want to support multi-lingual reference, for sure, plus the fact that conceptual object are ofter referenced to with different names."
   ((has-note :type string)
    (has-type :type type)
    (has-uri :type uri)
    (is-identified-by :type appellation)))



(def-class dimension (crm-entity)    
   "E54 - CIDOC "
   ((has-unit :type measurement-unit)
    (has-value :type number)) )

;;;; from akt!!!!  note that dimension and quantity are exactly the same
;;;  we'll leave only quantity just for not modifying much akt-related classes
;;; and we declare the slot-renaming info
;;;; duration (from akt) becomes then a subclass of quantity!!!!!

(def-class QUANTITY (dimension) ?qun
"++Philosurfical: This class comes from AKT support ontology. It has the same slot specs as dimension, however we left it here cause many (akt) time-related entities depend on it! Hopefully the slot-renaming syntax is correct and will solve all the name related issues"
 ((has-unit-of-measure :type measurement-unit)
  (has-magnitude :type number))
  :slot-renaming ((has-unit-of-measure has-unit)
                  (has-magnitude has-value)))
  
 
;; this akt class disappears forever:
;;(def-class UNIT-OF-MEASURE (intangible-thing)
;; "Any kind of unit of measure, meter, dollar, kilogram, a month, a day, a year etc..")
;; we changed in akt all unit-of-measure into MEASUREMENT-UNIT
;; we are aligning everything to CIDOC   *** checked for old unit-of-measure



(def-class place (crm-entity)
   "E53 - CIDOC - This class comprises extents in space, in particular on the surface of the earth, in the pure sense of physics: independent from temporal phenomena and matter. The instances of E53 Place are usually determined by reference to the position of 'immobile' objects such as buildings, cities, mountains, rivers, or dedicated geodetic marks. A Place can be determined by combining a frame of reference and a location with respect to this frame. It may be identified by one or more instances of E44 Place Appellation.++Philosurfical:  "
   ((consists-of :type place)  ;;(forms part of)  ;;; mmm watch out, the same relation goes from physical-object to material????
    (falls-within :type place)  ;; (contains)
    (overlaps-with :type place)
    (is-identified-by :type place-appellation)))   ;; this includes also spatial coordinates


 


(def-class primitive-value (PhiloSURFical-entity)
   "E59 -CIDOC - This class comprises primitive values used as documentation elements, which are not further elaborated upon within the model.  As such they are not considered as elements within our universe of discourse. No specific implementation recommendations are made. 
Philosurfical: Included as is. Here we can add primitives from the basic ocml ontology, or from the akt one. We'll see.. in order to 1) make the philosurfical ontology completely self-contained, and 2) rely on primitives which match the W3c SW basic datatypes standard (see)"
    () )


(def-class time-primitive (primitive-value)
   "E61 - CIDOC - This class comprises instances of E59 Primitive Value for time that should be implemented with appropriate validation, precision and interval logic to express date ranges relevant to cultural documentation.  
++Philosurfical:  we have integrated a time ontology based on the akt one + Allen's specifications. To be further investigated."
    () )



(def-class number (primitive-value)
   "E60 -CIDOC - This class comprises any encoding of computable (algebraic) values such as integers, real numbers, complex numbers, vectors, tensors etc., including intervals of these values to express limited precision.  
++Philosurfical: it seems that the number spec works as it is, getting the right subclasses form the OCML base ontology. We might want to check this better in the future, and possibly integrate directly a number-types ontology."
    () )

(def-class integer (number)
"++Philosurfical: Inserted in PhiloSURFical for consistency issues with the AKT classes")


(def-class string (primitive-value)
"E62 - CIDOC This class comprises the instances of E59 Primitive Values used for documentation such as free text strings, bitmaps, vector graphics, etc.
++Philosurfical: the class was not present in cipher. It is for sure included in ocml base ontology, hope it doesnt cause problems right now. Possibly we will have to set the include-base-ontology slot to false, when loading ocml, and including all that's needed manually. The type checking thing, is from akt."
    :sufficient-for-type-checking (string ?x))



