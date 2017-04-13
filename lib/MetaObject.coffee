

module.exports = (RC)->
  class RC::MetaObject extends RC::CoreObject
    @inheritProtected()

    @Module: RC

    iphData = @protected data: Object,
      default: null
    ipoParent = @protected parent: RC::MetaObject,
      default: null

    @public data: Object,
      get: -> @[iphData]

    @public parent: RC::MetaObject,
      get: -> @[ipoParent]

    @public addMetaData: Function,
      default: (asGroup, asKey, ahMetaData) ->
        @[iphData][asGroup] ?= {}
        Reflect.defineProperty @[iphData][asGroup], asKey,
          configurable: yes
          enumerable: yes
          value: ahMetaData
        return

    @public removeMetaData: Function,
      default: (asGroup, asKey) ->
        if @[iphData][asGroup]?
          Reflect.deleteProperty @[iphData][asGroup], asKey
        return

    @public getGroup: Function,
      default: (asGroup) ->
        vhGroup = RC::Utils.extend {}
        , @[ipoParent]?.getGroup?(asGroup) ? {}
        , @[iphData][asGroup] ? {}
        vhGroup

    constructor: (parent) ->
      super arguments...
      @[iphData] = {}
      @[ipoParent] = parent

  return RC::MetaObject.initialize()
