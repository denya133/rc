_ = require 'lodash'

module.exports = (Module)->
  {
    ANY
    ASYNC

    CoreObject
    Utils: { isGeneratorFunction }
  } = Module::

  class HookedObject extends CoreObject
    @inheritProtected()
    @module Module

    ipoAnchor = @protected anchor: ANY,
      default: null

    ipmDoHook = @protected @async doHook: Function,
      default: (asHook, alArguments, asErrorMessage, aDefaultValue) ->
        anchor = @[ipoAnchor] ? @
        if asHook?
          if _.isFunction anchor[asHook]
            if anchor.constructor.instanceMethods[asHook].async is ASYNC
              return yield anchor[asHook] alArguments...
            else if isGeneratorFunction anchor[asHook].body ? anchor[asHook]
              return yield from anchor[asHook] alArguments...
            else
              return yield Module::Promise.resolve anchor[asHook] alArguments...
          else if _.isString anchor[asHook]
            return yield Module::Promise.resolve anchor.emit? anchor[asHook], alArguments...
          else
            throw new Error asErrorMessage
        else
          return yield Module::Promise.resolve aDefaultValue

    @public init: Function,
      default: (@name, anchor) ->
        @super arguments...
        @[ipoAnchor] = anchor  if anchor?


  HookedObject.initialize()
