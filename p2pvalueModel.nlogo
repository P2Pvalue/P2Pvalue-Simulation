; Developed by Dr Peter Barbrook-Johnson 2015 as part of the p2pvalue EU project

; Comments welcome - email: p.barbrook-johnson@surrey.ac.uk


; Extensions; Extensions; Extensions; Extensions; Extensions; Extensions; Extensions; Extensions; Extensions; Extensions
; Extensions; Extensions; Extensions; Extensions; Extensions; Extensions; Extensions; Extensions; Extensions; Extensions
; Extensions; Extensions; Extensions; Extensions; Extensions; Extensions; Extensions; Extensions; Extensions; Extensions

extensions [profiler]

;setup                  ;; set up the model
;profiler:start         ;; start profiling
;repeat 20 [ go ]       ;; run something you want to measure
;profiler:stop          ;; stop profiling
;print profiler:report  ;; view the results
;profiler:reset         ;; clear the data

; Global Parameters; Global Parameters; Global Parameters; Global Parameters; Global Parameters; Global Parameters
; Global Parameters; Global Parameters; Global Parameters; Global Parameters; Global Parameters; Global Parameters
; Global Parameters; Global Parameters; Global Parameters; Global Parameters; Global Parameters; Global Parameters


globals [

  ; platform-features                  ; chooser for current platform features turned on/off

  ; proportion-using-platform          ; proportion of 1/9/90 using the software platform

  ; initial-number-#1s                 ; initial numbers of these agents
  ; initial-number-#9s
  ; initial-number-#90s
  ; initial-projects
  ; initial-tasks
  initial-products

  ; num-interest-categories             ; number of discrete 'interest' categories

  ; prop-of-projects-reward-subjective  ; proportion of tasks that have their reward decided subjectively -
                                        ; ie., variation / not as predictable

  ; prop-consumed-each-time             ; proportion of a product that is consumed by each #90 on each timestep
                                        ; currently just used to measure level of consumption by 90
                                        ; not depletion of product - ie., assume non-rivalrous

  ; reward-mechanism                    ; chooser specifying which reward mechanism is currently being used

  ; chance-of-finding-new-task          ; chance per tick working on a task idenitfies a new task

  #1s-left                              ; count of these agents who have left communuity
  #9s-left
  #90s-left

  #90s-left-no-product                  ; count of why 90s left (currently only 1 reason why they leave)

  new-#9s-total                         ; count of new #9 entered the community
  new-#90s-total                        ; count of new #90s entered the community

  new-#90s-chance

  new-#1-count                          ; count of new #1s

  products-consumed                     ; count products consumed
  tasks-completed                       ; count tasks completed

  new-tasks-count                       ; count of new tasks created
  new-products-count                    ; count of new products created

  #9-to-#1-count                        ; count of #9 turned into #1
  #1-to-#9-count                        ; count of #1s turned to #9
  #90-to-#9-count

  #90-used-featured-needs               ; count of 90s using featured needs

  new-#9-attracted-by-#90s              ; recored why a 9 entered

  num-skills                            ; number of skill types for projects or contributors

  #9-left-no-interest                   ; recording why #9 leave comm
  #9-left-drop-cons
  #9-left-burnout

  #1-left-burnout                       ; recording why #1 left

  time-with-no-#1s                      ; recording ticks with no agents
  time-with-no-#9
  time-with-no-#90s
  time-with-no-products
  time-with-no-tasks

  projects-died                         ; count of projects 'died'
  projects-finished                     ; count of projects finished
  loneTasksFinished

  count-new-projects                    ; count new projects appearing

  product-had-no-consumer-so-left       ; count of reasons why product 'died'

  products-out-competed                 ; record of times, in a one product commmunity,
                                        ; that a choice has been made between two

  contributions-made-by-1s              ; count of indiviudal contributions made
  time-contributed-by-1s                ; count of hours contributed
  contributions-made-by-9s              ; count of indiviudal contributions made
  time-contributed-by-9s                ; count of hours contributed

  #1-dropped-a-task                     ; record dropping of tasks and projects
  #9-dropped-a-task

  #1-dropped-a-project
  #9-dropped-a-project

  ; chance-90-find-a-task                 ; chance a 90 sees a task that makes them decide to become a 9
                                        ; - higher with platform

  community-prod-activity-ls            ; list of the history of community production activity

  community-con-activity-ls             ; list of the history of community consumption activity

]

; Agent types; Agent types; Agent types; Agent types; Agent types; Agent types; Agent types; Agent types
; Agent types; Agent types; Agent types; Agent types; Agent types; Agent types; Agent types; Agent types
; Agent types; Agent types; Agent types; Agent types; Agent types; Agent types; Agent types; Agent types

breed [#1s #1]
breed [#9s #9]
breed [#90s #90]
breed [projects project]
breed [t4sks t4sk]
breed [loneTasks loneTask]
breed [products product]
undirected-link-breed [tasklinks tasklink]
undirected-link-breed [lonetasklinks lonetasklink]
undirected-link-breed [friendlinks friendlink]
undirected-link-breed [consumerlinks consumerlink]
undirected-link-breed [projectproductlinks projectproductlink]

; Agent parameters by type; Agent parameters by type; Agent parameters by type; Agent parameters by type
; Agent parameters by type; Agent parameters by type; Agent parameters by type; Agent parameters by type
; Agent parameters by type; Agent parameters by type; Agent parameters by type; Agent parameters by type

#1s-own [
  my-projects-1s               ; list (actual list) of projects 1 attached to
  my-tasks-1s                  ; list (agentset) of tasks currently contributing to
  my-lone-tasks-1s             ; list (agentset) of lonetasks currently contributing to
  my-projects                  ;
  my-tasks                     ; these 4 used when changing breeds
  my-lone-tasks
  my-friends                   ;
  my-time                      ; static time availability for community - random 40
  time                         ; current spare time available (not being used on tasks already)
  skill                        ; skill types - 3 values from a possible 10
  interest                     ; interest score - random num-interest-categories
  using-platform?              ; yes/no - is the #1 using the platform?
  points                       ; count quant reward/point received by agent
  thanks                       ; have they received thanks and who from
  time-in-community            ; count ticks/weeks spent in community
  contribution-history-1s      ; list with contribution in previous N ticks
  contribution-history-9s      ; used when changing breed
  my-total-contribution-1s     ; count of previous contributions
  my-total-contribution-9s     ; used when changing breed
  feel-loved                   ; variable based on thanks and points used in decisions
]

#9s-own [
  my-projects                  ; list (actual list) of projects 9 attached to
  my-tasks                     ; list (agentset) of tasks currently contributing to
  my-lone-tasks                ; list (agentset) of lone tasks currently contributing to
  my-friends                   ; list (agentset) of other 9s currently friends with
  my-projects-1s               ;
  my-tasks-1s                  ; used when changing breeds
  my-lone-tasks-1s
  my-time                      ; static time availability for community - random 40
  time                         ; current spare time available (not being used on tasks already)
  skill                        ; skill types - 3 values from a possible 10
  interest                     ; interest score - random num-interest-categories
  using-platform?              ; yes/no - is the #9 using the platform?
  points                       ; count reward received by agent
  thanks                       ; have they received thanks and who from
  time-in-community            ; count ticks/weeks spent in community
  time-with-no-links           ; count ticks #9 has had no tasks
  contribution-history-9s      ; list with contribution in previous N ticks
  contribution-history-1s      ; used when changing breeds
  my-total-contribution-9s     ; count of previous contributions
  my-total-contribution-1s     ; used when changing breed
  feel-loved
  i-used-featured?             ; did the 9 ever find a featured need
]

#90s-own [
  interest                     ; interest score - random num-interest-categories
  consumption                  ; count level of volume consumed from products
  time-in-community            ; count ticks/weeks spent in community
  time-without-products        ; count ticks with no product to consume
  using-platform?              ; yes/no - is the #90 using the platform?
  skill                        ; skill types - 3 values from a possible 10
]

projects-own [
  inter3st                     ; interest score - random num-interest-categories
  num-tasks                    ; number of tasks currently in project
  my-tasks-projects            ; the tasks of this project
  production-activity          ; score - count of current contributors to project's tasks weighted by distance
  production-history           ; 10 tick history of production-activity
  age                          ; time task has been in community
  my-product                   ; product that the project links to, can be 'nobody'
  likes                        ; used in position in list
  likes-history                ; 10 tick history of likes
  reward-type                  ; obj or subj - how reward to each contributor is decided
  reward-level                 ; amount of reward random 100
  current-contributors         ; agentset of current contributors to tasks of this project
  is-on-platform?              ; is the project on the platform?
  is-private?                  ; is the project private?
  total-bounty                 ; the combined bounty of tasks within this project
]

t4sks-own [
  my-project                   ; project task is within
  typ3                         ; skil type required by task - one of ten
  inter3st                     ; interest score - random num-interest-categories
  time-required                ; time required to complete tasks random normal 50 10
  modularity                   ; contribution required by task per tick
  age                          ; time task has been in community
  featured?                    ; is the task currently being featured?
  bounty                       ; the bounty given to a task by its project's contributors
]

loneTasks-own [
  typ3                         ; skil type required by task - one of ten
  inter3st                     ; interest score - random num-interest-categories
  time-required                ; time required to complete tasks random normal 50 10
  modularity                   ; contribution required by task per tick
  age
  my-product-L                 ; product task is associated with
]

products-own [
  inter3st                     ; interest score - random num-interest-categories
  volume                       ; volume of consumable value product has
  consumption-activity         ; count of number of current consumers of this product
  age                          ; time product has been in community
  mon-project                  ; project product is associated with
  consumption-history          ; list of recent consumerlinks per tick
]

tasklinks-own [ ageTL ]         ; all links have an age parameter
friendlinks-own [ ageFL
                  times-worked-together ]
consumerlinks-own [ ageCL ]
projectproductlinks-own [ agePL ]

; Setup ; Setup ; Setup ; Setup ; Setup ; Setup ; Setup ; Setup ; Setup ; Setup ; Setup ; Setup ; Setup ; Setup ; Setup
; Setup ; Setup ; Setup ; Setup ; Setup ; Setup ; Setup ; Setup ; Setup ; Setup ; Setup ; Setup ; Setup ; Setup ; Setup
; Setup ; Setup ; Setup ; Setup ; Setup ; Setup ; Setup ; Setup ; Setup ; Setup ; Setup ; Setup ; Setup ; Setup ; Setup

to setup
  clear-all

   ;; colour lines to mark projects and products spaces
   ask patches with [pxcor = 17 OR pxcor = -5 OR pxcor = -14  OR pxcor = -4] [set pcolor white]

   ;; set some globals to zero
   setup-globals

   ;; create agents
   if number-of-products = "one" [ set initial-products 1 ]
   if number-of-products = "a few" [ set initial-products random 5 + 2 ]
   if number-of-products = "many" [ set initial-products random 100 ]
   create-existing-product
   create-existing-projects
   create-lone-tasks
   create-#1
   create-#9
   create-#90

   ;; set current activity to avoid artefact
   ask projects [ if count my-tasks-projects > 0 and count turtle-set [ tasklink-neighbors ] of my-tasks-projects > 0
                      [ let my-tasks-tasklinkneighbors turtle-set [ tasklink-neighbors ] of my-tasks-projects
                        set production-activity  ( count link-set [ my-tasklinks ] of my-tasks-projects  /
                                                   mean [ distance myself ] of my-tasks-tasklinkneighbors )
                      ]
                 ]
   let lonetasks-activity sum [ count my-lonetasklinks ] of loneTasks
   let total-prod-activity ( sum [production-activity] of projects + lonetasks-activity )
   set community-prod-activity-ls replace-item 10 community-prod-activity-ls total-prod-activity
   let total-cons-activity sum [consumption-activity] of products
   set community-con-activity-ls replace-item  10 community-con-activity-ls total-cons-activity

   reset-ticks
end

; Go ; Go ; Go ; Go ; Go ; Go ; Go ; Go ; Go ; Go ; Go ; Go ; Go ; Go ; Go ; Go ; Go ; Go ; Go ; Go ; Go ; Go ; Go ; Go
; Go ; Go ; Go ; Go ; Go ; Go ; Go ; Go ; Go ; Go ; Go ; Go ; Go ; Go ; Go ; Go ; Go ; Go ; Go ; Go ; Go ; Go ; Go ; Go
; Go ; Go ; Go ; Go ; Go ; Go ; Go ; Go ; Go ; Go ; Go ; Go ; Go ; Go ; Go ; Go ; Go ; Go ; Go ; Go ; Go ; Go ; Go ; Go

to go
  set-bounties                        ;; contributors can set a bounty to their project if they wish
  find-projects                       ;; contributors find projects - dependent on platform ON/OFF
  find-tasks                          ;; contributors find tasks - not dependent on platform, this is where actual decision
                                      ;; to defo contribute is made
  find-featured-tasks                 ;; 9s can find featured tasks if scenario is on
  contribute-to-tasks                 ;; contributors regulate the number of tasks they have, and record contribute
  drop-projects                       ;; contributors drop projects if lonely/unpopular/no tasks for them
  make-and-lose-friends               ;; friendships formed and broken
  advertise-featured-tasks            ;; projects/contrbutors decide which tasks they might want to 'feature'
  finish-tasks                        ;; finished tasks improve their product a bit, and die
  give-out-reward                     ;; projects give out reward and/or thanks when all their tasks are finshed
  finished-projects                   ;; finsihed project improve their product or birth a new product
  tasks-identified                    ;; creates new tasks from existing tasks, ie., find new ones by doing others
  projects-die                        ;; projects 'die' if no contributors or tasks
  calc-recent-activity                ;; projects calculate recent activity
  update-project-position             ;; projects get closer or further from 9s depending on recent activity (platform dependent)
  new-projects                        ;; if projects have high recent activity they might produce another project
                                      ;; 1 and 9 can also propose projects
  consume-products                    ;; 90s find product, consume, products calc consumption-activity,
                                      ;; small chance of dying, small chance connection with consumer lost
  update-product-position             ;; product moves closer or further from 90s depening on recent popularity of it,
  update-90s-and-9s-and-1s-positions  ;; 1s and 9s move closer to their friends, 90s move closer to consumers of same products
  products-die                        ;; products 'die' if no consumers, and compete if a one product community
  entry                               ;; various rules for diff agents entry to community
  exit                                ;; various rules for diff agents exit from community
  change-breed                        ;; rules for agents changing breed
  all-age                             ;; all agents tick on their age/time in comm variable
  update-community-activity           ;; calc history of prod and cons activity

  ;; some backstop stop conditions for model
  if count #1s = 0 [  set time-with-no-#1s time-with-no-#1s + 1  ]
  if count #9s = 0 [ set time-with-no-#9 time-with-no-#9 + 1 ]
  if count #90s = 0 [ set time-with-no-#90s time-with-no-#90s + 1 ]
  if count products = 0 [ set time-with-no-products time-with-no-products + 1 ]
  if count t4sks + count loneTasks = 0 [ set time-with-no-tasks time-with-no-tasks + 1 ]
  if ( time-with-no-#90s = 26 ) [ print "stop no #90s" print ticks stop ]
  if ( time-with-no-#1s = 26 ) [ print "stop no #1s" print ticks stop ]
  if ( time-with-no-#9 = 26 ) [ print "stop no #9" print ticks stop ]
  if ( time-with-no-products = 26 ) [ print "stop no products" print ticks stop ]
  if ( time-with-no-tasks = 26 ) [ print "stop no tasks" print ticks stop ]

  ;; backstop if too big / slow
  if count #1s > 200 [ print "huge community" stop ]
  if count #9s > 10000 [ print "huge community" stop ]
  if count #90s > 10000 [ print "huge community" stop ]

  tick
end

;Setup Procedures;Setup Procedures;Setup Procedures;Setup Procedures;Setup Procedures;Setup Procedures
;Setup Procedures;Setup Procedures;Setup Procedures;Setup Procedures;Setup Procedures;Setup Procedures
;Setup Procedures;Setup Procedures;Setup Procedures;Setup Procedures;Setup Procedures;Setup Procedures

to create-existing-product
  create-products initial-products [ set inter3st random num-interest-categories
                                     set xcor -10
                                     set ycor -25 + inter3st
                                     set size 2
                                     set color orange
                                     set shape "box"
                                     set volume random 100
                                     set age 0
                                     set consumption-history []
                                     set mon-project []
                                   ]
end


to create-project
    set count-new-projects count-new-projects
    set num-tasks random 10 + 2
    set production-history []
    set reward-level random 100

    ifelse random-float 1 < prop-of-projects-initially-private
      [set is-private? true]
      [set is-private? false]

    ifelse random-float 1 < prop-of-projects-reward-subjective
      [ set reward-type "subjective" ]
      [ set reward-type "objective" ]

    hatch-t4sks num-tasks [
      set size 0.7
      set color green
      set shape "circle"
      t4sk-set-typ3
      set inter3st [inter3st] of myself
      set time-required random-normal mean-time-required ( mean-time-required / 4 )
      set modularity random max-modularity + 1
      set age 0
      set my-project myself
      set featured? FALSE
    ]
    set my-tasks-projects t4sks with [ my-project = myself ]
    ;; TODO missing in create existing projects
    set current-contributors turtle-set [ tasklink-neighbors ] of my-tasks-projects
    set size 2.5
    set color green - 2
    set shape "target"
    set age 0
    set likes-history []
    ask t4sks with [my-project = myself ] [ set xcor [xcor] of myself
      set ycor [ycor] of myself
      set heading random 360
      fd 1
    ]
end

to create-existing-projects
  create-projects initial-projects [
    create-project
    set inter3st random num-interest-categories

    ifelse random-float 1 < proportion-onplatform-projects
      [set is-on-platform? true]
      [set is-on-platform? false]

    set xcor 5
    set ycor -25 + inter3st

     ask t4sks with [my-project = myself ] [ set xcor [xcor] of myself
      set ycor [ycor] of myself
      set heading random 360
      fd 1
    ]

    set my-product min-one-of products [ distance myself ]
    create-projectproductlink-with my-product [ set color red ]
    ask projectproductlink-neighbors [ set mon-project (list (projectproductlink-neighbors) ) ]
  ]
end

to create-lone-tasks
  create-loneTasks initial-projects [ set inter3st random num-interest-categories
                                      set xcor 0
                                      set ycor -25 + inter3st
                                      set size 0.7
                                      set color yellow
                                      set shape "circle"
                                      set time-required random-normal mean-time-required ( mean-time-required / 4 )
                                      set modularity random max-modularity + 1
                                      set age 0
                                      set typ3 random (num-skills - 1)
                                      set my-product-L one-of products
                                    ]
end

to-report set-using-platform
  ;; is true iff platform-features is TRUE and if a random number between 0 and 1 is below the proportion of people using the platform
  report platform-features and (random-float 1 < proportion-using-platform)
end

to create-#1
  create-#1s initial-number-1s [ set interest random num-interest-categories
                                 set xcor 18
                                 set ycor -25 + interest
                                 set size 1.5
                                 set color red
                                 set my-time 1 + random 40
                                 set time my-time
                                 set skill (n-of 3 (n-values num-skills [?]))
                                 set using-platform? set-using-platform
                                 set points 0
                                 set thanks "not received"
                                 set my-projects-1s (list (min-one-of projects [ distance myself ]) )
                                 let my-projects-tasks
                                       t4sks with [ member? ( [ my-project ] of self ) ( [my-projects-1s] of myself ) ]
                                 if any? my-projects-tasks with [ member? ( [ typ3 ] of self ) ( [ skill ] of myself ) ]
                                       [ let new-task$ my-projects-tasks with [ member? ( [ typ3 ] of self ) ( [ skill ] of myself ) ]
                                         create-tasklinks-with new-task$ [ set color 3 ]
                                       ]
                                 set my-tasks-1s tasklink-neighbors
                                 set time my-time - sum [ modularity ] of tasklink-neighbors
                                 if time > 0 [ create-lonetasklink-with min-one-of loneTasks [distance myself ] [set color 4]
                                               set my-lone-tasks-1s lonetasklink-neighbors
                                             ]
                                 set contribution-history-1s (n-values 10 [ round random-exponential 0.7 ] )
                                 set my-total-contribution-1s count my-tasklinks
                                 let new-friends other turtle-set [ tasklink-neighbors ] of my-tasks-1s
                                 create-friendlinks-with n-of round ( count new-friends / 2 ) new-friends [set color red
                                                                                                           set times-worked-together 1]
                                 set my-friends friendlink-neighbors
                               ]
end

to create-#9
  create-#9s initial-number-9s [ set interest random num-interest-categories
                                 set xcor ( random 6 ) + 19
                                 set ycor -25 + interest
                                 set size 1
                                 set color blue
                                 set my-time 1 + random 20
                                 set time my-time
                                 set skill (n-of 3 (n-values num-skills [?]))
                                 set using-platform? set-using-platform
                                 set i-used-featured? FALSE
                                 set points 0
                                 set thanks "not received"
                                 set my-projects (list (min-one-of projects [ distance myself ]))
                                 let my-projects-tasks
                                       t4sks with [ member? ( [ my-project ] of self ) ( [my-projects] of myself ) ]
                                 if any? my-projects-tasks with [ member? ( [ typ3 ] of self ) ( [ skill ] of myself ) ]
                                     [ let new-task$ my-projects-tasks with [ member? ( [ typ3 ] of self ) ( [ skill ] of myself ) ]
                                       create-tasklinks-with new-task$ [set color 3]
                                     ]
                                 set my-tasks tasklink-neighbors
                                 set time my-time - sum [ modularity ] of tasklink-neighbors
                                 if time > 0 [ create-lonetasklink-with min-one-of loneTasks [distance myself ] [set color 4]
                                               set my-lone-tasks lonetasklink-neighbors
                                             ]
                                 set contribution-history-9s (n-values 10 [ round random-exponential 0.6 ] )
                                 set my-total-contribution-9s count my-tasklinks
                                 let new-friends other turtle-set [ tasklink-neighbors ] of my-tasks
                                 create-friendlinks-with n-of round ( count new-friends / 2 ) new-friends [set color blue
                                                                                                           set times-worked-together 1]
                                 set my-friends friendlink-neighbors
                                ]
    ;; once 1s and 9s created - projects can set their current contributors
    ask projects [ set current-contributors turtle-set [ tasklink-neighbors ] of my-tasks-projects ]
end

to create-#90
  create-#90s initial-number-90s [ ifelse number-of-products = "one"
                                       [ set interest [ inter3st ] of one-of products + random 20 - 10
                                         if interest > 50 [ set interest 50 ]
                                         if interest < 0  [ set interest 0  ]
                                        ]
                                       [ set interest random num-interest-categories ]
                                    set xcor random 8 - 22
                                    set ycor -25 + interest
                                    set size 1
                                    set color yellow
                                    set skill (n-of 3 (n-values num-skills [?]))
                                    set consumption 0
                                    set using-platform? set-using-platform
                                    create-consumerlink-with min-one-of products [ distance myself ]
                                    ask consumerlink-neighbors [ if count my-consumerlinks > 0
                                           [ set consumption-activity ( ( count my-consumerlinks / mean [ distance myself ] of consumerlink-neighbors ) *
                                                                        ( volume / ( mean [ volume ] of products + 1 ) )
                                                                       )
                                           ]                  ]
                                  ]
end

to setup-globals
  set #9s-left 0
  set #90s-left 0
  set new-#9s-total 0
  set new-#90s-total 0
  set #9s-left 0
  set #90s-left 0
  set new-#9s-total 0
  set new-#90s-total 0
  set new-#1-count 0
  set products-consumed 0
  set tasks-completed 0
  set new-tasks-count 0
  set new-products-count 0
  set #9-to-#1-count 0
  set #1-to-#9-count 0
  set #9-left-no-interest 0
  set #1-left-burnout 0
  set time-with-no-#1s 0
  set time-with-no-#9 0
  set time-with-no-#90s 0
  set new-#9-attracted-by-#90s 0
  set projects-died  0
  set loneTasksFinished 0
  set count-new-projects 0
  set product-had-no-consumer-so-left 0
  set community-prod-activity-ls [0 0 0 0 0 0 0 0 0 0 0]
  set community-con-activity-ls [0 0 0 0 0 0 0 0 0 0 0]

  set num-skills 10

  if platform-features = FALSE [ set chance-90-find-a-task chance-90-find-a-task / 2 ]
end

;Go Procedures;Go Procedures;Go Procedures;Go Procedures;Go Procedures;Go Procedures;Go Procedures;Go Procedures;Go Procedures
;Go Procedures;Go Procedures;Go Procedures;Go Procedures;Go Procedures;Go Procedures;Go Procedures;Go Procedures;Go Procedures
;Go Procedures;Go Procedures;Go Procedures;Go Procedures;Go Procedures;Go Procedures;Go Procedures;Go Procedures;Go Procedures
;Go Procedures;Go Procedures;Go Procedures;Go Procedures;Go Procedures;Go Procedures;Go Procedures;Go Procedures;Go Procedures
;Go Procedures;Go Procedures;Go Procedures;Go Procedures;Go Procedures;Go Procedures;Go Procedures;Go Procedures;Go Procedures
;Go Procedures;Go Procedures;Go Procedures;Go Procedures;Go Procedures;Go Procedures;Go Procedures;Go Procedures;Go Procedures

to set-bounties
  ;; if bounties is ON, tasks set a bounty (with some probability) to 10% of points of contributors to its project
  ;; contributors decrease their points accordingly
  if reward-mechanism-2 = "bounties" [
        ask t4sks [ let myProjectsPoints [ sum [ points ] of current-contributors ] of my-project
                    let avProjectsPoints mean [ sum [ points ] of current-contributors ] of projects
                    if count tasklink-neighbors = 0 and
                       random-float 1 < prob-set-a-bounty and
                       myProjectsPoints > avProjectsPoints [
                             set bounty 0.1 * myProjectsPoints
                             ask [ current-contributors ] of my-project [ set points points - (0.1 * points) ]
                                                          ]
                    ]
        ask projects [ set total-bounty sum [ bounty ] of t4sks with [ my-project = myself ] ]
                                      ]
end

to-report project-distance

  let noise? (
    (not [ using-platform? ] of myself) or
    (community-type = "offline") or
    is-private?
  )

  let bounties? (
    [ using-platform? ] of myself and
    reward-mechanism-2 = "bounties" and
    not is-private?
  )

  let reputation? (
    [ using-platform? ] of myself and
    reward-mechanism-2 = "reputation" and
    not is-private?
  )

  let dist distance myself

  if noise?
    [ set dist dist + random max-noise - (max-noise / 2)]


  if (bounties? and total-bounty != 0) [
    let avgBounties
      mean [ total-bounty ] of projects


    if (avgBounties != 0) [
      ;; TODO: Is the attractive of a bounty proportional to the relation with the average?
      ;; should we take logarithms instead?

      ;; todo, should total bounties affect distance here? or should they go straight for bounties in tasks
      set dist dist - dist * bountiesEffect * (total-bounty / avgBounties)
    ]
  ]

  if (reputation?) [
    let avgReputation
      mean [ sum [ points ] of current-contributors ] of projects
    let myReputation
      sum [ points ] of current-contributors
    if (avgReputation != 0) [
      ;; TODO: Is the attractive of a project due to its reputation proportional to the relation with the average?
      ;; should we take logarithms instead?
      set dist dist - dist * reputationEffect * (myReputation / avgReputation)
    ]
  ]

  report dist
end

to find-projects

  ask #1s [ if time > 0
                [ let other-projects projects with [ not member? self [ my-projects-1s ] of myself ]
                  let new-project min-one-of other-projects [ project-distance ]
                  if other-projects != nobody [ set my-projects-1s lput new-project my-projects-1s ]
                ]
  ]


  ask #9s [ if time > 0
                [ let other-projects projects with [ not member? self [ my-projects ] of myself ]
                  let new-project min-one-of other-projects [ project-distance ]
                  if other-projects != nobody and new-project != nobody
                          ;; random number < prob / ( distance of new project / distance furthest project )
                          ;; ie., relative closeness of new project increases chance of joining it
                        [ if random-float 1 < ( prob-9-decides-to-join-project / ( ( [ project-distance ] of new-project ) /
                                                                                   ( [ project-distance ] of max-one-of projects [ project-distance ] )
                                                                                 )
                                              )
                              [ set my-projects lput new-project my-projects ]
                        ]
                ]
  ]

end

to find-tasks

  ; 1s find tasks that are in the projects they have found, with the right skills required
  ; they dont worry about thanks/points and friendship in joining tasks

  ask #1s [ if time > 0 [ let my-projects-tasks t4sks with [ member? ( [ my-project ] of self ) ( [my-projects-1s] of myself ) ]
                          if any? my-projects-tasks with [ member? ( [ typ3 ] of self ) ( [ skill ] of myself ) ]
                                [ let new-task$ my-projects-tasks with [ member? ( [ typ3 ] of self ) ( [ skill ] of myself ) ]
                                  create-tasklinks-with new-task$ [set color 3]
                                ]
                          if ( not any? my-projects-tasks with [ member? ( [ typ3 ] of self ) ( [ skill ] of myself ) ])
                                [ let new-task$-2 one-of my-projects-tasks
                                  if new-task$-2 != nobody [ create-tasklink-with new-task$-2 [set color 3] ]
                                ]
                          set my-tasks-1s tasklink-neighbors
                        ]
          ]

  ; 9s find tasks that are in the projects they have found, with the right skills required
  ; they are affected by thank/points and friendship in deciding to actually joing a task
  ; joiing a task is the point of deciding to make an actual contribution - once you have joined it is assumed you will contribute

  ask #9s [ if time > 0 [ ; 9s first must calc their current feel-loved score to be used in decision
                          if reward-mechanism = "none" [ set feel-loved 0 ]

                          if reward-mechanism = "'thanks' only" [ if thanks = "not received" [ set feel-loved 0 ]
                                                                  if thanks = "received from #9" [ set feel-loved 0.005 ]
                                                                  if thanks = "received from #1" [ set feel-loved 0.01 ]
                                                                ]

                          if reward-mechanism = "'points' only" [ set feel-loved 0
                                                                  let personType random-float 1
                                                                  if personType > 0.2 and points > median [ points ] of #9s [ set feel-loved 0.005 ]
                                                                  if personType < 0.2 and points < median [ points ] of #9s [ set feel-loved 0.005 ]
                                                                ]

                          if reward-mechanism = "both" [ let personType random-float 1
                                                         if thanks = "not received" [ set feel-loved 0 ]
                                                         if personType > 0.2 and points > median [ points ] of #9s [ set feel-loved 0.005 ]
                                                         if personType < 0.2 and points < median [ points ] of #9s [ set feel-loved 0.005 ]
                                                         if thanks = "received from #9" [ set feel-loved 0.005 ]
                                                         if thanks = "received from #1" [ set feel-loved 0.01 ]
                                                        ]

                          let my-projects-tasks t4sks with [ member? ( [ my-project ] of self ) ( [my-projects] of myself ) ]
                          if any? my-projects-tasks with [ member? ( [ typ3 ] of self ) ( [ skill ] of myself ) ]
                                [ let new-task$ my-projects-tasks with [ member? ( [ typ3 ] of self ) ( [ skill ] of myself ) ]

                                  ;; 9 might be attracted to an appropriate tasks just by the bounty (but still needs to be in one of their projects and right skill
                                  let aveBounty mean [ bounty ] of t4sks
                                  let aveContributors mean [ count tasklink-neighbors ] of t4sks

                                  ifelse any? new-task$ with [ ( ifelse-value ( count tasklink-neighbors != 0 ) [ bounty / count tasklink-neighbors ] [ bounty ] ) >
                                                                                                            ( aveBounty / aveContributors ) and random-float 1 < chance-9-chases-a-bounty ]
                                   [ create-tasklink-with max-one-of new-task$ [ ifelse-value ( count tasklink-neighbors != 0 ) [ bounty / count tasklink-neighbors ] [ bounty ] ] [set color 3]
                                     set my-tasks tasklink-neighbors
                                   ]
                                  [
                                  ; using contribution-history-9s increases chance of contribution with prev contributions
                                  ; using feel-loved increases chance of contribution with thanks/points
                                  ; higher chance when there are contributors who are my friend, and when i have contributors who
                                  ; are my friend, i only look at these tasks

                                  let contributors-to-new-task turtle-set [ tasklink-neighbors ] of new-task$
                                  let contributors-to-new-tasks-that-are-my-friend
                                        contributors-to-new-task with [ member? myself friendlink-neighbors ]

                                  ;; 9 goes for the taks with highest bounty / contributors

                                  ifelse any? contributors-to-new-tasks-that-are-my-friend and contribution-history-9s != 0 and random-float 1 < chance-9-picks-tasks-with-friends
                                        [ if ( random-float 1 < ( prob-9-contributes-to-friends-task + ( 0.01 * sum contribution-history-9s ) + feel-loved ) )
                                              [ let mostBountyOfFriendsTask max-one-of turtle-set [ tasklink-neighbors ] of contributors-to-new-tasks-that-are-my-friend [ bounty / count tasklink-neighbors ]
                                                create-tasklink-with mostBountyOfFriendsTask
                                                         [set color 3]
                                              ]
                                        ]
                                        [ if contribution-history-9s != 0 [ if ( random-float 1 < ( prob-9-contributes-to-none-friend-task + ( 0.01 * sum contribution-history-9s ) + feel-loved ) )
                                              [ create-tasklink-with max-one-of new-task$ [ ifelse-value ( count tasklink-neighbors != 0 ) [ bounty / count tasklink-neighbors ] [ bounty ] ] [set color 3] ] ]
                                        ]
                                  set my-tasks tasklink-neighbors
                                ]
                        ]
           ]

  ]

  ;; find lone tasks - 1s with easily online and with some error offline
  ;; 9s with some error online and randomly for offline

  ask #1s [ if community-type = "online" and time > 0
                [ if any? loneTasks [ let new-loneTask min-one-of loneTasks [ distance myself ]
                                      create-lonetasklink-with new-loneTask [set color 4]
                                      set my-lone-tasks-1s lonetasklink-neighbors
                                    ]
                ]
            if community-type = "offline" and time > 0
                [ if any? loneTasks [ let new-loneTask min-one-of loneTasks [ distance myself + random 5 - 2.5 ]
                                      create-lonetasklink-with new-loneTask [set color 4]
                                      set my-lone-tasks-1s lonetasklink-neighbors
                                    ]
                ]
           ]

  ask #9s [ if community-type = "online" and time > 0 and contribution-history-9s != 0
                [ if any? loneTasks and random-float 1 < prob-9-decides-to-join-project + ( 0.01 * sum contribution-history-9s )
                      [ let new-loneTask min-one-of loneTasks [ distance myself + random 5 - 2.5 ]
                        create-lonetasklink-with new-loneTask [set color 4]
                        set my-lone-tasks lonetasklink-neighbors
                      ]
                ]
            if community-type = "offline" and time > 0 and contribution-history-9s != 0
                [ if any? loneTasks and random-float 1 < prob-9-decides-to-join-project + ( 0.01 * sum contribution-history-9s )
                      [ create-lonetasklink-with one-of loneTasks [set color 4]
                        set my-lone-tasks lonetasklink-neighbors
                      ]
                ]
           ]
end

to find-featured-tasks
  ;; 9s and 90s only? can find featured/advertised tasks directly. ie., they are not focusing so much on interest, but also skills required.

  ;; possible todos - only low contributors use featured needs service?

  ;; possible todo - some needs more likely to be found? age?

  ;; if the right scenario
  if platform-features = TRUE and featured-needs? = TRUE
        ;; only 9s using TEEM
        [ ask #9s with [ using-platform? = true ]
              ;; if they have time, and are active
              [ if time > 0 and contribution-history-9s != 0
                    ;; look at featured tasks and with some probability, make a connection to one i have skills for
                    [ let featuredTasks t4sks with [ featured? = TRUE ]
                    ;; need to exlude tasks already joined? nope - nothing happens if you join twice
                    if any? featuredTasks and random-float 1 < prob-9-finds-featured-need
                          [ let new-FeaturedTask featuredTasks with [ member? ( [ typ3 ] of self ) ( [ skill ] of myself ) ]
                            if any? new-FeaturedTask [ create-tasklink-with one-of new-FeaturedTask [ set color 3 ]
                                                       set my-tasks tasklink-neighbors
                                                       ;; the project then also becomes one of their projects?
                                                       let new-project [ my-project ] of new-FeaturedTask
                                                       set my-projects lput new-project my-projects
                                                       set i-used-featured? TRUE
                                                     ]
                           ]
                     ]
                ]

          ask #90s with [ using-platform? = true ]

                ;; to do? how does chance of 90 become 9 here, relate to chance in change breed

                [ let featuredTasks t4sks with [ featured? = TRUE ]
                  if any? featuredTasks and random-float 1 < chance-90-find-a-task
                        [ let new-FeaturedTask featuredTasks with [ member? ( [ typ3 ] of self ) ( [ skill ] of myself ) ]
                          if any? new-FeaturedTask [  set breed #9s
                                                      set xcor ( random 6 ) + 19
                                                      set ycor -25 + interest
                                                      set size 1
                                                      set color blue
                                                      set my-time 1 + random 20
                                                      set time my-time
                                                      set points 0
                                                      set thanks "not received"

                                                      create-tasklink-with one-of new-FeaturedTask [ set color 3 ]
                                                      set my-tasks tasklink-neighbors
                                                      ;; the project then also becomes one of their projects?
                                                      let new-project [ my-project ] of new-FeaturedTask
                                                      set my-projects (list (new-project))
                                                      set contribution-history-9s (list (0))
                                                      ask my-consumerlinks [die]
                                                      set #90-used-featured-needs #90-used-featured-needs + 1
                                                      set #90-to-#9-count #90-to-#9-count + 1
                                                      set i-used-featured? TRUE
                                                   ]
                           ]
                  ]
                ]


end

to contribute-to-tasks

  ; 1s and 9s update time availability, if no time left, drop tasks
  ; then they update some records of contributions

   ask #1s [ set time my-time - sum [ modularity ] of tasklink-neighbors - sum [ modularity ] of lonetasklink-neighbors
             if time < 0 and count my-tasklinks > 1
                   [ ; need to pick tasks to drop
                     ; 1/4 chance each it is less popular tasks, task with lots to do, task with least friends, or a lonetask
                     let chance random-float 1
                     if chance < 0.25
                           [ ask link-with ( min-one-of tasklink-neighbors [ xcor ] ) [die] ]
                     if chance >= 0.25 and chance < 0.5
                           [ ask link-with ( max-one-of tasklink-neighbors [ time-required ] ) [die] ]
                     if chance >= 5 and chance < 0.75
                           [ ask link-with ( min-one-of tasklink-neighbors
                               [ count tasklink-neighbors with [ member? [ myself ] of myself friendlink-neighbors ] ] ) [die]
                           ]
                     if chance >= 0.75
                          [ if count lonetasklinks > 0 [ ask one-of lonetasklinks [ die ] ] ]
                     set #1-dropped-a-task #1-dropped-a-task + 1
                   ]
             set time my-time - sum [ modularity ] of tasklink-neighbors - sum [ modularity ] of lonetasklink-neighbors
             if count my-tasklinks > 0 [ set my-tasks-1s tasklink-neighbors
                                         set my-lone-tasks-1s lonetasklink-neighbors
                                         set contributions-made-by-1s contributions-made-by-1s + count tasklink-neighbors + count lonetasklink-neighbors
                                         set time-contributed-by-1s time-contributed-by-1s + ( my-time - time )
                                       ]
             set contribution-history-1s lput ( count my-tasklinks + count my-lonetasklinks ) contribution-history-1s
             if length contribution-history-1s > 10 [ set contribution-history-1s but-first contribution-history-1s ]
             set my-total-contribution-1s my-total-contribution-1s + ( count my-tasklinks + count my-lonetasklinks )
           ]

   ask #9s [ set time my-time - sum [ modularity ] of tasklink-neighbors - sum [ modularity ] of lonetasklink-neighbors
             if time < 0 and count my-tasklinks > 1
                   [ let chance random-float 1
                     if chance < 0.25
                           [ ask link-with ( min-one-of tasklink-neighbors [ xcor ] ) [die] ]
                     if chance >= 0.25 and chance < 0.5
                           [ ask link-with ( max-one-of tasklink-neighbors [ time-required ] ) [die] ]
                     if chance >= 0.5 and chance < 0.75
                           [ ask link-with ( min-one-of tasklink-neighbors
                               [ count tasklink-neighbors with [ member? [ myself ] of myself friendlink-neighbors ] ] ) [die]
                           ]
                     if chance >= 0.75
                           [ if count lonetasklinks > 0 [ ask one-of lonetasklinks [ die ] ] ]
                     set #9-dropped-a-task #9-dropped-a-task + 1
                   ]
             set time my-time - sum [ modularity ] of tasklink-neighbors - sum [ modularity ] of lonetasklink-neighbors
             if count my-tasklinks > 0 [ set my-tasks tasklink-neighbors
                                         set my-lone-tasks lonetasklink-neighbors
                                         set contributions-made-by-9s contributions-made-by-9s + count tasklink-neighbors + count lonetasklink-neighbors
                                         set time-contributed-by-9s time-contributed-by-9s + ( my-time - time )
                                       ]
             if contribution-history-9s = 0 [ set contribution-history-9s (list (0)) ]
             set contribution-history-9s lput ( count my-tasklinks + count my-lonetasklinks ) contribution-history-9s
             if length contribution-history-9s > 10 [ set contribution-history-9s but-first contribution-history-9s ]
             set my-total-contribution-9s my-total-contribution-9s + ( count my-tasklinks + count my-lonetasklinks )
           ]

  ; task reduce their time by their contriubutors * modularity

  ask t4sks [ set time-required time-required - (modularity * count tasklink-neighbors) ]

  ask loneTasks [ set time-required time-required - (modularity * count lonetasklink-neighbors) ]

  ; projects reset their current contributors

  ask projects [ set my-tasks-projects t4sks with [ my-project = myself ]
                 set current-contributors turtle-set [ tasklink-neighbors ] of my-tasks-projects
               ]
end

to drop-projects

  ; 1s drop a project and its tasks if it is lonely / unpopular

  ask #1s [ if any? ( turtle-set my-projects-1s ) with
                [ all? my-tasks-projects [ ( turtle-set tasklink-neighbors = turtle-set myself ) OR
                                           ( turtle-set tasklink-neighbors = nobody )
                                         ]
                ]
                  and random-float 1 < prob-1-drop-lonely-project [
                        let lonely-projects ( turtle-set my-projects-1s ) with
                              [ all? my-tasks-projects [ ( turtle-set tasklink-neighbors = turtle-set myself OR
                                                           turtle-set tasklink-neighbors = nobody )
                                                       ]
                              ]
                        let lonely-unpopular-project one-of lonely-projects with
                                ; distance of project increase chance it being picked to drop
                                ; especially if xcor less than 0 - ie., pretty unpopular
                              [ random-float 1 < ( [ xcor ] of myself - xcor / 17 - (- 4) )  ]
                        let lonely-unpopular-tasks [ my-tasks-projects ] of lonely-unpopular-project
                        set my-projects-1s remove lonely-unpopular-project my-projects-1s
                        set #1-dropped-a-project #1-dropped-a-project + 1
                        ask lonely-unpopular-tasks [ ask my-tasklinks [die] ]
                        set my-tasks-1s tasklink-neighbors
                        set #1-dropped-a-task #1-dropped-a-task + (count lonely-unpopular-tasks )
                                             ]
           ]

  ; 9s drop a project and its tasks if it is lonely / unpopular (also 10 times more likely to do this)

  ask #9s [ if any? ( turtle-set my-projects ) with
                [ all? my-tasks-projects [ ( turtle-set tasklink-neighbors = turtle-set myself ) OR
                                           ( turtle-set tasklink-neighbors = nobody )
                                         ]
                ]
                  and random-float 1 < prob-9-drop-a-lonely-or-no-tasks-project [
                       let lonely-projects ( turtle-set my-projects ) with
                             [ all? my-tasks-projects [ ( turtle-set tasklink-neighbors = turtle-set myself OR
                                                          turtle-set tasklink-neighbors = nobody )
                                                      ]
                             ]
                       let lonely-unpopular-project one-of lonely-projects with
                             [ random-float 1 < ( [ xcor ] of myself - xcor / 17 - (- 4) ) ]
                       let lonely-unpopular-tasks [ my-tasks-projects ] of lonely-unpopular-project
                       set my-projects remove lonely-unpopular-project my-projects
                       set #9-dropped-a-project #9-dropped-a-project + 1
                       ask lonely-unpopular-tasks [ ask my-tasklinks [die] ]
                       set my-tasks tasklink-neighbors
                       set #9-dropped-a-task #9-dropped-a-task + (count lonely-unpopular-tasks )
                                           ]
            ]

  ; with a certain chance 9s drop projects if they have no tasks in them

  ask #9s [ if count ( turtle-set my-projects ) with [ not member? self [ [ my-project ] of my-tasks ] of myself ] > 0 and
            random-float 1 < prob-9-drop-a-lonely-or-no-tasks-project
                  [ let projects-to-drop ( turtle-set my-projects ) with [ not member? self [ [my-project] of my-tasks ] of myself ]
                    set my-projects remove one-of projects-to-drop my-projects
                    set #9-dropped-a-project #9-dropped-a-project + 1
                  ]
           ]

end

to make-and-lose-friends

  ; 1s and 9s can make friends with those working on their tasks
  ; on each tick there is also a chance a friendship bond breaks

  ask #1s [ if count tasklink-neighbors > 0 [ let new-friendsL other turtle-set [ lonetasklink-neighbors ] of my-lone-tasks-1s
                                              let new-friendsT other turtle-set [ tasklink-neighbors ] of my-tasks-1s
                                              let new-friends turtle-set (list (new-friendsL) (new-friendsT))

                                              ask new-friends with [ member? myself friendlink-neighbors ]
                                                   [ ask friendlink-with myself [ set times-worked-together times-worked-together + 1 ] ]

                                              create-friendlinks-with n-of round ( count new-friends / 2 ) new-friends [set color red
                                                                                                                        set times-worked-together 1]
                                              if count friendlinks > 0 [ if random-float 1 < chance-forget-a-friend
                                                                            [ if any? friendlinks with [ times-worked-together = 1 ]
                                                                                 [ ask one-of friendlinks with [ times-worked-together = 1 ] [ die ] ]
                                                                            ]
                                                                         if random-float 1 < chance-forget-a-friend / 2
                                                                            [ if any? friendlinks with [ times-worked-together > 1 and times-worked-together < 5 ]
                                                                                 [ ask one-of friendlinks with [ times-worked-together > 1 and
                                                                                                                 times-worked-together < 5  ] [ die ] ]
                                                                             ]
                                                                         if random-float 1 < chance-forget-a-friend / 4
                                                                            [ if any? friendlinks with [ times-worked-together > 4 ]
                                                                                 [ ask one-of friendlinks with [ times-worked-together > 4 ] [ die ] ]
                                                                            ]
                                                                        ]
                                               set my-friends friendlink-neighbors
                                            ]
          ]

  ask #9s [ if count tasklink-neighbors > 0 [ let new-friendsT other turtle-set [ tasklink-neighbors ] of my-tasks
                                              let new-friendsL other turtle-set [ lonetasklink-neighbors ] of my-lone-tasks
                                              let new-friends turtle-set (list (new-friendsL) (new-friendsT))

                                              ask new-friends with [ member? myself friendlink-neighbors ]
                                                   [ ask friendlink-with myself [ set times-worked-together times-worked-together + 1 ] ]

                                              create-friendlinks-with n-of round ( count new-friends / 2 ) new-friends [set color blue
                                                                                                                        set times-worked-together 1 ]
                                              set my-friends friendlink-neighbors
                                              if count friendlinks > 0 [ if random-float 1 < chance-forget-a-friend
                                                                            [ if any? friendlinks with [ times-worked-together = 1 ]
                                                                                 [ ask one-of friendlinks with [ times-worked-together = 1 ] [ die ] ]
                                                                            ]
                                                                         if random-float 1 < chance-forget-a-friend / 2
                                                                            [ if any? friendlinks with [ times-worked-together > 1 and times-worked-together < 5 ]
                                                                                 [ ask one-of friendlinks with [ times-worked-together > 1 and
                                                                                                                 times-worked-together < 5  ] [ die ] ]
                                                                             ]
                                                                         if random-float 1 < chance-forget-a-friend / 4
                                                                            [ if any? friendlinks with [ times-worked-together > 4 ]
                                                                                 [ ask one-of friendlinks with [ times-worked-together > 4 ] [ die ] ]
                                                                            ]
                                                                        ]
                                            ]
          ]
end

to advertise-featured-tasks
  ;; projects with tasks that are not getting done 'feature' them if scenario on

  ;; potential to do - sorting the order of advetsied needs - some more visible?

  if platform-features = TRUE and featured-needs? = TRUE
  [
  ;; find tasks with no contributors and not already advertised
  ask projects [  let taskInNeedOfAdvertising my-tasks-projects with [ count tasklink-neighbors = 0 and featured? = FALSE ]
                  ;; with some probability
                  if any? taskInNeedOfAdvertising and random-float 1 < prob-project-advertises-a-task
                        ;; ask that task to become features
                        [ ask one-of taskInNeedOfAdvertising [ set featured? TRUE
                                                               set color color + 4
                                                              ]
                        ]
                  ;; remove featured needs from list
                  let taskNoLongerNeedsAdvertising my-tasks-projects with [ count tasklink-neighbors > 0 and featured? = TRUE ]
                  if any? taskNoLongerNeedsAdvertising
                        [ ask one-of taskNoLongerNeedsAdvertising [ set featured? FALSE
                                                                    set color color - 4
                                                                  ]
                        ]

                ]
  ]
end




to give-out-reward

  ; two types of reward mechanism - points and thanks
  ; points is quantitative - get points  when task is complete,
  ; relative number of points is then used in deciding whether to contribute again etc,
  ; thanks is (more) qualitative - do i have it or not, and who is it from
  ; this is then also used in other decisions, eg., contributions, exit...
  ; 'value' of thanks is higher from 1 than 9 etc

  if reward-mechanism = "none" [
    ask #1s [ set thanks "not received" set points 0 ]
    ask #9s [ set thanks "not received" set points 0 ]
  ]

  if reward-mechanism = "'thanks' only"
    [ ;; half of contributors at end of project get thanks from another 9
      ;; a third or less of current contributors (of those with least free time) get thanks from a 1
      ask projects [ if num-tasks = 0 [ ask n-of ( round count current-contributors / 2 ) current-contributors
                                            [ set thanks "received from #9" ]
                                        ask min-n-of random ( round count current-contributors / 3 ) current-contributors [ time ]
                                            [ set thanks "received from #1" ]
                                      ]
                   ]
      ; chance per tick that a contributor 'forgets' they got thanks
      ask #1s [ if random-float 1 < chance-forget-thanks [ set thanks "not received" ] ]
      ask #9s [ if random-float 1 < chance-forget-thanks [ set thanks "not received" ] ]
     ]

  if reward-mechanism = "'points' only"
    [ ;; points given out at end of project
      ;; some projects all give same points, some give with some variation
      ask projects [ if num-tasks = 0

          [ if reward-type = "subjective"
                [ ask current-contributors
                      [ set points points + random-normal ([ reward-level ] of myself) ([ reward-level ] of myself / 2) ]
                 ]
            if reward-type = "objective"
                [ ask current-contributors
                      [ set points points + [ reward-level ] of myself ]
                ]
           ]
        ]
                  ]


  if reward-mechanism = "both"
    [ ;; previous two combined when both mechanims being used
      ask projects [  if num-tasks = 0 [ ask n-of ( round count current-contributors / 2 ) current-contributors
                                             [ set thanks "received from #9" ]
                                         ask min-n-of random ( round count current-contributors / 3 )  current-contributors [ time ]
                                             [ set thanks "received from #1" ]
                                       ]
                   ]
      ask #1s [ if random-float 1 < chance-forget-thanks [ set thanks "not received" ] ]
      ask #9s [ if random-float 1 < chance-forget-thanks [ set thanks "not received" ] ]

      ask projects [ if num-tasks = 0

          [ if reward-type = "subjective"
                [ ask current-contributors
                      [ set points points + random-normal ([ reward-level ] of myself) ([ reward-level ] of myself / 2) ]
                 ]
            if reward-type = "objective"
                [ ask current-contributors
                      [ set points points + [ reward-level ] of myself ]
                ]
           ]
        ]
                  ]

end

;; Function by JenB, source: https://stackoverflow.com/a/28323443
to-report random-pareto [alpha mm]
  report mm / ( random-float 1 ^ (1 / alpha) )
end

to-report project-volume-increment
  report max-project-initial-volume * volume-increment-to-initial-volume-ratio * random-pareto 2 0
end

to-report task-volume-increment
  report task-project-volume-increment-ratio * project-volume-increment
end


to finish-tasks

  ; when a task is finished - it improves volume of its product
  ; volume is used in products position (ie., appeal to 90s)

  ; when it finishes it gives out its bounty

  ask t4sks [ if time-required <= 0 [ ifelse number-of-products = "many"
                                          [ ask products with [ mon-project = [ my-project ] of myself ]
                                                [ set volume volume + task-volume-increment ]
                                          ]
                                          [ ask products with [  mon-project != nobody and mon-project != 0 and member? [ my-project ] of myself mon-project ]
                                                [ set volume volume + task-volume-increment ]
                                          ]
                                      ;; points given out at end of task
                                      if reward-mechanism = "points" OR reward-mechanism = "both" [
                                        if reward-mechanism-2 = "bounties"
                                            [ ask tasklink-neighbors [ set points points + ( [ bounty ] of myself / [ count tasklink-neighbors ] of myself )   ]
                                              set tasks-completed tasks-completed + 1
                                              ask turtle-set my-project [ set num-tasks num-tasks - 1 ]
                                              die
                                            ]
                                        if my-project = nobody [die]
                                                                                                  ]
                                   ]
           ]

  ask loneTasks [ if time-required <= 0 [ ask my-product-L [ set volume volume + task-volume-increment ]
                                          if reward-mechanism = "points" OR reward-mechanism = "both"
                                                [ ask lonetasklink-neighbors [ set points points + random ( [ modularity ] of myself * 3 )  ] ]
                                          set loneTasksFinished loneTasksFinished + 1
                                          die
                                        ]
                ]
end

to finished-projects

  ;; a project is finshed it either improves its product volume, or creates a new product if it is not connected to one

  ask projects [ if num-tasks = 0 and my-product != nobody [ ask my-product [ set volume volume + project-volume-increment ]
                                                             set projects-finished projects-finished + 1
                                                             die ]
                 if num-tasks = 0 and my-product = nobody [ birth-a-product project-volume-increment

                                                            set projects-finished projects-finished + 1
                                                            die ]
               ]
end

to tasks-identified

    ;; if more people are working on a task - some chance they identify other tasks

   ask t4sks [ if count tasklink-neighbors > 0 [ if random-float 1 < chance-of-finding-new-task [ create-new-task ] ] ]

   ;; new lone tasks appear randomly

   if random-float 1 < chance-new-loneTask [
        create-loneTasks 1 [ set inter3st random num-interest-categories
                             set xcor 0
                             set ycor -25 + inter3st
                             set size 0.7
                             set color yellow
                             set shape "circle"
                             set time-required random-normal mean-time-required ( mean-time-required / 4 )
                             set modularity random max-modularity + 1
                             set age 0
                             set typ3 random (num-skills - 1)
                             set my-product-L one-of products
                           ]               ]
end

to create-new-task
  hatch-t4sks 1 [ set heading random 360
                  fd 1
                  set size 0.7
                  set color green
                  set shape "circle"
                  t4sk-set-typ3
                  set inter3st [inter3st] of myself
                  set time-required random-normal mean-time-required ( mean-time-required / 4 )
                  set modularity random max-modularity + 1
                  set age 0
                  set my-project [my-project] of myself
                  set new-tasks-count new-tasks-count + 1
                  ask turtle-set my-project [ set num-tasks num-tasks + 1 ]
                ]
end

to projects-die

  ;; projects are removed from list with some chance if no contributors are associated with them

  ask projects [ if not any? #9s with [ member? myself my-projects ] and
                    not any? #1s with [ member? myself my-projects-1s ]
                          [ if random-float 1 < chance-unpopular-project-dies [ set projects-died projects-died + 1
                                                                                ask turtle-set my-tasks-projects [ die ]
                                                                                die
                                                                              ]
                          ]
                ]
end

to calc-recent-activity

  ; projects calculate their contribution/production history
  ask projects [ set my-tasks-projects t4sks with [ my-project = myself ]
                 if count my-tasks-projects > 0 and count turtle-set [ tasklink-neighbors ] of my-tasks-projects > 0
                       [ let my-tasks-tasklinkneighbors turtle-set [ tasklink-neighbors ] of my-tasks-projects
                         set production-activity  ( count link-set [ my-tasklinks ] of my-tasks-projects  /
                                                    mean [ distance myself ] of  my-tasks-tasklinkneighbors )
                         set production-history lput ( count link-set [ my-tasklinks ] of my-tasks-projects /
                                                       mean  [ distance myself ] of my-tasks-tasklinkneighbors ) production-history
                         if length production-history = 11 [ set production-history but-first production-history ]
                       ]
                ]
end

to new-projects

  ; 1s and 9s to propose new projects with a small probability - 1s is higher

  ask #1s [ if random-float 1 < chance-contributor-proposes-a-new-project [ #1-or-#9-hatch-project ] ]
  ask #9s [ if random-float 1 < chance-contributor-proposes-a-new-project [ #1-or-#9-hatch-project ] ]

  ; projects can create other projects - if very active

  ask projects [ if length production-history > 3 and mean production-history > 0
        [ let history-difference mean sublist production-history (length production-history - 3) (length production-history )
          - mean production-history
          if random-float 1 < chance-a-project-hatches-a-project and history-difference > 0 [ project-hatch-a-project ]
        ]
               ]
end

to #1-or-#9-hatch-project
  hatch-projects 1 [
    create-project
    ifelse [using-platform?] of myself
      [ ifelse random-float 1 < proportion-onplatform-projects
        [ set is-on-platform? true ]
        [ set is-on-platform? false ]
      ]
      [ set is-on-platform? false ]

    set inter3st ([interest] of myself + random 3 - random 3) mod 50

    set ycor -25 + inter3st
    set xcor 5

    ifelse random-float 1 < 0.8
    [ set my-product min-one-of products [distance myself]
      create-projectproductlink-with my-product [set color red]
      ask projectproductlink-neighbors [ set mon-project lput myself mon-project ]
    ]
    [ set my-product nobody ]
  ]
end

to project-hatch-a-project
  hatch-projects 1 [
    create-project
    ifelse random-float 1 < proportion-onplatform-projects
      [set is-on-platform? true]
      [set is-on-platform? false]

    set inter3st ([inter3st] of myself + random 3 - random 3) mod 50

    set ycor -25 + inter3st
    set xcor [xcor] of myself

    if my-product != nobody [
      create-projectproductlink-with my-product [set color red]
      ask projectproductlink-neighbors [ set mon-project lput myself mon-project ]
    ]
  ]
end

to birth-a-product [initial-volume]

hatch-products 1 [ set inter3st ( [ inter3st ] of myself )
                                                    set xcor -10
                                                    set ycor -25 + inter3st
                                                    set size 2
                                                    set color orange
                                                    set shape "box"
                                                    set volume initial-volume
                                                    set age 0
                                                    set mon-project (list (myself))
                                                    set consumption-history
                                                          (n-values 10 [ random count [ current-contributors ] of myself * random 20 ])
                                                    create-projectproductlink-with one-of mon-project [ set color red ]
                                                    set new-products-count new-products-count + 1
                                                  ]
end

to consume-products

  ;; #90s link to products they want to consume

  ask #90s [ if count consumerlink-neighbors < 3 and count products > 0
                   [ let new-products products with [ not member? self [ consumerlink-neighbors ] of myself ]
                     if count new-products > 0 AND ( random-float 1 < chance-90-picks-another-product OR count consumerlink-neighbors = 0 )
                           [ create-consumerlink-with min-one-of new-products [ distance myself ] ]
                   ]
           ]

  ;; #90s actually consume - non-rivalrous so do not deplete them

  ; ask #90s [ set consumption consumption + ( prop-consumed-each-time * ( sum [ volume ] of consumerlink-neighbors ) ) ]

  ; product updates consumption activity

  ask products [ if count my-consumerlinks > 0 and volume != "Infinity"
                       [ set consumption-activity ( ( count my-consumerlinks / mean [ distance myself ] of consumerlink-neighbors ) *
                                                    ( volume / ( mean [ volume ] of products + 1 ) )
                                                  )
                         set consumption-history lput ( ( count my-consumerlinks / mean [ distance myself ] of consumerlink-neighbors ) *
                                                        ( volume / ( mean [ volume ] of products + 1 ) )
                                                      ) consumption-history
                         if length consumption-history = 11 [ set consumption-history but-first consumption-history ]
                       ]
                ]

  ; random breaks in consumerlinks

  ask consumerlinks [ if random-float 1 < chance-consumer-link-breaks [die] ]
end


to entry

  ; 90s enter if see high recent consumption activity

  if ( item 0 community-con-activity-ls ) != 0
        [ if ( mean sublist community-con-activity-ls 8 11 ) > ( mean community-con-activity-ls ) * new-90s-barrier
                      [ create-#90s ( round ( initial-number-90s / 10 )) [ set interest random num-interest-categories
                                                                           set xcor random 8 - 22
                                                                           set ycor -25 + interest
                                                                           set size 1
                                                                           set color yellow
                                                                           set skill (n-of 3 (n-values num-skills [?]))
                                                                           set consumption 0
                                                                           set using-platform? set-using-platform
                                                                           set new-#90s-total new-#90s-total + 1
                                                                         ]
                      ]
         ]

  ; 90s enter by chance

  if random-float 1 < ( 1 - ( 0.5 * new-90s-barrier ) ) [ create-#90s 10 [ set interest random num-interest-categories
                                                                          set xcor random 8 - 22
                                                                          set ycor -25 + interest
                                                                          set size 1
                                                                          set color yellow
                                                                          set skill (n-of 3 (n-values num-skills [?]))
                                                                          set consumption 0
                                                                          set using-platform? set-using-platform
                                                                          set new-#90s-total new-#90s-total + 1
                                                                          set new-#90s-chance new-#90s-chance + 1
                                                                         ]
  ]

  ; 9 enter if see recent jump in consumption

   if (mean sublist community-con-activity-ls 8 11) > (mean community-con-activity-ls) * new-9s-barrier
              [ create-#9s max list 1 round ( initial-number-9s / 10 ) [ set interest random num-interest-categories
                                                              set xcor ( random 6 ) + 19
                                                              set ycor -25 + interest
                                                              set size 1
                                                              set color blue
                                                              set my-time 1 + random 20
                                                              set time my-time
                                                              set skill (n-of 3 (n-values num-skills [?]))
                                                              set using-platform? set-using-platform
                                                              set i-used-featured? FALSE
                                                              set points 0
                                                              set thanks "not received"
                                                              set my-projects (list (nobody))
                                                              set my-tasks tasklink-neighbors
                                                              ;; mentor and then get 3 friends via them
                                                              if count #1s > 0 [ let mentor min-one-of #1s [ distance myself ]
                                                                                 let mentors-friends count [ friendlink-neighbors ] of mentor
                                                                                 create-friendlinks-with n-of ( mentors-friends / 2 )
                                                                                       [ friendlink-neighbors ] of mentor [ set color blue set times-worked-together 1 ]
                                                                                 ]
                                                              set contribution-history-9s (list (0))
                                                              set my-friends friendlink-neighbors
                                                              set new-#9s-total new-#9s-total + 1
                                                              set new-#9-attracted-by-#90s new-#9-attracted-by-#90s + 1
                                                             ]
              ]
end

to exit

  ;; #9s exit if no tasks with their interest for a while and not feeling loved (thanks or points)

  ask #9s [ if reward-mechanism = "none" [ set feel-loved 0 ]

            if reward-mechanism = "'thanks' only" [ if thanks = "not received" [ set feel-loved 0 ]
                                                    if thanks = "received from #9" [ set feel-loved 0.005 ]
                                                    if thanks = "received from #1" [ set feel-loved 0.01 ]  ]

            if reward-mechanism = "'points' only" [ ifelse points > mean [ points ] of #9s [ set feel-loved 0.005 ]
                                                                                           [ set feel-loved 0 ]
                                                  ]

            if reward-mechanism = "both" [ if thanks = "not received" [ set feel-loved 0 ]
                                           if points > median [ points ] of #9s [ set feel-loved 0.005 ]
                                           if thanks = "received from #9" [ set feel-loved 0.005 ]
                                           if thanks = "received from #1" [ set feel-loved 0.01 ]
                                          ]

            if ( count my-tasklinks + count my-lonetasklinks ) = 0 [ set time-with-no-links time-with-no-links + 1 ]
            if not any? t4sks with [ inter3st = [ interest ] of myself ] and
               not any? loneTasks with [ inter3st = [ interest ] of myself ] and random-float 1 < ( chance-9s-exit - feel-loved )
                  [ set #9s-left #9s-left + 1
                    set #9-left-no-interest #9-left-no-interest + 1
                    die
                  ]
          ]

  ;; 9s exit if consumption has dropped - ie., 90s have left,

  ask #9s [ if (( mean sublist community-con-activity-ls 8 11 ) < ( mean sublist community-con-activity-ls 0 8 ))
                and random-float 1 < ( chance-9s-exit - feel-loved )
                         [ set #9s-left #9s-left + 1
                           set #9-left-drop-cons #9-left-drop-cons + 1
                           die
                          ]
            ]

  ;; #90s leave if no product they like with some chance

  ask #90s [ if count my-consumerlinks = 0 [ set time-without-products time-without-products + 1 ]
             if ( not any? products with [ inter3st = [ interest ] of myself ] ) and
                  random-float 1 < chance-90s-exit [ set #90s-left #90s-left + 1
                                                     set #90s-left-no-product #90s-left-no-product + 1
                                                     die
                                                   ]
           ]

  ;; #1s and #9s leave if 'motivation very low' ie., no thanks (or thanks from lower contributor)
  ;; or low points plus some small chance (higher for 9s), or if no reward-mech, just some low chance

  if reward-mechanism = "none"
       [ ask #1s [ if random-float 1 < chance-1-burn-out / 2 [ set #1s-left #1s-left + 1
                                                               set #1-left-burnout #1-left-burnout + 1
                                                               die
                                                             ]
                  ]
       ]

          ask #9s [ if random-float 1 < ( chance-1-burn-out ) [ set #9s-left #9s-left + 1
                                                                set #9-left-burnout #9-left-burnout + 1
                                                                die
                                                              ]
                  ]

  if reward-mechanism = "'thanks' only"
        [ ask #1s [ if thanks = "not received" OR thanks = "received from #9"
                        [ if random-float 1 < chance-1-burn-out [ set #1s-left #1s-left + 1
                                                                  set #1-left-burnout #1-left-burnout + 1
                                                                  die
                                                                ]
                        ]
                  ]

          ask #9s [ if thanks = "not received" and random-float 1 < ( chance-1-burn-out * 5 ) [ set #9s-left #9s-left + 1
                                                                                                set #9-left-burnout #9-left-burnout + 1
                                                                                                die
                                                                                              ]
                  ]

        ]

  if reward-mechanism = "'points' only"
        [ ask #1s [ if points < median [points] of #1s and random-float 1 < chance-1-burn-out [ set #1s-left #1s-left + 1
                                                                                                set #1-left-burnout #1-left-burnout + 1
                                                                                                die
                                                                                              ]
                  ]

          ask #9s [ if points < median [points] of #9s and random-float 1 < ( chance-1-burn-out * 5 ) [ set #9s-left #9s-left + 1
                                                                                                        set #9-left-burnout #9-left-burnout + 1
                                                                                                        die
                                                                                                      ]
                  ]
        ]

  if reward-mechanism = "both"
        [ ask #1s [ if thanks = "not received" OR thanks = "received from #9" OR points < mean [points] of #1s
              [ if random-float 1 < chance-1-burn-out [ set #1s-left #1s-left + 1
                                                        set #1-left-burnout #1-left-burnout + 1
                                                        die
                                                      ]
              ]
                  ]

           ask #9s [ if thanks = "not received" OR points < mean [points] of #9s
                 [ if random-float 1 < ( chance-1-burn-out * 5 ) [ set #9s-left #9s-left + 1
                                                                   set #9-left-burnout #9-left-burnout + 1
                                                                   die
                                                                 ]
                 ]
                   ]
         ]
end

to change-breed

 ; 90 become 9 if they find a task close to their interest - and a very small chance - ie., they find something on the list

 ask #90s [ if random-float 1 < chance-90-find-a-task and ( any? t4sks with [ ( inter3st < [ interest ] of myself + 3 ) and
                                                                              ( inter3st > [ interest ] of myself - 3 ) ] )
                [ let task-i-found min-one-of t4sks [ ( abs ( inter3st - [ interest ] of myself ) )  ]
                  set breed #9s
                  set xcor ( random 6 ) + 19
                  set ycor -25 + interest
                  set size 1
                  set color blue
                  set my-time 1 + random 20
                  set time my-time
                  set points 0
                  set i-used-featured? FALSE
                  set thanks "not received"
                  create-tasklink-with task-i-found [set color 3]
                  set my-tasks tasklink-neighbors
                  let new-project projects with [ member? task-i-found [ my-tasks-projects ] of self ]
                  set my-projects (list (new-project))
                  set contribution-history-9s (list (0))
                  ask my-consumerlinks [die]
                  set my-friends friendlink-neighbors
                  set #90-to-#9-count #90-to-#9-count + 1
                ]
            ]

 ;; 9 become 1 if their contributions increase plus some chance
 ask #9s [ if length contribution-history-9s > 3 [ let history-difference
                                                 mean sublist contribution-history-9s
                                                              (length contribution-history-9s - 3)
                                                              (length contribution-history-9s )
                                                 -
                                                 mean contribution-history-9s
           if ( history-difference > 0 ) and ( random-float 1 < chance-9-become-1  )
                 [ set breed #1s
                   set xcor 18
                   set ycor -25 + interest
                   set size 1.5
                   set color red
                   set my-time 1 + random 40
                   set time my-time
                   set contribution-history-1s [ contribution-history-9s ] of self
                   set my-total-contribution-1s [ my-total-contribution-9s ] of self
                   set my-projects-1s [my-projects] of self
                   set my-tasks-1s [ my-tasks ] of self
                   set my-lone-tasks-1s [ my-lone-tasks ] of self
                   set #9-to-#1-count #9-to-#1-count + 1
                 ]                               ]
          ]

 ; #1s become #9s if recent activity low and feel unloved plus a probability..

 ; could add- 1s also want to feel supported by communuty - thanks a proxy for this?, also number of friends,

 ask #1s [ if length contribution-history-1s > 3 [ let history-difference
                                                   mean sublist contribution-history-1s
                                                                (length contribution-history-1s - 3)
                                                                (length contribution-history-1s )
                                                   -
                                                   mean contribution-history-1s
           if ( history-difference < 0 ) and ( random-float 1 < chance-1-become-9 - feel-loved )
                 [ set breed #9s
                   set xcor ( random 6 ) + 19
                   set ycor -25 + interest
                   set size 1
                   set color blue
                   set my-time 1 + random 20
                   set i-used-featured? FALSE
                   set time my-time
                   set my-projects [my-projects-1s] of self
                   set my-tasks [ my-tasks-1s ] of self
                   set my-lone-tasks [ my-lone-tasks-1s ] of self
                   set contribution-history-9s (list (0))
                   set my-total-contribution-9s 0
                   set #1-to-#9-count #1-to-#9-count + 1
                  ]                                 ]
          ]
end


;; Update Positions and Calculations ;; Update Positions and Calculations ;; Update Positions and Calculations ;; Update Positions and Calculations
;; Update Positions and Calculations ;; Update Positions and Calculations ;; Update Positions and Calculations ;; Update Positions and Calculations
;; Update Positions and Calculations ;; Update Positions and Calculations ;; Update Positions and Calculations ;; Update Positions and Calculations
;; Update Positions and Calculations ;; Update Positions and Calculations ;; Update Positions and Calculations ;; Update Positions and Calculations

to like-project

  let projects-i-like projects with [ inter3st < [ interest ] of myself + 3 and
                                      inter3st > [ interest ] of myself - 3
                                    ]
  if any? projects-i-like and random-float 1 < 0.1 [ ask projects-i-like [ set likes likes + 1 ] ]

end

to update-project-position

;; different rules for when platform is on or off...

if platform-features = TRUE [

  ; this is akin to how the list of projects in the platform is ordered
  ; up votes (90,9,1 give 'likes'), crowd-funding, and acitivity,
  ; important that change in likes and activity is relative to itself

  ask projects [

  ; activity increases in recent prod history will push up position

   if length production-history > 3 and mean production-history > 0
         [ let history-difference mean sublist production-history
                                  (length production-history - 3)
                                  (length production-history )
                                  -
                                  mean production-history
           if random-float 1 < 0.1 [ set xcor max list ( xcor + history-difference / ( mean production-history * 10) ) ( -4 ) ]
         ]
               ]


  ; upvotes input
  ; with a probablity 1,9,90 give votes to projects with similar interest to theirs (but dont worry about skill etc)
  ; this is then used to push up position if recent history if likes is up

  ask #1s [like-project]

  ask #9s [like-project]

  ask #90s [like-project]

  ask projects [ set likes-history lput likes likes-history
                 if length likes-history = 11 [ set likes-history but-first likes-history ]
                 if length likes-history > 3 and mean likes-history > 0
                       [ let history-difference mean sublist likes-history
                                                (length likes-history - 3)
                                                (length likes-history )
                                                -
                                                mean likes-history
                         if random-float 1 < 0.1 [ set xcor max list ( xcor + history-difference / mean likes-history * 2 ) ( -4 ) ]
                       ]
  ; crowd-funding input - i.e, if few tasks left - get pushed up the list
                 if num-tasks < 3 [ set xcor xcor + 1 ]
                ]
                          ] ; closing bracket for if platform-features TRUE



  if platform-features = FALSE and community-type = "online" [

    ; online projects still get some sorting by number of people working on them
    ask projects [ ifelse count current-contributors > mean [count current-contributors] of projects [ set xcor xcor + 1 ]
                                                                                                     [ set xcor xcor - 1 ]
                 ]
                                                             ]

  if platform-features = FALSE and community-type = "offline" [
    ; no movement - position meaningless as projects found randomly
    ]

  ; regulate position

  ask projects [ if xcor < -4 [ set xcor -4 ]
                 if xcor > 17 [ set xcor 17 ]
                 if reward-mechanism-2 = "reputation" [ set label round sum [ points ] of current-contributors ]
                 if reward-mechanism-2 = "bounties" [ set label round total-bounty ]

               ]

  ; tasks need to go with their project

  if platform-features = TRUE OR community-type = "online" [ ask t4sks [ set xcor [ xcor ] of my-project
                                                                         set ycor [ ycor ] of my-project
                                                                         set heading random 360
                                                                         fd 1
                                                                       ]
                                                            ]

  ; lone tasks get closer if popular

  ask loneTasks [ ifelse count my-lonetasklinks > median [ count my-lonetasklinks ] of loneTasks
                      [ set xcor xcor + 0.1 ][ set xcor xcor - 0.1 ]
                  if xcor < -4 [ set xcor -4 ]
                  if xcor > 17 [ set xcor 17 ]
                ]
end

to update-product-position

  ; product should moves towards users, ie.. is more appealing, when its consmuption gorws relative to itself,
  ; and when its volume grows relative to others

  ask products [ if length consumption-history > 3 and mean consumption-history > 0
                     [ let history-difference mean sublist consumption-history
                                              (length consumption-history - 3)
                                              (length consumption-history )
                                              -
                                              mean consumption-history
                       if random-float 1 < 0.1 [ set xcor max list ( xcor - history-difference / mean consumption-history * 10 ) ( -14 ) ]
                     ]
                  let mean-volume mean [volume] of products
                  ifelse volume > mean-volume [ set xcor xcor - 0.1 ]
                                              [ set xcor xcor + 0.1 ]
                  if volume > ( mean-volume * 1.5 ) [ set xcor xcor - 0.2 ]
                  if volume < ( mean-volume * 0.5 ) [ set xcor xcor + 0.2 ]
                  ;; regulate position
                  if xcor < -14 [ set xcor -14 ]
                  if xcor > -6 [ set xcor -6 ]
                ]
end

to update-90s-and-9s-and-1s-positions

  ;; 9s and 90s get pulled close to their link-neighbours or similar
  ;; made only every 5 weeks to speed up simulations - using links when lots was slowing it down

  if ticks mod 20 = 0 [

  ask #9s [ if count my-friendlinks > 0
    [ let mean-friend-position mean [ycor] of friendlink-neighbors
      if mean-friend-position > ycor AND random-float 1 > 0.5 [ set ycor ycor + 1 ]
      if mean-friend-position < ycor AND random-float 1 > 0.5 [ set ycor ycor - 1 ]
    ]     ]

  ask #90s [ if count my-consumerlinks > 0
    [ let myconsumerlinkneighborslinkneighbors turtle-set [ consumerlink-neighbors ] of consumerlink-neighbors
      let average-position-of-similar-consumers mean [ycor] of myconsumerlinkneighborslinkneighbors
      if average-position-of-similar-consumers > ycor AND random-float 1 > 0.5 [ set ycor ycor + 1 ]
      if average-position-of-similar-consumers < ycor AND random-float 1 > 0.5 [ set ycor ycor - 1 ]
    ]      ]

  ; 1s move the same as 9s, but are more stubborn - less chance

  ask #1s [ if count my-friendlinks > 0
    [ let mean-friend-position mean [ycor] of friendlink-neighbors
      if mean-friend-position > ycor AND random-float 1 > 0.8 [ set ycor ycor + 1 ]
      if mean-friend-position < ycor AND random-float 1 > 0.8 [ set ycor ycor - 1 ]
    ]     ]

  ]
end

to update-community-activity

  ; recording and updating consumption and production activity

  let lonetasks-activity sum [ count my-lonetasklinks ] of loneTasks
  let total-prod-activity ( sum [production-activity] of projects + lonetasks-activity )
  let total-cons-activity sum [consumption-activity] of products

  set community-prod-activity-ls ( lput total-prod-activity (but-first community-prod-activity-ls) )
  set community-con-activity-ls ( lput total-cons-activity (but-first community-con-activity-ls) )

end

to products-die

  ; products can disappear if they have no consumers plus a small chance
  ask products [ if count my-consumerlinks = 0 [ if random-float 1 < chance-products-die
                                                     [ set product-had-no-consumer-so-left product-had-no-consumer-so-left + 1
                                                       ask loneTasks with [ my-product-L = myself ] [die]
                                                       die
                                                     ]
                                                ]
                ]

  ;; products die/compete if there should be only one (ie., one product community) and there are two or more!
  ;; they use total consumption history - when a new product appears it is given a consumption history based on its project

  if number-of-products = "one" and count products > 1 and random-float 1 < 0.5
       [ ask min-one-of products [ sum consumption-history ] [ set products-out-competed products-out-competed + 1
                                                               ask loneTasks with [ my-product-L = myself ] [die]
                                                               die
                                                              ]
       ]
end

to all-age
  ;; turtles and links age
  ask #1s [ set time-in-community time-in-community + 1 ]
  ask #9s [ set time-in-community time-in-community + 1 ]
  ask #90s [ set time-in-community time-in-community + 1 ]
  ask t4sks [ set age age + 1 ]
  ask loneTasks [ set age age + 1 ]
  ask products [ set age age + 1 ]
  ask projects [ set age age + 1 ]
  ask tasklinks [ set ageTL ageTL + 1]
  ask consumerlinks [ set ageCL ageCL + 1]
  ask friendlinks [ set ageFL ageFL + 1]
end

to t4sk-set-typ3
  ; new tasks set their skill type
  if count t4sks with [ my-project = [ my-project] of myself ] = 0 [ set typ3 random (num-skills - 1) ]
  if count t4sks with [ my-project = [ my-project] of myself ] > 0
       [ ifelse random-float 1 > 0.5 [ set typ3 [ typ3 ] of one-of t4sks with [ my-project = [ my-project] of myself ] ]
                                     [ set typ3 random  (num-skills - 1) ] ]
end
@#$#@#$#@
GRAPHICS-WINDOW
322
227
711
637
25
25
7.4314
1
10
1
1
1
0
0
0
1
-25
25
-25
25
0
0
1
ticks
30.0

BUTTON
343
22
443
71
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
445
22
545
71
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
35
480
275
513
initial-number-1s
initial-number-1s
0
100
5
1
1
NIL
HORIZONTAL

SLIDER
35
514
274
547
initial-number-9s
initial-number-9s
0
1000
45
1
1
NIL
HORIZONTAL

SLIDER
34
613
274
646
initial-tasks
initial-tasks
0
100
5
1
1
NIL
HORIZONTAL

PLOT
864
62
1310
350
Size of Community
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"#1s" 1.0 0 -2674135 true "" "plot count #1s"
"#9s" 1.0 0 -13345367 true "" "plot count #9s"
"#90s" 1.0 0 -1184463 true "" "plot count #90s"

PLOT
2848
1098
3093
1273
Entry&Exit Per Tick
NIL
NIL
0.0
10.0
0.0
50.0
true
true
"" ""
PENS
"New#9s" 1.0 0 -6759204 true "" "if ticks > 0 [ plot new-#9s-total / ticks ]"
"New#90s" 1.0 0 -8330359 true "" "if ticks > 0 [ plot new-#90s-total / ticks]"
"Exit#90s" 1.0 0 -15040220 true "" "if ticks > 0 [ plot #90s-left / ticks]"
"Exit#9s" 1.0 0 -14730904 true "" "if ticks > 0 [ plot #9s-left / ticks]"

SLIDER
1164
929
1436
962
prop-of-projects-reward-subjective
prop-of-projects-reward-subjective
0
1
1
0.1
1
NIL
HORIZONTAL

PLOT
2481
1236
2641
1356
Tasks' TimeReq
NIL
NIL
0.0
1500.0
0.0
10.0
true
false
"" ""
PENS
"default" 100.0 1 -13840069 true "" "histogram [time-required] of t4sks"

PLOT
1633
1221
1793
1341
#1s' Points
NIL
NIL
0.0
1000.0
0.0
10.0
true
false
"" ""
PENS
"default" 10.0 1 -2674135 true "" "histogram [ points ] of #1s"

PLOT
2108
1246
2268
1366
#9s' Points
NIL
NIL
0.0
100.0
0.0
5.0
true
false
"" ""
PENS
"default" 1.0 1 -13345367 true "" "histogram [ points ] of #9s"

PLOT
2481
1101
2641
1221
Projects' RewardLevel
NIL
NIL
0.0
100.0
0.0
10.0
true
false
"" ""
PENS
"default" 5.0 1 -13840069 true "" "histogram [reward-level] of projects"

PLOT
2034
251
2532
397
Tasks&Products
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Tasks" 1.0 0 -10899396 true "" "plot count t4sks"
"Prod" 1.0 0 -955883 true "" "plot count products"
"Projects" 1.0 0 -15575016 true "" "plot count projects"
"LoneTasks" 1.0 0 -1184463 true "" "plot count loneTasks"

BUTTON
547
22
645
71
go once
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
35
546
275
579
initial-number-90s
initial-number-90s
0
5000
450
50
1
NIL
HORIZONTAL

PLOT
1633
1101
1793
1221
#1s' Time
NIL
NIL
-50.0
40.0
0.0
10.0
true
false
"" ""
PENS
"default" 5.0 1 -2674135 true "" "histogram [ time ] of #1s"

PLOT
1633
1358
1793
1478
#9s' Time
NIL
NIL
-30.0
20.0
0.0
10.0
true
false
"" ""
PENS
"default" 5.0 1 -13345367 true "" "histogram [time] of #9s"

PLOT
3207
261
3445
381
Overtime
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"#1s" 1.0 0 -2674135 true "" "plot count #1s with [ time < 0 ]"
"#9s" 1.0 0 -13345367 true "" "plot count #9s with [ time < 0 ]"

PLOT
1788
1516
1948
1636
#90s' Consumption
NIL
NIL
0.0
25.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 1 -13840069 true "" "histogram [consumption] of #90s"

SLIDER
640
2009
913
2042
prop-consumed-each-time
prop-consumed-each-time
0
1
0.001
0.001
1
NIL
HORIZONTAL

SLIDER
1163
889
1436
922
num-interest-categories
num-interest-categories
0
50
50
1
1
NIL
HORIZONTAL

PLOT
3207
101
3445
221
Ave No. Links
NIL
NIL
0.0
10.0
0.0
2.0
true
true
"" ""
PENS
"#1s" 1.0 0 -2674135 true "" "if count #1s > 0 [ plot mean [ count link-neighbors] of #1s ]"
"#9s" 1.0 0 -13345367 true "" "if count #9s > 0 [ plot mean [ count link-neighbors ] of #9s ]"
"#90s" 1.0 0 -13840069 true "" "if count #90s > 0 [ plot mean [ count link-neighbors ] of #90s ]"

BUTTON
344
75
646
125
Obey Power Law (based on 1s)
set initial-number-9s initial-number-1s * 9\nset initial-number-90s initial-number-1s * 90\nset initial-tasks initial-number-1s\nset initial-products initial-number-1s
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
2387
157
2457
202
#90s Left
#90s-left
0
1
11

MONITOR
2251
157
2316
202
#9s Left
#9s-left
17
1
11

MONITOR
2187
157
2252
202
New #9s
new-#9s-total
0
1
11

MONITOR
2321
157
2386
202
New #90s
new-#90s-total
0
1
11

MONITOR
1834
247
1914
292
NIL
count #1s
0
1
11

MONITOR
1834
291
1914
336
NIL
count #9s
0
1
11

MONITOR
1834
337
1914
382
NIL
count #90s
0
1
11

MONITOR
1871
147
1963
192
NIL
count t4sks
0
1
11

MONITOR
1871
194
1964
239
NIL
count products
0
1
11

PLOT
2963
1301
3208
1451
ProdCons&TasksCompl
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Prod" 1.0 0 -955883 true "" "plot products-consumed"
"Tasks" 1.0 0 -13840069 true "" "plot tasks-completed"

PLOT
2963
1451
3208
1601
NewProd&Tasks
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Prod" 1.0 0 -955883 true "" "plot new-products-count"
"Tasks" 1.0 0 -13840069 true "" "plot new-tasks-count"
"Projects" 1.0 0 -15575016 true "" "plot count-new-projects"

MONITOR
2863
1361
2963
1406
NIL
products-consumed
0
1
11

MONITOR
2863
1406
2963
1451
NIL
tasks-completed
0
1
11

MONITOR
2858
1556
2963
1601
NIL
new-tasks-count
0
1
11

MONITOR
2858
1511
2963
1556
NIL
new-products-count
0
1
11

PLOT
1793
1101
1953
1221
#1s' Skill
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 1 -2674135 true "" "histogram [ skill ] of #1s"

PLOT
1953
1101
2113
1221
#1s' Interest
NIL
NIL
0.0
50.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 1 -2674135 true "" "histogram [interest] of #1s"

PLOT
1793
1358
1953
1478
#9s' Skill
NIL
NIL
0.0
100.0
0.0
10.0
true
false
"" ""
PENS
"default" 10.0 1 -13345367 true "" "histogram [skill] of #9s"

PLOT
1953
1358
2113
1478
#9s' Interest
NIL
NIL
0.0
50.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 1 -13345367 true "" "histogram [interest] of #9s"

PLOT
2113
1101
2273
1221
#1s' Time in Comm
NIL
NIL
0.0
500.0
0.0
10.0
true
false
"" ""
PENS
"default" 10.0 1 -2674135 true "" "histogram [time-in-community] of #1s"

PLOT
2113
1361
2273
1481
#9s' Time in Comm
NIL
NIL
0.0
250.0
0.0
10.0
true
false
"" ""
PENS
"default" 10.0 1 -13345367 true "" "histogram [time-in-community] of #9s"

PLOT
1628
1516
1788
1636
#90s' Interest
NIL
NIL
0.0
50.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 1 -13840069 true "" "histogram [interest] of #90s"

PLOT
1948
1516
2108
1636
#90s' Time in Comm
NIL
NIL
0.0
50.0
0.0
10.0
true
false
"" ""
PENS
"default" 5.0 1 -13840069 true "" "histogram [time-in-community] of #90s"

PLOT
2638
1356
2798
1476
Tasks' Interest
NIL
NIL
0.0
50.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 1 -13840069 true "" "histogram [inter3st] of t4sks"

PLOT
2321
1101
2481
1221
Projects' RewardType
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Group" 1.0 0 -5825686 true "" "plot count projects with [reward-type = \"subjective\"]"
"Obj" 1.0 0 -7500403 true "" "plot count projects with [reward-type = \"objective\" ]"

PLOT
2321
1356
2481
1476
Tasks' Modularity
NIL
NIL
0.0
21.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 1 -13840069 true "" "histogram [modularity] of t4sks"

PLOT
2481
1356
2641
1476
Tasks' Age
NIL
NIL
0.0
2000.0
0.0
10.0
true
false
"" ""
PENS
"default" 100.0 1 -13840069 true "" "histogram [age] of t4sks"

PLOT
2321
1491
2481
1611
Prod's Interest
NIL
NIL
0.0
50.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 1 -955883 true "" "histogram [inter3st] of products"

PLOT
2481
1493
2641
1613
Prod's Age
NIL
NIL
0.0
200.0
0.0
10.0
true
false
"" ""
PENS
"default" 10.0 1 -955883 true "" "histogram [age] of products"

MONITOR
1914
247
1994
292
% #1s
( count #1s / ( count #1s + count #9s + count #90s )) * 100
1
1
11

MONITOR
1914
291
1993
336
% #9s
( count #9s / ( count #1s + count #9s + count #90s )) * 100
1
1
11

MONITOR
1914
337
1993
382
% #90s
( count #90s / ( count #1s + count #9s + count #90s )) * 100
1
1
11

PLOT
3207
517
3451
654
Long time Members
NIL
NIL
0.0
10.0
0.0
0.5
true
true
"" ""
PENS
"6 months" 1.0 0 -1264960 true "" "plot (( count #1s with [ time-in-community > 26 ] ) + ( count #9s with [ time-in-community > 26 ]) + ( count #90s with [ time-in-community > 26 ] )) / ( count #1s + count #9s + count #90s )"
"1 year" 1.0 0 -5825686 true "" "plot (( count #1s with [ time-in-community > 52 ] ) + ( count #9s with [ time-in-community > 52 ]) + ( count #90s with [ time-in-community > 52 ] )) / ( count #1s + count #9s + count #90s )"
"2 years" 1.0 0 -8431303 true "" "plot (( count #1s with [ time-in-community > 104 ] ) + ( count #9s with [ time-in-community > 104 ]) + ( count #90s with [ time-in-community > 104 ] )) / ( count #1s + count #9s + count #90s )"

PLOT
2834
254
3089
413
Why #9s Left
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"no interest" 1.0 0 -16777216 true "" "plot #9-left-no-interest"
"Became #1" 1.0 0 -10899396 true "" "plot #9-to-#1-count"
"Cons Dop" 1.0 0 -7500403 true "" "plot #9-left-drop-cons"
"Burnout" 1.0 0 -955883 true "" "plot #9-left-burnout"

PLOT
2834
101
3089
251
Why #1s Left
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"BurntOut" 1.0 0 -16777216 true "" "plot #1-left-burnout"
"Became #9s" 1.0 0 -13345367 true "" "plot #1-to-#9-count"

PLOT
2834
574
3089
729
Why #9s and #90s Enter?
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"#9s See #90s" 1.0 0 -955883 true "" "plot new-#9-attracted-by-#90s"
"#90s See Consumption " 1.0 0 -7500403 true "" "plot new-#90s-total"
"#90s by chance" 1.0 0 -2674135 true "" "plot new-#90s-chance"

TEXTBOX
45
845
580
890
---ADVANCED PARAMETERS SET USING DATA / PLAUSABILITY---
14
0.0
1

TEXTBOX
33
39
303
57
---INPUT: PLATFORM ADOPTION---
14
0.0
1

TEXTBOX
38
364
275
382
---INPUT: COMMUNITY TYPE---
14
0.0
1

TEXTBOX
864
20
1327
40
--------------------MAIN OUTPUTS-------------------
14
0.0
1

TEXTBOX
2844
61
3079
81
---OUTPUT: WHY EXIT/ENTER---
14
0.0
1

TEXTBOX
3197
57
3470
92
---OUTPUT: LINKS-STRUCTURE---
14
0.0
1

SLIDER
34
579
274
612
initial-projects
initial-projects
0
50
15
5
1
NIL
HORIZONTAL

TEXTBOX
724
224
746
914
/\\\n |\n |\n |\n |\n |\n |\n i \n n\n t\n e\n r\n e\n s\n t\n |\n |\n |\n |\n |\n |\n |\n\\/\n
14
0.0
1

TEXTBOX
344
172
723
220
                 Products                                             \n                 <--More                      Projects\n#90s          Appealing-          ---Higher in list--->       #1s   #9s
12
0.0
1

SLIDER
642
1930
915
1963
chance-of-finding-new-task
chance-of-finding-new-task
0
1
0.001
0.001
1
NIL
HORIZONTAL

PLOT
2638
1101
2798
1222
HistoProjectsNumTasks
NIL
NIL
0.0
25.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 1 -13840069 true "" "histogram [num-tasks] of projects"

MONITOR
2858
1471
2963
1516
NIL
count-new-projects
0
1
11

TEXTBOX
1923
1058
2428
1077
-------UNINTERESTING OUTPUTS & DIAGNOSTICS----------
15
0.0
1

PLOT
2034
394
2260
515
Count Links
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Task" 1.0 0 -7500403 true "" "plot count tasklinks"
"Friend" 1.0 0 -13345367 true "" "plot count friendlinks"
"Cons" 1.0 0 -13840069 true "" "plot count consumerlinks"

MONITOR
1871
104
1964
149
NIL
count projects
17
1
11

PLOT
2257
394
2483
514
AgesOfLinks
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Friend" 1.0 0 -13345367 true "" "if count friendlinks > 0 [ plot mean [ageFL] of friendlinks ]"
"Consumer" 1.0 0 -13840069 true "" "if count consumerlinks > 0 [ plot mean [ageCL] of consumerlinks ]"
"Task" 1.0 0 -7500403 true "" "if count tasklinks > 0 [ plot mean [ageTL] of tasklinks ]"

CHOOSER
36
253
276
298
reward-mechanism
reward-mechanism
"none" "'thanks' only" "'points' only" "both"
3

PLOT
2494
104
2834
264
Average Contributions Made
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"No. Contributions 1s" 1.0 0 -2139308 true "" "if count #1s > 0 [ plot contributions-made-by-1s / count #1s ]"
"Time Contributed 1s (hrs)" 1.0 0 -8053223 true "" "if count #1s > 0 [ plot time-contributed-by-1s / count #1s ]"
"No. Contributions 9s" 1.0 0 -8275240 true "" "if count #9s > 0 [ plot contributions-made-by-9s / count #9s ]"
"Time Contributed 9s (hrs)" 1.0 0 -14730904 true "" "if count #9s > 0 [ plot time-contributed-by-9s / count #9s ]"

CHOOSER
35
389
277
434
community-type
community-type
"online" "offline"
0

CHOOSER
35
435
275
480
number-of-products
number-of-products
"one" "a few" "many"
1

PLOT
3204
734
3459
884
Dropped Projects&Tasks
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"1 task" 1.0 0 -5298144 true "" "plot #1-dropped-a-task"
"9 task" 1.0 0 -14070903 true "" "plot #9-dropped-a-task"
"1 project" 1.0 0 -1069655 true "" "plot #1-dropped-a-project"
"9 project" 1.0 0 -5325092 true "" "plot #9-dropped-a-project"

PLOT
3214
391
3455
512
Projects Finished & Died
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Finshed" 1.0 0 -955883 true "" "plot projects-finished"
"Died" 1.0 0 -7500403 true "" "plot projects-died"
"loneTasks" 1.0 0 -1184463 true "" "plot loneTasksFinished"

SWITCH
36
69
276
102
platform-features
platform-features
0
1
-1000

PLOT
2494
264
2834
384
ChangeRole
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"#90->#9" 1.0 0 -16777216 true "" "plot #90-to-#9-count"
"#9->#1" 1.0 0 -7500403 true "" "plot #9-to-#1-count"
"#1->#9" 1.0 0 -2674135 true "" "plot #1-to-#9-count"
"#90 featuredNeed" 1.0 0 -955883 true "" "plot #90-used-featured-needs"

PLOT
2494
384
2834
569
ContributionsHisto
NIL
NIL
0.0
200.0
0.0
10.0
false
true
"" ""
PENS
"#9s" 1.0 1 -13791810 true "" "histogram [ my-total-contribution-9s ] of #9s"
"#1s" 1.0 1 -2139308 true "" "histogram [ my-total-contribution-1s ] of #1s"

PLOT
2834
421
3089
571
Why #90s Leave?
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"No product 4 them" 1.0 0 -16777216 true "" "plot #90s-left-no-product"

MONITOR
2121
157
2183
202
#1s Left
#1s-left
0
1
11

SLIDER
36
103
276
136
proportion-using-platform
proportion-using-platform
0
1
0.5
0.1
1
NIL
HORIZONTAL

MONITOR
2064
157
2126
202
New #1s
#9-to-#1-count
0
1
11

SLIDER
639
2080
909
2113
new-90s-barrier
new-90s-barrier
0
5
1.5
0.25
1
NIL
HORIZONTAL

MONITOR
2387
204
2457
249
#90->#9
#90-to-#9-count
0
1
11

MONITOR
2254
204
2319
249
#9->#1
#9-to-#1-count
0
1
11

MONITOR
2124
201
2187
246
#1->#9
#1-to-#9-count
0
1
11

PLOT
2827
731
3087
881
PointsHisto
NIL
NIL
0.0
200.0
0.0
10.0
true
true
"" ""
PENS
"#9s" 1.0 1 -13345367 true "" "histogram [points] of #9s"
"#1s" 1.0 1 -2674135 true "" "histogram [points] of #1s"

MONITOR
3207
657
3369
702
NIL
products-out-competed
0
1
11

PLOT
2494
567
2834
832
Thanks Counts
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"#9s Thanks from #9s" 1.0 0 -6759204 true "" "plot count #9s with [ thanks = \"received from #9\" ]"
"#9s Thanks from #1s" 1.0 0 -14070903 true "" "plot count #9s with [ thanks = \"received from #1\" ]"
"#1s Thanks from #9s" 1.0 0 -865067 true "" "plot count #1s with [ thanks = \"received from #9\" ]"
"#1s Thanks from #1s" 1.0 0 -5298144 true "" "plot count #1s with [ thanks = \"received from #1\" ]"

PLOT
2034
514
2484
634
Mean Consumption History of Products
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "if count products > 0 [ plot mean [sum consumption-history] of products ]"

PLOT
2318
1226
2478
1346
Histo Current Contributors
NIL
NIL
0.0
30.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 1 -16777216 true "" "histogram [ count current-contributors]  of projects"

PLOT
1948
1246
2108
1366
#9s Time with No Links
NIL
NIL
0.0
100.0
0.0
10.0
true
false
"" ""
PENS
"default" 5.0 1 -16777216 true "" "histogram [ time-with-no-links] of #9s"

SLIDER
638
1882
913
1915
mean-time-required
mean-time-required
10
1000
200
10
1
NIL
HORIZONTAL

SLIDER
638
1845
913
1878
max-modularity
max-modularity
1
80
1
1
1
NIL
HORIZONTAL

SLIDER
635
895
910
928
prob-9-decides-to-join-project
prob-9-decides-to-join-project
0.1
0.6
0.3
0.1
1
NIL
HORIZONTAL

SLIDER
635
939
912
972
prob-9-contributes-to-friends-task
prob-9-contributes-to-friends-task
0
1
0.5
0.05
1
NIL
HORIZONTAL

SLIDER
635
974
915
1007
prob-9-contributes-to-none-friend-task
prob-9-contributes-to-none-friend-task
0
1
0.05
0.05
1
NIL
HORIZONTAL

SLIDER
637
1013
917
1046
prob-1-drop-lonely-project
prob-1-drop-lonely-project
0
1
0.01
0.01
1
NIL
HORIZONTAL

SLIDER
637
1048
917
1081
prob-9-drop-a-lonely-or-no-tasks-project
prob-9-drop-a-lonely-or-no-tasks-project
0
1
0.05
0.05
1
NIL
HORIZONTAL

SLIDER
635
1410
910
1443
chance-forget-a-friend
chance-forget-a-friend
0
1
0.7
0.01
1
NIL
HORIZONTAL

SLIDER
635
1449
910
1482
chance-forget-thanks
chance-forget-thanks
0
1
0.1
0.05
1
NIL
HORIZONTAL

SLIDER
635
1494
915
1527
chance-unpopular-project-dies
chance-unpopular-project-dies
0
1
0.5
0.05
1
NIL
HORIZONTAL

SLIDER
635
1549
950
1582
chance-contributor-proposes-a-new-project
chance-contributor-proposes-a-new-project
0
1
0.001
0.0005
1
NIL
HORIZONTAL

SLIDER
635
1584
920
1617
chance-a-project-hatches-a-project
chance-a-project-hatches-a-project
0
1
0.03
0.005
1
NIL
HORIZONTAL

SLIDER
635
1619
920
1652
chance-90-picks-another-product
chance-90-picks-another-product
0
1
0.01
0.005
1
NIL
HORIZONTAL

SLIDER
634
1682
919
1715
chance-consumer-link-breaks
chance-consumer-link-breaks
0
1
0.345
0.005
1
NIL
HORIZONTAL

SLIDER
639
2048
909
2081
new-9s-barrier
new-9s-barrier
0.5
3
1.5
0.1
1
NIL
HORIZONTAL

SLIDER
639
2118
909
2151
chance-9s-exit
chance-9s-exit
0
1
0.01
0.005
1
NIL
HORIZONTAL

SLIDER
639
2150
909
2183
chance-90s-exit
chance-90s-exit
0
1
0.035
0.005
1
NIL
HORIZONTAL

SLIDER
639
2188
909
2221
chance-1-burn-out
chance-1-burn-out
0
1
0.001
0.0005
1
NIL
HORIZONTAL

SLIDER
637
1765
862
1798
chance-9-become-1
chance-9-become-1
0
1
0.005
0.005
1
NIL
HORIZONTAL

SLIDER
637
1802
867
1835
chance-1-become-9
chance-1-become-9
0
1
0.005
0.005
1
NIL
HORIZONTAL

SLIDER
640
1973
915
2006
chance-products-die
chance-products-die
0
1
0.1
0.05
1
NIL
HORIZONTAL

TEXTBOX
1470
897
1637
917
keep at 50
11
0.0
1

TEXTBOX
1474
939
1641
968
something to investiagte later perhaps
11
0.0
1

TEXTBOX
939
898
1106
927
seems to have little effect - leave at 0.5
11
0.0
1

TEXTBOX
933
963
1100
983
these two, to be investigated
11
0.0
1

TEXTBOX
934
1035
1101
1064
these two also to be investigated
11
0.0
1

TEXTBOX
929
1450
1096
1470
to be investigated
11
0.0
1

TEXTBOX
937
1529
1104
1549
to be investigated
11
0.0
1

TEXTBOX
929
1609
1096
1629
to be investigated
11
0.0
1

TEXTBOX
937
1692
1104
1712
to be investigated
11
0.0
1

TEXTBOX
877
1804
1302
1831
should be kept higher than 0.01 otherwise 1s can grow in number, 0.1 seems ok - stops 1s from ever spiralling away
11
0.0
1

TEXTBOX
874
1764
1202
1794
0.1 seems to allow 1s to gorw high, 0.01 keeps 1s very low, perhaps in between is good - 0.4?
11
0.0
1

TEXTBOX
930
1869
1283
1907
to be investigated - mean time required - intuitivekly seems to need to be over 200 for projects not too just all disappear
11
0.0
1

TEXTBOX
942
1994
1109
2014
all 3 to be investigated
11
0.0
1

TEXTBOX
927
2055
1340
2157
new9s barrier - should be between 0.5 and 1.5, nearer 1.5\n\nnew90s barrier - circa 1.5 seems good, 3 and no growth, 0.75 and never no growth
11
0.0
1

PLOT
3293
1133
3453
1253
histogramTimesWorkedTogether
NIL
NIL
0.0
100.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 1 -16777216 true "" "histogram [ times-worked-together ] of friendlinks"

PLOT
3298
1258
3498
1408
friendLinks
NIL
NIL
0.0
100.0
0.0
10.0
true
true
"" ""
PENS
"#9s" 1.0 1 -13791810 true "" "histogram [count friendlink-neighbors] of #9s"
"#1s" 1.0 1 -2674135 true "" "histogram [count friendlink-neighbors] of #1s"

SLIDER
639
2227
909
2260
chance-new-loneTask
chance-new-loneTask
0
1
0.7
0.05
1
NIL
HORIZONTAL

SLIDER
634
1719
919
1752
chance-90-find-a-task
chance-90-find-a-task
0
1
0.005
0.01
1
NIL
HORIZONTAL

SLIDER
638
1290
918
1323
prop-of-projects-initially-private
prop-of-projects-initially-private
0
1
0
0.05
1
NIL
HORIZONTAL

SLIDER
36
136
276
169
proportion-onplatform-projects
proportion-onplatform-projects
0
1
0.55
0.05
1
NIL
HORIZONTAL

TEXTBOX
33
192
293
223
---INPUT: FEATURE SCENARIOS---
14
0.0
1

SWITCH
36
219
276
252
featured-needs?
featured-needs?
0
1
-1000

CHOOSER
36
298
278
343
reward-mechanism-2
reward-mechanism-2
"baseline-both" "reputation" "bounties"
1

SLIDER
638
1087
916
1120
prob-9-finds-featured-need
prob-9-finds-featured-need
0
1
0.05
0.05
1
NIL
HORIZONTAL

TEXTBOX
667
848
1054
881
---ADVANCED PARAMETERS TO BE CALIBRATED---
14
0.0
1

SLIDER
638
1127
918
1160
prob-project-advertises-a-task
prob-project-advertises-a-task
0
1
0.05
0.05
1
NIL
HORIZONTAL

PLOT
2034
634
2484
784
Featured Needs
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"% of tasks features" 1.0 0 -13840069 true "" "if count t4sks > 0 [ plot ( ( count t4sks with [ featured? = TRUE ] ) / ( count t4sks ) ) * 100 ]"
"% of current #9s ever using featured feature" 1.0 0 -13345367 true "" "if count #9s > 0 [ plot ( ( count #9s with [ i-used-featured? = TRUE ] ) / ( count #9s ) ) * 100 ]"

PLOT
2034
787
2484
937
Projects' Sum Points of Contributors / Average Sum Points of Contributors
Sum Points / Average Sum Points
Freq
0.0
50.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 1 -13210332 true "" "if count projects > 0 and mean [ sum [ points ] of current-contributors ] of projects != 0 [ histogram [ ( sum [ points ] of current-contributors ) / ( mean [ sum [ points ] of current-contributors ] of projects ) ] of projects   ]"

PLOT
2491
867
2831
1017
T4sks' Bounty
Bounty
Freq
0.0
100.0
0.0
10.0
true
true
"" ""
PENS
"t4sks" 5.0 1 -14439633 true "" "histogram [ bounty ] of t4sks"
"projects" 10.0 1 -15575016 true "" "histogram [ total-bounty ] of projects"

SLIDER
637
1168
916
1201
prob-set-a-bounty
prob-set-a-bounty
0
1
0.1
0.05
1
NIL
HORIZONTAL

SLIDER
638
1333
918
1366
prop-productless-proj
prop-productless-proj
0
1
0.25
0.05
1
NIL
HORIZONTAL

PLOT
2831
884
3091
1034
Average Points of Contributors
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"#1s" 1.0 0 -2674135 true "" "plot mean [points] of #1s"
"#9s" 1.0 0 -13345367 true "" "plot mean [points] of #9s"
"1s max" 1.0 0 -3026479 true "" "plot ( max [points] of #1s )"
"1s min" 1.0 0 -3026479 true "" "plot ( min [points] of #1s )"
"9s max" 1.0 0 -3026479 true "" "plot ( max [points] of #9s )"
"9s min" 1.0 0 -3026479 true "" "plot ( min [points] of #9s )"

SLIDER
637
1372
921
1405
max-noise
max-noise
0
15
5
1
1
NIL
HORIZONTAL

SLIDER
638
1210
917
1243
bountiesEffect
bountiesEffect
0
0.25
0.1
0.02
1
NIL
HORIZONTAL

SLIDER
638
1252
915
1285
reputationEffect
reputationEffect
0
0.3
0.1
0.02
1
NIL
HORIZONTAL

SLIDER
637
2267
959
2300
task-project-volume-increment-ratio
task-project-volume-increment-ratio
0
1
0.2
0.05
1
NIL
HORIZONTAL

TEXTBOX
1821
41
2206
85
------ADDITIONAL OUTPUTS--------
14
0.0
1

TEXTBOX
910
375
1270
645
----------------------------------------------------------------------------------------------------------------\n\n\n\n\n\n\n\n\n			MEASURE OF SILO / CENTRALITY / SOCIAL STRUCTURE HERE\n\n\n\n\n\n\n\n----------------------------------------------------------------------------------------------------------------
14
0.0
0

TEXTBOX
1137
844
1590
902
---ADVANCED PARAMETERS NOT TO EXPLORE---
14
0.0
1

TEXTBOX
104
915
437
954
;;; CAN WE PUT ANYTHING IN HERE? ;;;
14
0.0
1

SLIDER
637
2299
957
2332
chance-9-chases-a-bounty
chance-9-chases-a-bounty
0
100
0.5
0.1
1
NIL
HORIZONTAL

SLIDER
637
2330
907
2363
chance-9-picks-tasks-with-friends
chance-9-picks-tasks-with-friends
0
1
0.8
0.1
1
NIL
HORIZONTAL

SLIDER
640
2365
877
2398
max-project-initial-volume
max-project-initial-volume
0
300
100
5
1
NIL
HORIZONTAL

SLIDER
635
2400
972
2433
volume-increment-to-initial-volume-ratio
volume-increment-to-initial-volume-ratio
0
3
1
0.05
1
NIL
HORIZONTAL

PLOT
865
365
1310
515
plot 1
NIL
NIL
0.0
10.0
0.0
1.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "let contributors (turtle-set #9s #1s)\nlet numContribs (count contributors)\nplot sum [numContribs - 1 - count my-friends] of contributors / ( ( numContribs - 1 ) * ( numContribs - 2 ) )"

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.3
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="calibratingTo4Types_9Sep" repetitions="3" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="800"/>
    <metric>count #1s</metric>
    <metric>count #9s</metric>
    <metric>count #90s</metric>
    <metric>( count #1s / ( count #1s + count #9s + count #90s )) * 100</metric>
    <metric>( count #9s / ( count #1s + count #9s + count #90s )) * 100</metric>
    <metric>( count #90s / ( count #1s + count #9s + count #90s )) * 100</metric>
    <metric>count projects</metric>
    <metric>count t4sks</metric>
    <metric>count loneTasks</metric>
    <metric>count products</metric>
    <metric>#9-to-#1-count</metric>
    <metric>#1s-left</metric>
    <metric>#1-to-#9-count</metric>
    <metric>new-#9s-total</metric>
    <metric>#9s-left</metric>
    <metric>new-#90s-total</metric>
    <metric>#90s-left</metric>
    <metric>#90-to-#9-count</metric>
    <metric>count friendlinks</metric>
    <metric>count tasklinks</metric>
    <metric>mean [ my-total-contribution-9s ] of #9s</metric>
    <metric>mean [ my-total-contribution-1s ] of #1s</metric>
    <metric>count #9s with [ count my-friendlinks = 0 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 1 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 2 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 3 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 4 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 5 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 6 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 7 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 8 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 9 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 10 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 11 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 12 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 13 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 14 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 15 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 16 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 17 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 18 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 19 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 20 ]</metric>
    <metric>count #9s with [ count my-friendlinks &gt; 20 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s = 0 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 0 and my-total-contribution-1s &lt;= 50 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 50 and my-total-contribution-1s &lt;= 100 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 100 and my-total-contribution-1s &lt;= 150 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 150 and my-total-contribution-1s &lt;= 200 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 200 and my-total-contribution-1s &lt;= 250 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 250 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s = 0 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 0 and my-total-contribution-9s &lt;= 50 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 50 and my-total-contribution-9s &lt;= 1000 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 100 and my-total-contribution-9s &lt;= 150 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 150 and my-total-contribution-9s &lt;= 200 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 200 and my-total-contribution-9s &lt;= 250 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 250 ]</metric>
    <metric>products-out-competed</metric>
    <enumeratedValueSet variable="prob-1-drop-lonely-project">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="reward-mechanism">
      <value value="&quot;both&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-number-90s">
      <value value="10"/>
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-9-decides-to-join-project">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-90-picks-another-product">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-9s-barrier">
      <value value="0.4"/>
      <value value="1.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="proportion-using-platform">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-consumer-link-breaks">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="community-type">
      <value value="&quot;online&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-products-die">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-9-become-1">
      <value value="0.005"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prop-consumed-each-time">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-modularity">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-1-become-9">
      <value value="0.005"/>
      <value value="0.075"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-number-1s">
      <value value="1"/>
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="platform-features">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-9-drop-a-lonely-or-no-tasks-project">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-a-project-hatches-a-project">
      <value value="0.03"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-interest-categories">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-products">
      <value value="&quot;one&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prop-of-projects-reward-subjective">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-forget-a-friend">
      <value value="0.75"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-unpopular-project-dies">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-contributor-proposes-a-new-project">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-90s-barrier">
      <value value="1.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-9s-exit">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-of-finding-new-task">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-tasks">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-projects">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-9-contributes-to-none-friend-task">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-forget-thanks">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-number-9s">
      <value value="0"/>
      <value value="1"/>
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-1-burn-out">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mean-time-required">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-90s-exit">
      <value value="0.09"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-9-contributes-to-friends-task">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-90-find-a-task">
      <value value="0.001"/>
      <value value="0.01"/>
      <value value="0.1"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="calibratingToOfflineTypes_18Sep" repetitions="2" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="400"/>
    <metric>count #1s</metric>
    <metric>count #9s</metric>
    <metric>count #90s</metric>
    <metric>( count #1s / ( count #1s + count #9s + count #90s )) * 100</metric>
    <metric>( count #9s / ( count #1s + count #9s + count #90s )) * 100</metric>
    <metric>( count #90s / ( count #1s + count #9s + count #90s )) * 100</metric>
    <metric>count projects</metric>
    <metric>count t4sks</metric>
    <metric>count loneTasks</metric>
    <metric>count products</metric>
    <metric>#9-to-#1-count</metric>
    <metric>#1s-left</metric>
    <metric>#1-to-#9-count</metric>
    <metric>new-#9s-total</metric>
    <metric>#9s-left</metric>
    <metric>new-#90s-total</metric>
    <metric>#90s-left</metric>
    <metric>#90-to-#9-count</metric>
    <metric>count friendlinks</metric>
    <metric>count tasklinks</metric>
    <metric>mean [ my-total-contribution-9s ] of #9s</metric>
    <metric>mean [ my-total-contribution-1s ] of #1s</metric>
    <metric>count #9s with [ count my-friendlinks = 0 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 1 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 2 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 3 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 4 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 5 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 6 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 7 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 8 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 9 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 10 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 11 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 12 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 13 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 14 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 15 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 16 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 17 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 18 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 19 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 20 ]</metric>
    <metric>count #9s with [ count my-friendlinks &gt; 20 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s = 0 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 0 and my-total-contribution-1s &lt;= 50 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 50 and my-total-contribution-1s &lt;= 100 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 100 and my-total-contribution-1s &lt;= 150 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 150 and my-total-contribution-1s &lt;= 200 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 200 and my-total-contribution-1s &lt;= 250 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 250 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s = 0 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 0 and my-total-contribution-9s &lt;= 50 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 50 and my-total-contribution-9s &lt;= 1000 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 100 and my-total-contribution-9s &lt;= 150 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 150 and my-total-contribution-9s &lt;= 200 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 200 and my-total-contribution-9s &lt;= 250 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 250 ]</metric>
    <metric>products-out-competed</metric>
    <enumeratedValueSet variable="prob-1-drop-lonely-project">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="reward-mechanism">
      <value value="&quot;'thanks' only&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-number-90s">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-9-decides-to-join-project">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-90-picks-another-product">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-9s-barrier">
      <value value="0.4"/>
      <value value="1.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="proportion-using-platform">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-consumer-link-breaks">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="community-type">
      <value value="&quot;offline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-products-die">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-9-become-1">
      <value value="0.005"/>
      <value value="0.075"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prop-consumed-each-time">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-modularity">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-1-become-9">
      <value value="0.005"/>
      <value value="0.075"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-number-1s">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="platform-features">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-9-drop-a-lonely-or-no-tasks-project">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-a-project-hatches-a-project">
      <value value="0.03"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-interest-categories">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-products">
      <value value="&quot;one&quot;"/>
      <value value="&quot;a few&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prop-of-projects-reward-subjective">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-forget-a-friend">
      <value value="0.95"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-unpopular-project-dies">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-contributor-proposes-a-new-project">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-90s-barrier">
      <value value="0.5"/>
      <value value="1.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-9s-exit">
      <value value="0.01"/>
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-of-finding-new-task">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-tasks">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-projects">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-9-contributes-to-none-friend-task">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-forget-thanks">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-number-9s">
      <value value="9"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-1-burn-out">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mean-time-required">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-90s-exit">
      <value value="0.09"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-9-contributes-to-friends-task">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-90-find-a-task">
      <value value="0.001"/>
      <value value="0.1"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="offlineBaseline21sep" repetitions="2" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="400"/>
    <metric>count #1s</metric>
    <metric>count #9s</metric>
    <metric>count #90s</metric>
    <metric>( count #1s / ( count #1s + count #9s + count #90s )) * 100</metric>
    <metric>( count #9s / ( count #1s + count #9s + count #90s )) * 100</metric>
    <metric>( count #90s / ( count #1s + count #9s + count #90s )) * 100</metric>
    <metric>count projects</metric>
    <metric>count t4sks</metric>
    <metric>count loneTasks</metric>
    <metric>count products</metric>
    <metric>#9-to-#1-count</metric>
    <metric>#1s-left</metric>
    <metric>#1-to-#9-count</metric>
    <metric>new-#9s-total</metric>
    <metric>#9s-left</metric>
    <metric>new-#90s-total</metric>
    <metric>#90s-left</metric>
    <metric>#90-to-#9-count</metric>
    <metric>count friendlinks</metric>
    <metric>count tasklinks</metric>
    <metric>mean [ my-total-contribution-9s ] of #9s</metric>
    <metric>mean [ my-total-contribution-1s ] of #1s</metric>
    <metric>count #9s with [ count my-friendlinks = 0 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 1 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 2 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 3 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 4 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 5 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 6 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 7 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 8 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 9 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 10 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 11 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 12 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 13 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 14 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 15 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 16 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 17 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 18 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 19 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 20 ]</metric>
    <metric>count #9s with [ count my-friendlinks &gt; 20 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s = 0 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 0 and my-total-contribution-1s &lt;= 50 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 50 and my-total-contribution-1s &lt;= 100 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 100 and my-total-contribution-1s &lt;= 150 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 150 and my-total-contribution-1s &lt;= 200 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 200 and my-total-contribution-1s &lt;= 250 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 250 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s = 0 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 0 and my-total-contribution-9s &lt;= 50 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 50 and my-total-contribution-9s &lt;= 1000 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 100 and my-total-contribution-9s &lt;= 150 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 150 and my-total-contribution-9s &lt;= 200 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 200 and my-total-contribution-9s &lt;= 250 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 250 ]</metric>
    <metric>products-out-competed</metric>
    <enumeratedValueSet variable="prob-1-drop-lonely-project">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="reward-mechanism">
      <value value="&quot;'thanks' only&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-number-90s">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-9-decides-to-join-project">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-90-picks-another-product">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-9s-barrier">
      <value value="0.4"/>
      <value value="1.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="proportion-using-platform">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-consumer-link-breaks">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="community-type">
      <value value="&quot;offline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-products-die">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-9-become-1">
      <value value="0.005"/>
      <value value="0.075"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prop-consumed-each-time">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-modularity">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-1-become-9">
      <value value="0.005"/>
      <value value="0.075"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-number-1s">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="platform-features">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-9-drop-a-lonely-or-no-tasks-project">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-a-project-hatches-a-project">
      <value value="0.03"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-interest-categories">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-products">
      <value value="&quot;one&quot;"/>
      <value value="&quot;a few&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prop-of-projects-reward-subjective">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-forget-a-friend">
      <value value="0.95"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-unpopular-project-dies">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-contributor-proposes-a-new-project">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-90s-barrier">
      <value value="0.5"/>
      <value value="1.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-9s-exit">
      <value value="0.01"/>
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-of-finding-new-task">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-tasks">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-projects">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-9-contributes-to-none-friend-task">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-forget-thanks">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-number-9s">
      <value value="9"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-1-burn-out">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mean-time-required">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-90s-exit">
      <value value="0.09"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-9-contributes-to-friends-task">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-90-find-a-task">
      <value value="0.001"/>
      <value value="0.1"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="offline21sep_100collapse" repetitions="8" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="400"/>
    <metric>count #1s</metric>
    <metric>count #9s</metric>
    <metric>count #90s</metric>
    <metric>( count #1s / ( count #1s + count #9s + count #90s )) * 100</metric>
    <metric>( count #9s / ( count #1s + count #9s + count #90s )) * 100</metric>
    <metric>( count #90s / ( count #1s + count #9s + count #90s )) * 100</metric>
    <metric>count projects</metric>
    <metric>count t4sks</metric>
    <metric>count loneTasks</metric>
    <metric>count products</metric>
    <metric>#9-to-#1-count</metric>
    <metric>#1s-left</metric>
    <metric>#1-to-#9-count</metric>
    <metric>new-#9s-total</metric>
    <metric>#9s-left</metric>
    <metric>new-#90s-total</metric>
    <metric>#90s-left</metric>
    <metric>#90-to-#9-count</metric>
    <metric>count friendlinks</metric>
    <metric>count tasklinks</metric>
    <metric>mean [ my-total-contribution-9s ] of #9s</metric>
    <metric>mean [ my-total-contribution-1s ] of #1s</metric>
    <metric>count #9s with [ count my-friendlinks = 0 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 1 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 2 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 3 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 4 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 5 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 6 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 7 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 8 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 9 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 10 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 11 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 12 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 13 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 14 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 15 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 16 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 17 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 18 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 19 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 20 ]</metric>
    <metric>count #9s with [ count my-friendlinks &gt; 20 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s = 0 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 0 and my-total-contribution-1s &lt;= 50 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 50 and my-total-contribution-1s &lt;= 100 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 100 and my-total-contribution-1s &lt;= 150 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 150 and my-total-contribution-1s &lt;= 200 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 200 and my-total-contribution-1s &lt;= 250 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 250 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s = 0 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 0 and my-total-contribution-9s &lt;= 50 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 50 and my-total-contribution-9s &lt;= 1000 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 100 and my-total-contribution-9s &lt;= 150 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 150 and my-total-contribution-9s &lt;= 200 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 200 and my-total-contribution-9s &lt;= 250 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 250 ]</metric>
    <metric>products-out-competed</metric>
    <enumeratedValueSet variable="prob-1-drop-lonely-project">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="reward-mechanism">
      <value value="&quot;'thanks' only&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-number-90s">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-9-decides-to-join-project">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-90-picks-another-product">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-9s-barrier">
      <value value="1.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="proportion-using-platform">
      <value value="0.5"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-consumer-link-breaks">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="community-type">
      <value value="&quot;offline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-products-die">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-9-become-1">
      <value value="0.005"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prop-consumed-each-time">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-modularity">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-1-become-9">
      <value value="0.005"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-number-1s">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="platform-features">
      <value value="false"/>
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-9-drop-a-lonely-or-no-tasks-project">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-a-project-hatches-a-project">
      <value value="0.03"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-interest-categories">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-products">
      <value value="&quot;one&quot;"/>
      <value value="&quot;a few&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prop-of-projects-reward-subjective">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-forget-a-friend">
      <value value="0.95"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-unpopular-project-dies">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-contributor-proposes-a-new-project">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-90s-barrier">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-9s-exit">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-of-finding-new-task">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-tasks">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-projects">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-9-contributes-to-none-friend-task">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-forget-thanks">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-number-9s">
      <value value="9"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-1-burn-out">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mean-time-required">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-90s-exit">
      <value value="0.09"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-9-contributes-to-friends-task">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-90-find-a-task">
      <value value="0.001"/>
      <value value="0.1"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="21sep_largeSteady_online" repetitions="30" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="800"/>
    <metric>count #1s</metric>
    <metric>count #9s</metric>
    <metric>count #90s</metric>
    <metric>( count #1s / ( count #1s + count #9s + count #90s )) * 100</metric>
    <metric>( count #9s / ( count #1s + count #9s + count #90s )) * 100</metric>
    <metric>( count #90s / ( count #1s + count #9s + count #90s )) * 100</metric>
    <metric>count projects</metric>
    <metric>count t4sks</metric>
    <metric>count loneTasks</metric>
    <metric>count products</metric>
    <metric>#9-to-#1-count</metric>
    <metric>#1s-left</metric>
    <metric>#1-to-#9-count</metric>
    <metric>new-#9s-total</metric>
    <metric>#9s-left</metric>
    <metric>new-#90s-total</metric>
    <metric>#90s-left</metric>
    <metric>#90-to-#9-count</metric>
    <metric>count friendlinks</metric>
    <metric>count tasklinks</metric>
    <metric>mean [ my-total-contribution-9s ] of #9s</metric>
    <metric>mean [ my-total-contribution-1s ] of #1s</metric>
    <metric>count #9s with [ count my-friendlinks = 0 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 1 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 2 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 3 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 4 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 5 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 6 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 7 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 8 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 9 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 10 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 11 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 12 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 13 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 14 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 15 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 16 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 17 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 18 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 19 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 20 ]</metric>
    <metric>count #9s with [ count my-friendlinks &gt; 20 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s = 0 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 0 and my-total-contribution-1s &lt;= 50 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 50 and my-total-contribution-1s &lt;= 100 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 100 and my-total-contribution-1s &lt;= 150 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 150 and my-total-contribution-1s &lt;= 200 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 200 and my-total-contribution-1s &lt;= 250 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 250 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s = 0 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 0 and my-total-contribution-9s &lt;= 50 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 50 and my-total-contribution-9s &lt;= 1000 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 100 and my-total-contribution-9s &lt;= 150 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 150 and my-total-contribution-9s &lt;= 200 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 200 and my-total-contribution-9s &lt;= 250 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 250 ]</metric>
    <metric>products-out-competed</metric>
    <enumeratedValueSet variable="prob-1-drop-lonely-project">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="reward-mechanism">
      <value value="&quot;both&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-number-90s">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-9-decides-to-join-project">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-90-picks-another-product">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-9s-barrier">
      <value value="1.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="proportion-using-platform">
      <value value="0.5"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-consumer-link-breaks">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="community-type">
      <value value="&quot;online&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-products-die">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-9-become-1">
      <value value="0.005"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prop-consumed-each-time">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-modularity">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-1-become-9">
      <value value="0.075"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-number-1s">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="platform-features">
      <value value="false"/>
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-9-drop-a-lonely-or-no-tasks-project">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-a-project-hatches-a-project">
      <value value="0.03"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-interest-categories">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-products">
      <value value="&quot;one&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prop-of-projects-reward-subjective">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-forget-a-friend">
      <value value="0.75"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-unpopular-project-dies">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-contributor-proposes-a-new-project">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-90s-barrier">
      <value value="1.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-9s-exit">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-of-finding-new-task">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-tasks">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-projects">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-9-contributes-to-none-friend-task">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-forget-thanks">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-number-9s">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-1-burn-out">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mean-time-required">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-90s-exit">
      <value value="0.09"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-9-contributes-to-friends-task">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-90-find-a-task">
      <value value="0.1"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="21sep_largeSudden_online" repetitions="15" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="800"/>
    <metric>count #1s</metric>
    <metric>count #9s</metric>
    <metric>count #90s</metric>
    <metric>( count #1s / ( count #1s + count #9s + count #90s )) * 100</metric>
    <metric>( count #9s / ( count #1s + count #9s + count #90s )) * 100</metric>
    <metric>( count #90s / ( count #1s + count #9s + count #90s )) * 100</metric>
    <metric>count projects</metric>
    <metric>count t4sks</metric>
    <metric>count loneTasks</metric>
    <metric>count products</metric>
    <metric>#9-to-#1-count</metric>
    <metric>#1s-left</metric>
    <metric>#1-to-#9-count</metric>
    <metric>new-#9s-total</metric>
    <metric>#9s-left</metric>
    <metric>new-#90s-total</metric>
    <metric>#90s-left</metric>
    <metric>#90-to-#9-count</metric>
    <metric>count friendlinks</metric>
    <metric>count tasklinks</metric>
    <metric>mean [ my-total-contribution-9s ] of #9s</metric>
    <metric>mean [ my-total-contribution-1s ] of #1s</metric>
    <metric>count #9s with [ count my-friendlinks = 0 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 1 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 2 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 3 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 4 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 5 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 6 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 7 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 8 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 9 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 10 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 11 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 12 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 13 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 14 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 15 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 16 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 17 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 18 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 19 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 20 ]</metric>
    <metric>count #9s with [ count my-friendlinks &gt; 20 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s = 0 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 0 and my-total-contribution-1s &lt;= 50 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 50 and my-total-contribution-1s &lt;= 100 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 100 and my-total-contribution-1s &lt;= 150 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 150 and my-total-contribution-1s &lt;= 200 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 200 and my-total-contribution-1s &lt;= 250 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 250 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s = 0 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 0 and my-total-contribution-9s &lt;= 50 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 50 and my-total-contribution-9s &lt;= 1000 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 100 and my-total-contribution-9s &lt;= 150 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 150 and my-total-contribution-9s &lt;= 200 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 200 and my-total-contribution-9s &lt;= 250 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 250 ]</metric>
    <metric>products-out-competed</metric>
    <enumeratedValueSet variable="prob-1-drop-lonely-project">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="reward-mechanism">
      <value value="&quot;both&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-number-90s">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-9-decides-to-join-project">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-90-picks-another-product">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-9s-barrier">
      <value value="0.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="proportion-using-platform">
      <value value="0.5"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-consumer-link-breaks">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="community-type">
      <value value="&quot;online&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-products-die">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-9-become-1">
      <value value="0.005"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prop-consumed-each-time">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-modularity">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-1-become-9">
      <value value="0.005"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-number-1s">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="platform-features">
      <value value="false"/>
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-9-drop-a-lonely-or-no-tasks-project">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-a-project-hatches-a-project">
      <value value="0.03"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-interest-categories">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-products">
      <value value="&quot;one&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prop-of-projects-reward-subjective">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-forget-a-friend">
      <value value="0.75"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-unpopular-project-dies">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-contributor-proposes-a-new-project">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-90s-barrier">
      <value value="1.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-9s-exit">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-of-finding-new-task">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-tasks">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-projects">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-9-contributes-to-none-friend-task">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-forget-thanks">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-number-9s">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-1-burn-out">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mean-time-required">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-90s-exit">
      <value value="0.09"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-9-contributes-to-friends-task">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-90-find-a-task">
      <value value="0.01"/>
      <value value="0.1"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="21Sep_smallSteady_online" repetitions="30" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="800"/>
    <metric>count #1s</metric>
    <metric>count #9s</metric>
    <metric>count #90s</metric>
    <metric>( count #1s / ( count #1s + count #9s + count #90s )) * 100</metric>
    <metric>( count #9s / ( count #1s + count #9s + count #90s )) * 100</metric>
    <metric>( count #90s / ( count #1s + count #9s + count #90s )) * 100</metric>
    <metric>count projects</metric>
    <metric>count t4sks</metric>
    <metric>count loneTasks</metric>
    <metric>count products</metric>
    <metric>#9-to-#1-count</metric>
    <metric>#1s-left</metric>
    <metric>#1-to-#9-count</metric>
    <metric>new-#9s-total</metric>
    <metric>#9s-left</metric>
    <metric>new-#90s-total</metric>
    <metric>#90s-left</metric>
    <metric>#90-to-#9-count</metric>
    <metric>count friendlinks</metric>
    <metric>count tasklinks</metric>
    <metric>mean [ my-total-contribution-9s ] of #9s</metric>
    <metric>mean [ my-total-contribution-1s ] of #1s</metric>
    <metric>count #9s with [ count my-friendlinks = 0 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 1 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 2 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 3 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 4 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 5 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 6 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 7 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 8 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 9 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 10 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 11 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 12 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 13 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 14 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 15 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 16 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 17 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 18 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 19 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 20 ]</metric>
    <metric>count #9s with [ count my-friendlinks &gt; 20 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s = 0 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 0 and my-total-contribution-1s &lt;= 50 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 50 and my-total-contribution-1s &lt;= 100 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 100 and my-total-contribution-1s &lt;= 150 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 150 and my-total-contribution-1s &lt;= 200 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 200 and my-total-contribution-1s &lt;= 250 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 250 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s = 0 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 0 and my-total-contribution-9s &lt;= 50 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 50 and my-total-contribution-9s &lt;= 1000 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 100 and my-total-contribution-9s &lt;= 150 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 150 and my-total-contribution-9s &lt;= 200 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 200 and my-total-contribution-9s &lt;= 250 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 250 ]</metric>
    <metric>products-out-competed</metric>
    <enumeratedValueSet variable="prob-1-drop-lonely-project">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="reward-mechanism">
      <value value="&quot;both&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-number-90s">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-9-decides-to-join-project">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-90-picks-another-product">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-9s-barrier">
      <value value="1.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="proportion-using-platform">
      <value value="0.5"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-consumer-link-breaks">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="community-type">
      <value value="&quot;online&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-products-die">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-9-become-1">
      <value value="0.005"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prop-consumed-each-time">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-modularity">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-1-become-9">
      <value value="0.005"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-number-1s">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="platform-features">
      <value value="false"/>
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-9-drop-a-lonely-or-no-tasks-project">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-a-project-hatches-a-project">
      <value value="0.03"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-interest-categories">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-products">
      <value value="&quot;one&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prop-of-projects-reward-subjective">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-forget-a-friend">
      <value value="0.75"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-unpopular-project-dies">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-contributor-proposes-a-new-project">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-90s-barrier">
      <value value="1.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-9s-exit">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-of-finding-new-task">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-tasks">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-projects">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-9-contributes-to-none-friend-task">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-forget-thanks">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-number-9s">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-1-burn-out">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mean-time-required">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-90s-exit">
      <value value="0.09"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-9-contributes-to-friends-task">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-90-find-a-task">
      <value value="0.01"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="21Sep_smallGrowCollapse_online" repetitions="30" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="800"/>
    <metric>count #1s</metric>
    <metric>count #9s</metric>
    <metric>count #90s</metric>
    <metric>( count #1s / ( count #1s + count #9s + count #90s )) * 100</metric>
    <metric>( count #9s / ( count #1s + count #9s + count #90s )) * 100</metric>
    <metric>( count #90s / ( count #1s + count #9s + count #90s )) * 100</metric>
    <metric>count projects</metric>
    <metric>count t4sks</metric>
    <metric>count loneTasks</metric>
    <metric>count products</metric>
    <metric>#9-to-#1-count</metric>
    <metric>#1s-left</metric>
    <metric>#1-to-#9-count</metric>
    <metric>new-#9s-total</metric>
    <metric>#9s-left</metric>
    <metric>new-#90s-total</metric>
    <metric>#90s-left</metric>
    <metric>#90-to-#9-count</metric>
    <metric>count friendlinks</metric>
    <metric>count tasklinks</metric>
    <metric>mean [ my-total-contribution-9s ] of #9s</metric>
    <metric>mean [ my-total-contribution-1s ] of #1s</metric>
    <metric>count #9s with [ count my-friendlinks = 0 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 1 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 2 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 3 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 4 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 5 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 6 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 7 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 8 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 9 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 10 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 11 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 12 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 13 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 14 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 15 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 16 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 17 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 18 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 19 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 20 ]</metric>
    <metric>count #9s with [ count my-friendlinks &gt; 20 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s = 0 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 0 and my-total-contribution-1s &lt;= 50 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 50 and my-total-contribution-1s &lt;= 100 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 100 and my-total-contribution-1s &lt;= 150 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 150 and my-total-contribution-1s &lt;= 200 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 200 and my-total-contribution-1s &lt;= 250 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 250 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s = 0 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 0 and my-total-contribution-9s &lt;= 50 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 50 and my-total-contribution-9s &lt;= 1000 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 100 and my-total-contribution-9s &lt;= 150 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 150 and my-total-contribution-9s &lt;= 200 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 200 and my-total-contribution-9s &lt;= 250 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 250 ]</metric>
    <metric>products-out-competed</metric>
    <enumeratedValueSet variable="prob-1-drop-lonely-project">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="reward-mechanism">
      <value value="&quot;both&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-number-90s">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-9-decides-to-join-project">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-90-picks-another-product">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-9s-barrier">
      <value value="1.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="proportion-using-platform">
      <value value="0.5"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-consumer-link-breaks">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="community-type">
      <value value="&quot;online&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-products-die">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-9-become-1">
      <value value="0.005"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prop-consumed-each-time">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-modularity">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-1-become-9">
      <value value="0.005"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-number-1s">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="platform-features">
      <value value="false"/>
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-9-drop-a-lonely-or-no-tasks-project">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-a-project-hatches-a-project">
      <value value="0.03"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-interest-categories">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-products">
      <value value="&quot;one&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prop-of-projects-reward-subjective">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-forget-a-friend">
      <value value="0.75"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-unpopular-project-dies">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-contributor-proposes-a-new-project">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-90s-barrier">
      <value value="1.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-9s-exit">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-of-finding-new-task">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-tasks">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-projects">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-9-contributes-to-none-friend-task">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-forget-thanks">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-number-9s">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-1-burn-out">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mean-time-required">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-90s-exit">
      <value value="0.09"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-9-contributes-to-friends-task">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-90-find-a-task">
      <value value="0.1"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="offline21sep_50collapse" repetitions="8" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="400"/>
    <metric>count #1s</metric>
    <metric>count #9s</metric>
    <metric>count #90s</metric>
    <metric>( count #1s / ( count #1s + count #9s + count #90s )) * 100</metric>
    <metric>( count #9s / ( count #1s + count #9s + count #90s )) * 100</metric>
    <metric>( count #90s / ( count #1s + count #9s + count #90s )) * 100</metric>
    <metric>count projects</metric>
    <metric>count t4sks</metric>
    <metric>count loneTasks</metric>
    <metric>count products</metric>
    <metric>#9-to-#1-count</metric>
    <metric>#1s-left</metric>
    <metric>#1-to-#9-count</metric>
    <metric>new-#9s-total</metric>
    <metric>#9s-left</metric>
    <metric>new-#90s-total</metric>
    <metric>#90s-left</metric>
    <metric>#90-to-#9-count</metric>
    <metric>count friendlinks</metric>
    <metric>count tasklinks</metric>
    <metric>mean [ my-total-contribution-9s ] of #9s</metric>
    <metric>mean [ my-total-contribution-1s ] of #1s</metric>
    <metric>count #9s with [ count my-friendlinks = 0 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 1 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 2 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 3 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 4 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 5 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 6 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 7 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 8 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 9 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 10 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 11 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 12 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 13 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 14 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 15 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 16 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 17 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 18 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 19 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 20 ]</metric>
    <metric>count #9s with [ count my-friendlinks &gt; 20 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s = 0 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 0 and my-total-contribution-1s &lt;= 50 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 50 and my-total-contribution-1s &lt;= 100 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 100 and my-total-contribution-1s &lt;= 150 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 150 and my-total-contribution-1s &lt;= 200 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 200 and my-total-contribution-1s &lt;= 250 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 250 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s = 0 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 0 and my-total-contribution-9s &lt;= 50 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 50 and my-total-contribution-9s &lt;= 1000 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 100 and my-total-contribution-9s &lt;= 150 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 150 and my-total-contribution-9s &lt;= 200 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 200 and my-total-contribution-9s &lt;= 250 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 250 ]</metric>
    <metric>products-out-competed</metric>
    <enumeratedValueSet variable="prob-1-drop-lonely-project">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="reward-mechanism">
      <value value="&quot;'thanks' only&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-number-90s">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-9-decides-to-join-project">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-90-picks-another-product">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-9s-barrier">
      <value value="0.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="proportion-using-platform">
      <value value="0.5"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-consumer-link-breaks">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="community-type">
      <value value="&quot;offline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-products-die">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-9-become-1">
      <value value="0.005"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prop-consumed-each-time">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-modularity">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-1-become-9">
      <value value="0.005"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-number-1s">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="platform-features">
      <value value="false"/>
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-9-drop-a-lonely-or-no-tasks-project">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-a-project-hatches-a-project">
      <value value="0.03"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-interest-categories">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-products">
      <value value="&quot;one&quot;"/>
      <value value="&quot;a few&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prop-of-projects-reward-subjective">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-forget-a-friend">
      <value value="0.95"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-unpopular-project-dies">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-contributor-proposes-a-new-project">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-90s-barrier">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-9s-exit">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-of-finding-new-task">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-tasks">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-projects">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-9-contributes-to-none-friend-task">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-forget-thanks">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-number-9s">
      <value value="9"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-1-burn-out">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mean-time-required">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-90s-exit">
      <value value="0.09"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-9-contributes-to-friends-task">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-90-find-a-task">
      <value value="0.001"/>
      <value value="0.1"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="offline21sep_200steady" repetitions="8" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="400"/>
    <metric>count #1s</metric>
    <metric>count #9s</metric>
    <metric>count #90s</metric>
    <metric>( count #1s / ( count #1s + count #9s + count #90s )) * 100</metric>
    <metric>( count #9s / ( count #1s + count #9s + count #90s )) * 100</metric>
    <metric>( count #90s / ( count #1s + count #9s + count #90s )) * 100</metric>
    <metric>count projects</metric>
    <metric>count t4sks</metric>
    <metric>count loneTasks</metric>
    <metric>count products</metric>
    <metric>#9-to-#1-count</metric>
    <metric>#1s-left</metric>
    <metric>#1-to-#9-count</metric>
    <metric>new-#9s-total</metric>
    <metric>#9s-left</metric>
    <metric>new-#90s-total</metric>
    <metric>#90s-left</metric>
    <metric>#90-to-#9-count</metric>
    <metric>count friendlinks</metric>
    <metric>count tasklinks</metric>
    <metric>mean [ my-total-contribution-9s ] of #9s</metric>
    <metric>mean [ my-total-contribution-1s ] of #1s</metric>
    <metric>count #9s with [ count my-friendlinks = 0 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 1 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 2 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 3 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 4 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 5 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 6 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 7 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 8 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 9 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 10 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 11 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 12 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 13 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 14 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 15 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 16 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 17 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 18 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 19 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 20 ]</metric>
    <metric>count #9s with [ count my-friendlinks &gt; 20 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s = 0 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 0 and my-total-contribution-1s &lt;= 50 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 50 and my-total-contribution-1s &lt;= 100 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 100 and my-total-contribution-1s &lt;= 150 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 150 and my-total-contribution-1s &lt;= 200 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 200 and my-total-contribution-1s &lt;= 250 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 250 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s = 0 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 0 and my-total-contribution-9s &lt;= 50 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 50 and my-total-contribution-9s &lt;= 1000 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 100 and my-total-contribution-9s &lt;= 150 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 150 and my-total-contribution-9s &lt;= 200 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 200 and my-total-contribution-9s &lt;= 250 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 250 ]</metric>
    <metric>products-out-competed</metric>
    <enumeratedValueSet variable="prob-1-drop-lonely-project">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="reward-mechanism">
      <value value="&quot;'thanks' only&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-number-90s">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-9-decides-to-join-project">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-90-picks-another-product">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-9s-barrier">
      <value value="0.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="proportion-using-platform">
      <value value="0.5"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-consumer-link-breaks">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="community-type">
      <value value="&quot;offline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-products-die">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-9-become-1">
      <value value="0.005"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prop-consumed-each-time">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-modularity">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-1-become-9">
      <value value="0.075"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-number-1s">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="platform-features">
      <value value="false"/>
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-9-drop-a-lonely-or-no-tasks-project">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-a-project-hatches-a-project">
      <value value="0.03"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-interest-categories">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-products">
      <value value="&quot;one&quot;"/>
      <value value="&quot;a few&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prop-of-projects-reward-subjective">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-forget-a-friend">
      <value value="0.95"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-unpopular-project-dies">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-contributor-proposes-a-new-project">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-90s-barrier">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-9s-exit">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-of-finding-new-task">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-tasks">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-projects">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-9-contributes-to-none-friend-task">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-forget-thanks">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-number-9s">
      <value value="9"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-1-burn-out">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mean-time-required">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-90s-exit">
      <value value="0.09"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-9-contributes-to-friends-task">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-90-find-a-task">
      <value value="0.001"/>
      <value value="0.1"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="offline21sep_50steady" repetitions="8" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="400"/>
    <metric>count #1s</metric>
    <metric>count #9s</metric>
    <metric>count #90s</metric>
    <metric>( count #1s / ( count #1s + count #9s + count #90s )) * 100</metric>
    <metric>( count #9s / ( count #1s + count #9s + count #90s )) * 100</metric>
    <metric>( count #90s / ( count #1s + count #9s + count #90s )) * 100</metric>
    <metric>count projects</metric>
    <metric>count t4sks</metric>
    <metric>count loneTasks</metric>
    <metric>count products</metric>
    <metric>#9-to-#1-count</metric>
    <metric>#1s-left</metric>
    <metric>#1-to-#9-count</metric>
    <metric>new-#9s-total</metric>
    <metric>#9s-left</metric>
    <metric>new-#90s-total</metric>
    <metric>#90s-left</metric>
    <metric>#90-to-#9-count</metric>
    <metric>count friendlinks</metric>
    <metric>count tasklinks</metric>
    <metric>mean [ my-total-contribution-9s ] of #9s</metric>
    <metric>mean [ my-total-contribution-1s ] of #1s</metric>
    <metric>count #9s with [ count my-friendlinks = 0 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 1 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 2 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 3 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 4 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 5 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 6 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 7 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 8 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 9 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 10 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 11 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 12 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 13 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 14 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 15 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 16 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 17 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 18 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 19 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 20 ]</metric>
    <metric>count #9s with [ count my-friendlinks &gt; 20 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s = 0 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 0 and my-total-contribution-1s &lt;= 50 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 50 and my-total-contribution-1s &lt;= 100 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 100 and my-total-contribution-1s &lt;= 150 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 150 and my-total-contribution-1s &lt;= 200 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 200 and my-total-contribution-1s &lt;= 250 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 250 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s = 0 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 0 and my-total-contribution-9s &lt;= 50 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 50 and my-total-contribution-9s &lt;= 1000 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 100 and my-total-contribution-9s &lt;= 150 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 150 and my-total-contribution-9s &lt;= 200 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 200 and my-total-contribution-9s &lt;= 250 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 250 ]</metric>
    <metric>products-out-competed</metric>
    <enumeratedValueSet variable="prob-1-drop-lonely-project">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="reward-mechanism">
      <value value="&quot;'thanks' only&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-number-90s">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-9-decides-to-join-project">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-90-picks-another-product">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-9s-barrier">
      <value value="1.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="proportion-using-platform">
      <value value="0.5"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-consumer-link-breaks">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="community-type">
      <value value="&quot;offline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-products-die">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-9-become-1">
      <value value="0.005"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prop-consumed-each-time">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-modularity">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-1-become-9">
      <value value="0.075"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-number-1s">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="platform-features">
      <value value="false"/>
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-9-drop-a-lonely-or-no-tasks-project">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-a-project-hatches-a-project">
      <value value="0.03"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-interest-categories">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-products">
      <value value="&quot;one&quot;"/>
      <value value="&quot;a few&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prop-of-projects-reward-subjective">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-forget-a-friend">
      <value value="0.95"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-unpopular-project-dies">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-contributor-proposes-a-new-project">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-90s-barrier">
      <value value="1.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-9s-exit">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-of-finding-new-task">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-tasks">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-projects">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-9-contributes-to-none-friend-task">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-forget-thanks">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-number-9s">
      <value value="9"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-1-burn-out">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mean-time-required">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-90s-exit">
      <value value="0.09"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-9-contributes-to-friends-task">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-90-find-a-task">
      <value value="0.001"/>
      <value value="0.1"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="offline21sep_QuickDeath" repetitions="8" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="400"/>
    <metric>count #1s</metric>
    <metric>count #9s</metric>
    <metric>count #90s</metric>
    <metric>( count #1s / ( count #1s + count #9s + count #90s )) * 100</metric>
    <metric>( count #9s / ( count #1s + count #9s + count #90s )) * 100</metric>
    <metric>( count #90s / ( count #1s + count #9s + count #90s )) * 100</metric>
    <metric>count projects</metric>
    <metric>count t4sks</metric>
    <metric>count loneTasks</metric>
    <metric>count products</metric>
    <metric>#9-to-#1-count</metric>
    <metric>#1s-left</metric>
    <metric>#1-to-#9-count</metric>
    <metric>new-#9s-total</metric>
    <metric>#9s-left</metric>
    <metric>new-#90s-total</metric>
    <metric>#90s-left</metric>
    <metric>#90-to-#9-count</metric>
    <metric>count friendlinks</metric>
    <metric>count tasklinks</metric>
    <metric>mean [ my-total-contribution-9s ] of #9s</metric>
    <metric>mean [ my-total-contribution-1s ] of #1s</metric>
    <metric>count #9s with [ count my-friendlinks = 0 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 1 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 2 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 3 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 4 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 5 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 6 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 7 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 8 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 9 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 10 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 11 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 12 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 13 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 14 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 15 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 16 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 17 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 18 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 19 ]</metric>
    <metric>count #9s with [ count my-friendlinks = 20 ]</metric>
    <metric>count #9s with [ count my-friendlinks &gt; 20 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s = 0 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 0 and my-total-contribution-1s &lt;= 50 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 50 and my-total-contribution-1s &lt;= 100 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 100 and my-total-contribution-1s &lt;= 150 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 150 and my-total-contribution-1s &lt;= 200 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 200 and my-total-contribution-1s &lt;= 250 ]</metric>
    <metric>count #1s with [ my-total-contribution-1s &gt; 250 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s = 0 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 0 and my-total-contribution-9s &lt;= 50 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 50 and my-total-contribution-9s &lt;= 1000 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 100 and my-total-contribution-9s &lt;= 150 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 150 and my-total-contribution-9s &lt;= 200 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 200 and my-total-contribution-9s &lt;= 250 ]</metric>
    <metric>count #9s with [ my-total-contribution-9s &gt; 250 ]</metric>
    <metric>products-out-competed</metric>
    <enumeratedValueSet variable="prob-1-drop-lonely-project">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="reward-mechanism">
      <value value="&quot;'thanks' only&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-number-90s">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-9-decides-to-join-project">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-90-picks-another-product">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-9s-barrier">
      <value value="1.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="proportion-using-platform">
      <value value="0.5"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-consumer-link-breaks">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="community-type">
      <value value="&quot;offline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-products-die">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-9-become-1">
      <value value="0.005"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prop-consumed-each-time">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-modularity">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-1-become-9">
      <value value="0.075"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-number-1s">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="platform-features">
      <value value="false"/>
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-9-drop-a-lonely-or-no-tasks-project">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-a-project-hatches-a-project">
      <value value="0.03"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-interest-categories">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-products">
      <value value="&quot;one&quot;"/>
      <value value="&quot;a few&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prop-of-projects-reward-subjective">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-forget-a-friend">
      <value value="0.95"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-unpopular-project-dies">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-contributor-proposes-a-new-project">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-90s-barrier">
      <value value="1.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-9s-exit">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-of-finding-new-task">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-tasks">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-projects">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-9-contributes-to-none-friend-task">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-forget-thanks">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-number-9s">
      <value value="9"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-1-burn-out">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mean-time-required">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-90s-exit">
      <value value="0.09"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-9-contributes-to-friends-task">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-90-find-a-task">
      <value value="0.001"/>
      <value value="0.1"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="no-behaviour-change-test" repetitions="1" runMetricsEveryStep="true">
    <setup>random-seed 111
setup</setup>
    <go>go</go>
    <timeLimit steps="200"/>
    <metric>count turtles</metric>
    <enumeratedValueSet variable="initial-number-90s">
      <value value="45"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prop-of-projects-reward-subjective">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-projects">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-unpopular-project-dies">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-90s-barrier">
      <value value="1.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-consumer-link-breaks">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="community-type">
      <value value="&quot;online&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-1-burn-out">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-interest-categories">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="reward-mechanism">
      <value value="&quot;both&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-90s-exit">
      <value value="0.035"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-number-9s">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-contributor-proposes-a-new-project">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-9-contributes-to-friends-task">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-9-contributes-to-none-friend-task">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-9s-barrier">
      <value value="1.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-products-die">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prop-consumed-each-time">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="platform-features">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-9-drop-a-lonely-or-no-tasks-project">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-90-picks-another-product">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-9s-exit">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-9-decides-to-join-project">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-modularity">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-new-loneTask">
      <value value="0.7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-forget-thanks">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-a-project-hatches-a-project">
      <value value="0.03"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-1-become-9">
      <value value="0.005"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mean-time-required">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-1-drop-lonely-project">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-90-find-a-task">
      <value value="0.005"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-9-become-1">
      <value value="0.005"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-number-1s">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-products">
      <value value="&quot;a few&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-forget-a-friend">
      <value value="0.7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-tasks">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="proportion-using-platform">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-of-finding-new-task">
      <value value="0.001"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
1
@#$#@#$#@
