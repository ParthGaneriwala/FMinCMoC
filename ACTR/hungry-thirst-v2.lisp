;;;;;;;;;;;;;;
;; hungry-thirsty model
;; Mar 19, 2024 M. Matsumuro
;; This is a hungry-thirsty model based on this webpage
;; https://acs.ist.psu.edu/misc/nottingham/pst2/hungry-thirsty/ht-tutorial.html
;; I've confirmed that the code works on ACT-R 7.27.7
;; Load this file and run
;; Mar 19, 2024 Modified code to be similar to the Soar's one
;; 	Add production rules that correspond to each Soar's rule(?) as possible
;;	though this ACT-R model is not plausible as a human model
;;	To always fire the better-to-eat rule first, we need to modify its utility.
;;	I didn't do it because if utility modification is allowed, I'll increase
;;	the utility of the eat rule.
;;;;;;;;;;;;;;


(clear-all)

(define-model hungry-thirsty

;; trace is visible (:v). you can change the trace level {high, medium, low}
(sgp :v t :trace-detail medium) ; this parameters are for tracing
;; enable randomness
(sgp :er t)

;; From here to goal-focus correspond to Section I
; declare a chunk tytpe goal that has two slots {hungry, thirsty}
(chunk-type goal hungry thirsty)

; define chunks 
(define-chunks
  ;; model works without there definition, but makes warnings
  (yes isa chunk) (no isa chunk) (eating isa chunk) (drinking isa chunk)
  ;; start from hungery and thirsty
  (goal isa goal hungry yes thirsty yes)
  )

(goal-focus goal)


;; I'm hungry
;; If-statement of this rule = propose-op*eat
(P eat
  =goal>
    hungry        yes

 ==>

;; Then-statement of this rule = apply-op*eat
 ;; eat!
  !output! "   chomp chomp..."

 =goal>
    hungry        eating
)

;; This is rule for terminating eat
(P terminate-eat
  =goal>
    hungry        eating

 ==>

  =goal>
    hungry        no
)


;; I'm thirsty
(P drink
;; If-statement of this rule = propose-op*drink
  =goal>
    hungry        no
    thirsty       yes

 ==>
 
;; Then-statement of this rule = apply-op*drink
 ;; drink!
   !output! "   glug glug..."

  =goal>
    thirsty       drinking
)


;; This is rule for terminating drink
(P terminate-drink
  =goal>
    thirsty       drinking

 ==>

  =goal>
    thirsty       no
)

;; I'm hungry
;; If-statement of this rule = compare*eat*better*drink
(P better-to-eat
  =goal>
    hungry        yes
    thirsty       yes

 ==>

;; Then-statement of this rule = apply-op*eat
 ;; eat!
  !output! "   chomp chomp..."

 =goal>
    hungry        eating
)


;; I'm satisfied
;; If-statement of this rule = top-goal*state*success
(P complete
  =goal>
    hungry        no
    thirsty       no

 ==>

;; Then-statement of this rule = top-goal*halt*state*success
 ;; stop running
  -goal>
)

)
        
