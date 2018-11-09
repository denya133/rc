

module.exports = (Module)->
  {
    HookedObjectInterface
    TransitionInterface
    StateInterface
  } = Module::

  class EventInterface extends HookedObjectInterface
    @inheritProtected()
    @module Module

    @virtual transition: TransitionInterface

    @virtual target: StateInterface

    @virtual @async testGuard: Function

    @virtual @async testIf: Function

    @virtual @async testUnless: Function

    @virtual @async doBefore: Function

    @virtual @async doAfter: Function

    @virtual @async doSuccess: Function

    @virtual @async doError: Function


    @initialize()
