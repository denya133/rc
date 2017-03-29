_ = require 'lodash'

###
  # Технология машины состояний проектировалась с оглядкой на
  https://github.com/aasm/aasm

class Tomato extends CoreObject
  @StateMachine 'default', ->
    @beforeAllEvents 'beforeAllEvents'
    @afterAllTransitions 'afterAllTransitions'
    @afterAllEvents 'afterAllEvents'
    @errorOnAllEvents 'errorOnAllEvents'
    @state 'first',
      initial: yes
      beforeExit: 'beforeExitFromFirst'
      afterExit: 'afterExitFromFirst'
    @state 'sleeping',
      beforeExit: 'beforeExitFromSleeping'
      afterExit: 'afterExitFromSleeping'
    @state 'running',
      beforeEnter: 'beforeEnterToRunning'
      afterEnter: 'afterEnterFromRunning'
    @event 'run',
      before: 'beforeRun'
      after: 'afterRun'
      error: 'errorOnRun'
     , =>
        @transition ['first', 'second'], 'third',
          guard: 'checkSomethingCondition'
          after: 'afterFirstSecondToThird'
        @transition 'third', 'running',
          if: 'checkThirdCondition'
          after: 'afterThirdToRunning'
        @transition ['first', 'third', 'sleeping', 'running'], 'superRunning',
          unless: 'checkThirdCondition'
          after: 'afterSleepingToRunning'

  checkSomethingCondition: ->
    console.log '!!!???? checkSomethingCondition'
    yes
  checkThirdCondition: ->
    console.log '!!!???? checkThirdCondition'
    yes
  beforeExitFromSleeping: ->
    console.log 'DFSDFSD beforeExitFromSleeping'
  beforeExitFromFirst: ->
    console.log 'DFSDFSD beforeExitFromFirst'
  afterExitFromSleeping: ->
    console.log 'DFSDFSD afterExitFromSleeping'
  afterExitFromFirst: ->
    console.log 'DFSDFSD afterExitFromFirst'
  beforeEnterToRunning: ->
    console.log 'DFSDFSD beforeEnterToRunning'
  beforeRun: ->
    console.log 'DFSDFSD beforeRun'
  afterRun: ->
    console.log 'DFSDFSD afterRun'
  afterFirstSecondToThird: (firstArg, secondArg)->
    console.log firstArg, secondArg # => {key: 'value'}, 125
    console.log 'DFSDFSD afterFirstSecondToThird'
  afterThirdToRunning: (firstArg, secondArg)->
    console.log firstArg, secondArg # => {key: 'value'}, 125
    console.log 'DFSDFSD afterThirdToRunning'
  afterSleepingToRunning: (firstArg, secondArg)->
    console.log firstArg, secondArg # => {key: 'value'}, 125
    console.log 'DFSDFSD afterSleepingToRunning'
  afterRunningToSleeping: ->
    console.log 'DFSDFSD afterRunningToSleeping'

  beforeAllEvents: ->
    console.log 'DFSDFSD beforeAllEvents'
  afterAllTransitions: ->
    console.log 'DFSDFSD afterAllTransitions'
  afterAllEvents: ->
    console.log 'DFSDFSD afterAllEvents'
  errorOnAllEvents: (err)->
    console.log 'DFSDFSD errorOnAllEvents', err, err.stack
  errorOnRun: ->
    console.log 'DFSDFSD errorOnRun'

tomato = new Tomato()
tomato.run({key: 'value'}, 125) # можно передать как аргументы какие нибудь данные, они будут переданы внутырь коллбеков указанных на транзишенах в ключах :after
console.log 'tomato.state', tomato.state
###

###
StateMachine flow

try
  event           beforeAllEvents
  event           before
  event           guard
    transition      guard
    old_state       beforeExit
    old_state       exit
    ...update state...
                    afterAllTransitions
    transition      after
    new_state       beforeEnter
    new_state       enter
    ...save state...
    transition      success             # if persist successful
    old_state       afterExit
    new_state       afterEnter
  event           success             # if persist successful
  event           after
  event           afterAllEvents
catch
  event           error
  event           errorOnAllEvents
###

module.exports = (RC)->
  class RC::StateMachineMixin extends RC::Mixin
    @inheritProtected()

    iplStateMachines = @protected stateMachines: Object,
      null

    cplStateMachineConfigs = @protected @static stateMachineConfigs: Object,
      null

    @public initializeStateMachines: Function,
      default: ->
        @[iplStateMachines] ?= {}
        if _.isObject configs = @constructor[cplStateMachineConfigs]
          for own vsName, vmConfig of configs then do (vsName, vmConfig) =>
            unless @[iplStateMachines][vsName]?
              @[iplStateMachines][vsName] = RC::StateMachine.new vsName, @, {}
              vmConfig.call @[iplStateMachines][vsName]
              @[iplStateMachines][vsName].reset()
        return

    @public @static StateMachine: Function,
      default: (asName, ..., amConfig) ->
        @[cplStateMachineConfigs] ?= {}
        if asName is amConfig
          asName = 'default'
        unless @[cplStateMachineConfigs][asName]?
          @[cplStateMachineConfigs][asName] = amConfig
        return

    @public getStateMachine: Function,
      default: (asName) ->
        @[iplStateMachines]?[asName]

    constructor: (args...) ->
      super args...
      @initializeStateMachines()

  return RC::StateMachineMixin.initialize()
