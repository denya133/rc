_ = require 'lodash'

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

    ipoAnchor = @private anchor: RC::Constants.ANY,
      default: null

    ipsGuard = @private guard: String,
      default: null

    ipsAfter = @private after: String,
      default: null

    ipsSuccess = @private success: String,
      default: null

    @public testGuard: Function,
      default: (args...) ->
        anchor = @[ipoAnchor] ? @
        if (vsGuard = @[ipsGuard])?
          if _.isFunction anchor[vsGuard]
            RC::Promise.resolve anchor[vsGuard] args...
          else
            RC::Promise.reject new Error 'Specified guard not found'
        else
          RC::Promise.resolve()

    @public doAfter: Function,
      default: (args...) ->
        anchor = @[ipoAnchor] ? @
        if (vsAfter = @[ipsAfter])?
          if _.isFunction anchor[vsAfter]
            RC::Promise.resolve anchor[vsAfter] args...
          else
            RC::Promise.reject new Error 'Specified after not found'
        else
          RC::Promise.resolve()

    @public doSuccess: Function,
      default: (args...) ->
        anchor = @[ipoAnchor] ? @
        if (vsSuccess = @[ipsSuccess])?
          if _.isFunction anchor[vsSuccess]
            RC::Promise.resolve anchor[vsSuccess] args...
          else
            RC::Promise.reject new Error 'Specified success not found'
        else
          RC::Promise.resolve()

    constructor: (@name, anchor, ..., config = {})->
      super arguments...
      @[ipoAnchor] = anchor  if anchor?
      {
        guard: @[ipsGuard]
        after: @[ipsAfter]
        success: @[ipsSuccess]
      } = config


  return RC::Transition.initialize()
