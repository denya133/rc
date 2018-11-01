

module.exports = (Module)->
  {
    NilT
    FuncG
    Interface
  } = Module::

  class HookedObjectInterface extends Interface
    @inheritProtected()
    @module Module

    @virtual init: FuncG [String, Object], NilT


    @initialize()
