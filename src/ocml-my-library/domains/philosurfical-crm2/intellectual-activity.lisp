;; ++Philosurfical
;; all the subclasses of temporal-entity/activity involving intellectual stuff

(in-package ocml)



;; main intellectual activities

(def-class intellectual-activity (activity)
"++Philosurfical: Any theoretical activity which creates or modifies directly only abstract entities. This class hierarchy is only indicative, more work is needed here."
((involves-idea :type philosophical-idea)))

(def-class conceptual-creation (intellectual-activity beginning-of-existence)
"++Philosurfical: This class replaces the original CIDOC-E65 - creation"
((has-created :type conceptual-object)))

(def-class idea-conception (conceptual-creation)
"++Philosurfical: "
((has-created :type philosophical-idea)))


(def-class expression-creation (conceptual-creation)
"++Philosurfical:"
((has-created :type expression)))


(def-class idea-modification (intellectual-activity)
"++Philosurfical:"
((has-old-idea :type philosophical-idea)
 (has-new-idea :type philosophical-idea) ;; they must be of the same type
 (within-context :type view)))

(def-class theory-refinement (idea-modification)
"++Philosurfical:"
((has-old-idea :type theory)
 (has-new-idea :type theory)
 (has-added-element :type philosophical-idea)
 (has-removed-element :type philosophical-idea)))


(def-class idea-usage (intellectual-activity)
"++Philosurfical:"
((idea-used :type philosophical-idea)
 (used-in-view :type view)))

(def-class theory-transposition (idea-usage)
"++Philosurfical:"
((idea-used :type theory)
 (old-context :type problem-area)
 (new-context :type problem-area)))


(def-class study (intellectual-activity)   ;; need more thinking here... we can study everything right?????
"++Philosurfical: mmm not sure about this"
((studies :type crm-entity)))

(def-class study-an-idea (study)
"++Philosurfical:"
((studies :type philosophical-idea)))

(def-class study-a-document (study)
"++Philosurfical:"
((studies :type information-object)))

;;(def-class study-an-event (study)   --> what's the sense of STUDYING and event? interpreting it is enough!
;;""
;;((studies :type event)))


(def-class view-subscription (intellectual-activity)
"++Philosurfical: "
((old-view :type view)
 (new-view :type view)
 (convincing-argument :type argument)))






;;++++
;; INTERPRETATIONS
;;++++

;; --> i need to add a rule, saying that the author of the interpretation differs from the author of the 
;;  annotation, i should infer another interpretation at a higher level (see paper)


(def-class interpretation (intellectual-activity)
   "++Philosurfical: The act of making claims about intellectual contents. At this level the only slots are 'what is interpreted', and the generic relation 'is-about' which can link the interpretation to pretty much anything e.g. the book is-about Napoleon. "
((has-interpretation :type propositional-content)
 (interprets :type crm-entity)
 (is-about-entity :type crm-entity)))




(def-class io-interpretation (interpretation)  ;; ADD also document-about-event!!!!!
   "++Philosurfical:  "
((interprets :type information-object)))

(def-class expression-interpretation (io-interpretation)  
   "++Philosurfical: interpretations about expressions, and among them, linguistic representations. An add onof these interpretations is the fact that we can give entities a pedagogical value. "
((interprets :type expression)
 (has-pedagogical-value :type pedagogical-functional-role)))




(def-class event-interpretation (interpretation)
   "++Philosurfical:  "
((interprets :type event)
 (causally-connected-to :type event)))


;; ++
;; interpretations of ideas

(def-class idea-interpretation (interpretation)
"The characteristic feature of an idea interpretation is that we can claim its author to be somebody's different, from the one specified initially with the instance"
((interprets :type propositional-content)
 (was-conceived-by :type actor)
 (is-related-to-idea :type philosophical-idea) ;;generic relation, among ideas of different type
 (similar-to :type philosophical-idea)
 (contrasts-with :type philosophical-idea)))



(def-class concept-interpretation (idea-interpretation)
"Interpretations of concepts"
((interprets :type concept)
 (is-specialization-of :type Concept)  ;; narrower than
 (is-generalization-of :type Concept)  ;; broader than
 (is-equivalent-to :type Concept)  ;; has the same meaning
 (has-opposite-concept :type Concept)    ;; the classic antynomyc relation (--> dychotomy) .. wecould also specify more the various types of antynomy (gradable, relational, complementary)
 (has-related-concept :type Concept)  ;; reflects a generic and positive semantic closure
 (requires-concept :type concept)  ;; notional dependency rule, semantic dependance, implication such as "buy" and "pay"
 (causes-concept :type concept))) ;; e.g. to kill-to die not sure about this one




(def-class View-interpretation (idea-interpretation)
"++PhiloSURFical : interpretations of views: we are replicating some slots of the view class, as an initial mechanism for providing support for inconsistent and contrasting annotations. We'll look into the issue more while enlarging the KB"
((interprets :type view)
 (defines-concept :type Concept)
 (uses-idea :type Philosophical-idea)
 (interprets-fact :type temporal-entity)
 (typifies :type intellectual-movement)
 (tackles-problem :type Problem) 
 (attacked-by-problem :type Problem) 
 (influences-View :type View)  
 (influenced-by-View :type View) ;; influence is something related to the "inspiration"
 (supports-View :type View)  ;; mutually excluding... + inverses somewhere!
 (opposes-View :type View)
 (has-supporting-argument :type Argument)
 (has-opposing-argument :type Argument)
 (has-exemplar-document :type expression)))

(def-class Thesis-interpretation (View-interpretation)
"++PhiloSURFical : thesis interpretations - all the properties are in common with the thesis class"
((interprets :type thesis)
 (part-of-thesis :type Thesis)
 (part-of-theory :type Theory)
 (part-of-school :type school-of-thought)
 (part-of-system :type Philosophical-system)))

(def-class Theory-interpretation (View-interpretation)
"++PhiloSURFical : theory interpretations - all the properties are in common with the theory class"
((interprets :type theory)
 (part-of-theory :type Theory)
 (part-of-school :type school-of-thought)
 (part-of-system :type Philosophical-system)
 (defines-Method :type Method)
 (has-thesis :type Thesis)))


(def-class Philosophical-system-interpretation  (View-interpretation)
"++PhiloSURFical : - all the properties are in common with the referring class "
((interprets :type philosophical-system)
 (part-of-school :type School-of-thought)
 (defines-method :type method)
 (has-theory :type theory)
 (has-thesis :type Thesis)))


(def-class School-of-thought-interpretation  (View-interpretation)
"++PhiloSURFical :  - all the properties are in common with the referring class "
((interprets :type school-of-thought)
 (has-main-thesis :type Thesis)
 (classifies-view :type View)
 (has-exemplar-theory :type Theory) ;; the theory that has inspired it, or helps understanding it
 (has-main-exponent :type actor)))



(def-class Distinction-interpretation (idea-interpretation)
"++PhiloSURFical : just one property for now"
((interprets :type distinction)
 (related-to-problem :type problem)))




(def-class Problem-interpretation (idea-interpretation)
"++PhiloSURFical : interpretations of problems.."
((interprets :type problem)
 (has-problem-type :type problem-type)
 (exists-in-area :type Problem-area)
 (linked-to-fact :type Temporal-entity)
 (attacks-View :type View)
 (has-supportive-view :type View) 
 (is-tackled-by-View :type View)
 (defined-by-argument :type Argument)
 (is-tackled-by-argument :type Argument)
 (related-to-problem :type Problem)
 (derives-from-problem :type Problem)
 (has-equivalent-meaning-as :type problem)
 (has-resolutive-method :type Method)))



(def-class problem-area-interpretation (idea-interpretation)
"++PhiloSURFical : interpretations of problem areas, of their hierarchical relationships"
((related-to-area :type Problem-area) ;;this should also be inferred, depending on the closure of problems
 (sub-area-of :type Problem-area) 
 (has-sub-area :type Problem-area)))




(def-class argument-interpretation (idea-interpretation)
"++PhiloSURFical : interpretations of arguments - we do not support interpretations of argument parts for now, but it's possible to implement that too"
((interprets :type argument)
 (supports-Idea :type Philosophical-idea)
 (contrasts-Idea :type Philosophical-idea)
 (tackles-problem :type Problem)
 (defines-problem :type problem)))



(def-class method-interpretation (idea-interpretation)
"++PhiloSURFical : interpretations of methods - very basic for now"
((interprets :type method)
 (supports-view :type view)))



(def-class Rhetorical-figure-interpretation (idea-interpretation)
"++PhiloSURFical : interpretations of rhet. figures - for now we can just say what it supposedly relates to"
((interprets :type rhetorical-figure)
 (associated-with :type philosophical-idea)))