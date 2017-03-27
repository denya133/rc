
###
Stand-alone or mixed-in class (via StateMachineMixin)

Inspiration:

- https://github.com/PureMVC/puremvc-js-util-statemachine
- https://github.com/aasm/aasm
###

module.exports = (RC)->
  class RC::StateMachine extends RC::HookedObject
    @inheritProtected()

    @Module: RC

    @public name: String,
      default: null

    @public state: String,
      default: null


    constructor: (@name, anchor, ..., config = {})->
      super arguments...


  return RC::StateMachine.initialize()
