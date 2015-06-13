;;; -*- Mode: LISP; Syntax: Common-lisp; Base: 10; Package: OCML;   -*-

;; ++Philosurfical-CRM ontology - AKT imported classes

;; descrption here....



(in-package "OCML")




;; ++++++++++++
;; PUBLICATIONS
;; ++++++++++++


;;we just intend linguistic-publications - name has not been changed to maintain akt working, we should change it in the future!
(def-class PUBLICATION (Manifestation)
  "AKT : A publication is something which has one or more publication references. A publication can be both an article in a journal or a journal itself. The distinction between publication and publication-reference makes it possible to distinguish between multiple occurrences of the same publication, for instance in different media.
++Philosurfical: this reflects out model, since a reference is an expression, while the publication is a manifestation.  The has-abstract and has-date slots have been removed.  " 
((embodies :type symbolic-expression)
 (has-first-author :type actor)   ;; we changes generic-agent into actor
 (has-other-authors :type actor)   ;;list has been changed to actor!
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
  "AKT : A publication produced in electronic form"
((has-physical-medium :type electronic-medium)))  ;; which doesnt exist yet

(def-class COMPOSITE-PUBLICATION (publication)
  "AKT : A publication which contains items which can be themselves referenced through a  publication reference.  Composite publications include newspapers, magazines and journals.  A book which is a collection of articles is a composite publication, a monograph is not"
  ((contains-publication :min-cardinality 1
                         :type publication)
   (has-publication-reference :type composite-publication-reference)))

(def-relation EDITED-BY (?x ?author)
  :iff-def (and (or (composite-publication-reference ?x)
                    (composite-publication ?x))
                (has-author ?x ?author)))


(def-class SERIAL-PUBLICATION (Publication) ?x
  "AKT : This used to be called periodical publication.  However, many periodicals do not appear at fixed intervals, which is why librarians refer to them as serials. So, we now use the concept of serial publication and the has-periodicity slot has been removed. 
++Philosurfical: we removed the has-impact-factor slot. ")

(def-class PERIODICAL-PUBLICATION (serial-publication) ?x 
  "AKT : A periodical-publication is published regularly, such as once every week.  Strictly speaking, the noun 'periodical' is used by librarians to refer to things published at intervals of greater than a day.  We use the phase periodical-publication to include newspapers and other daily publications, since they share many bibliographic features. The periodicity indicates how often the publication comes out.    Note that this is a duration, rather than a time interval. A time interval indicates a specific time interval on the time continuum, so we need    to model periodicity as a time quantity"
  ((has-periodicity :cardinality 1 :type duration)))


(def-axiom CONSISTENCY-BETWEEN-COMPOSITE-PUBLICATIONS-AND-THEIR-CONTENTS
  (<=> (included-in-publication ?a ?p)
       (contains-publication ?p ?a)))


(def-class JOURNAL (serial-publication composite-publication)
"AKT : "
   ((contains-article :type publication))
   :slot-renaming ((contains-article contains-publication)))

(def-class MAGAZINE (serial-publication composite-publication)
"AKT :"
  ((contains-article :type publication))
  :slot-renaming ((contains-article contains-publication)))

(def-class NEWSPAPER (periodical-publication composite-publication)
"AKT :"
  ((contains-news-item :type news-item))
  :slot-renaming ((contains-news-item contains-publication)))

(def-class NEWSLETTER (serial-publication composite-publication)
  "AKT : Merrian-Webster says: a small publication (such as a leaflet or newspaper) containing news of interest chiefly to a special group"
  ((contains-news-item :type news-item))
  :slot-renaming ((contains-news-item contains-publication)))

(def-class DAILY-NEWSPAPER (newspaper)
"AKT :"
  ((has-periodicity :value 24-hour-duration)))

(def-axiom MUTUALLY-EXCLUSIVE-SERIAL-PUBLICATIONS
  (subclass-partition  Serial-Publication 
                                  (Setof Journal Magazine Newspaper)))

(def-class BOOK (publication)
"AKT : "
  ((has-publication-reference :min-cardinality 1
                              :type book-reference)))


(def-class PROCEEDINGS (composite-publication)
"AKT : "
  ((has-publication-reference :min-cardinality 1
                              :type proceedings-reference)
   (contains-publication :min-cardinality 1
                         :type paper-in-proceedings)))

(def-class CONFERENCE-PROCEEDINGS (proceedings)
"AKT : "
  ((has-publication-reference :min-cardinality 1
                              :type conference-proceedings-reference)
   (refers-to-event :type conference)))

(def-class WORKSHOP-PROCEEDINGS (proceedings)
"AKT :"
  ((has-publication-reference :min-cardinality 1
                              :type workshop-proceedings-reference)
   (refers-to-event :type workshop)))


(def-class ITEM-IN-A-COMPOSITE-PUBLICATION (publication)
"AKT : "
  ((included-in-publication :type composite-publication)
   (has-publication-reference :min-cardinality 1
                              :type reference-to-item-in-a-composite-publication)))

(def-class BOOK-SECTION-CONTRIBUTION (item-in-a-composite-publication)
"AKT : "
  ((included-in-publication :type edited-book)
   (has-publication-reference :min-cardinality 1
                              :type book-section-contribution-reference )))

(def-class ARTICLE-IN-A-JOURNAl (item-in-a-composite-publication)
"AKT : "
  ((included-in-publication :type journal)
   (has-publication-reference :min-cardinality 1
                              :type article-reference )))

(def-class JOURNAL-ISSUE (composite-publication)
"AKT :  "
  ((included-in-publication :type journal)
   (has-publication-reference :min-cardinality 1
                              :type journal-issue-reference )))

(def-class PAPER-IN-PROCEEDINGS (item-in-a-composite-publication)
"AKT :  "
  ((included-in-publication :type proceedings)
   (has-publication-reference :min-cardinality 1
                              :type paper-in-proceedings-reference )))

(def-class NEWS-ITEM (item-in-a-composite-publication)
"AKT :  ")






;; ++++++++++++
;; REFERENCES
;; ++++++++++++


;; the following are conceptual object / information object / expression / symbolic-expression / linguistic-expression / sentence / reference !!!
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
(def-class PUBLICATION-REFERENCE (reference)
  "AKT : this branch comes form there, but in ++PhiloSURFical we have decided that a publication reference is an intangible, abstract information"
  ((has-first-author :type actor)   ;; changed generic-agent to actor
   (has-other-authors :type actor)  
   (has-date :type calendar-date)
   (has-place-of-publication :type place-appellation) 
   (refers-to-publication :type publication :cardinality 1)))

(def-axiom CONSISTENCY-BETWEEN-PUBLICATIONS-AND-THEIR-REFERENCES    
  (<=> (refers-to-publication ?r ?p)
       (has-publication-reference ?p ?r)))

(def-class WEB-REFERENCE (publication-reference)
"AKT :"
  ((has-URL :type URL)))

  
(def-class BOOK-REFERENCE (Publication-Reference)
"AKT :"
  ((published-by :type publishing-house)
   (has-ISBN-number :type ISBN-Number)))

(def-class COMPOSITE-PUBLICATION-REFERENCE (publication-reference)
"AKT :"
  ((refers-to-publication :type composite-publication :cardinality 1)))

(def-class EDITED-BOOK-REFERENCE (composite-publication-reference Book-Reference)
"AKT :"
  ((refers-to-publication :type edited-book :cardinality 1)))

(def-class PROCEEDINGS-REFERENCE (composite-publication-reference)
"AKT :"
  ((refers-to-publication :type proceedings :cardinality 1)))

(def-class CONFERENCE-PROCEEDINGS-REFERENCE (proceedings-reference)
"AKT :"
  ((refers-to-publication :type conference-proceedings :cardinality 1)))

(def-class WORKSHOP-PROCEEDINGS-REFERENCE (proceedings-reference)
"AKT :"
  ((refers-to-publication :type workshop-proceedings :cardinality 1)))


(def-class REFERENCE-TO-ITEM-IN-A-COMPOSITE-PUBLICATION (publication-reference)
"AKT :"
  ((refers-to-publication :type item-in-a-composite-publication)
   (has-page-numbers :type string)))


(def-class BOOK-SECTION-CONTRIBUTION-REFERENCE  (reference-to-item-in-a-composite-publication )
"AKT :"
  ((refers-to-publication :type book-section-contribution :cardinality 1)
   ))


(def-class  ARTICLE-REFERENCE 
  (reference-to-item-in-a-composite-publication )
"AKT :"
  (
   (refers-to-publication :type article-in-a-journal :cardinality 1)
   (issue-number :type integer)
   (issue-volume :type integer)))


(def-class  JOURNAL-ISSUE-REFERENCE
  (reference-to-item-in-a-composite-publication )
"AKT :"
  (
   (refers-to-publication :type journal-issue :cardinality 1)
   (issue-number :type integer)
   (issue-volume :type integer)))

(def-class PAPER-IN-PROCEEDINGS-REFERENCE (reference-to-item-in-a-composite-publication )
"AKT :"
  ((refers-to-publication :type paper-in-proceedings :cardinality 1)))

(def-class THESIS-REFERENCE (Publication-Reference)
"AKT :"
((institute-of-thesis :type academic-unit)))
   ;; (degree-of-thesis :type academic-degree)  we dont have academic degrees for now
  
(def-class TECHNICAL-REPORT-REFERENCE (Publication-Reference)
"AKT :"
  ((published-by :type organization)
   (has-tech-report-number :type integer)))

(def-class EDITED-BOOK (composite-publication book)
"AKT :"
  ((has-publication-reference :min-cardinality 1
                              :type edited-book-reference)
   (contains-publication :min-cardinality 1
                         :type book-section-contribution)))




