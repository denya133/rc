
###
Transition instances for StateMachine class

Inspiration:

- https://github.com/PureMVC/puremvc-js-util-statemachine
- https://github.com/aasm/aasm
###

module.exports = (RC)->
  class RC::Transition extends RC::CoreObject
    @inheritProtected()

    @Module: RC

    @public name: String,
      default: null

    @public state: RC::State,
      default: null

    constructor: (@name, config = {})->
      super arguments...


  return RC::Transition.initialize()
