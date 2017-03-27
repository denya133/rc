
###
State instances for StateMachine class

Inspiration:

- https://github.com/PureMVC/puremvc-js-util-statemachine
- https://github.com/aasm/aasm
###

module.exports = (RC)->
  class RC::State extends RC::CoreObject
    @inheritProtected()

    @Module: RC

    iphTransitions = @private transitions: Object,
      default: {}

    @public getTransitions: Function,
      default: -> @[iphTransitions]

    @public name: String,
      default: null

    @public getTransition: Function,
      default: (asEvent) ->
        @[iphTransitions][asEvent]

    @public addTransition: Function,
      default: (asEvent, aoTarget, aoTransition) ->
        unless @[iphTransitions][asEvent]?
          @[iphTransitions][asEvent] =
            target: aoTarget
            transition: aoTransition
        @[iphTransitions][asEvent]

    @public removeTransition: Function,
      default: (asEvent) ->
        if @[iphTransitions][asEvent]?
          delete @[iphTransitions][asEvent].transition
          delete @[iphTransitions][asEvent].target
          delete @[iphTransitions][asEvent]
        return

    constructor: (@name, config = {})->
      super arguments...


  return RC::State.initialize()
