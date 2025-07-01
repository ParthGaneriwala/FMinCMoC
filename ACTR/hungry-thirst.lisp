;;;;;;;;;;;;;;
;; hungry-thirsty model
;; Mar 7, 2024 M. Matsumuro
;; This is a hungry-thirsty model based on this webpage
;; https://acs.ist.psu.edu/misc/nottingham/pst2/hungry-thirsty/ht-tutorial.html
;; I've confirmed that the code works on ACT-R 7.27.7
;; Load this file and run
;;;;;;;;;;;;;;


(clear-all)

(define-model hungry-thirsty

; trace is visible (:v). you can change the trace level {high, medium, low}
(sgp :v t :trace-detail medium)
; enable randomness
(sgp :er t)

; declare a chunk tytpe goal that has two slots {hungry, thirsty}
(chunk-type goal hungry thirsty)

; define chunks 
(define-chunks
  ;; model works without there definition, but makes warnings
  (yes isa chunk) (no isa chunk)
  ;; start from hungery and thirsty
  (goal isa goal hungry yes thirsty yes)
  )

(goal-focus goal)

;; I'm hungry
(P eat
  =goal>
    hungry        yes

 ==>

 ;; eat!
  =goal>
    hungry        no
)

;; I'm thirsty
(P drink
  =goal>
    thirsty       yes

 ==>
 
 ;; drink!
  =goal>
    thirsty       no
)

;; I'm satisfied
(P complete
  =goal>
    hungry        no
    thirsty       no

 ==>
 
 ;; stop running
  -goal>
)

)
        
