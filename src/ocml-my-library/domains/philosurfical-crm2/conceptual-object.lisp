;;; -*- Mode: LISP; Syntax: Common-lisp; Base: 10; Package: OCML;   -*-


;; ++Philosurfical-CRM ontology

;; compared to CIDOC: the original type, right and information-object have remained unchanged;
;; we have also integrated  1) AKT publications  2) AKT publication-references  3) ROLES





(in-package "OCML")



(def-class conceptual-object (man-made-thing)
   "E28-CIDOC - This class comprises non-material products of our minds, in order to allow for reasoning about their identity, circumstances of creation and historical implications.
++Philosurfical: Refers-to-concept of type type has been removed. Instead an additional slot is required called refers-to-crm-meta-entity to allow concepts such as classes to be referred to. Refers-to has been written as refers-to-crm-entity. This is used to refer to anything in the CRM knowledge base. The subclass -language- has been taken away, and put under form-of-expression."
((is-identified-by :type conceptual-object-appellation)))





;; ************
;;; from CIDOC: RIGHT and TYPE (language has been taken away, and put under FORM-OF-EXPRESSION)
;; ************

(def-class right (conceptual-object)
   "E30-CIDOC - This class comprises legal privileges concerning material and immaterial things or their derivatives.  These include reproduction and property rights."
())



(def-class type (conceptual-object)
"E55-CIDOC - This class comprises arbitrary concepts (universals) and provides a mechanism for organising them into a hierarchy. This hierarchy is intended to duplicate the names of all the classes present in the model. This allows additional refinement, through subtyping, of those classes which do not require further analysis of their formal properties, but which nonetheless represent typological distinctions important to a given user group.
++Philosurfical: basically type is used to provide classifications which don't find a better place in the ontology"
   ((has-broader-term :type type)
    (has-narrower-term :type type)))


(def-class gender (type)
   "++Philosurfical: Added by philosurfical"
    () )
;; a couple of inevitable instances
(def-instance male gender)
(def-instance female gender)


(def-class material (type)
   "E57-CIDOC - This class is a specialization of E55 Type and comprises the concepts of materials Instances of E57 Material may denote properties of matter before its use, during its use, and as incorporated in an object, such as ultramarine powder, tempera paste, reinforced concrete"
    () )


(def-class measurement-unit (type)
   "E58-CIDOC - No local slots. 
++Philosurfical: Not sure why it is a subclass of type"
    () )


;;++Philosurfical
(def-class Genre (type)
"++Philosurfical: Literary form used to represent a linguistic expression. Here we do not refer to the material features of it, but to the abtract structure a text or any other work can implement. E.g. a sonnet, a stanza, an aphorism. We also include the pedagogical discourse types, even if they have a much less structured form compared to the literary ones.")
(def-class Literary-genre (Genre) 
"++Philosurfical: Basically the styles a literary text can have, otherwise called genres")
;; useful instances  -- RETHINK whether instance or class!
(def-instance Poetry Literary-genre)
(def-instance Confession Literary-genre)
(def-instance Treatise Literary-genre)
(def-instance Essay Literary-genre)
(def-instance Aphorism Literary-genre)
(def-instance Fictional-Text Literary-genre)
(def-instance Meditation Literary-genre)
(def-instance Dialogue Literary-genre)
(def-instance Novel Literary-genre)
(def-instance Biography Literary-genre)
(def-instance Autobiography Literary-genre)
(def-instance Play Literary-genre)

(def-class musical-genre (genre)
"++Philosurfical: ")
(def-instance Ballad musical-genre)
(def-instance Symphony musical-genre)
(def-instance Sonata musical-genre)




;;++Philosurfical
(def-class Problem-type (type)
"++Philosurfical: Characterizations of problems, depending on their solutions' number")
;; useful instances
(def-instance Dilemma Problem-type
"++Philosurfical: Apparently unsolvable problem. A dilemma is a problem offering two solutions, neither of which is acceptable. The two options are often described as the horns of a dilemma, neither of which is comfortable. (en.wikipedia.org/wiki/Dilemma)")
(def-instance Multilemma Problem-type
"++Philosurfical: Problem that has different solutions")
(def-instance Open-problem Problem-type
"++Philosurfical: Problem that  is still unresolved or not categorized")
(def-instance Paradox Problem-type 
"++Philosurfical: A particularly difficult problem,.......It's an 'apparently true statement or group of statements that leads to a contradiction or a situation which defies intuition. Typically, either the statements in question do not really imply the contradiction, the puzzling result is not really a contradiction, or the premises themselves are not all really true or cannot all be true together', (http://en.wikipedia.org/wiki/Paradox)")





;; ************
;;++Philosurfical: ROLE
;; ************


(def-class Role (conceptual-object)
" ++Philosurfical : The function or role objects can play in a context. This class was not part of CIDOC, so we added it"
((played-by :type crm-entity)))


(def-class Social-Role (Role)
"++Philosurfical :Role played by humans within a community"
((played-by :type person)))
(def-class teaching-role (social-role)
"++Philosurfical : ")
;; useful instances
(def-instance Philosopher social-role) ;; a couple of useful instances   - defined by the <common-sense>
(def-instance Scientist social-role) 
(def-instance linguist social-role)
(def-instance writer social-role)
(def-instance logician social-role)
(def-instance professor teaching-role)


(def-class degree-type (role)
"++Philosurfical: Class that subsumes any kind of degrees - phd or cooking degree. We were undecided whether a subclass of type or role, and decided for the last option on the basis it is not used to classify things, but it is more an attribute of a degree, the role it plays within the educational curriculum - conclusion reached thanks to a discussion with Riichiro Mizoguchi")
(def-class academic-degree (degree-type)
"++Philosurfical: Degrees conferred by universities or academic institutions")  ;; can put a constraint here
;; useful instances
(def-instance PhD academic-degree)
(def-instance BA academic-degree)
(def-instance MA academic-degree)
(def-instance Professorship academic-degree)




(def-class pedagogical-functional-role (role)
"++Philosurfical :Generic function that a resource can perform, from the pedagogical perspective"
((played-by :type information-object)))

(def-class textual-structural-role (role)
"++PhiloSURFical : class that gathers the various structures a text can be composed of. We decided to model everything as instances, as this is the level of granularity needed here. The only exception is reference, which has been modeled as class because by doing this we could import all the AKT references. Similarly, all the other entities could be better represented as classes, and by using a model with abstracts also the chosen composition of elements into a presentational structure e.g. what paragraph/intro/summary comes first etc.  - for now we just leave this aside. In the actual ontology, the parts of a text have a number and a slot indicating what text-part-role they represent in the context of a self-contained-expression. It is implicit, and left to the implementation of the system, the increasing or decreasing ordering of the components to be chosen as the presentational structure.")

(def-class reference (textual-structural-role)
())

;; useful instances
(def-instance Remark Pedagogical-functional-role)
(def-instance Original-text Pedagogical-functional-role)
(def-instance Theme Pedagogical-functional-role)
(def-instance Sub-theme Pedagogical-functional-role)
(def-instance Vocabulary-lexicon Pedagogical-functional-role)  ;; this is more a propositinal-content
(def-instance Etymology Pedagogical-functional-role)    ;; this is more a propositinal-content
(def-instance Historical-context Pedagogical-functional-role)
(def-instance Reference-element Pedagogical-functional-role)
(def-instance Exercise Pedagogical-functional-role)
(def-instance Explanation Pedagogical-functional-role)
(def-instance Side-context Pedagogical-functional-role)
(def-instance Main-context Pedagogical-functional-role)
(def-instance Anticipation Pedagogical-functional-role)  ;; double check this!!!!

(def-instance question textual-structural-role)
(def-instance title textual-structural-role)
(def-instance subtitle textual-structural-role)
(def-instance paragraph textual-structural-role)
(def-instance reference textual-structural-role)
(def-instance introduction textual-structural-role)
(def-instance abstract textual-structural-role)
(def-instance summary textual-structural-role)




;;++Philosurfical
(def-class representational-medium (role)
"++Philosurfical: We need this class, cause we need to specify a medium of the manifestation. But this is different from the instance of information-carrier, which is a specific object carrying information. That is, it's one of the items produced as a manifestation, embodied in a specific medium. So the medium, intended as the class of items carrying this feature, is here represented as a type."
())
(def-class paper-medium (representational-medium)
"++Philosurfical:")
(def-class electronic-medium (representational-medium)
"++Philosurfical:")
(def-class audio-based (representational-medium)
"++Philosurfical:")
;; useful instances
(def-instance book-medium paper-medium)
(def-instance canvas-medium paper-medium)
(def-instance audio-tape-medium electronic-medium)
(def-instance video-tape-medium electronic-medium)
(def-instance cd-rom-medium electronic-medium)
(def-instance computer-medium electronic-medium)
(def-instance file-medium electronic-medium)  ;; the material part of it






;; ***********
;; PROPOSITIONAL CONTENTS
;; ***********

(def-class propositional-content (conceptual-object) 
"++Philosurfical: Class that comprises all abstract, man-made contents of information objects and representations in general. We are mainly dealing with philosophical ideas, however we reproduced a simple hierarchy of propositions, inspired by Mizoguchi. As he says in -Tutorial on ontological engineering - Part 3, 2004-,  --- the content of the symbolic representations are recognized as proposition which has two kinds of proposition as its subclasses: Design proposition and Product proposition. The former works as specification of the production of something. The latter itself is the product. For example, a piece of music composed is a specification of the music sound produced by the music player. Procedure is specification of the valid sequence of actions. An execution of the procedure generates a result(product). Novel cannot be specification of anything because it is already a product.----
This division of propositional contens needs further investigation - it is not entirely used by the philosurfical application, as the philosophical-idea entities are our main focus, for now")




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

(def-class Dialogue (philosophical-work)
"Form of literature used by the greeks and indians for purposes of rhetorical entertainment and instruction.")
(def-class treatise (philosophical-work)
"a written work devoted to the systematic examination of a particular subject, usually philosophical or scientific")
(def-class Essay (philosophical-work)
"A short literary comp[osition on a single subject, usually presenting the personal view of the author")
(def-class Autobiography (philosophical-work)
"Biography of oneself narrated by oneself e.g. Augustine's confessions")
(def-class Meditation (philosophical-work)
"A contemplative discourse, usually on a religious or philosophical subject")



;; the other product proposition, philosophical-idea is in another file 





;; ***********
;; INFORMATION OBJECTs
;; ***********


(def-class information-object (conceptual-object legal-object)
"++Philosurfical: it is analogous to the class information-object in CIDOC and DOLCE. The abstraction of objects carrying information, sepatated from theit physical embodiment."
((has-date :type time-specification)))


(def-class expression (information-object)
"FRBR : The intellectual or artistic realization of a work in the form of alpha-numeric, musical, or choreographic notation, sound, image, object, movement, etc., or any combination of such forms.
++Philosurfical: The important property was-made-by is inherited from man-made-thing. We added the has-original-date slot for facilitating the instantiation process: by doing so, we do not have to create all the expressions' instances just for accessing the first publication date!"
((has-form :type representational-form)
 (has-content :type propositional-content)
 (has-original-date :type time-specification)))


(def-class self-contained-expression (expression)
"FRBR-CIDOC : an expression that conveys the whole idea of the proposition it represents"
())
(def-class expression-fragment (expression)
"FRBR-CIDOC : an expression that conveys only partially the content of the proposition it represents"
((part-of-expression :type expression)))


(def-class symbolic-expression (self-contained-expression)
((has-form :type symbolic-form)))
(def-class 2d-expression (self-contained-expression)
((has-form :type iconic-form)))


(def-class text (symbolic-expression)
"++Philosurfical:  "
((has-form :type natural-language)))
(def-class utterance (symbolic-expression)
"++Philosurfical:  "
((has-form :type spoken-language)))
(def-class musical-score (symbolic-expression)
"++Philosurfical:  "
((has-form :type musical-symbol-sequence)
 (has-content :type piece-of-music)))
(def-class Formula (symbolic-expression)
"++Philosurfical:  A syntactically well-formed formula, e.g. in any knowledge representation language."
((has-form :type artificial-language)))

(def-class symbol-figure (2d-expression)
((has-form :type line-image)))
(def-class film (2d-expression)
((has-form :type motion-image)))
(def-class painting (2d-expression)
())
(def-class calligraphy (2d-expression)
())


;; just one fragment for now.. the others will come easily
(def-class symbolic-expression-fragment (expression-fragment)
"++Philosurfical: the has-string-content property is not ontologically sound... but quite a useful shortcut when instantiating hundreds of sentences of a text! "
((has-form :type symbolic-form)
 (has-number-reference :type number)
 (has-string-content :type String)))
(def-class sentence (symbolic-expression-fragment)
"++Philosurfical: an obvious expression fragment we decided to make explicit.. "
((has-form :type natural-language)
 (has-textual-role :type textual-structural-role)))
(def-class word (symbolic-expression-fragment)
"++Philosurfical: atomic linguistic element"
((has-form :type natural-language)))






#|  these are all interpretations
has-as-subject :type propositional-content)
 (is-about :type information-object)
 (describes-depicts :type period)))
|#




;; MANIFESTATION
 
(def-class Manifestation (information-object)
"FRBR: The physical embodiment of an expression of a work.
++Philosurfical: Since a manifestation can also be the single item (manuscript) produced by an author, a publication is something different from a manifestation.In such an extreme case, the instance of manifestation represents the one-element set comprising the only existing copy of the expression - and the instance of the item class stands for the physical object itself. The has-title slot is inherited, and the was-made-by too "
((embodies :type expression :cardinality 1)
 (has-physical-medium :type representational-medium)))

 

;; ++ AKT publications, defined in another file







;; +++++++++
;; REPRESENTATIONAL FORM  ***************************
;; +++++++++


(def-class representational-form (conceptual-object)
"++Philosurfical:  inspired from primarily DOLCE")

(def-class symbolic-form (representational-form)
"++Philosurfical: ")
(def-class iconic-form (representational-form)
"++Philosurfical: ")

(def-class musical-symbol-sequence (symbolic-form)
"++Philosurfical:   ")
(def-class natural-language (symbolic-form)
"++Philosurfical: ")
(def-class artificial-language (symbolic-form)
"++Philosurfical: ")


(def-class still-image (iconic-form)
"++Philosurfical:  ")
(def-class line-image (still-image)
"++Philosurfical:  ")
(def-class motion-image (iconic-form)
"++Philosurfical:  ")


(def-class written-language (natural-language)
"++Philosurfical:"  )
(def-class spoken-language (natural-language)
"++Philosurfical:"  )

(def-class mathematical-notation (artificial-language)
"++Philosurfical:  ")
(def-class programming-language (artificial-language)
"++Philosurfical:   ")

;; a couple of useful instances  -- WATCH OUT this needs to be worked out!!!!!!!!!!!
;; i have no roles, as mizo does, so I need more instances!
(def-instance line-image still-image)
(def-instance hand-drawn-image still-image)
(def-instance photo still-image)








#|

PREVIOUS version


(def-class Work (Information-Object)
"FRBR: A distinct intellectual or artistic creation. A work is an abstract entity; there is no single material object one can point to as the work. We recognize the work through individual realizations or expressions of the work, but the work itself exists only in the commonality of content between and among the various expressions of the work 
++Philosurfical: since work it'a an abstract entity, it doesn't make much sense to specify a form.. right? So we just provide slots from 'original' form and genre. Moreover, there is no date-specification here... works are abstracts..."
((has-original-form :type representational-form)
 (has-original-genre :type genre)
 (is-realized-through :type Expression :min-cardinality 1)))
|#

#|
;; by using expressions (from frbr) we can now represent different editions of the same work, e.g. publications or medium-variations 
(def-class Expression (Information-Object)   
"FRBR : The intellectual or artistic realization of a work in the form of alpha-numeric, musical, or choreographic notation, sound, image, object, movement, etc., or any combination of such forms.
++Philosurfical: The important property was-made-by is inherited from man-made-thing"
((has-date :type time-specification)
 (part-of-expression :type expression)
 (has-expression-part :type expression)
 (has-form :type representational-form)
 (has-genre :type genre)
 (realizes :type work :cardinality 1) 
 (is-embodied-in :type Manifestation :min-cardinality 1)))

  

(def-class symbolic-expression (expression) 
"++Philosurfical: Class of the expressions ordered through a language"
((has-form :type symbolic-form)
 (has-string-content :type string)))

(def-class 2d-expression (expression)
"++Philosurfical: "
((has-form :type still-image)))

(def-class sound-expression (expression)
"++Philosurfical: "
((has-form :type sound)))

(def-class video-expression (expression)
"++Philosurfical: "
((has-form :type motion-image)))

(def-class 3d-expression (expression)
"++Philosurfical:  "
((has-form :type 3d-form)))


(def-class linguistic-expression (symbolic-expression)
"++Philosurfical:  "
((has-form :type natural-language)))

(def-class musical-expression (symbolic-expression)
"++Philosurfical:  "
((has-form :type musical-notation)))

(def-class Formula (symbolic-expression)
"++Philosurfical:  A syntactically well-formed formula, e.g. in any knowledge representation language."
((has-form :type artificial-language)))

(def-class musical-score (musical-expression)
"++Philosurfical:  "
((has-content :type piece-of-music)
 (has-genre :type musical-genre)))

(def-class theatre-play (3d-expression)
"++Philosurfical:   "
((has-form :value theatrical-performance)  ;; not sure of :value
 (has-content :type drama)))


(def-class Word (linguistic-expression)
"++Philosurfical: A term of a Language that represents a concept - usually")
(def-class Sentence (linguistic-expression)
"++Philosurfical: A syntactically well-formed formula of a Language"
((element-of-paragraph :type paragraph)))
(def-class Paragraph (linguistic-expression)
"++Philosurfical:  A paragraph usually delimited by two break lines"
((has-number-reference :type Number)))

(def-class Question (Sentence)
"++Philosurfical:  This is useful cause a problem is usually represented by a sentence")
(def-class Title (Sentence appellation)
"++Philosurfical:  ") 
(def-class Reference (Sentence)
"++Philosurfical:  ")

(def-class Abstract (Paragraph)
"++Philosurfical:  ")
(def-class Introduction (Paragraph)
"++Philosurfical:  ")
(def-class Summary (Paragraph)
"++Philosurfical:  ")



..... also

;; the first two types of manifestations are not explored much, in terms of slots
(def-class AUDIO-PRODUCTION (Manifestation)
  "++Philosurfical: The physical embodiement of a sound expression"
((embodies :type sound-expression :cardinality 1)))

(def-class VIDEO-PRODUCTION (Manifestation)
  "++Philosurfical: The physical embodiement of a video expression"
((embodies :type film :cardinality 1)))


|#

