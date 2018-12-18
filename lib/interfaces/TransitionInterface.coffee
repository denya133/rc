

module.exports = (Module)->
  {
    HookedObjectInterface
  } = Module::

  class TransitionInterface extends HookedObjectInterface
    @inheritProtected()
    @module Module

    @virtual @async testGuard: Function

    @virtual @async testIf: Function

    @virtual @async testUnless: Function

    @virtual @async doAfter: Function

    @virtual @async doSuccess: Function


    @initialize()
