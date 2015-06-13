;; here we put all the publication-related classes from akt, and the frbr ones too
;; everything is subclass of information-carrier


(in-package "OCML")


;;;  *****from AKT

;; the first two types of manifestations are not explored much, in terms of slots
(def-class AUDIO-PRODUCTION (Manifestation)
  "Any kind of recorded audio, which is tangible.  This also includes a  
   audio file on a machine")

(def-class VIDEO-PRODUCTION (Manifestation)
  "Any kind of recorded video, which is tangible.  This also includes (e.g.,) a mpeg 
   video file on a machine")


;; REMEMBER that with this class we mean all the LINGUISTIC publications!! .. cause also a cd is a publication, right?
(def-class PUBLICATION (Manifestation)
  "A publication is something which has one or more publication references.
   A publication can be both an article in a journal or a journal itself.
   The distinction between publication and publication-reference makes it possible
   to distinguish between multiple occurrences of the same publication, for instance in
   different media"
;;  ((has-title :type string)
   ((has-first-author :type agent)   ;; we changes generic-agent into agent
   (has-other-authors :type list)   ;; mmmm list can be used?
;;   (has-abstract :type string)    ----> this property can be canceled? it is a property of the expression, not of its physical embodiment!!!!!
;;   (has-date :type calendar-date)   this has gone up at the manifestation level!!!!
   (has-publication-reference :min-cardinality 1
                              :type publication-reference)
   (cites-publication-reference :type publication-reference)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(def-rule FIRST-AUTHOR-OF-PUBLICATION
  ((has-first-author ?pub ?x) if
   (Publication ?pub)
   (has-publication-reference ?pub ?ref)
   (has-first-author ?ref ?x)))

(def-rule OTHER-AUTHORS-OF-PUBLICATION
  ((has-other-authors ?pub ?l) if
   (Publication ?pub)
   (has-publication-reference ?pub ?ref)
   (has-other-authors ?ref ?l)))

(def-rule TITLE-OF-PUBLICATION
  ((has-title ?pub ?t) if
   (Publication ?pub)
   (has-publication-reference ?pub ?ref)
   (has-title ?ref ?t)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(def-rule AUTHOR-OF-PUBLICATION-OR-REF
  ((has-author ?pub ?x) if
   (or (has-first-author ?pub ?x)
       (and (has-other-authors ?pub ?l)
            (member ?x ?l)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(def-class ELECTRONIC-PUBLICATION (Publication)
  "A publication produced in electronic form"
  )

(def-class COMPOSITE-PUBLICATION (publication)
  "A publication which contains items which can be themselves referenced through a 
   publication reference.  Composite publications include newspapers, magazines and journals.
   A book which is a collection of articles is a composite publication, a monograph is not"
  ((contains-publication :min-cardinality 1
                         :type publication)
   (has-publication-reference :type composite-publication-reference)
   ))

(def-relation EDITED-BY (?x ?author)
  :iff-def (and (or (composite-publication-reference ?x)
                    (composite-publication ?x))
                (has-author ?x ?author)))


(def-class SERIAL-PUBLICATION (Publication) ?x
  "This used to be called periodical publication.  However, many periodicals
do not appear at fixed intervals, which is why librarians refer to them as serials.
So, we now use the concept of serial publication and the has-periodicity slot has been 
removed"

  ((has-impact-factor :type positive-number)))


(def-class PERIODICAL-PUBLICATION (serial-publication) ?x 
  "This comes from the ontolingua library.
   A periodical-publication is published regularly, such as once
   every week.  Strictly speaking, the noun 'periodical' is used
   by librarians to refer to things published at intervals of greater
   than a day.  We use the phase periodical-publication to include
   newspapers and other daily publications, since they share many
   bibliographic features.
   The periodicity indicates how often the publication comes out. Note that this is
   a duration, rather than a time interval. A time interval indicates a specific time interval
   on the time continuum, so we need to model periodicity as a time quantity"
  ((has-periodicity :cardinality 1 :type duration)))



;;;(def-class ARTICLE-IN-A-COMPOSITE-PUBLICATION (publication)
;;;  ((included-in-publication :type composite-publication)))

(def-axiom CONSISTENCY-BETWEEN-COMPOSITE-PUBLICATIONS-AND-THEIR-CONTENTS
  (<=> (included-in-publication ?a ?p)
       (contains-publication ?p ?a)))


(def-class JOURNAL (serial-publication composite-publication)
   ((contains-article :type publication))
   :slot-renaming ((contains-article contains-publication)
                  ))

(def-class MAGAZINE (serial-publication composite-publication)
  ((contains-article :type publication))
  :slot-renaming ((contains-article contains-publication)
                  ))

(def-class NEWSPAPER (periodical-publication composite-publication)
  ((contains-news-item :type news-item))
  :slot-renaming ((contains-news-item contains-publication)
                  ))

(def-class NEWSLETTER (serial-publication composite-publication)
  "Merrian-Webster says: a small publication (such as a leaflet or newspaper) 
   containing news of interest chiefly to a special group"
  ((contains-news-item :type news-item))
  :slot-renaming ((contains-news-item contains-publication)
                  ))

(def-class DAILY-NEWSPAPER (newspaper)
  ((has-periodicity :value 24-hour-duration)))

(def-axiom MUTUALLY-EXCLUSIVE-SERIAL-PUBLICATIONS
  (subclass-partition  Serial-Publication 
                                  (Setof Journal Magazine Newspaper)))

(def-class BOOK (publication)
  ((has-publication-reference :min-cardinality 1
                              :type book-reference)))




(def-class PROCEEDINGS (composite-publication)
  ((has-publication-reference :min-cardinality 1
                              :type proceedings-reference)
   (contains-publication :min-cardinality 1
                         :type paper-in-proceedings)))

(def-class CONFERENCE-PROCEEDINGS (proceedings)
  ((has-publication-reference :min-cardinality 1
                              :type conference-proceedings-reference)
   (refers-to-event :type conference)))

(def-class WORKSHOP-PROCEEDINGS (proceedings)
  ((has-publication-reference :min-cardinality 1
                              :type workshop-proceedings-reference)
   (refers-to-event :type workshop)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(def-class ITEM-IN-A-COMPOSITE-PUBLICATION (publication)
  ((included-in-publication :type composite-publication)
   (has-publication-reference :min-cardinality 1
                              :type reference-to-item-in-a-composite-publication)))


(def-class BOOK-SECTION-CONTRIBUTION (item-in-a-composite-publication)
  ((included-in-publication :type edited-book)
   (has-publication-reference :min-cardinality 1
                              :type book-section-contribution-reference )))

(def-class ARTICLE-IN-A-JOURNAl (item-in-a-composite-publication)
  ((included-in-publication :type journal)
   (has-publication-reference :min-cardinality 1
                              :type article-reference )))

(def-class JOURNAL-ISSUE (composite-publication)
  ((included-in-publication :type journal)
   (has-publication-reference :min-cardinality 1
                              :type journal-issue-reference )))

(def-class PAPER-IN-PROCEEDINGS (item-in-a-composite-publication)
  ((included-in-publication :type proceedings)
   (has-publication-reference :min-cardinality 1
                              :type paper-in-proceedings-reference )))



(def-class NEWS-ITEM (item-in-a-composite-publication))





;; the following are conceptual object / information object !!!
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
(def-class PUBLICATION-REFERENCE (reference)
  "we have decided that a publication reference is an intangible, abstract information"
  ((has-title :type string)
   (has-first-author :type agent)   ;; changed generic-agent to agent
   (has-other-authors :type list)   ;; ??
   (has-author :type agent)    ;; changed generic-agent to agent
   (has-date :type calendar-date)
   (has-place-of-publication :type location)   ;;; mmmm place or place-appellation?
   (refers-to-publication :type publication :cardinality 1)))

(def-axiom CONSISTENCY-BETWEEN-PUBLICATIONS-AND-THEIR-REFERENCES    ;; what does this mean, really ? how can i be sure data are not duplicated?
  (<=> (refers-to-publication ?r ?p)
       (has-publication-reference ?p ?r)))

(def-class WEB-REFERENCE (publication-reference)
  ((has-URL :type URL)))

  
(def-class BOOK-REFERENCE (Publication-Reference)
  ((published-by :type publishing-house)
   (has-ISBN-number :type ISBN-Number)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(def-class COMPOSITE-PUBLICATION-REFERENCE (publication-reference)
  ((refers-to-publication :type composite-publication :cardinality 1)))


(def-class EDITED-BOOK-REFERENCE (composite-publication-reference Book-Reference)
  ((refers-to-publication :type edited-book :cardinality 1)))


(def-class PROCEEDINGS-REFERENCE (composite-publication-reference)
  ((refers-to-publication :type proceedings :cardinality 1)))

(def-class CONFERENCE-PROCEEDINGS-REFERENCE (proceedings-reference)
  ((refers-to-publication :type conference-proceedings :cardinality 1)))

(def-class WORKSHOP-PROCEEDINGS-REFERENCE (proceedings-reference)
  ((refers-to-publication :type workshop-proceedings :cardinality 1)))


(def-class REFERENCE-TO-ITEM-IN-A-COMPOSITE-PUBLICATION (publication-reference)
  ((refers-to-publication :type item-in-a-composite-publication)
   (has-page-numbers :type string)))


(def-class BOOK-SECTION-CONTRIBUTION-REFERENCE 
  (reference-to-item-in-a-composite-publication )
  ((refers-to-publication :type book-section-contribution :cardinality 1)
   ))


(def-class  ARTICLE-REFERENCE 
  (reference-to-item-in-a-composite-publication )
  (
   (refers-to-publication :type article-in-a-journal :cardinality 1)
   (issue-number :type integer)
   (issue-volume :type integer)))


(def-class  JOURNAL-ISSUE-REFERENCE
  (reference-to-item-in-a-composite-publication )
  (
   (refers-to-publication :type journal-issue :cardinality 1)
   (issue-number :type integer)
   (issue-volume :type integer)))

(def-class PAPER-IN-PROCEEDINGS-REFERENCE (reference-to-item-in-a-composite-publication )
  ((refers-to-publication :type paper-in-proceedings :cardinality 1)))

(def-class THESIS-REFERENCE (Publication-Reference)
  (
   ;; (degree-of-thesis :type academic-degree)  we dont have academic degrees for now
   (institute-of-thesis :type academic-unit)))

(def-class TECHNICAL-REPORT-REFERENCE (Publication-Reference)
  ((published-by :type organization)
   (has-tech-report-number :type integer)))


(def-class EDITED-BOOK (composite-publication book)
  ((has-publication-reference :min-cardinality 1
                              :type edited-book-reference)
   (contains-publication :min-cardinality 1
                         :type book-section-contribution)))