;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; water_jug_model.lisp
;; Jul 1, 2025
;; Miki Matsumuro
;;
;; Perform water jug task
;;  * the target value is 1
;;  * initialize and stop rules
;;	- initialize-image
;;	- get-target1/2
;;  * fill, pour, empty rules
;;	- each for the jugs 1 and 2
;;  * when no possible operation -> stuck rule
;;  * need to reset for running again
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(clear-all)

(define-model water_jug
(sgp :v t)
(sgp :er t)
(sgp :iu 5)

(chunk-type current-jug jug1 jug2 jug1-state jug2-state pre1 pre2)
(chunk-type goal target start-from preOpe)
(chunk-type addition arg1 arg2 answer)

(define-chunks
 (jug1 isa chunk) (jug2 isa chunk)
 (emptyJug isa chunk) (fullJug isa chunk) (some isa chunk)
  (fill1 isa chunk)   (fill2 isa chunk)
  (pour1 isa chunk)   (pour2 isa chunk)
  (empty1 isa chunk)   (empty2 isa chunk)
 (goal1 isa goal target 1 preOpe nil)
)
   
(goal-focus goal1)

(P initialize-image
  =goal>
    target        =target
  ?imaginal>
    state         free
    buffer        empty

 ==>

  !eval! (format t "jug1 ~d, jug2 ~d~%" 0 0)

+imaginal>
    isa current-jug
    jug1          0
    jug2          0
    jug1-state    emptyJug
    jug2-state    emptyJug
)

(P fill1
  =goal>
    target        =target
 ?imaginal>
    state         free
  =imaginal>
    jug1          =jug1
    jug2          =jug2
  - jug1-state    fullJug
  - jug2-state    fullJug

 ==>

  !eval! (format t "jug1 ~d, jug2 ~d~%" 5 =jug2)
  
  =imaginal>
    jug1          5
    jug1-state    fullJug
    pre1          =jug1
    pre2          =jug2
  =goal>
    preOpe	  fill1
)

(P fill2
  =goal>
    target        =target
 ?imaginal>
    state         free
  =imaginal>
    jug1          =jug1
    jug2          =jug2
  - jug2-state    fullJug
  - jug1-state    fullJug

 ==>

  !eval! (format t "jug1 ~d, jug2 ~d~%" =jug1 3)
  
  =imaginal>
    jug2          3
    jug2-state    fullJug
    pre1          =jug1
    pre2          =jug2
  =goal>
    preOpe	  fill2
)

(P pour1
  =goal>
    target        =target
  - preOpe	  pour2
 ?imaginal>
    state         free
  =imaginal>
    jug1          =jug1
    jug2          =jug2
    pre1          =pre1
    pre2          =pre2
  - jug1-state    emptyJug
  - jug2-state    fullJug

  !bind! =rest-jug1 (if (< (- 3 =jug2) =jug1)
			(- =jug1 (- 3 =jug2))
			0)
  !bind! =jug1-new-state (if (= =rest-jug1 0)
			     'emptyJug
			     'some)
  !bind! =new-jug2 (if (> (+ =jug2 =jug1) 3)
		       3
		       (+ =jug2 =jug1))
  !bind! =jug2-new-state (if (= =new-jug2 3)
			     'fullJug
			     'some)

 ==>

  !eval! (format t "jug1 ~d, jug2 ~d~%" =rest-jug1 =new-jug2)

  =imaginal>
    jug1          =rest-jug1
    jug1-state    =jug1-new-state
    jug2          =new-jug2
    jug2-state    =jug2-new-state    
    pre1          =jug1
    pre2          =jug2
  =goal>
    preOpe	  pour1
)

(P pour2
  =goal>
    target        =target
  - preOpe	  pour1
 ?imaginal>
    state         free
  =imaginal>
    jug2          =jug2
    jug1          =jug1
    pre1          =pre1
    pre2          =pre2
  - jug2-state    emptyJug
  - jug1-state    fullJug

  !bind! =rest-jug2 (if (< (- 5 =jug1) =jug2)
			(- =jug2 (- 5 =jug1))
			0)
  !bind! =jug2-new-state (if (= =rest-jug2 0)
			     'emptyJug
			     'some)
  !bind! =new-jug1 (if (> (+ =jug1 =jug2) 5)
		       5
		       (+ =jug1 =jug2))
  !bind! =jug1-new-state (if (= =new-jug1 5)
			     'fullJug
			     'some)
			     
;;  !eval! (not (and (= =rest-jug2 =pre2)
;;		   (= =new-jug1 =pre1)))
 ==>

  !eval! (format t "jug1 ~d, jug2 ~d~%" =new-jug1 =rest-jug2)

  =imaginal>
    jug1          =new-jug1
    jug1-state    =jug1-new-state
    jug2          =rest-jug2
    jug2-state    =jug2-new-state    
    pre1          =jug1
    pre2          =jug2
  =goal>
    preOpe	  pour2
)

(P empty1
  =goal>
    target        =target
 ?imaginal>
    state         free
 =imaginal>
    jug1          =jug1
    jug2          =jug2
    pre1          =pre1
    pre2          =pre2
  - jug1-state    emptyJug
  - jug2-state    emptyJug

  !eval! (not (= =pre1 0))
  
 ==>

  !eval! (format t "jug1 ~d, jug2 ~d~%" 0 =jug2)

  =imaginal>
    jug1          0
    jug1-state    emptyJug
    pre1          =jug1
    pre2          =jug2
  =goal>
    preOpe	  empty1
)

(P empty2
  =goal>
    target        =target
  ?imaginal>
    state         free
  =imaginal>
    jug1          =jug1
    jug2          =jug2
    pre1          =pre1
    pre2          =pre2
  - jug1-state    emptyJug
  - jug2-state    emptyJug

  !eval! (not (= =pre2 0))
  
 ==>

  !eval! (format t "jug1 ~d, jug2 ~d~%" =jug1 0)

  =imaginal>
    jug2          0
    jug2-state    emptyJug
    pre1          =jug1
    pre2          =jug2
  =goal>
    preOpe	  empty2
)

(P stuck
  =goal>
  ?imaginal>
    state         free
  =imaginal>
    jug1          =jug1
    jug2          =jug2
    
 ==>

  !eval! (format t "jug1 ~d, jug2 ~d~%" 0 0)
 
  =imaginal>
    jug1          0
    jug2          0
    pre1          nil
    pre2          nil
    jug1-state    emptyJug
    jug2-state    emptyJug
  =goal>
    preOpe	  nil
 
)
(spp stuck :u 3)

(P get-target1
  =goal>
    target        =target
  =imaginal>
    jug1          =target

 ==>

  !eval! (format t "jug1 get the target~%")

  -goal>
)
(spp get-target1 :u 10)

(P get-target2
  =goal>
    target        =target
  =imaginal>
    jug2          =target

 ==>

  !eval! (format t "jug2 get the target~%")
  
  -goal>
)
(spp get-target2 :u 10)


)
