;;; -*- Mode: LISP; Syntax: Common-lisp; Base: 10; Package: OCML;   -*-

;; Philosurfical-CRM ontology

;; here i put the time related stuff, which has been integrated from the  akt-support time ontology + an ontology i got from djnanesh
;; this series of time-specifications should reflect Allen's specs

;; we still have to fix the uncertain dates issue, and the BC-AC definition, also in the instances!



(in-package "OCML")



(def-class time-specification (crm-entity)
   "E52 - CIDOC Renamed as time specification, as a span may be expressed as a time point on some level of granularity 
++Philosurfical:  This will be replaced with the more expressive CIPHER time ontology based on Allen."
((is-identified-by :type time-appellation)))



(def-class YEAR-IN-TIME (integer time-primitive) ?x
	"A year-in-time must be an integer and integer can be a year-in-time"
	:iff-def (integer ?x)
        :avoid-infinite-loop t)

(def-class MONTH-IN-TIME (positive-integer time-primitive)?x
  "A month-in-time is an integer in the interval 1-12"
  :iff-def (and (positive-integer ?x)(< ?x 13) )
  :prove-by  (member ?x '(1 2 3 4 5 6 7 8 9 10 11 12 ))
  :no-proofs-by (:iff-def))

(def-class DAY-IN-TIME (positive-integer time-primitive)?x
  "A day-in-time is an integer in the interval 1-31"
  :iff-def (and (positive-integer ?x)(< ?x 32) )
  :prove-by  (member ?x '(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23
                          24 25 26 27 28 29 30 31))
  
  :no-proofs-by (:iff-def))

(def-class HOUR-IN-TIME (non-negative-integer time-primitive) ?x
  "A hour-in-time is an integer in the interval 0-23"
  :iff-def (and (non-negative-integer ?x)(< ?x 24) )
  :prove-by  (member ?x '(0  1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23))
  :no-proofs-by (:iff-def))
      

(def-class MINUTE-IN-TIME (non-negative-integer time-primitive) ?x
  "A minute-in-time is an integer in the interval 0-59"
  :iff-def (and (non-negative-integer ?x)(< ?x 60) )
  :prove-by  (member ?x '(0  1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29
                          30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58
                          59))
  :no-proofs-by (:iff-def))



(def-class SECOND-IN-TIME (real-number time-primitive)?x
  "A second-in-time is a real number greater or equal to 0, less than 60"
  :iff-def (and (real-number ?x)(not (< ?x 0))(< ?x 60))
  :avoid-infinite-loop t)


;; ++ added for phylosurfical
(def-class frequency-of-occurence (time-primitive))
(def-instance unique frequency-of-occurence)
(def-instance sporadic frequency-of-occurence)
(def-instance frequent frequency-of-occurence)
(def-instance habitual frequency-of-occurence)




(def-class TIME-POINT (time-specification) ?tp
 ((second-of :type second-in-time :max-cardinality 1)
  (minute-of :type minute-in-time :max-cardinality 1)
  (hour-of :type hour-in-time :max-cardinality 1)
  (day-of :type day-in-time :max-cardinality 1)
  (month-of :type month-in-time :max-cardinality 1)
  (year-of :type year-in-time :max-cardinality 1))
 :constraint (and (not (and (month-of ?x 2)
                            (> (the ?day (day-of ?x ?day))
                               29)))
                  (not (and (member-of ?x (4 6 9 11))
                            (> (the ?day (day-of ?x ?day))
                               30))))) 

(def-relation IDLE-TIME-POINT (?tp)
 :constraint (time-point ?tp)
 :iff-def (and (= (second-of-tp ?tp) 0)
               (= (minute-of-tp ?tp) 0)
               (= (hour-of-tp ?tp) 0)
               (= (day-of-tp ?tp) 0)
               (= (month-of-tp ?tp) 0)
               (= (year-of-tp ?tp) 0)))

(def-function SECOND-OF-TP (?tp)
 :constraint (time-point ?tp)
 :body (the ?second (second-of ?tp ?second)))

(def-function MINUTE-OF-TP (?tp)
 :constraint (time-point ?tp)
 :body (the ?minute (minute-of ?tp ?minute)))

(def-function HOUR-OF-TP (?tp)
 :constraint (time-point ?tp)
 :body (the ?hour (hour-of ?tp ?hour)))

(def-function DAY-OF-TP (?tp)
 :constraint (time-point ?tp)
 :body (the ?day (day-of ?tp ?day))) 

(def-function MONTH-OF-TP (?tp)
 :constraint (time-point ?tp)
 :body (the ?month (month-of ?tp ?month)))

(def-function YEAR-OF-TP (?tp)
 :constraint (time-point ?tp)
 :body (the ?year (year-of ?tp ?year)))

               

(def-class TIME-INTERVAL (time-specification) ?int
 "An interval is a period of time elapsed between the start of an event and end of an event.The start of an event is precedes the end of an event. (Ref. J.F.Allen (1983), Maintaining knowledge about temporal intervals)."
 ((has-start-time :type time-point :max-cardinality 1)
  (has-end-time :type time-point :max-cardinality 1)
  (has-unit-of-measure :type measurement-unit))
 :constraint (time-point-precedes (the ?st (has-start-time ?int ?st))
                                  (the ?et (has-end-time ?int ?et))))


(def-class DAY (time-interval)
  ((has-duration :value 24-hour-duration)))

(def-class WEEK (time-interval)
  ((has-duration :value 7-day-duration)))

(def-class MONTH (time-interval))

(def-class JANUARY (month)
  ((has-duration :value 31-day-duration)))

(def-class FEBRUARY (month)
  ((has-duration :default-value 28-day-duration)))

(def-class FEBRUARY-IN-LEAP-YEARS (february)
  ((has-duration :value 29-day-duration)))
  
(def-class MARCH (month)
  ((has-duration :value 31-day-duration)))

(def-class APRIL (month)
  ((has-duration :value 30-day-duration)))

(def-class MAY (month)
  ((has-duration :value 31-day-duration)))

(def-class JUNE (month)
  ((has-duration :value 30-day-duration)))

(def-class JULY (month)
  ((has-duration :value 31-day-duration)))

(def-class AUGUST (month)
  ((has-duration :value 31-day-duration)))

(def-class SEPTEMBER (month)
  ((has-duration :value 30-day-duration)))

(def-class OCTOBER (month)
  ((has-duration :value 31-day-duration)))

(def-class NOVEMBER (month)
  ((has-duration :value 30-day-duration)))

(def-class DECEMBER (month)
  ((has-duration :value 31-day-duration)))

(def-class YEAR (time-interval)
  ((has-duration :value 12-month-duration)))


(def-function TIME-INTERVAL-DURATION (?interval) -> ?duration
 :constraint (and (time-interval ?interval)
                  (duration ?duration))
 :body (time-point-difference  (the ?et (has-end-time ?interval ?et))
                               (the ?st (has-start-time ?interval ?st))))

(def-class TIME-RANGE (time-interval) ?tr
 )


(def-function TIME-RANGE-DURATION (?tr) -> ?duration
  :constraint (and (time-range ?tr)
                   (duration ?duration))
  :body (time-point-difference (the ?et (has-end-time ?tr ?et))
                               (the ?st (has-start-time ?tr ?st))))




(def-class DURATION (quantity time-primitive)   ;; is physical-quantity already there??????
  "A measure of time, e.g., 5 hours"
  ((has-unit-of-measure :type time-appellation)  ;; used to be time-measure!
   ))

(def-instance 24-HOUR-DURATION duration
  ((has-unit-of-measure hour)
   (has-magnitude 24)))

(def-instance 7-DAY-DURATION duration
  ((has-unit-of-measure day)
   (has-magnitude 7)))

(def-instance 28-DAY-DURATION duration
  ((has-unit-of-measure day)
   (has-magnitude 28)))

(def-instance 29-DAY-DURATION duration
  ((has-unit-of-measure day)
   (has-magnitude 29)))

(def-instance 30-DAY-DURATION duration
  ((has-unit-of-measure day)
   (has-magnitude 30)))

(def-instance 31-DAY-DURATION duration
  ((has-unit-of-measure day)
   (has-magnitude 31)))

(def-instance 12-MONTH-DURATION duration
  ((has-unit-of-measure year)
   (has-magnitude 12)))



(def-function MAGNITUDE-OF-DURATION (?dur) -> ?mag
 :constraint (and (duration ?dur)
                  (number ?mag))
 :body (the ?mag (has-magnitude ?dur ?mag)))


(def-function UNIT-OF-DURATION (?dur) -> ?uom
 :constraint (and (duration ?dur)
                  (measurement-unit ?uom))
 :body (the ?uom (has-unit-of-measure ?dur ?uom)))
 


;;(def-class UNIT-OF-TIME ()
;; "This can be a second, a month, a year, a day, etc..")


(def-class CALENDAR-DATE (time-point)
 "A calendar date is a time point in which month, day and year have 
  been specified"
  ((day-of :type day-in-time :cardinality 1)
   (month-of :type month-in-time :cardinality 1)
   (year-of :type year-in-time :cardinality 1)))


(def-function UNIVERSAL-TIME-ENCODER (?tp)
"This function encodes the standard structure of time-point into universal-time structure."
 :constraint (time-point ?tp)
 :lisp-fun '(lambda (?tp)
              (encode-universal-time (the-slot-value ?tp 'second-of)
                                     (the-slot-value ?tp 'minute-of)
                                     (the-slot-value ?tp 'hour-of)
                                     (the-slot-value ?tp 'day-of)
                                     (the-slot-value ?tp 'month-of)
                                     (the-slot-value ?tp 'year-of))))

;; not totally clear yet why we need universal-times
(def-class UNIVERSAL-TIME (time-specification) ?x
 :constraint (integer ?x))


(def-function DECODE-TIME-POINT-FROM-UNIVERSAL-TIME (?ut)
 :constraint (universal-time ?ut)
 :lisp-fun '(lambda (?ut)
              (multiple-value-bind
                  (second minute hour day month year ignore1 ignore2 ignore3)
                  (decode-universal-time ?ut)
                (name 
                 (define-domain-instance (gentemp "TIME-POINT") 'time-point 
                                         `((second-of ,second)
                                           (minute-of ,minute)
                                           (hour-of ,hour)
                                           (day-of ,day)
                                           (month-of ,month)
                                           (year-of ,year)))))))


(def-function TIME-POINT-DIFFERENCE (?tp-1 ?tp-2)
"This function calculates the difference of two universal-time strctures."
 :constraint (and (time-point ?tp-1)
                  (time-point ?tp-2))
 :body (decode-time-point-from-universal-time
        (- (universal-time-encoder ?tp-1) (universal-time-encoder ?tp-2))))


(def-function TIME-POINT-SUM (?tp-1 ?tp-2)
"This function calculates the sum of two universal-time structures."
 :constraint (and (time-point ?tp-1)
                  (time-point ?tp-2))
 :body (decode-time-point-from-universal-time
        (+ (universal-time-encoder ?tp-1) (universal-time-encoder ?tp-2)))) 


(def-relation DURATION-IS-LESS-THAN (?d1 ?d2)
 :constraint (and (duration ?d1)
                  (duration ?d2))
 :iff-def (< (the ?magnitude1 (has-magnitude ?d1 ?magnitude1))
             (the ?magnitude2 (has-magnitude ?d2 ?magnitude2))))
                  

(def-instance second measurement-unit)

(def-instance minute measurement-unit)

(def-instance hour measurement-unit)

(def-instance day measurement-unit)

(def-instance month measurement-unit)

(def-instance year measurement-unit)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;**;;;Following are the useful relations for the Time-Ranges;;;*;;;

(def-relation TIME-POINT-PRECEDES (?time-point-1 ?time-point-2)
"This relation states that a time-point-1 precedes a time-point-2."
 :constraint (and (time-point ?time-point-1)
                  (time-point ?time-point-2))
 :iff-def (< (universal-time-encoder ?time-point-1)
             (universal-time-encoder ?time-point-2)))


;(def-relation TIME-POINT-PRECEDES (?time-point-1 ?time-point-2)
; :constraint (and (time-point ?time-point-1)
;                 (time-point ?time-point-2))
; :iff-def (or (< (the ?sit (second-of ?time-point-1 ?sit))
;                 (the ?sit2 (second-of ?time-point-2 ?sit2)))
;              (< (the ?mit (minute-of ?time-point-1 ?mit))
;                 (the ?mit2 (minute-of ?time-point-2 ?mit2)))
;              (< (the ?hit (hour-of ?time-point-1 ?hit))
;                 (the ?hit2 (hour-of ?time-point-2 ?hit2)))
;              (< (the ?dit (day-of ?time-point-1 ?dit))
;                 (the ?dit2 (day-of ?time-point-2 ?dit2)))
;              (< (the ?moit (month-of ?time-point-1 ?moit))
;                 (the ?moit2 (month-of ?time-point-2 ?moit2)))
;              (< (the ?yit (year-of ?time-point-1 ?yit))
;                 (the ?yit2 (year-of ?time-point-2 ?yit2)))))



            
(def-relation FOLLOWS (?time-point-1 ?time-point-2)
 "This relation relation states that a time-point ?time-point-2 follows a time-point ?time-point-1."
 :constraint (and (time-point ?time-point-1)
                  (time-point ?time-point-2))
 :iff-def (time-point-precedes ?time-point-2 ?time-point-1)) 
            

(def-relation TIME-POINTS-EQUAL (?time-point-1 ?time-point-2)
 :constraint (and (time-point ?time-point-1)
                  (time-point ?time-point-2))
 :iff-def (and (= (minute-of ?time-point-1)
                  (minute-of ?time-point-2))
               (= (second-of ?time-point-1)
                  (second-of ?time-point-2))
               (= (hour-of ?time-point-1)
                  (hour-of ?time-point-2))
               (= (day-of ?time-point-1)
                  (day-of ?time-point-2))
               (= (month-of ?time-point-1)
                  (month-of ?time-point-2))
               (= (year-of ?time-point-1)
                  (year-of ?time-point-2))))


;;;These are BASIC relations;;;

(def-relation BEFORE (?time-range-1 ?time-range-2)
"It means time-range-1 is before the time-range-2."
 :constraint (and (time-range ?time-range-1)
                  (time-range ?time-range-2))
 :iff-def (time-point-precedes (the ?et (has-end-time ?time-range-1 ?et))
                    (the ?st (has-start-time ?time-range-2 ?st))))


(def-relation AFTER (?time-range-1 ?time-range-2)
"It means time-range-1 is after the time-range-2."
 :constraint (and (time-range ?time-range-1)
                  (time-range ?time-range-2))
 :iff-def (time-point-precedes (the ?et (has-end-time ?time-range-2 ?et))
                               (the ?st (has-start-time ?time-range-1 ?st))))

(def-relation IS-AFTER (?time-range-2 ?time-range-1)
"It means that time-range-2 starts after the time-range-1 is finished."
 :constraint (and (time-range ?time-range-1)
                  (time-range ?time-range-2))
 :iff-def (follows (the ?st (has-start-time ?time-range-2 ?st))
                   (the ?et (has-end-time ?time-range-1 ?et))))


(def-relation MEETS (?time-range-1 ?time-range-2)
"It means that time-range-2 starts at the same time when time-range-1 ends."
 :constraint (and (time-range ?time-range-1)
                  (time-range ?time-range-2))
 :iff-def (time-points-equal (the ?et (has-end-time ?time-range-1 ?et))
                             (the ?st (has-start-time ?time-range-2 ?st))))


(def-relation OVERLAPS (?time-range-1 ?time-range-2)
"It means that two time-ranges overlaps with each other."
 :constraint (and (time-range ?time-range-1)
                  (time-range ?time-range-2))
 :iff-def (and (time-point-precedes (the ?st-1 (has-start-time ?time-range-1 ?st-1))
                                    (the ?st-2 (has-start-time ?time-range-2 ?st-2)))
               (follows (the ?et-1 (has-end-time ?time-range-1 ?et-1))
                        (the ?st-2 (has-start-time ?time-range-2 ?st-2)))
               (time-point-precedes (the ?et-1 (has-end-time ?time-range-1 ?et-1))
                                    (the ?et-2 (has-end-time ?time-range-2 ?et-2)))))


(def-relation STARTS-SIMULTANEOUSLY (?time-range-1 ?time-range-2)
"It means that both the time-ranges starts at the same time."
 :constraint (and (time-range ?time-range-1)
                  (time-range ?time-range-2))
 :iff-def (time-points-equal (the ?st-1 (has-start-time ?time-range-1 ?st-1))
                             (the ?st-2 (has-start-time ?time-range-2 ?st-2))))
                         

(def-relation FINISHES-SIMULTANEOUSLY (?time-range-1 ?time-range-2)
"It means that both the time-ranges finishes at the same time but time-range-1 starts after time-range-2."
 :constraint (and (time-range ?time-range-1)
                  (time-range ?time-range-2))
 :iff-def (time-points-equal (the ?et-1 (has-end-time ?time-range-1 ?et-1))
                             (the ?et-2 (has-end-time ?time-range-2 ?et)-2)))


(def-relation TIME-RANGE-EQUALS (?time-range-1 ?time-range-2)
"It means that both the time-ranges starts and finsihes at the same time."
 :constraint (and (time-range ?time-range-1)
                  (time-range ?time-range-2))
 :iff-def (and (time-point-equals (the ?st-1 (has-start-time ?time-range-1 ?st-1))
                                  (the ?st-2 (has-start-time ?time-range-2 ?st-2)))
               (time-point-equals (the ?et-1 (has-end-time ?time-range-1 ?et-1))
                                  (the ?et-2 (has-end-time ?time-range-2 ?et-2)))))


(def-relation TIME-POINT-WITHIN-INTERVAL (?tp ?interval)
 :constraint (and (time-point ?tp)
                  (time-interval ?interval))
 :iff-def (and (or (follows (the-slot-value ?interval has-end-time)
                            (the-slot-value ?tp second-of))
                   (follows (the-slot-value ?interval has-end-time)
                            (the-slot-value ?tp minute-of))
                   (follows (the-slot-value ?interval has-end-time)
                            (the-slot-value ?tp hour-of))
                   (follows (the-slot-value ?interval has-end-time)
                            (the-slot-value ?tp day-of))
                   (follows (the-slot-value ?interval has-end-time)
                            (the-slot-value ?tp month-of))
                   (follows (the-slot-value ?interval has-end-time)
                            (the-slot-value ?tp year-of)))
               (or (time-point-precedes (the-slot-value ?interval has-start-time)
                                        (the-slot-value ?tp second-of))
                   (time-point-precedes (the-slot-value ?interval has-start-time)
                                        (the-slot-value ?tp minute-of))
                   (time-point-precedes (the-slot-value ?interval has-start-time)
                                        (the-slot-value ?tp hour-of))
                   (time-point-precedes (the-slot-value ?interval has-start-time)
                                        (the-slot-value ?tp day-of))
                   (time-point-precedes (the-slot-value ?interval has-start-time)
                                        (the-slot-value ?tp month-of))
                   (time-point-precedes (the-slot-value ?interval has-start-time)
                                        (the-slot-value ?tp year-of)))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;These are DERIVED Relations;;;

(def-relation IS-DURING (?time-range-1 ?time-range-2)
"It means that time-range-2 is in between (during) the the start and end time of time-range-1."
 :constraint (and (time-range ?time-range-1)
                  (time-range ?time-range-2))
 :iff-def (and (time-point-precedes (the ?st-1 (has-start-time ?time-range-1 ?st-1))
                                    (the ?st-2 (has-start-time ?time-range-2 ?st-2)))
               (follows (the ?et-1 (has-end-time ?time-range-1 ?et-1))
                        (the ?et-2 (has-end-time ?time-range-2 ?et-2)))))




(def-relation BEFORE-OR-EQUAL (?time-range-1 ?time-range-2)
"It says that either one time range is before the other or is equal to the other time range."
 :constraint (and (time-range ?time-range-1)
                  (time-range ?time-range-2))
 :iff-def (or (before ?time-range-1 ?time-range-2)
              (meets ?time-range-1 ?time-range2)))


(def-relation AFTER-OR-EQUAL (?time-range-1 ?time-range-2)
"It says that either one time range is after the other or is equal to the other time range."
 :constraint (and (time-range ?time-range-1)
                  (time-range ?time-range-2))
 :iff-def (or (after ?time-range-1 ?time-range-2)
              (meets ?time-range-1 ?time-range-2)))


(def-relation IS-AFTER-THAN (?time-range-1 ?time-range-2)
"It is true when one time range is after the otehr time range."
 :constraint (and (time-range ?time-range-1)
                  (time-range ?time-range-2))
 :iff-def (is-after ?time-range-2 ?time-range-1))


(def-relation DURING-OR-EQUAL (?time-range-1 ?time-range-2)
"It is true when one time range is-during the other time range or both these time ranges starts or finishes simultaneously or they are equal to each other."
 :constraint (and (time-range ?time-range-1)
                  (time-range ?time-range-2))
 :iff-def (or (is-during ?time-range-1 ?time-range-2)
              (starts-simultaneously ?time-range-1 ?time-range-2)
              (finishes-simultaneously ?time-range-1 ?time-range-2)
              (time-range-equals ?time-range-1 ?time-range-2)))


(def-relation OVERLAPS-OR-MEETS (?time-range-1 ?time-range-2)
"It is true when two time ranges either overlaps with each other or meets each other." 
 :constraint (and (time-range ?time-range-1)
                  (time-range ?time-range-2))
 :iff-def (or (overlaps ?time-range-1 ?time-range-2)
              (meets ?time-range-1 ?time-range-2)))


(def-relation OVERLAPS-OR-EQUALS (?time-range-1 ?time-range-2)
"It is true when two time ranges either overlaps with each other and are equal to each other."
 :constraint (and (time-range ?time-range-1)
                  (time-range ?time-range-2))
 :iff-def (or (overlaps ?time-range-1 ?time-range-2)
              (time-range-equals ?time-range-1 ?time-range-2))) 


(def-relation STARTS-OR-EQUAL (?time-range-1 ?time-range-2)
"It is true when two time ranges either starts simulataneously or are equal to each other."
 :constraint (and (time-range ?time-range-1)
                  (time-range ?time-range-2))
 :iff-def (or (starts-simultaneously ?time-range-1 ?time-range-2)
              (time-range-equals ?time-range-1 ?time-range-2)))


(def-relation FINISHES-OR-EQUALS (?time-range-1 ?time-range-2)
"It is true when two time ranges finishes simultaneously or are equal to each other."
 :constraint (and (time-range ?time-range-1)
                  (time-range ?time-range-2))
 :iff-def (or (finishes-simultaneously ?time-range-1 ?time-range-2)
              (time-range-equals ?time-range-1 ?time-range-2)))


(def-relation DISJOINT-TIME-RANGES (?time-range-1 ?time-range-2)
"It is true if either time-range-1 is before time-range-2 or time-range-2 is before time-range-1."
 :constraint (and (time-range ?time-range-1)
                  (time-range ?time-range-2))
 :iff-def (or (before ?time-range-1 ?time-range-2)
              (before ?time-range-2 ?time-range-1)))



(def-relation DUE-DATE-EARLIER-THAN-OTHER (?dd1 ?dd2)
"It says that if each of the slot value of due-date-1 precedes every slot-value of due-date-2 then due-date-1 is earlier-than due-date-2."
 :constraint (and (calendar-date ?dd1)
                  (calendar-date ?dd2))
 :iff-def (and (time-point-precedes (the-slot-value ?dd1 day-of)
                                    (the-slot-value ?dd2 day-of))
               (time-point-precedes (the-slot-value ?dd1 month-of)
                                    (the-slot-value ?dd2 month-of))
               (time-point-precedes (the-slot-value ?dd1 year-of)
                                    (the-slot-value ?dd2 year-of))))


(def-relation DUE-DATE-LATER-THAN-OTHER (?dd2 ?dd1)
"It says that is each of the slot value of due-date-2 follows every slot-value of due-date-1 then due-date-2 is later than due-date-1."
 :constraint (and (calendar-date ?dd1)
                  (calendar-date ?dd2))
 :iff-def (and (follows (the-slot-value ?dd2 day-of)
                        (the-slot-value ?dd1 day-of))
               (follows (the-slot-value ?dd2 month-of)
                        (the-slot-value ?dd1 month-of))
               (follows (the-slot-value ?dd2 year-of)
                        (the-slot-value ?dd1 year-of))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;The following relations are defined for the time intervals exactly as it is described in J F Allen's paper.

(def-relation TIME-INTERVAL-BEFORE (?ti1 ?ti2)
 :constraint (and (time-interval ?ti1)
                  (time-interval ?ti2))
 :iff-def (and (time-point-precedes (the-slot-value ?ti1 has-start-time)
                                    (the-slot-value ?ti2 has-start-time))
               (time-point-precedes (the-slot-value ?ti1 has-end-time)
                                    (the-slot-value ?ti2 has-end-time))))


(def-relation TIME-INTERVAL-EQUAL (?ti1 ?ti2)
 :constraint (and (time-interval ?ti1)
                  (time-interval ?ti2))
 :iff-def (and (time-points-equal (the-slot-value ?ti1 has-start-time)
                                  (the-slot-value ?ti2 has-start-time))
               (time-points-equal (the-slot-value ?ti1 has-end-time)
                                  (the-slot-value ?ti2 has-end-time))))

(def-relation time-interval-meets (?ti1 ?ti2)
 :constraint (and (time-interval ?ti1)
                  (time-interval ?ti2))
 :iff-def (time-points-equal (the-slot-value ?ti2 has-end-time)
                             (the-slot-value ?ti1 has-start-time)))



(def-relation time-interval-overlaps (?ti1 ?ti2)
 :constraint (and (time-interval ?ti1)
                  (time-interval ?ti2))
 :iff-def (and (time-point-precedes (the-slot-value ?ti1 has-start-time)
                                    (the-slot-value ?ti2 has-start-time))
               (follows (the-slot-value ?ti1 has-end-time)
                        (the-slot-value ?ti2 has-start-time))
               (time-point-precedes (the-slot-value ?ti1 has-end-time)
                                    (the-slot-value ?ti2 has-end-time))))


(def-relation time-interval-during (?ti1 ?ti2)
 :constraint (and (time-interval ?ti1)
                  (time-interval ?ti2))
 :iff-def (and (time-point-precedes (the-slot-value ?ti1 has-start-time)
                                    (the-slot-value ?ti2 has-start-time))
               (follows (the-slot-value ?ti1 has-end-time)
                        (the-slot-value ?ti2 has-end-time))))


(def-relation time-interval-starts (?ti1 ?ti2)
 :constraint (and (time-interval ?ti1)
                  (time-interval ?ti2))
 :iff-def (time-points-equal (the-slot-value ?ti1 has-start-time)
                             (the-slot-value ?ti2 has-start-time)))


(def-relation time-interval-finishes (?ti1 ?ti2)
 :constraint (and (time-interval ?ti1)
                  (time-interval ?ti2))
 :iff-def (time-points-equal (the-slot-value ?ti1 has-end-time)
                             (the-slot-value ?ti2 has-end-time)))
;;;;;;;;;;;;
;;;(Alex) Chao-Chiang Meng and Michael Sullivan (1991). Logos A Constraint-Directed Reasoning Sheel for Operations M;;anagem;;;ent, IEEE Expert, 6(1), pp.01-16.;;;;
;;;;;;;;;;;

(def-relation time-interval-elapsed-by (?ti1 ?ti2)
"This relation states, if one interval precedes another interval, then, it says, by how much time another interval succeeds the prior interval."
 :constraint (and (time-interval ?ti1)
                  (time-interval ?ti2)
                  (has-start-time ?ti1 ?st1)
                  (has-end-time ?ti1 ?et1)
                  (has-start-time ?ti2 ?st2)
                  (has-end-time ?ti2 ?et2))
 :iff-def (or (time-point-precedes ?et1 ?st2)
              (= ?et1
                 (+ (?st2 (= ?diff-tp
                             (time-point-difference ?et1 ?st2)))))))


(def-relation time-interval-during-delay-and-lag (?ti1 ?ti2)
"This relation states that if two intervals are during each other, and if one interval delays or lag from the other interval, it states by how much margin the interval has delayed or laged."
 :constraint (and (time-interval ?ti1)
                  (has-start-time ?ti1 ?st1)
                  (has-end-time ?ti1 ?et1)
                  (time-interval ?ti2)
                  (has-start-time ?ti2 ?st2)
                  (has-end-time ?ti2 ?et2))
 :iff-def (and (or (follows ?st2 ?st1)
                   (= ?st2
                      (+ (?st1 
                          (= ?diff-tp
                             (time-point-difference ?st2 ?st1))))))
               (or (time-point-precedes ?st2 ?et1)
                   (= ?et1
                      (+ (?et2
                          (= ?diff-tp
                             (time-point-difference ?et1 ?et2))))))))


(def-relation time-interval-overlap-or-lag (?ti1 ?ti2)
"This relation states that if two intervals are overlapping each other, and if one interval lags another interval, then it says by how much margin these intervals are laged."
 :constraint (and (time-interval ?ti1)
                  (has-start-time ?ti1 ?st1)
                  (has-end-time ?ti1 ?et1)
                  (time-interval ?ti2)
                  (has-start-time ?ti2 ?st2)
                  (has-end-time ?ti2 ?et2))
 :iff-def (and (time-point-precedes ?st1 ?st2)
               (or (and (time-point-precedes ?st2 ?et1)
                        (time-point-precedes ?et1 ?et2))
                   (= ?et1
                      (+ (?st1
                          (= ?diff-tp
                             (time-point-difference ?et1 ?st2))))))))


(def-relation time-interval-starts-by (?ti1 ?ti2)
"This relation states that if two intervals starts at the same time, and if one interval finishes after another interval then it says by how much margin the interval finishes over other." 
 :constraint (and (time-interval ?ti1)
                  (has-start-time ?ti1 ?st1)
                  (has-end-time ?ti1 ?et1)
                  (time-interval ?ti2)
                  (has-start-time ?ti2 ?st2)
                  (has-end-time ?ti2 ?et2))
 :iff-def (and (time-points-equal ?st1 ?st2)
               (or (time-point-precedes ?et1 ?et2)
                   (= ?et2
                      (+ (?et1
                          (= ?diff-tp
                             (time-point-difference ?et2 ?et1))))))))


(def-relation time-interval-finishes-dalay (?ti1 ?ti2)
"This relation stats that if two interval finishes at the same time, but they have different start-time, then it says, by how much time these two intervals differ in terms of thri start times."
 :constraint (and (time-interval ?ti1)
                  (has-start-time ?ti1 ?st1)
                  (has-end-time ?ti1 ?et1)
                  (time-interval ?ti2)
                  (has-start-time ?ti2 ?st2)
                  (has-end-time ?ti2 ?et2))
 :iff-def (and (or (follows ?st1 ?st2)
                   (= ?st1
                      (+ (?st2
                          (= ?diff-tp
                             (time-point-difference ??st1 ?st2))))))
               (time-points-equal ?et1 ?et2)))
                

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




