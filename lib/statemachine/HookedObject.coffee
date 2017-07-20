_ = require 'lodash'

module.exports = (Module)->
  {
    ANY

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
            if isGeneratorFunction anchor[asHook].body ? anchor[asHook]
              yield return anchor[asHook] alArguments...
            else
              yield return Module::Promise.resolve anchor[asHook] alArguments...
          else if _.isString anchor[asHook]
            yield return Module::Promise.resolve anchor.emit? anchor[asHook], alArguments...
          else
            throw new Error asErrorMessage
            yield return
        else
          yield return Module::Promise.resolve aDefaultValue

    @public init: Function,
      default: (@name, anchor) ->
        @super arguments...
        @[ipoAnchor] = anchor  if anchor?


  HookedObject.initialize()
