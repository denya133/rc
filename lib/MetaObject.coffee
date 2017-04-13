

module.exports = (RC)->
  class RC::MetaObject extends RC::CoreObject
    @inheritProtected()

    @Module: RC

    @public data: Object,
      default: null

    @public parent: RC::MetaObject,
      default: null

    @public addMetaData: Function,
      default: (asGroup, asKey, ahMetaData) ->
        @data[asGroup] ?= {}
        Reflect.defineProperty @data[asGroup], asKey,
          configurable: yes
          value: ahMetaData
        return

    @public removeMetaData: Function,
      default: (asGroup, asKey) ->
        if @data[asGroup]?
          Reflect.deleteProperty @data[asGroup], asKey
        return

    constructor: (args...) ->
      super args...
      @data = {}
      @parent = args[0]

  return RC::MetaObject.initialize()
