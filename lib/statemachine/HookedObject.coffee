_ = require 'lodash'

module.exports = (Module)->
  {
    ANY

    CoreObject
  } = Module::

  class HookedObject extends CoreObject
    @inheritProtected()
    @module Module

    ipoAnchor = @protected anchor: ANY,
      default: null

    ipmDoHook = @protected doHook: Function,
      default: (asHook, alArguments, asErrorMessage, aDefaultValue) ->
        anchor = @[ipoAnchor] ? @
        if asHook?
          if _.isFunction anchor[asHook]
            Module::Promise.resolve anchor[asHook] alArguments...
          else if _.isString anchor[asHook]
            Module::Promise.resolve anchor.emit? anchor[asHook], alArguments...
          else
            Module::Promise.reject new Error asErrorMessage
        else
          Module::Promise.resolve aDefaultValue

    @public init: Function,
      default: (@name, anchor) ->
        @super arguments...
        @[ipoAnchor] = anchor  if anchor?


  HookedObject.initialize()
