;;; -*- Mode: LISP; Syntax: Common-lisp; Base: 10; Package: OCML;   -*-

;; Philosurfical-CRM ontology

;; here i put all the persistent items , integrating also
;;  0) my modified individuals   1) belief-groups 2) organizations from AKT   3) geo-political entities   4) spatial coordinates and concept appellation 



(in-package "OCML")



(def-class persistent-item (crm-entity)
   "E77-CIDOC - This class comprises items that have a persistent identity, sometimes known as 'endurants' in philosophy.  They can be repeatedly recognized within the duration of their existence by identity criteria rather than by continuity or observation. Persistent Items can be either physical entities, such as 
people, animals or things, or conceptual entities such as ideas, concepts, products of the imagination or common names. The criteria that determine the identity of an item are often difficult to establish -; the decision depends largely on the judgement of the observer. 
++Philosurfical: we went back to the original name in cidoc - cipher called them existence"
    () )



(def-class thing (persistent-item)
   "E70-CIDOC - This general class comprises usable discrete, identifiable, instances of E77 Persistent Item that are documented as single units.  They can be either intellectual products or physical things, and are characterized by relative stability. They may for instance either have a solid physical form, an electronic encoding, or they may be logical concept or structure.
++Philosurfical: we are a little concerned about the has-dimension slot, and its applicability for abstract concepts!We put it under physical-thing.."
   ((had-a-general-use :type type)
    ;; (has-dimension :type dimension)  
    (shows-features-of :type thing)))


 
(def-class legal-object (thing)
   "E72-CIDOC - This class comprises those material or immaterial items to which instances of E30 Right, such as the right of ownership or use, can be applied.  This is true for all E18 Physical Thing. In the case of instances of E28 Conceptual Object, however, the identity of the E28 Conceptual Object or the method of its use may be too ambiguous to reliably establish instances of E30 Right, as in the case of taxa and inspirations.
++Philosurfical: in cypher crm this was put as a subclass of persistent-item - we went back to the original crm spec "
   ((is-subject-to :type right)
    (right-held-by :type actor)) )


;; this class just redefines a few things (physical-man-made-thing) at a higher level, together with Conceptual-object!!!
(def-class man-made-thing (thing)
   "E71-CIDOC - This class comprises discrete, identifiable man-made items that are documented as single units. These items are either intellectual products or man-made physical things, and are characterized 
by relative stability.
++Philosurfical: Should there not be a slot was-made-by? This has been added, of type actor, in cipher... we added it as well. Title is an alias for is-identified-by, however title seems too high up. Does a man-made scratch have a title? We removed the title class, and "
   ((has-title :type title)  ;; we decided to keep it, cause we could be interested in artistic items as well
    (was-intended-for :type type)
    (was-made-by :type Actor) ))  ;; added




(def-class physical-thing (legal-object)
   "E18 -CIDOC - This class comprises all persistent physical items with a relatively stable form, man-made or natural. Depending on the existence of natural boundaries of such things, the CRM distinguishes the 
instances of E19 Physical Object from instances of E26 Physical Feature, such as holes, rivers, pieces of land etc.
++Philosurfical: has-dimension slot was originally of thing, but it makes more sense here. We also have omitted the properties: P49 has former or current keeper, P51 has former or current owner, P58 has section definition, P59 has section. P53 has former or current location has been renamed to has-location. Has-current-keeper and owner moved down to man-made-object"
   ((has-condition :type condition-state)
    (has-dimension :type dimension)  
    (is-composed-of :type physical-thing)
    (has-location :type place)
    (has-owner :type Actor)
    (has-keeper :type Actor)
    (consists-of :type material)))  ;;(is incorporated in)



(def-class physical-object (physical-thing)
   "E19 - CIDOC - This class comprises items of a material nature that are units for documentation and have physical boundaries that separate them completely in an objective way from other objects. The class also includes all aggregates of objects made for functional purposes of whatever kind, independent of physical coherence, such as a set of chessmen. Typically, instances of E19 Physical Object can be moved (if not too heavy).  In some contexts, such objects, except for aggregates, are also called 'bona fide objects' 
(Smith-Varzi, 2000, pp.401-420), i.e. naturally defined objects.
++Philosurfical: two locations slots have been omitted - the inherited has-location seems to be enough. Is-identified-by and has-preferred-identifier have been moved down to man-made-object"
   ((bears-feature :type physical-feature)
    (has-number-of-parts :type number)))




(def-class biological-object (physical-object)
   "E20 - CIDOC - This class comprises individual items of a material nature, which live, have lived or are natural products of or from living organisms. "
    () )



(def-class physical-man-made-thing (man-made-thing physical-thing)
   "E24-CIDOC  - This class comprises all persistent physical items that are purposely created by human activity. This class comprises man-made objects, such as a swords, and man-made features, such as rock art.
++Philosurfical: we do not see the need of all these classes... maybe to remove!!"
   ((depicts :type crm-entity) ;;(is depicted by)
    (shows-visual-item :type 2d-expression) ;; modified by me
    (carries :type information-object)))  ;; (is carried by)   -original from cidoc
#| original cipher slots:
(depicts-concept :type conceptual-object)
    (depicts-event :type event)
    (depicts-physical-thing :type physical-thing)
    (shows-visual-item :type visual-item)) )
|#


(def-class collection (physical-man-made-thing)
"E78 -CIDOC - This class comprises aggregations of physical items that are assembled and maintained (\"curated\" and \"preserved,\" in museological terminology) by one or more instances of E39 Actor over time for a specific purpose and audience, and according to a particular collection development plan. 
++Philosurfical: we might be interested in collection of conceptual objects, so to create a narrative as a sequence of paragraphs/ideas! This class was not included in cipher "
((has-curator :type Actor)))


(def-class man-made-object (physical-man-made-thing physical-object)
   "E22-CIDOC - This class comprises physical objects purposely created by human activity. The difference with physical-man-made-thing is that the latter can also include man-made-features, which do not have a distinct existence as objects "
   ((is-identified-by :type object-identifier)   
    (has-preferred-identifier :type object-identifier)
    (has-current-keeper :type Actor)
    (has-current-owner :type Actor)))


(def-class information-carrier (man-made-object)
"E84-CIDOC - This class comprises all instances of E22 Man-Made Object that are explicitly designed to act as persistent physical carriers for instances of E73 Information Object. This allows a relationship to be asserted between an E19 Physical Object and its immaterial information contents. An E84 Information Carrier may or may not contain information, e.g., a diskette. Note that any E18 Physical Thing may carry information, such as an E34 Inscription. ***However, unless it was specifically designed for this purpose, it is not an Information Carrier. Therefore the property P128 carries (is carried by) applies to E18 Physical Thing in general. 
++Philosurfical: so the relation carries is inherited from Physical-thing - we might want to add a specific relation for man-made objects... e.g. manifestations. This class was left out in cipher-crm...  why? As a manifestation embodiement, it exemplifies it: a single exemplar of a manifestation."
())



(def-class item (information-carrier)
"FRBR : the information carrier that exemplifies a manifestation, i.e. indirectly a production plan"
((exemplifies :type Manifestation :cardinality 1)))



;; shall we introduce a single-manifestation class?



(def-class physical-feature (physical-thing)
   "E26 -CIDOC- This class comprises identifiable features that are physically attached in an integral way to particular physical objects."
    () )


(def-class man-made-feature (physical-man-made-thing physical-feature)
   "E25-CIDOC - This class comprises physical features that are purposely created by human activity, such as scratches, artificial caves, artificial water channels, etc."
    () )


(def-class site (physical-feature)
   "E27-CIDOC  - This class comprises pieces of land or sea floor. In contrast to the purely geometric notion of E53 Place, this class describes constellations of matter on the surface of the Earth or other celestial body, which can be represented by photographs, paintings and maps. "
    () )





;; +++++++++++
;;; ********* ACTORS *************
;; +++++++++++

(def-class actor (persistent-item)
   "E39-CIDOC - This class comprises people, either individually or in groups, who have the potential to 
perform intentional actions for which they can be held responsible.  
++Philosurfical: has former-or-current-residence has been shortened to has-residence.. the first 4 slots only are originally from CIDOC"
   ((has-contact-point :type contact-point)
    (has-residence :type place)  
    (possesses :type right)
    (is-identified-by :type Actor-appellation)))
   ;;  (has-worked-for :type Organization)))  RELATION inferred from Working_for_organization



(def-class individual (actor)
"++PhiloSURFical: If we have a group class, I don't see why not putting also this one" ())

;; (def-class fictitious-person (actor conceptual-object) )  ;; this could stay here: Zeus, Demiurgo, Mani etc.


(def-class person (individual biological-object)
   "E21-CIDOC - This class comprises real persons who live or are assumed to have lived. Legendary figures that may have existed, such as Ulysses and King Arthur, fall into this class if the documentation refers to them as historical figures. In cases where doubt exists as to whether several persons are in fact identical, multiple instances can be created and linked to indicate their relationship. The CRM does not propose a specific form to support reasoning about possible identity. 
++Philosurfical : The class has no slots in CIDOC. We added the gender slot, which has no associated event; the has-social-role slot, cause it's not something we want to record as an event (even if it would be possible), but just a property useful for classifying thinkers; the dates/places of birth/death are shortcuts, cause often we do not want to model the birth/death events for everybody, but still want some basic info about it. In the case of philosophers, in fact, this is not needed cause people do not usually dispute these information, but more their intellectual subscriptions. ****TO DO ****However, sometimes we are interested in modeling such events, so we need to construct an axiom which establishes the priority of one or the other information, or the inference of the existence of an event, from the value of the person slots."
   ((has-gender :type gender)
    (has-date-of-birth :type time-specification)   ;;in the case of unsure dates, it'll be a range
    (has-date-of-death :type time-specification)  
    (has-birth-place :type place)   
    (has-death-place :type place)
    (has-social-role :type social-role)))
  ;;  (has-associated-locations :type place)  inferred from the journeys
  ;;  (was-teacher-of :type person)   it's an event
  ;;  (was-student-of :type person)   it's an event
  ;;  (studied-at :type educational-organization)  part of the event above
  ;;  (is-member-of :type Group-of-people)))  this is another RELATION, inferred from event Joining_a_group

;;this rule is missing here! -->  def-rule locations-visited-has-to-be-associated ?l ?h


(def-class group (actor)
   "E74-CIDOC - This class comprises any gatherings or organizations of two or more people that act collectively or in a similar way due to any form of unifying relationship. A gathering of people becomes an E74 Group when it exhibits organizational characteristics usually typified by a set of ideas or beliefs held in common, or actions performed together. 
++Philosurfical : Has current or former member  has been changed to present tense. Since we can have groups of people and organization, we introduces also the subclass group-of-people. (for groups of objects there is already the class collection"
   ((has-member :type actor)))


;;;; stuff added by MICHELE ***************


(def-class Group-Of-People (Group)
"++PhiloSURFical: I added this class to refer explicitly to groups composed only by people"
((has-member :type person)))

(def-class Belief-Group (Group-Of-People)
"++PhiloSURFical: Group of people united by a shared set of beliefs - it is a social object also because we identify it tx to the belief shared"
((shares-belief :type View :min-cardinality 1)
 (has-related-intellectual-event :type intellectual-movement)))

(def-class Philosophical-school (Belief-group) ?p
"++PhiloSURFical: E.g. the stoics or the circle of vienna, intended as the people composing them" 
((has-related-philo-event :type Philosophical-movement))
:constraint  (and  (shares-belief ?p ?v)
                   (belong-to-area ?v ?a)
                   (branch-of-philosophy ?a)))

#| the old rule was:
:iff-def 
(and (and (has-member ?x ?h)
                   (person ?h))
              (has-social-role ?h philosopher))
:avoid-infinite-loop t)  ;; I want to say that AT LEAST one of the members must be a philosopher!
|#

(def-class Political-group (Belief-group)
"++PhiloSURFical:")

(def-class Religious-group (Belief-group)
"++PhiloSURFical:")




(def-class legal-body (group)
   "E40-CIDOC - This class comprises institutions or groups of people that have obtained a legal recognition as a group and can act collectively as agents.
++Philosurfical: we have added a set of organizations, partly taken from AKT. See below."
   () )




;;; ******** organization imported from AKT  (and slightly modified) 


(def-class ORGANIZATION (legal-body)
  "AKT - An organization is a type of legal agent.
++Philosurfical: the original slot has-affiliated-person has been overridden by has-member:agent; the has-size slot not needed in this context. "
  ((organization-part-of :type organization)
   (has-sub-unit :type organization-unit)
   (headed-by :type person)))


(def-class POLITICAL-ORGANIZATION (organization)
  "AKT - An organization which has a political connotation")


(def-class ORGANIZATION-UNIT (legal-body)
  "AKT - An organization may have a number of units. Units may themselves have sub-units.
++Philosurfical: we have taken out all the address related slots, cause actors already have the has-contact slot. Same as above, for has-size and has-affiliated-person"
  ((unit-of-organization :type organization)
   (sub-unit-of-organization-unit :type organization-unit)
   (has-sub-unit :type organization-unit)
   (headed-by :type person)))    ;; affiliated-person changed to person


(def-rule UNIT-OF-ORGANIZATION-IS-TRANSITIVE
  ((unit-of-organization ?u ?o)
   if
   (sub-unit-of-organization-unit ?u ?u-super)
   (unit-of-organization ?u-super ?o)))
   

(def-class PUBLISHING-HOUSE (organization)
"AKT - ")

(def-class NON-PROFIT-ORGANIZATION (organization)
"AKT - ")

(def-class PROFIT-ORGANIZATION (organization)
"AKT - "
  ((subsidiary-of :type profit-organization)))

(def-class PARTNERSHIP (profit-organization)
  "AKT - A partnership is not necessarily a company, e.g. a consultancy firm is not a company")

(def-class COMPANY (profit-organization)
"AKT - ")

(def-class PRIVATE-COMPANY (company)
"AKT - ")

(def-class PUBLIC-COMPANY (company)
"AKT - ")

(def-class INDUSTRIAL-ORGANIZATION (profit-organization )
"AKT - ")

(def-class GOVERNMENT-ORGANIZATION (non-profit-organization)
"AKT - ")

(def-class CIVIL-SERVICE (GOVERNMENT-ORGANIZATION)
"AKT - ")

(def-class GOVERNMENT (GOVERNMENT-ORGANIZATION)
"AKT - "
  ((government-of-country :type country)))

(def-class CHARITABLE-ORGANIZATION (non-profit-organization)
"AKT - ")

(def-class LEARNING-CENTRED-ORGANIZATION (organization)
"AKT - ++Philosurfical: quite a useful class")

(def-class R-and-D-INSTITUTE (learning-centred-organization )
"AKT - ")

(def-class R-and-D-INSTITUTE-WITHIN-LARGER-ORGANIZATION (r-and-d-institute organization-unit)
"AKT - ")

(def-class EDUCATIONAL-ORGANIZATION (learning-centred-organization)
"AKT - ++Philosurfical: quite a useful class")

(def-class R-AND-D-INSTITUTE-WITHIN-EDUCATIONAL-ORGANIZATION (R-and-D-INSTITUTE-WITHIN-LARGER-ORGANIZATION)
"AKT - ")

(def-class HIGHER-EDUCATIONAL-ORGANIZATION (educational-organization)
"AKT - "
  ((has-academic-unit :type academic-unit) 
   (has-support-unit :type academic-support-unit)))

(def-rule HAS-ACADEMIC-UNIT-IMPLIES-HAS-ORGANIZATION-UNIT
  ((has-sub-unit ?x ?y)
   if
   (has-academic-unit ?x ?y)))

(def-rule HAS-SUPPORT-UNIT-IMPLIES-HAS-ORGANIZATION-UNIT
  ((has-sub-unit ?x ?y)
   if
   (has-support-unit ?x ?y)))

(def-class UNIVERSITY (higher-educational-organization)
"AKT - 
++Philosurfical: the has-vice-chancellor slot could be taken away, cause it's clearly time-related, and we don't need it here in a static way. We could add an event some time in the future..... and actually this applies to all the headed-by properties!!!!"
  ((has-faculty :type university-faculty)
   (has-vice-chancellor :type person))
  :slot-renaming ((has-vice-chancellor headed-by)))

(def-class DISTANCE-TEACHING-UNIVERSITY (university)
"AKT - ")

(def-class SCHOOL (educational-organization)
"AKT - ")

(def-class EDUCATIONAL-ORGANIZATION-UNIT (organization-unit) ?x
"AKT - "
  ((unit-of-organization :type educational-organization)
   )
  :iff-def (and (unit-of-organization ?x ?y)
                (educational-organization ?y)))
                
(def-class ACADEMIC-UNIT (educational-organization-unit)
"AKT - "
  ((unit-of-organization :type university)
   ))

(def-class UNIVERSITY-FACULTY (academic-unit)
"AKT - ")

(def-class ACADEMIC-SUPPORT-UNIT (educational-organization-unit)
"AKT - ")


(def-class GEO-POLITICAL-ENTITY (organization place)
"++PhiloSURFical -  ")   ;;; added by MIKELE 

(def-class Continent (GEO-POLITICAL-ENTITY )
"++PhiloSURFical -  ")
(def-class City (GEO-POLITICAL-ENTITY )
"++PhiloSURFical -  "
((part-of-country :type country)))     ;;here we need a transitivity on some properties
(def-class CAPITAL-CITY (city )
"++PhiloSURFical -  "
((is-capital-of :type country)))
(def-class country (GEO-POLITICAL-ENTITY)
"++PhiloSURFical -  "
((part-of-region :type Region)
 (part-of-continent :type Continent)))
(def-class Region (GEO-POLITICAL-ENTITY)
"++PhiloSURFical -  "
((part-of-continent :type Continent)
 (part-of-country :type country)))



;; ******* CONTACT POINTS

(def-class contact-point (persistent-item)
   "E51-CIDOC - This class comprises identifiers used to communicate with instances of E39 Actor. These include E-mail addresses, telephone numbers, post office boxes, Fax numbers, etc. Most postal addresses can be considered both as instances of E44 Place Appellation and E51 Contact Point.
++Philosurfical: I guess this is left partially open, so to let users adapt it to their needs..."
    () )

;; address is subclass here (too)



;;; ********  APPELLATION


(def-class appellation (persistent-item)
   "E41-CIDOC - This class comprises all proper names, words, phrases or codes, either meaningful or not, that are used or can be used to identify a specific instance of some class within a certain context. Instances of E41 Appellation do not identify objects by their meaning but by convention, tradition or agreement. From an implementation point of view, the class E41 Appellation is unlike most others, whose instances in a database can be considered as surrogates or references to real-world entities, in that each instance is nothing other than the E41 Appellation itself, i.e. the instance of E41 Appellation 'Martin' is nothing other than the name 'Martin' which should not be confused with any instance of E21 Person or persons called Martin."
((has-alternative-form :type appellation) ))

(def-class title (appellation)
" E35-CIDOC - left as it was....
++PhiloSURFical : it may change in the future - see the note on text-structural-roles."
())

;;++
(def-class URI (appellation) ?x
"++Philosurfical : Unique Resource Identifier: a particular type of string")
  
(def-class URL (URI) 
  "++PhiloSURFical -  A URL is a particular type of URI")



(def-class object-identifier (appellation)
   "E42-CIDOC - This class comprises codes assigned to objects in order to identify them uniquely within the context of one or more organisations.Such codes are often known as inventory numbers, registration codes, etc. and are typically composed of alphanumeric sequences."
    () )

;;++
(def-class ISBN-Number (object-identifier)
"++Philosurfical ")



(def-class place-appellation (appellation)
   "E44-CIDOC - This class comprises any sort of identifier characteristically used to refer to an E53 Place. Instances of E44 Place Appellation may vary in their degree of precision and their meaning may vary over time - the same instance of E44 Place Appellation may be used to refer to several places, either because of cultural shifts, or because objects used as reference points have moved around. 
++Philosurfical: the slot (identifies :type Place), which is not present in cidoc, has been removed for now"
    ())

(def-class place-name (place-appellation)
   "E48-CIDOC - This class comprises particular and common forms of E44 Place Appellation. Place Names may change their application over time: the name of an E53 Place may change, and a name may be reused for a different E53 Place"
    () )




(def-class section-definition (place-appellation)
   "E46-CIDOC - This class comprises areas of objects referred to in terms specific to the general geometry or structure of its kind.The 'prow' of the boat, the 'frame' of the picture, the 'front' of the building are all instances of E46 Section Definition. "
    () )

(def-class spatial-coordinates (place-appellation)
   "E47-CIDOC - This class comprises the textual or numeric information required to locate specific instances of E53 Place within schemes of spatial identification. Coordinates are a specific form of E44 Place Appellation, that is, a means of referring to a particular E53 Place. Coordinates are not restricted to longitude, latitude and altitude. Any regular system of reference that maps onto an E19 Physical Object can be used to generate coordinates. 
++Philosurfical: we added some definition of coordinates, pointing to numbers. Boundary boxes define the space occupied by countries, as in Geonames.org. From there we can also retreive other information, such as the capital names!"
((has-latitude :type number)
 (has-longitude :type number)
 (has-altitude :type number)
 (has-bBoxWest :type number)
 (has-bBoxNorth :type number)
 (has-bBoxEast :type number)
 (has-bBoxSouth :type number)))


(def-class address (contact-point place-appellation)
   "E45-CIDOC - This class comprises identifiers expressed in coding systems for places, such as postal 
addresses used for mailing. An E45 Address can be considered both as the name of an E53 Place and as an E51 Contact Point for an E39 Actor. 
++Philosurfical: Address should provide some structure. For now this has been achieved through the slots has-street-number, has-street-name, has-town-or-city-name, has-country"
   ((has-email-address :type string)
    (has-country :type string)
    (has-street-name :type string)
    (has-street-number :type string)
    (has-town-or-city-name :type string)) )


(def-class time-appellation (appellation)
   "CIDOC - This class comprises all forms of names or codes, such as historical periods, and dates, which are characteristically used to refer to a specific E52 Time-Specification. The instances of E49 Time Appellation may vary in their degree of precision, and they may be relative to other time frames, 'Before Christ' for example. Instances of E52 Time-Specification. are often defined by reference to a cultural period or an event e.g. 'the duration of the Ming Dynasty'."
    () )

(def-class date (time-appellation)
   "E50-CIDOC - This class comprises specific forms of E49 Time Appellation.
++Philosurfical: for the moment we don't see how this makes things easier..."
    () )


(def-class conceptual-object-appellation (appellation)
   "E75-CIDOC - This class comprises all specific identifiers of intellectual products or standardized patterns, e.g. an ISBN number"
    () )

;;++
(def-class idea-appellation (conceptual-object-appellation)
"++PhiloSURFical - Class to refer to the names of concepts: typical of area is an interesting property, likely to be used in information extraction"
((typical-of-area :type Field-of-study)))


;; title is a subclass of appellation and linguistic object

(def-class actor-appellation (appellation)
"CIDOC - This class comprises any sort of name, number, code or symbol characteristically used to identify an E39 Actor.  "
())





