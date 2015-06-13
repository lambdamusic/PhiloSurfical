


;; ++++++++++++++++++++++++++++++++++++++++++++++ instances example ++++++++++++++++++

;; this is the propositional content
(def-instance Tractatus-Logico-Philosophicus philosophical-work
((was-made-by Wittgenstein)
 (has-title "Tractatus Logico-Philosophicus")))


;; this is the representation
(def-instance Tractatus-original-english-version text
((has-content Tractatus-Logico-Philosophicus)
 (has-form written-english)
 (was-made-by C-K-Ogden) 
 (has-title "Tractatus Logico-Philosophicus")
 (has-date 1922)   ;; it's the date of the translation
 (has-publisher The-Project-Gutenberg-EBook-team)
 (has-publication-reference gutemberg-tractatus-reference)
 (has-publication-date 5-2004)
 ))


;; the following are structure-instances
(def-instance tractatus-chapter-1 chapter
((part-of-text Tractatus-original-english-version)
 (has-number-reference 1)))

(def-instance paragraph-6.35 paragraph
((part-of-text Tractatus-original-english-version)
 (part-of-chapter tractatus-chapter-1)
 (has-number-reference 6.35)
 (has-content sentence-6.35)))

(def-instance paragraph-6.3432 paragraph
((part-of-text Tractatus-original-english-version)
 (part-of-chapter tractatus-chapter-1)
 (has-number-reference 6.3432)
 (has-content sentence-6.35)))


;; the following two are representation-sentence
(def-instance sentence-6.35 sentence
 ((has-string-content "Although the spots in our picture are geometrical figures, nevertheless geometry can obviously say nothing at all about their actual form and position. The network, however, is purely geometrical; all its properties can be given a priori. Laws like the principle of sufficient reason, etc. are about the net and not about what the net describes.")
  (has-form written-english)))

(def-instance paragraph-6.3432 sentence
 ((part-of-text Tractatus-original-english-version)
  (has-string-content "We ought not to forget that any description of the world by means of mechanics will be of the completely general kind. For example, it will never mention particular point-masses: it will only talk about any point- masses whatsoever.")
  (has-form written-english)))




;; finally the represented thing
(def-instance my-file-tractatus represented-thing
((has-representation Tractatus-original-english-version)
 (has-medium file-medium)))






;; ++++++++++++++++++++++++++++++++++++++++++++++ the related classes  ++++++++++++++++++




(def-class conceptual-object (man-made-thing)
   "E28-CIDOC - This class comprises non-material products of our minds, in order to allow for reasoning about their identity, circumstances of creation and historical implications.
++Philosurfical: Refers-to-concept of type type has been removed. Instead an additional slot is required called refers-to-crm-meta-entity to allow concepts such as classes to be referred to. Refers-to has been written as refers-to-crm-entity. This is used to refer to anything in the CRM knowledge base. The subclass -language- has been taken away, and put under form-of-expression."
((is-identified-by :type conceptual-object-appellation)))




;; ***********
;; PROPOSITIONAL CONTENTS
;; ***********

(def-class propositional-content (conceptual-object) )


(def-class design-proposition (propositional-content)
"++Philosurfical: taken from Mizoguchi classification- he says that 'It is essentially a specification for the production phase(mode) which theoretically follows it and used as specification' -. It refers to all proposition which are made in order to specify an activity. In other words, what we are interested in, given a design proposition, is not there yet unless we produce it with an action e.g. a piece of music, or a play")

(def-class product-proposition (propositional-content)
"++Philosurfical: taken from Mizoguchi classification, it refers to all propositions which are concluded in themselves, e.g. a novel, a problem, or a theory. They are not supposed to be used as the specification of something else")

(def-class procedure (design-proposition)
"++Philosurfical:")
(def-class piece-of-music (design-proposition)
"++Philosurfical:")
(def-class symphony (piece-of-music)
"++Philosurfical:")

(def-class drama (design-proposition)  ;; not sure, it'll conflict with work
"++Philosurfical:")
(def-class symbol (design-proposition)
"++Philosurfical:")
(def-class specification (design-proposition)
"++Philosurfical:")

(def-class novel (product-proposition)
"++Philosurfical:")
(def-class poem (product-proposition)
"++Philosurfical:")
(def-class painting (product-proposition)
"++Philosurfical:")
(def-class philosophical-work (product-proposition)
"++Philosurfical: class that comprises all abstract works in philosophy")

(def-class Dialogue (philosophical-work))
(def-class Tractatus (philosophical-work))
(def-class Essay (philosophical-work))
(def-class Autobiography (philosophical-work))
(def-class Meditation (philosophical-work))



;; the other product proposition, philosophical-idea is in another file 


;; **********
;; REPRESENTATION
;; **********
(def-class representation (conceptual-object legal-object)
"++Philosurfical: it is analogous to the class information-object in CIDOC and DOLCE. The abstraction of objects carrying information, sepatated from theit physical embodiment. We have taken, again, Mizoguchi's terminology, as it seemed the most appropriate."
((has-form :type representational-form)
 (has-content :type propositional-content)
 (has-date :type date)
 (has-author :type actor))) ;; e.g. the publisher

(def-class symbolic-representation (representation)
((has-form :type symbol-sequence)))

(def-class 2d-representation (representation)
((has-form :type image)))



(def-class text (symbolic-representation)
"++Philosurfical:  "
((has-form :type natural-language)))
(def-class sentence (symbolic-representation)
"++Philosurfical:  "
((has-form :type natural-language)
 (part-of-text :type text)
 (has-string-content :type string))

(def-class utterance (symbolic-representation)
"++Philosurfical:  "
((has-form :type spoken-language)))
(def-class musical-score (symbolic-representation)
"++Philosurfical:  "
((has-form :type musical-symbol-sequence)
 (has-content :type piece-of-music)))
(def-class Formula (symbolic-representation)
"++Philosurfical:  A syntactically well-formed formula, e.g. in any knowledge representation language."
((has-form :type artificial-language)))



(def-class symbol-figure (2d-representation)
((has-form :type line-image)))
(def-class film (2d-representation))
(def-class painting (2d-representation))
(def-class calligraphy (2d-representation))



;; ***********
;; REPRESENTATIONAL FORM  ***************************
;; this is a classification of signs (signs according to Peirce's schema)

(def-class representational-form (conceptual-object)
"++Philosurfical:  inspired from primarily DOLCE")

(def-class symbol-sequence (representational-form)
"++Philosurfical: ")
(def-class image (representational-form)
"++Philosurfical: ")

(def-class musical-symbol-sequence (symbol-sequence)
"++Philosurfical:   ")
(def-class natural-language (symbol-sequence)
"++Philosurfical: ")
(def-class artificial-language (symbolic-form)
"++Philosurfical: ")


(def-class still-image (image)
"++Philosurfical:  ")
(def-class motion-image (image)
"++Philosurfical:  ")


(def-class written-language (natural-language)
"++Philosurfical:"  )
(def-class spoken-language (natural-language)
"++Philosurfical:"  )

(def-class mathematical-notation (artificial-language)
"++Philosurfical:  ")
(def-class programming-language (artificial-language)
"++Philosurfical:   ")

(def-class line-image (still-image))
(def-class hand-drawn-image (still-image))
(def-class  photo (still-image))






;; STRUCTURE  ... example, I've put only two, but we could have also abstract, summary, etc.

(def-class structure (conceptual-object))

(def-class text-structure (structure))

(def-class text-structure-container (structure)
((has-component :type text-structure-component)
 (structures-text :type text)))

(def-class text-structure-component (structure)
((part-of-container :type text-structure-container)))

(def-class paragraph (text-structure-component)
((has-number-reference integer)
 (part-of-text text)
 (part-of-chapter chapter)
 (has-content sentence)))

(def-class chapter (text-structure-component)
((has-number-reference integer)
 (part-of-text text)
 (has-content sentence)))




;; REPRESENTED-THING

(def-class represented-thing (physical-man-made-thing)
((has-representation representation)
 (has-medium representational-medium)))  ;;or physical object? is it abstract or concrete?




;; ***********
;; MEDIUMs 
;; ***********

(def-class representational-medium (role)
"++Philosurfical: We need this class, cause we need to specify a medium of the manifestation. But this is different from the instance of information-carrier, which is a specific object carrying information. That is, it's one of the items produced as a manifestation, embodied in a specific medium. So the medium is a type."
())
(def-class paper-medium (representational-medium)
"++Philosurfical:")
(def-class electronic-medium (representational-medium)
"++Philosurfical:")
(def-class audio-based (representational-medium)
"++Philosurfical:")

(def-instance book-medium paper-medium)
(def-instance canvas-medium paper-medium)
(def-instance audio-tape-medium electronic-medium)
(def-instance video-tape-medium electronic-medium)
(def-instance cd-rom-medium electronic-medium)
(def-instance hard-drive-medium electronic-medium)
(def-instance file-medium electronic-medium)  ;; the material part of it






