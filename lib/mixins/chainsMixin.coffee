_ = require 'lodash'

###
  Chains
  ```
    @beforeHook 'beforeVerify', only: ['verify']
    @afterHook 'afterVerify', only: ['verify']

    @beforeHook 'beforeCount', only: ['count']
    @afterHook 'afterCount', only: ['count']

    @chains ['verify', 'count'] # если в классе, унаследованном от Model, Controller, CoreObject надо объявить цепи для методов

    constructor: -> # именно в конструкторе надо через методы beforeHook и afterHook объявить методы инстанса класса, которые будут использованы в качестве звеньев цепей
      super

    beforeVerify: ->

    beforeCount: ->

    afterVerify: (data)->
      data

    afterCount: (data)->
      data
  ```
###


module.exports = (RC)->
  class RC::ChainsMixin extends RC::Mixin
    @inheritProtected()

    cplInitialHooks = @protected @static internalInitialHooks: Array,
      default: []
    cplBeforeHooks = @protected @static internalBeforeHooks: Array,
      default: []
    cplAfterHooks = @protected @static internalAfterHooks: Array,
      default: []
    cplFinallyHooks = @protected @static internalFinallyHooks: Array,
      default: []
    cplErrorHooks = @protected @static internalErrorHooks: Array,
      default: []
    cplChains = @protected @static internalChains: Array,
      default: []

    cpmChains = @protected @static getChains: Function,
      default: (AbstractClass = null) ->
        AbstractClass ?= @
        vlChainsFromSuper = if AbstractClass.superclass?()?
          @[cpmChains] AbstractClass.superclass?()
        _.uniq [].concat (vlChainsFromSuper ? []), AbstractClass[cplChains] ? []

    @public @static chains: Function,
      default: (alChains)->
        alChains = [ alChains ]  unless _.isArray alChains
        @[cplChains] ?= []
        @[cplChains].push alChains...
        return

    @public callAsChain: Function,
      default: (methodName, args...) ->
        try
          initialData = @initialAction methodName, args...
          initialData ?= []
          initialData = [initialData]  unless _.isArray initialData
          data = @beforeAction methodName, initialData...
          data ?= []
          data = [data]  unless _.isArray data
          result = @[Symbol.for "chain_#{methodName}"]? data...
          afterResult = @afterAction methodName, result
          @finallyAction methodName, afterResult
        catch err
          @errorInAction methodName, err
          throw err

    cpmDefineHookMethods = @private @static defineHookMethods: Function,
      default: (asHookName) ->
        vsHookNames = "#{asHookName}s"
        vplPointer = Symbol.for "internal#{_.upperFirst vsHookNames}"
        @public @static "#{asHookName}": Function,
          default: (method, options = {}) ->
            @[vplPointer] ?= []
            switch
              when options.only?
                @[vplPointer].push method: method, type: 'only', actions: options.only
              when options.except?
                @[vplPointer].push method: method, type: 'except', actions: options.except
              else
                @[vplPointer].push method: method, type: 'all'
            return
        @public @static "#{vsHookNames}": Function,
          default: (AbstractClass = @) ->
            vlHooksFromSuper = if (ref = AbstractClass.superclass?())?
              @[vsHookNames] ref
            _.uniq [].concat (vlHooksFromSuper ? []), AbstractClass[vplPointer] ? []
        return

    @[cpmDefineHookMethods] methodName  for methodName in [
      'initialHook', 'beforeHook', 'afterHook', 'finallyHook', 'errorHook'
    ]

    ipmCallWithChainNameOnSingle = @private callWithChainNameOnSingle: Function,
      default: (methodName, actionName, singleData) ->
        if _.isFunction @[methodName]
          @[methodName].chainName = actionName
          res = @[methodName] singleData
          delete @[methodName].chainName
          res
        else
          singleData

    ipmCallWithChainNameOnArray = @private callWithChainNameOnArray: Function,
      default: (methodName, actionName, arrayData) ->
        arrayData = [arrayData]  unless _.isArray arrayData
        if _.isFunction @[methodName]
          @[methodName].chainName = actionName
          res = @[methodName] arrayData...
          delete @[methodName].chainName
          res
        else
          arrayData

    @public initialAction: Function,
      default: (action, data...)->
        @constructor.initialHooks().forEach ({method, type, actions})=>
          data = switch
            when type is 'all'
                , type is 'only' and action in actions
                , type is 'except' and action not in actions
              @[ipmCallWithChainNameOnArray] method, action, data
            else
              data
          return
        data

    @public beforeAction: Function,
      default: (action, data...)->
        @constructor.beforeHooks().forEach ({method, type, actions})=>
          data = switch
            when type is 'all'
                , type is 'only' and action in actions
                , type is 'except' and action not in actions
              @[ipmCallWithChainNameOnArray] method, action, data
            else
              data
          return
        data

    @public afterAction: Function,
      default: (action, data)->
        @constructor.afterHooks().forEach ({method, type, actions})=>
          data = switch
            when type is 'all'
                , type is 'only' and action in actions
                , type is 'except' and action not in actions
              @[ipmCallWithChainNameOnSingle] method, action, data
            else
              data
          return
        data

    @public finallyAction: Function,
      default: (action, data)->
        @constructor.finallyHooks().forEach ({method, type, actions})=>
          data = switch
            when type is 'all'
                , type is 'only' and action in actions
                , type is 'except' and action not in actions
              @[ipmCallWithChainNameOnSingle] method, action, data
            else
              data
          return
        data

    @public errorInAction: Function,
      default: (action, err)->
        @constructor.errorHooks().forEach ({method, type, actions})=>
          err = switch
            when type is 'all'
                , type is 'only' and action in actions
                , type is 'except' and action not in actions
              @[ipmCallWithChainNameOnSingle] method, action, err
            else
              err
          return
        err

    @public @static initializeChains: Function,
      default: (args...) ->
        # @super args...
        vlChains = @[cpmChains]()
        if _.isArray vlChains
          for methodName in vlChains# when @[Symbol.for "chain_#{methodName}"]?
            @::[Symbol.for "chain_#{methodName}"] = @::[methodName]
            @public "#{methodName}": Function,
              default: (args...) ->
                @callAsChain methodName, args...
        return


  return RC::ChainsMixin.initialize()
