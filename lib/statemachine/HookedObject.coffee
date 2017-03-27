_ = require 'lodash'

module.exports = (RC)->
  class RC::HookedObject extends RC::CoreObject
    @inheritProtected()

    @Module: RC

    ipoAnchor = @private anchor: RC::Constants.ANY,
      default: null

    ipmDoHook = @protected doHook: Function,
      default: (asHook, alArguments, asErrorMessage, aDefaultValue) ->
        anchor = @[ipoAnchor] ? @
        if asHook?
          if _.isFunction anchor[asHook]
            RC::Promise.resolve anchor[asHook] alArguments...
          else
            RC::Promise.reject new Error asErrorMessage
        else
          RC::Promise.resolve aDefaultValue

    constructor: (@name, anchor)->
      super arguments...
      @[ipoAnchor] = anchor  if anchor?


  return RC::HookedObject.initialize()
