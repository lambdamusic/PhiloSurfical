;;; -*- Mode: LISP; Syntax: Common-lisp; Base: 10; Package: OCML;   -*-

;; Philosurfical-CRM ontology

;; here i put all the temporal entities , integrating also
;;   1) intellectual movements 2) experiment and journey 3) publication-event (AKT)    4) social activities (some from AKT)  5) intellectual activities
;;      6) CLAIMS


(in-package "OCML")



(def-class temporal-entity (crm-entity)
   "E2-CIDOC  - This class comprises all phenomena, such as the instances of E4 Periods, E5 Events and states, which happen over a limited extent in time.  In some contexts, these are also called perdurants. This class is disjoint from E77 Persistent Item. This is an abstract class and has no direct instances. E2 Temporal Entity is specialized into E4 Period, which applies to a particular geographic area (defined with a greater or lesser degree of precision), and E3 Condition State, which applies to instances of E18 Physical Thing. 
++Philosurfical: The slot has-time-span is of type time-specification rather than span as it may be a time point. This is consistent with the CIPHER time ontology."
((has-time-specification :type time-specification)
 (is-equal-in-time-to :type Temporal-Entity) 
 (finishes :type Temporal-Entity) ;;(is finished by)
 (starts :type Temporal-Entity)  ;;(is started by) 
 (occurs-during :type Temporal-Entity)  ;; (includes) 
 (occurs-before :type Temporal-entity)  ;; =  when it finishes, the other has not started yet
 (overlaps-in-time-with :type Temporal-Entity)  ;; (is overlapped in time by)  = finishes after the start of
 (meets-in-time-with :type Temporal-Entity)))   ;; (is met in time by)   = is followed by 


(def-class condition-state (temporal-entity)
   "E3-CIDOC - This class comprises the state of objects characterized by a certain condition over a time span.
++Philosurfical :It seems that there is a missing slot here. A slot has-state could be used to record the state e.g. in-ruins. It is suggested that such information can be recorded in the has-type slot, however according to the scope note for E1 has-type reflects the class hierarchy. Their solution would also treat the state and the time differently without justification from a modelling perspective. For now, this new slot has been added called has-state which for now has been defined as type string. Later a new class state could be added. As in E53, consists-of is written has-part and falls-within is written as is-a-part-of"
   ((consists-of :type condition-state)
    (has-state :type type)) )  ;; we modified it as type.. to be further defined

(def-class period (temporal-entity)
   "E4-CIDOC - This class comprises sets of coherent phenomena or cultural manifestations bounded in time and space. It is the social or physical coherence of these phenomena that identify an E4 Period and not the associated spatio-temporal bounds. [...] Typically this class is used to describe prehistoric or historic periods such as the 'Neolithic Period', the 'Ming Dynasty' or the 'McCarthy Era'. There are however no assumptions about the scale of the associated phenomena. In particular all events are seen as synthetic processes consisting of coherent phenomena. Therefore E4 Period is a superclass of E5 Event. [...] Artistic style may be modeled as E4 Period. 
++Philosurfical: the subclasses intellectual movement and philosophical movement has been added as types of period."
   ((consists-of :type period)
    (falls-within :type period)  ;; (contains)
    (overlaps-with :type period)
    (is-separated-from :type period)
    (took-place-at :type place)
    (took-place-on-or-within :type physical-object)))


;;***** extended for ++Philosurfical

(def-class Intellectual-movement (period)
"++Philosurfical : E.g. enlightememnt, or dadaism.. we will eventually differentiate other types of movement - artistic, etc.."
((has-related-group-of-people :type belief-group)
 (is-typified-by :type view)))    

(def-class Philosophical-movement (Intellectual-movement)
"++Philosurfical : E.g. stoicism, or platonism, or even atomism? or is this just a doctrine??? question here"
((has-related-group-of-people :type philosophical-school)
 (is-typified-by :type view)))



;; EVENTS start HERE

(def-class event (period)
   "E5-CIDOC - This class comprises changes of states in cultural, social or physical systems, regardless of scale, brought about by a series or group of coherent physical, cultural, technological or legal phenomena. Such changes of state will affect instances of E77 Persistent Item or its subclasses. The distinction between an E5 Event and an E4 Period is partly a question of the scale of observation. Viewed at a coarse level of detail, an E5 Event is an 'instantaneous' change of state.
++Philosurfical: no slots added, even if we thinked about the causally-connected-to one..."
   ((had-participant :type actor)
    (occurred-in-the-presence-of :type persistent-item)))


;;++
(def-relation has-attended-event (?p ?event)
  :sufficient
  (and (?p person)
       (?event event)
       (had-participant ?event ?p)))




(def-class activity (event)
   "E7-CIDOC -This class comprises actions intentionally carried out by instances of E39 Actor that result in changes of state in the cultural, social, or physical systems documented. This notion includes complex, composite and long-lasting actions such as the building of a settlement or a war, as well as simple, short-lived actions such as the opening of a door. 
++Philosurfical: There are 2 binary relations here, which have been translated in ocml only as slots. See the original documentation for reference. Had-a-general-purpose has been omitted. Does not appear to add anything useful.Same for used-object-of type."
   ((carried-out-by :type Actor)  ;; performed
    (was-influenced-by :type crm-entity)
    (used-specific-object :type Thing)
    (was-motivated-by :type crm-entity)
    (was-intended-use-of :type man-made-thing)
    (had-specific-purpose :type activity)
    (continued :type activity)))




(def-class beginning-of-existence (event)
   "E63-CIDOC - This class comprises events that bring into existence any E77 Persistent Item. It may be used for temporal reasoning about things (intellectual products, physical items, groups of people, living beings) beginning to exist; it serves as a hook for determination of a terminus postquem and antequem.  "
    ((brought-into-existence :type persistent-item) ))


(def-class end-of-existence (event)
   "E64-CIDOC - This class comprises events that end the existence of any E77 Persistent Item. It may be used for temporal reasoning about things (physical items, groups of people, living beings) ceasing to exist; it serves as a hook for determination of a terminus postquem and antequem. In cases where substance from a Persistent Item continues to exist in a new form, the process would be documented by E81 Transformation."
    ((took-out-of-existence :type persistent-item) ))


#| ---------we manage ourselves all the creation of conceptual entities!.. see below ---------------

(def-class creation (beginning-of-existence activity)  ;; maybe not even activity, but intellectual-activity
   "E65 - This class comprises events that result in the creation of conceptual items or immaterial 
products, such as legends, poems, texts, music, images, movies, laws, types etc. 

note:
++Philosurfical: here we have to say more... if we create a view, or a problem area, don't we have to specify more stuff? We need some deep thinking here. Witt can 
create a concept, and a theory, but somewhere I need to say that the concept is in the context of the theory. And that brentano has created a new field of study 
called introspectionism. Let's flesh out the various features of idea-creation."
    ((has-created :type conceptual-object) ))


(def-class type-creation (creation)
"E83 - This class comprises activities formally defining new types of items.   
It is typically a rigorous scholarly or scientific process that ensures a type is exhaustively 
described and appropriately named. In some cases, particularly in archaeology and the life 
sciences, E83 Type Creation requires the identification of an exemplary specimen and the 
publication of the type definition in an appropriate scholarly forum. 
++Philosurfical: need some meditation here.. how much are we gonna use types??"
((created-type :type type)
 (was-based-on :type crm-entity)))

|#



(def-class formation (beginning-of-existence activity)
   "E66-CIDOC : This class comprises events that result in the formation of a formal or informal E74 Group of people, such as a club, society, association, corporation or nation.  "
    ((has-formed :type Group) ))

(def-class birth (beginning-of-existence)
   "E67-CIDOC - This class comprises the birth of a human beings. E67 Birth is a biological event focussing on the context of people coming into life.(E63 Beginning of Existence comprises the coming into life of any living beings). 
++Philosurfical: it many be the case, as noted by cipher, that some slots are not needed. For example, brought into life seems correct, but from another point of view it seems it could be easily replaced by the brought into existence of the beginning of existence class. For indicating the place, we have the slot took-place-at, inherited from period"
    ((by-mother :type person)
     (from-father :type person)
     (brought-into-life :type person)))


(def-class death (end-of-existence)
   "E69-CIDOC  - This class comprises the deaths of human beings. If a person is killed, their death should be instantiated as E69 Death and as E7 Activity. The death or perishing of other living beings should be documented using E64 End of Existence."
    ((was-death-of :type Person)) )

(def-class destruction (end-of-existence)
   "E6-CIDOC - This class comprises events that destroy one or more instances of E18 Physical Thing such that they lose their identity as the subjects of documentation. "
    ((destroyed :type physical-thing)) )

(def-class dissolution (end-of-existence)
   "E68-CIDOC - This class comprises the events that result in the formal or informal termination of an E74 Group of people.  If the dissolution was deliberate, the Dissolution event should also be instantiated as an E7 Activity. "
    ((dissolved :type Group)))


(def-class transformation (beginning-of-existence end-of-existence) 
"E81-CIDOC - This class comprises the events that result in the simultaneous destruction of one E77Persistent Item and the creation of another E77 Persistent Item that preserves recognizable substance from the first but has a fundamentally different nature and identity. [...] Instances of E81 Transformation are therefore distinct from re-classifications (documented using E17 Type Assignment) or modifications (documented using E11 Modification) of objects that do not fundamentally change their nature or identity. 
++Philosurfical : need some consideration here - cause it's a quite important class"
((resulted-in :type Persistent-Item)  ;; (resulted from)
 (transformed :type Persistent-Item)))  ;;(was transformed by)



;; ++Philosurfical
(def-class experiment (activity)   
"++Philosurfical : used-specific-object comes from activity!"
((within-research-area :type problem-area)
 (has-background-theory :type view)  ;; very broad for now
 (has-assumption :type assumption)
 (proves-view :type view)))




(def-class modification (activity)
   "E11-CIDOC - This class comprises all instances of E7 Activity that create, alter or change E24 Physical Man- Made Thing.  This class includes the production of an item from raw materials, and other so far undocumented objects, and the preventive treatment or restoration of an object for conservation.  Since the distinction between modification and production is not always clear, modification is regarded as the more generally applicable concept. 
++Philosurfical: Use-general-technique and used-specific-technique have been combined into one slot used-technique of type design-or-procedure. However, we will have to consider this more, since we dont have a design class yet, if not related to the philosophical methods!! here we are talking about modifications to physical objects, so we must be careful not to include ph. methods that modify behaviours or attitudes"
   ((has-modified :type Physical-man-made-thing)
    (used-technique :type procedure)  ;; to CHECK
    (employed :type material)))

(def-class part-addition (modification)
"E79-CIDOC  - This class comprises activities that result in an instance of E24 Physical Man-Made Thing being increased, enlarged or augmented by the addition of a part.  "
((augmented :type Physical-man-made-thing)   ;;(was augmented by)
 (added :type Physical-thing)))  ;;(was added by)

(def-class part-removal (modification)
"E80-CIDOC  - This class comprises the activities that result in an instance of E18 Physical Thing being decreased by the removal of a part. "
((diminished :type Physical-man-made-thing)  ;;(was diminished by)
 (removed :type Physical-thing)))  ;; (was removed by)





(def-class move (activity)
   "E9-CIDOC  - This class comprises changes of the physical location of the instances of E19 Physical Object. Note, that the class E9 Move inherits the property P7 took place at (witnessed): E53 Place.This property should be used to describe the trajectory or a larger area within which a move takes place, whereas the properties P26 moved to (was destination of), P27 moved from (was origin of) describe the start and end points only.
++Philosurfical: we considered adding a subclass Journey, to refer to person's trips. Not done it yet. "
((moved :type Physical-Object) 
 (moved-to :type  Place)  ;; (was destination of)
 (moved-from :type place)))  ;; (was origin of)


;;+++
(def-class journey (move)
"++Philosurfical: Added this class to refer to voluntary movement of humans. The slot carried-out-by, from activity, is renamed to has-traveller"
((has-traveler :type person))
:slot-renaming ((has-traveler carried-out-by)))
               


(def-class production (beginning-of-existence modification)
   "E12-CIDOC - This class comprises activities that are designed to, and succeed in, creating one or more new items.  It specializes the notion of modification into production. The decision as to whether or not an object is regarded as new is context sensitive. [...] This entity can be collective: the printing of a thousand books, for example, would normally be considered a single event.
++Philosurfical: This specialises beginning of existence to physical objects.This is a subclass of beginning-of-existence, and also of the class modification. From modification it also inherits the properties of activity."
    ((has-produced :type Physical-Man-Made-Thing) ))   ;; (was-produced-by)



;; ++Philosurfical ---- from AKT 

(def-class PUBLICATION-EVENT (production)   
"++Philosurfical: this class is inspired from the AKT reference ontology. The slots have been slightly modified  -from event-product to has-published. The information-carrier is the physical object produced, while manifestation is the abstract reification of the publication product "
((has-produced-manifestation :type manifestation)
 (has-published :type information-carrier))
   :slot-renaming ((has-published has-produced)))  
  



(def-class transfer-of-custody (activity)
   "E10-CIDOC - This class comprises transfers of physical custody of objects between instances of E39 Actor.  The distinction between the legal responsibility for custody and the actual physical possession of the object should be expressed using the property P2 has type (is type of). A specific case of transfer of custody is theft. 
++Philosurfical: doesnt seem very useful, for now."
   ((custody-surrendered-by :type actor)
    (custody-received-by :type actor)
    (transferred-custody-of :type Physical-thing)) )



(def-class acquisition (activity)
   "E8-CIDOC - This class comprises transfers of legal ownership from one or more instances of E39 Actor to one or more other instances of E39 Actor.  
++Philosurfical|: not very useful for us. "
   ((transferred-title-from :type actor)
    (transferred-title-to :type actor)
    (transferred-title-of :type physical-thing)) )


;; claims are a subclass of attribute assignment
(def-class attribute-assignment (activity)
     "E13-CIDOC - This class comprises the actions of making assertions about properties of an object or any relation between two items or concepts. This class allows the documentation of how the respective assignment came about, and whose opinion it was. All the attributes or properties assigned in such an action can also be seen as directly attached to the respective item or concept, possibly as a collection of contradictory values. 
++Philosurfical: we dont use it for now, quite specific to museum related reosurces and activities"
  ((assigned-attribute-to :type crm-entity)
   (assigned :type crm-entity)))

(def-class condition-assessment (attribute-assignment)
   "E14-CIDOC - This class describes the act of assessing the state of preservation of an object during a particular period.  
++Philosurfical: not very useful" 
   ((has-identified :type condition-state)  ;;(identified by)
    (concerned :type Physical-thing)))   ;;(was assessed by)

(def-class identifier-assignment (attribute-assignment)
   "E15-CIDOC - This class comprises actions assigning or deassigning object identifiers. Examples of such identifiers include Find Numbers and Inventory Numbers.
++Philosurfical : not very useful" 
   ((assigned :type object-identifier)
    (deassigned :type object-identifier)
    (registered :type Physical-object) ))

(def-class type-assignment (attribute-assignment)
   "E17-CIDOC - This class comprises the actions of classifying items of whatever kind. Such items include objects, specimens, people, actions and concepts.  
++Philosurfical : not very useful  - although of possible usage, if the system is used to classify a library of philosophy, for example."
   ((assigned :type type)
    (classified :type crm-entity)))

(def-class measurement (attribute-assignment)
   "E16-CIDOC - This class comprises actions measuring physical properties and other values that can be determined by a systematic procedure.  
++Philosurfical : not very useful"
   ((observed-dimension :type dimension)
    (measured :type thing)))



#|
;; ++PhiloSurfical  <------ IMPORTANT.. needed to store the instantiation process.. ..????
(def-class claim (attribute-assignment)
"++Philosurfical: A claim in general, and in particular within the Philosurfical system. This branch will be extended properly, as claims are the mechanism used for keeping track of users' instantiation of the ontology. It is likely that in the future we'll use an external mini-ontology of claims to do that..."
((has-annotator :type person)
 (has-claim :type interpretation)
 (has-pedagogical-value :type pedagogical-functional-role))
:slot-renaming ((has-annotator was-made-by)
                (has-claim assigned-attribute-to)
                (has-pedagogical-value assigned)))
|#






;; ++PhiloSurfical
(def-class social-activity (activity)
"++Philosurfical: Class comprising all the events where the social component, i.e. th presence of various persons, is essential to their existence"
((had-participant :type person)))


;; from AKT events

(def-class social-gathering (social-activity)
"AKT : ")

(def-class conference (social-gathering)
"AKT : "
  ((published-proceedings :type conference-Proceedings-Reference)))

(def-class workshop (social-gathering)
"AKT : "
  ((published-proceedings :type workshop-Proceedings-Reference)))

(def-class seminar (social-gathering)
"AKT : "
  ((published-proceedings :type workshop-Proceedings-Reference))) ;; we havent defined any specific proceedings yet..


(def-class meeting (social-gathering)
"++Philosurfical: A meeting type of event. Note that both attendee and organizer have  multiple cardinality"
  ((meeting-attendee :type person)
   (meeting-organizer :type person))
  :slot-renaming ((meeting-organizer carried-out-by)  
                  (meeting-attendee  had-participant)))


;;++

(def-class close-social-contact (social-activity)
"++Philosurfical: Class that refers to encounters or other contacts between two persons only"
((had-participant :type person :cardinality 2)
 (has-frequency :type frequency-of-occurence)))

(def-class 2-persons-meeting (close-social-contact meeting)
"++Philosurfical: "
((meeting-attendee :type person :cardinality 1)
 (meeting-organizer :type person :cardinality 1)))

(def-class mail-exchange (close-social-contact)
"++Philosurfical: "
((has-sender :type person :cardinality 1)
 (has-receiver :type person :cardinality 1)
 (has-item-sent :type information-carrier))
:slot-renaming ((has-sender carried-out-by)
                (has-receiver had-participant)))

(def-class telephone-conversation (close-social-contact)
"++Philosurfical: "
((has-caller :type person :cardinality 1)
 (has-receiver :type person :cardinality 1))
:slot-renaming ((has-caller carried-out-by)
                (has-receiver had-participant)))


;;++
(def-class educational-activity (social-activity)
"++Philosurfical: Any activity which has an educational context"
((has-subject-area :type problem-area)))

(def-class teaching (educational-activity)
"++Philosurfical: Generic teaching: not all teaching takes place in schools..."
((has-teacher :type person)
 (has-learner :type person)))

(def-class learning (educational-activity)
"++Philosurfical: Generic learning not all teaching takes place in schools..."
((has-learner :type person)
 (has-teacher :type person)))


;; ++
(def-class joining-a-group (social-activity)
"++Philosurfical: Class that refers events about a person formally and intentionally taking part in a group"
((group-joined :type group)))

(def-class working-for-organization (joining-a-group)
"++Philosurfical: "
((group-joined :type organization)
 (working-role :type social-role))) ;;for now only social role

(def-class teaching-at-institution (working-for-organization teaching)
"++Philosurfical: This class inherits also from the generic teaching class"
((group-joined :type educational-organization)
 (working-role :type teaching-role)))

(def-class learning-at-institution (joining-a-group learning)
"++Philosurfical: This class inherits also from the generic learning class"
((group-joined :type educational-organization)
 (degree-of-study :type academic-degree)))


;; ++
(def-class discussion (social-activity)
"++Philosurfical: Generic activity of discussion - by facilitator we mean the person (or more than one) who starts the discussion or leads it"
((has-facilitator :type person)
 (has-subject-area :type problem-area)
 (has-topic :type problem)))

(def-class argumentation (discussion)
"++Philosurfical: More formal discussion, where view and arguments are well delineated and contrast each other. We do not look into the complex dynamics involved in an argumentation, but just try to give a screenshot of the event"
((involves-argument :type argument-structure)
 (involves-view :type view)
 (has-person-attacking :type person)
 (has-person-defending :type person)))
 

