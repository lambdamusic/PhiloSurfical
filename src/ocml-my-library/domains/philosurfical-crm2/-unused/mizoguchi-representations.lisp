

(in-package ocml)


(def-class representation (conceptual-object)
((has-form :type representational-form :cardinality 1)
 (has-content :type proposition :cardinality 1)))  



(def-class symbolic-representation (representation)
((has-form :type symbol-sequence)))

(def-class 2d-representation (representation)
((has-form :type still-image)))


(def-class procedure-representation (symbolic-representation)
((has-content :type procedure)))

(def-class musical-score (symbolic-representation)
((has-form :type musical-symbol)
 (has-content :type piece-of-music)))


;; ** repr. form

(def-class representational-form (conceptual-object))

(def-class symbol-sequence (representational-form))

(def-class natural-language (symbol-sequence))

(def-class spoken-language (natural-language))
(def-class written-language (natural-language))

(def-class artificial-language (symbol-sequence))

(def-class musical-symbol (artificial-language))
(def-class mathematical-symbol (artificial-language))
(def-class programming-language (artificial-language))

(def-class still-image (representational-form))

(def-class photo (still-image))
(def-class hand-written-image (still-image))
(def-class figure (still-image))

(def-class motion-image (representational-form))


;; ** proposition

(def-class proposition (conceptual-object))

(def-class design-proposition (proposition))

(def-class product-proposition (proposition))

(def-class procedure (design-proposition))
(def-class piece-of-music (design-proposition))
(def-class drama (design-proposition))
(def-class symbol (design-proposition))
(def-class specification (design-proposition))

(def-class novel (product-proposition))
(def-class poem (product-proposition))
(def-class painting (product-proposition))
(def-class calligraphy (product-proposition))




