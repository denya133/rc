_ = require 'lodash'

module.exports = (RC)->
  class RC::HookedObject extends RC::CoreObject
    @inheritProtected()

    @Module: RC

    ipoAnchor = @protected anchor: RC::ANY,
      default: null

    ipmDoHook = @protected doHook: Function,
      default: (asHook, alArguments, asErrorMessage, aDefaultValue) ->
        anchor = @[ipoAnchor] ? @
        if asHook?
          if _.isFunction anchor[asHook]
            RC::Promise.resolve anchor[asHook] alArguments...
          else if _.isString anchor[asHook]
            RC::Promise.resolve anchor.emit? anchor[asHook], alArguments...
          else
            RC::Promise.reject new Error asErrorMessage
        else
          RC::Promise.resolve aDefaultValue

    @public init: Function,
      default: (@name, anchor) ->
        @super arguments...
        @[ipoAnchor] = anchor  if anchor?


  RC::HookedObject.initialize()
