

module.exports = (RC)->
  class RC::MetaObject
    iphData = Symbol.for '~data'
    ipoParent = Symbol.for '~parent'

    Reflect.defineProperty @::, 'data',
      get: -> @[iphData]

    Reflect.defineProperty @::, 'parent',
      get: -> @[ipoParent]

    Reflect.defineProperty @::, 'addMetaData',
      value: (asGroup, asKey, ahMetaData) ->
        @[iphData][asGroup] ?= {}
        Reflect.defineProperty @[iphData][asGroup], asKey,
          configurable: yes
          enumerable: yes
          value: ahMetaData
        return

    Reflect.defineProperty @::, 'removeMetaData',
      value: (asGroup, asKey) ->
        if @[iphData][asGroup]?
          Reflect.deleteProperty @[iphData][asGroup], asKey
        return

    Reflect.defineProperty @::, 'getGroup',
      value: (asGroup) ->
        vhGroup = RC::Utils.extend {}
        , @[ipoParent]?.getGroup?(asGroup) ? {}
        , @[iphData][asGroup] ? {}
        vhGroup

    constructor: (parent) ->
      @[iphData] = {}
      @[ipoParent] = parent

  return RC::MetaObject
