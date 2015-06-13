;;; -*- Mode: LISP; Syntax: Common-lisp; Base: 10; Package: OCML;   -*-

;; naming convention: all the compound words are hyphenated (no underscores used) !




(def-instance Italy country
((part-of-continent Europe)))
(def-instance Germany country
((part-of-continent Europe)))
(def-instance Britain country
((part-of-continent Europe)))
(def-instance Ireland country
((part-of-continent Europe)))
(def-instance Iceland country
((part-of-continent Europe)))
(def-instance Norway country
((part-of-continent Europe)))
(def-instance Finland country
((part-of-continent Europe)))
(def-instance France country
((part-of-continent Europe)))
(def-instance Spain country
((part-of-continent Europe)))
(def-instance Portugal country
((part-of-continent Europe)))
(def-instance Greece country
((part-of-continent Europe)))
(def-instance Albania country
((part-of-continent Europe)))
(def-instance Sweden country
((part-of-continent Europe)))
(def-instance Russia country
((part-of-continent Europe)))
(def-instance Romania country
((part-of-continent Europe)))
(def-instance Hungary country
((part-of-continent Europe)))
(def-instance Polland country
((part-of-continent Europe)))  
;; many others left out

(def-instance Europe continent)
(def-instance America continent)
(def-instance Africa continent)
(def-instance Oceania continent)
;; how's the other continent called?

(def-instance north-america region
((part-of-continent america)))
(def-instance south-america region
((part-of-continent america)))




#|

(def-class GEO-POLITICAL-ENTITY (organization place))   ;;; added by MIKELE 

(def-class Continent (GEO-POLITICAL-ENTITY ))
(def-class City (GEO-POLITICAL-ENTITY )
((part-of-country :type country)))     ;;here we need a transitivity on some properties
(def-class CAPITAL-CITY (city )
((is-capital-of :type country)))
(def-class country (GEO-POLITICAL-ENTITY)
((part-of-region :type Region)
 (part-of-continent :type Continent)))
(def-class Region (GEO-POLITICAL-ENTITY)
((part-of-continent :type Continent)
 (part-of-country :type country)))

|#