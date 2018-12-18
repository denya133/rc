

module.exports = (Module)->
  {
    Interface
  } = Module::

  class HookedObjectInterface extends Interface
    @inheritProtected()
    @module Module

    @virtual name: String


    @initialize()
