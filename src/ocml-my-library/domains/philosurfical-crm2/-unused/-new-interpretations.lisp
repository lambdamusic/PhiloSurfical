;; new interpretations


(def-class interpretation (intellectual-activity)
   "++Philosurfical: The act of making claims about anything in the domain world"
((carried-out-by :type Actor)    ;; this is actually inherited
 (interprets :type entity)
 (has-interpretation :type propositional-content)))

  

(def-class representation-interpretation (interpretation) 
   "++Philosurfical: interpretations about linguistic representations "
((interprets :type representation)))

(def-class text-interpretation (interpretation)  
   "++Philosurfical: interpretations about linguistic representations "
((interprets :type text)
 (has-pedagogical-value :type pedagogical-functional-role)))


(def-class event-interpretation (interpretation)
   "++Philosurfical:  "
((interprets :type event)
 (causally-connected-to :type event)))


(def-class idea-interpretation (interpretation)
((interprets :type propositional-content)
 (conceived-by :type actor)))


(def-class concept-interpretation (idea-interpretation)
((interprets :type concept)
 (has-similar-meaning-as :type Concept)
 (is-in-contrast-with :type Concept)
 (is-in-relation-with :type Concept)))


