

module.exports = (Module)->
  {
    NilT
    FuncG, DictG, MaybeG
    EventInterface
    TransitionInterface
    StateMachineInterface
    HookedObjectInterface
    StateInterface: StateInterfaceDefinition
  } = Module::

  class StateInterface extends HookedObjectInterface
    @inheritProtected()
    @module Module

    @virtual getEvents: FuncG [], DictG String, EventInterface

    @virtual initial: Boolean

    @virtual getEvent: FuncG String, MaybeG EventInterface

    @virtual defineTransition: FuncG [String, StateInterfaceDefinition, TransitionInterface, MaybeG Object], EventInterface

    @virtual removeTransition: FuncG String, NilT

    @virtual @async doBeforeEnter: Function

    @virtual @async doEnter: Function

    @virtual @async doAfterEnter: Function

    @virtual @async doBeforeExit: Function

    @virtual @async doExit: Function

    @virtual @async doAfterExit: Function

    @virtual @async send: FuncG String, NilT


    @initialize()
