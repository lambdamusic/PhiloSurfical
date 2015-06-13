;;; -*- Mode: LISP; Syntax: Common-lisp; Base: 10; Package: OCML;   -*-

;; ++Philosurfical-CRM ontology

;; here i put all the philosophical ideas ---> all the abstract types in the philosophical domain!



(in-package "OCML")



;; rules and relations *********************************


(def-relation influences-View (?x ?y)
  :iff-def (influenced-by-View (?y ?x))
  :avoid-infinite-loop t)
(def-relation influenced-by-View (?x ?y)
  :iff-def (influences-View (?y ?x))
  :avoid-infinite-loop t)
(def-axiom who-influences-is-influenced    ;;;the axiom gives reasoning capabilities
  (inverse influences-View influenced-by-View))  


(def-relation tackles-problem (?x ?y)
  :iff-def (is-tackled-by-View (?y ?x))
  :avoid-infinite-loop t)
(def-relation is-tackled-by-View (?x ?y)
  :iff-def (tackles-problem (?y ?x))
  :avoid-infinite-loop t)
(def-axiom who-tackles-is-tackled    
  (inverse tackles-problem is-tackled-by-View))

(def-relation attacks-View (?x ?y)
  :iff-def (attacked-by-problem (?y ?x))
  :avoid-infinite-loop t)
(def-relation attacked-by-problem (?x ?y)
  :iff-def (attacks-View (?y ?x))
  :avoid-infinite-loop t)
(def-axiom who-attacks-is-attacked    
  (inverse attacks-View attacked-by-problem))

(def-relation HAS-AS-SUBJECT (?x ?y)
  :iff-def (IS-TREATED-IN (?y ?x))
  :avoid-infinite-loop t)
(def-relation IS-TREATED-IN (?x ?y)
  :iff-def (HAS-AS-SUBJECT (?y ?x))
  :avoid-infinite-loop t)
(def-axiom anything-that-HAS-AS-SUBJECT-IS-TREATED-IN
  (inverse HAS-AS-SUBJECT IS-TREATED-IN))



;;  axiom establishing the same 
;;  type of the related objects   DOES NOT WORK WHEN I TRY TO DEFINE the INSTANCE OF A CONCEPT!

(def-relation is-related-to (?c1 ?c2)
              :constraint (and (and (Philosophical-idea ?c1)
                                    (Philosophical-idea ?c2))
                               (and (direct-instance-of ?c1 ?class1)
                                    (direct-instance-of ?c2 ?class2) 
                                    (= ?class1 ?class2))       ;;; right way to express equality?
                               (not (is-opposed-to ?c1 ?c2))    ;; i need to say that they exclude each other!!!
                               (not (is-opposed-to ?c2 ?c1)))
              :iff-def (is-related-to ?c2 ?c1)   ;; this is to say that it's symmetrical
              :avoid-infinite-loop t)


(def-relation is-opposed-to (?c1 ?c2)
              :constraint (and (and (Philosophical-idea ?c1)
                                    (Philosophical-idea ?c2))
                               (and (direct-instance-of ?c1 ?class1)
                                    (direct-instance-of ?c2 ?class2) 
                                    (= ?class1 ?class2))      ;;; right way to express equality?
                               (not (is-related-to ?c1 ?c2))   ;; i need to say that they exclude each other!!!
                               (not (is-related-to ?c2 ?c1)))
              :iff-def (is-opposed-to ?c2 ?c1)   ;; this is to say that it's symmetrical
              :avoid-infinite-loop t)

;; missing? reflexive? symmetrical? transitive?


;; *******  not needed anymore: they should become instances of sc.of th.! (and also contextualised instances...)
;; (def-axiom monism-or-dualism
;;   (SUBCLASS-PARTITION philosophical-School-of-thought (monism dualism)))  ;;this is to say that it cannot be both!




;;   ***************        M A I N       C L A S S E S     ******************************************************


(def-class Philosophical-idea (propositional-content)
((has-description :type String) 
 (appears-in :type Information-object)
 (has-referred-author :type Agent))
:slot-renaming ((has-referred-author was-made-by))) ;;for clarity reasons




;;;;;;;;;;;;;;;;;;;    V I E W   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(def-class View (Philosophical-idea)
"Generic class referring to propositions expressing a viewpoint, that is, descriptions defining other concepts and, in general, meanings.
We excluded exists-in-area, cause a ph. system exists in various areas - and defines-method cause a thesis is not enough to define a method. Another possible relation
is defines-key-concept..."
((defines-concept :type Concept)
 (uses-idea :type Philosophical-idea)
 (interprets-fact :type temporal-entity)
 (typifies :type intellectual-movement)
 (tackles-problem :type Problem) 
 (attacked-by-problem :type Problem) 
 (influences-View :type View)  
 (influenced-by-View :type View) ;; influence is something related to the "inspiration"
 (supports-View :type View)  ;; mutually excluding... + inverses somewhere!
 (opposes-View :type View)
 (is-similar-to-view :type View)
 (has-supporting-argument :type Argument)
 (has-opposing-argument :type Argument)))



(def-class Thesis (View)
"Philosophical-idea expressing a standpoint in need of demonstration but not necessarily having it"
((part-of-thesis :type Thesis)
 (part-of-theory :type Theory)
 (part-of-school :type school-of-thought)
 (part-of-system :type Philosophical-system)
 (exists-in-area :type problem-area)))

(def-class Law (Thesis)
"A thesis with vast predictive power, especially in scientific areas")
(def-class Principle (Thesis)
"It is a thesis demonstrated or taken as fundamental in a philosophical system, e.g. the -ego- in the -idealism-")
(def-class Self-evident-principle (Principle)
"A principle that is self-demonstrated, so it's a valid assumption")



(def-class Theory (View)
"A systemic conceptual construction, with a coherent and organic architecture. It explains a specific phenomena (or set of) and answers to an
existing problem. It comprises concepts, propositions and it HAS to be related to at least one argument. This is required to guarantee a more solid
architecture, compared for example to a School-of-thought. Examples are the -theory of evolution- or the -theory of possible worlds-."
((part-of-theory :type Theory)
 (part-of-school :type school-of-thought)
 (part-of-system :type Philosophical-system)
 (defines-Method :type Method)
 (exists-in-area :type problem-area)
 (has-thesis :type Thesis)))

(def-class Philosophical-theory (theory)
((exists-in-area :type branch-of-philosophy)))

(def-class Scientific-theory (theory)
((exists-in-area :type scientific-area)
 (predicts-fact :type temporal-entity)
 (verified-by-fact :type temporal-entity :min-cardinality 1))
:slot-renaming ((verified-by-fact interprets-fact)))




(def-class Philosophical-system  (theory)
"It is the Philosophical-idea comprising the set of an author's theories, within a system. 
A philosopher can build different ph. systems in his life, see Wittgenstein for example"
((part-of-school :type School-of-thought)
 (defines-method :type method)
 (has-theory :type theory)
 (has-thesis :type Thesis)))



(def-class School-of-thought  (View)
"A generic standpoint, a belief or view about a subject area or a problem. It is not as formalized and systematic as a theory, and its contents
are limited to be <thesis>. Examples are -pacifism-, -animism-, -expansionism-. They could be further classified depending on their area of 
provenience (politics, religion). This class is needed cause often a mental content refer to a belief, but without the specificity of a theory"
((has-thesis :type Thesis)
 (has-exemplar-theory :type Theory) ;; the theory that has inspired it, or helps understanding it
 (classifies-view :type View)))

(def-class Contextualized-school-of-thought (School-of-thought)
"Needed to separate the meaning of generic schools or conceptions, to their related but more specific meanings in specific fields of study"
((is-about-school :type School-of-thought)
 (exists-in-area :type Field-of-study)))




;;;;;;;;;;;;;;;;; C O N C E P T ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(def-class Concept (Philosophical-idea)
((has-common-name :type concept-appellation)
 (defined-by-view :type View)
 (is-specialization-of :type Concept)
 (is-generalization-of :type Concept)
 (has-similar-meaning-as :type Concept)
 (is-in-contrast-with :type Concept)
 (is-in-relation-with :type Concept)))

;; requires --> notional dependency rule (from paper)
              



;;;;;;;;;;;;; D I S T I N C T I O N ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(def-class Distinction (Philosophical-idea)
((exists-in-area :type problem-area)
 (related-to-problem :type problem)
 (defined-by-view :type view)
 (contains-concept :type concept)))


(def-class Dichotomy (Distinction)
"A classification that states the breakdown of a space between two opposing principles or concepts, e.g.mind/body, relations-of-ideas/matters-of-fact 
in Hume, a-priori/a-posteriori in Kant "
((contains-concept :type concept :cardinality 2)))  







;;;;;;;;;;; P R O B L E M - A R E A ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(def-class Problem-area (Philosophical-idea)
"A set of problems linked by different kind of relational schemas, offer organized around a central problem."
((contains-problem :type Problem)
 (has-central-problem :type problem)
 (specified-by-criteria :type thesis)
 (related-to-area :type Problem-area) ;;this should also be inferred, depending on the closure of problems
 (sub-area-of :type Problem-area) 
 (has-sub-area :type Problem-area)))


(def-class Field-of-study (Problem-area)
"A field of study is seen as a particular kind of problem-area. The distinctive trait of a field of study, is that
the area has been socially and historically recognized as separate from the others, and from being a mere agglomerate of
problems. Therefore, being fundamentally social constructs, field-of-studies are born and die in history. " 
((defined-by-view :type View)
 (has-exemplar-theory :type theory)
 (has-methodology :type method)))

(def-class generic-field-of-study (Problem-area)
"Field of study defined extensionally"
((defined-by-view :type
                  (setofall ?v (and (has-sub-area ?gf ?f)
                                    (defined-by-view ?f ?v))))))

 
(def-class Humanistic-discipline (generic-field-of-study))

(def-class Scientific-discipline (generic-field-of-study))

(def-class Branch-of-philosophy (Humanistic-discipline)
"The set of established research areas in philosophy, classic subjects of teaching and investigation.
We have taken most of them are taken from Wordnet and from http://www.routledge.com/Philosophy/subjects")





;;;;;;;;;;;;; P R O B L E M ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(def-class Problem (Philosophical-idea)
((contains-concept :type Concept)
 (has-problem-type :type problem-type)
 (exists-in-area :type Problem-area)
 (has-supportive-view :type View) 
 (related-to-problem :type Problem)
 (derives-from-problem :type Problem)
 (has-equivalent-meaning-as :type problem)
 (has-resolutive-method :type Method)
 (defined-by-argument :type Argument)
 (is-tackled-by-argument :type Argument)
 (is-tackled-by-View :type View) 
 (attacks-View :type View)
 (linked-to-fact :type Temporal-entity)))


(def-class existence-problem (Problem)
"Problem of the kind <Does X exist?>"
((contains-concept :type Concept :cardinality 1)))  
(def-class existence-as-concrete-problem (existence-problem)
"Problem of the kind <Is X concrete/real?>")
(def-class existence-as-abstract-problem (existence-problem)
"Problem of the kind <Is X abstract?>")

(def-class definitory-problem (Problem)
"Problem of the kind <What is X?>"
((contains-concept :type Concept :cardinality 1))) 
(def-class definitory-problem-essence (definitory-problem)
"Problem of the kind <what are the characteristic traits X has?>")
(def-class definitory-problem-attribute (definitory-problem)
"Problem of the kind <what are the attributes X has?>")
(def-class composition-problem (definitory-problem-essence)
"Problem of the kind <What is X composed of?")


(def-class functional-problem (Problem)
"Problem of the kind <What is the function of X?>"
((contains-concept :type Concept :cardinality 1))) 
(def-class purpose-problem (functional-problem)
"Problem of the kind <What is the purpose of X?>") 

(def-class relational-problem (Problem)
"Problem of the kind <What is the relation between X and Y?>"
((contains-concept :type Concept :cardinality 2))) 
(def-class dependence-problem (relational-problem)
"Problem of the kind <Are X and Y dependent?>")
(def-class dependence-cause-problem (dependence-problem)
"Problem of the kind <Is X the cause of Y?>")
(def-class dependence-effect-problem (dependence-problem)
"Problem of the kind <Is X the effect of Y?>")
(def-class independence-problem (relational-problem)
"Problem of the kind <Is X independent from Y?>")
(def-class equality-problem (relational-problem)
"Problem of the kind <Is X equal to Y?>")
(def-class difference-problem (relational-problem)
"Problem of the kind <Is X different from Y?>")


(def-class modality-problem (Problem)
"Problem about the degree of certainty X is likely to happen, or not"
((contains-concept :type Concept :cardinality 1)))
(def-class necessity-problem (modality-problem)
"Problem of the kind <is X necessary?>")
(def-class possibility-prolem (modality-problem)
"Problem of the kind <is X possible?>")
(def-class contingency-problem (modality-problem)
"Problem of the kind <is X contingent?>")
(def-class impossibility-problem (modality-problem)
"Problem of the kind <is X impossible?>")

;; inserito per necessita di trovare un problema astratto-generale che sussuma il problema epistemologico
(def-class factual-problem (Problem)
"Problem of the kind <how, in what way does X happen, or manifests itself?"
((contains-concept :type Concept :cardinality 1)))






;;;;;;;;;;;;;;;;;;;;;;;;;    A R G U M E N T   S T R U C T U R E   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(def-class Argument-entity (Philosophical-idea)
"Class used to group all the argument-related entities"
((belongs-to-view :type View)
 (has-associated-concept :type concept)
 (has-associated-event :type argument-event)))



(def-class Argument (Argument-entity)
"Reification of the argument-event class - it represents the famous argumentative knots in the history of philosophy"
((supports-Idea :type Philosophical-idea)
 (contrasts-Idea :type Philosophical-idea)
 (tackles-problem :type Problem)
 (defines-problem :type problem)
 (uses-method :type argumentative-method)
 (has-argument-part :type argument-part)))


(def-class Inductive-argument (Argument)
((uses-method :type inductive-method)))

(def-class Deductive-argument (Argument)
((uses-method :type deductive-method)))

(def-class abductive-argument (Argument)
((uses-method :type abductive-method)))




(def-class Argument-part (Argument-entity)
"Statements or sets of statements having a logical value within an argument."
((belongs-to-argument :type Argument)))


(def-class Assumption (Argument-part)
"Proposition that does not necessarily have a demonstration, but that is taken as true. 
E.g. the assumption of <goodness of god> in Descartes"
((assumed-in-theory :type Theory)
 (assumed-in-School-of-thought :type School-of-thought)
 (developed-in :type Demonstration)))

(def-class Hypothesis (assumption)
"Assumption that is used in an argument, specifically in a science-related one (experimental)")

(def-class Demonstration (Argument-part)
"The propositions describing the middle steps in the argumentation"
((develops-premise :type Hypothesis)
 (produces-conclusion :type Thesis)))

(def-class Conclusion (Argument-part)
"Propositions related to the conclusion of an argument"
((produced-by-demostration :type Demostration)))





;;;;;;;;;;;;;;;;;;;;;;;;;    M E T H O D    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(def-class Method (Philosophical-idea)
"A recognized philosophical methodology, abstract or practical. It can be mapped to Dolce's procedures"
((is-used-by-view :type View)
 (used-by-argument :type argument)
 (is-defined-by-view :type View))) ;; this is just the inverse of has-Method..


(def-class Abstract-method (Method)
"A procedure of reasoning or an abstract methodology. For example, the dialectic method in Plato, the epoche' in Husserl, Baco's scientific method or
the absolute doubt of Descates")

(def-class Practical-method (Method)
"A practical doctrine of life, such as the non-violence doctrine of Gandhi, or the ascetism in Schopenauer ")


(def-class logical-mathematical-method (abstract-method))

(def-class algorithm (logical-mathematical-method))

(def-class rule-of-inference (abstract-method))
;; we also have rules-of-replacement!!!! which are still part of the prop calculus.. so maybe all these rule types will be subclasses of log-math-method....

(def-class fallacy (rule-of-inference))

(def-class argumentative-method (abstract-method))



(def-class Precept (Practical-method)  ;; we also called it life-praxis
"A rule of personal conduct, like a commandment in Christianity or the five precepts in buddism")

(def-class Scientific-method (Practical-method)
"A rule of personal conduct, like a commandment in Christianity or the five precepts in buddism")




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  R E T H O R I C A L    F I G U R E     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(def-class Rhetorical-figure (Philosophical-idea) 
"A proposition that uses some literary figure to express or hint at its meaning"
((used-in-argument :type Argument)
 (used-in-View :type View)))

(def-class Maxime (Rhetorical-figure) ;; 
"Short statement expressing a general truth or rule of conduct. Examples are -amor fati- or -adequatio 
intellectus ad rem- or -cogito ergo sum-"
((explains-metaphorically :type View)))
(def-class Metaphor (Rhetorical-figure)
"Any Philosophical-idea that means something in a not-direct manner, e.g. through some analogy"
((explains-metaphorically :type View)))
(def-class Analogy (metaphor)
"...")
(def-class Myth (Metaphor)
"The myth of the cave in Plato"
((explains-metaphorically :type View)))

(def-class Thought-experiment (Rhetorical-figure)
"The twin earth of Putnam, or the Chinese room of Searle..")

(def-class Example (Rhetorical-figure)
"...")
(def-class counter-example (example))


















