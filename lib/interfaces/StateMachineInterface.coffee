

module.exports = (Module)->
  {
    NilT
    MaybeG, DictG, FuncG, ListG, UnionG
    HookedObjectInterface
    StateInterface, TransitionInterface
  } = Module::

  class StateMachineInterface extends HookedObjectInterface
    @inheritProtected()
    @module Module

    @virtual currentState: MaybeG StateInterface

    @virtual initialState: MaybeG StateInterface

    @public states: DictG String, StateInterface

    @virtual @async doBeforeReset: Function

    @virtual @async doAfterReset: Function

    @virtual @async doBeforeAllEvents: Function

    @virtual @async doAfterAllEvents: Function

    @virtual @async doAfterAllTransitions: Function

    @virtual @async doErrorOnAllEvents: Function

    @virtual @async doWithAnchorUpdateState: Function

    @virtual @async doWithAnchorRestoreState: Function

    @virtual @async doWithAnchorSave: Function

    @virtual registerState: FuncG [String, MaybeG Object], StateInterface

    @virtual removeState: FuncG String, Boolean

    @virtual registerEvent: FuncG [String, UnionG(String, ListG String), String, MaybeG(Object), MaybeG Object], NilT

    @virtual @async reset: Function

    @virtual @async send: FuncG String, NilT

    @virtual @async transitionTo: FuncG [StateInterface, TransitionInterface], NilT

    @virtual beforeAllEvents: FuncG String, NilT

    @virtual afterAllTransitions: FuncG String, NilT

    @virtual afterAllEvents: FuncG String, NilT

    @virtual errorOnAllEvents: FuncG String, NilT

    @virtual withAnchorUpdateState: FuncG String, NilT

    @virtual withAnchorSave: FuncG String, NilT

    @virtual withAnchorRestoreState: FuncG String, NilT

    @virtual state: FuncG [String, MaybeG Object], NilT

    @virtual event: FuncG [String, UnionG(Object, Function), MaybeG Function], NilT

    @virtual transition: FuncG [ListG(String), String, MaybeG Object], NilT


    @initialize()
