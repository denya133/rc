

module.exports = (RC)->
  class RC::MetaObject
    iphData = Symbol.for '~data'
    ipoParent = Symbol.for '~parent'
    ipoTarget = Symbol.for '~target'

    Reflect.defineProperty @::, 'data',
      get: -> @[iphData]

    Reflect.defineProperty @::, 'parent',
      get: -> @[ipoParent]

    Reflect.defineProperty @::, 'target',
      get: -> @[ipoTarget]

    Reflect.defineProperty @::, 'addMetaData',
      value: (asGroup, asKey, ahMetaData) ->
        @[iphData][asGroup] ?= {}
        Reflect.defineProperty @[iphData][asGroup], asKey,
          configurable: yes
          enumerable: yes
          value: ahMetaData
        return

    Reflect.defineProperty @::, 'appendMetaData',
      value: (asGroup, asKey, ahMetaData) ->
        @[iphData][asGroup] ?= {}
        if (list = @[iphData][asGroup][asKey])?
          list.push ahMetaData
        else
          list = [ ahMetaData ]
          Reflect.defineProperty @[iphData][asGroup], asKey,
            configurable: yes
            enumerable: yes
            value: list
        return

    Reflect.defineProperty @::, 'removeMetaData',
      value: (asGroup, asKey) ->
        if @[iphData][asGroup]?
          Reflect.deleteProperty @[iphData][asGroup], asKey
        return

    Reflect.defineProperty @::, 'collectGroup',
      value: (asGroup, collector = []) ->
        collector = collector.concat @[ipoParent]?.collectGroup?(asGroup, collector) ? []
        collector.push @[iphData][asGroup] ? {}
        collector

    Reflect.defineProperty @::, 'getGroup',
      value: (asGroup, abDeep = yes) ->
        assign = if abDeep then RC::assign else Object.assign
        vhGroup = assign {}, (@collectGroup asGroup)...
        vhGroup

    Reflect.defineProperty @::, 'getOwnGroup',
      value: (asGroup) -> @[iphData][asGroup] ? {}

    constructor: (target, parent) ->
      @[ipoTarget] = target
      @[ipoParent] = parent
      @[iphData] = {}
      for own key of parent?.data
        @[iphData][key] = {}


  RC::MetaObject
