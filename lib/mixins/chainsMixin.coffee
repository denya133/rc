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

    @public @static initialHook: Function,
      default: (method, options = {})->
        @[cplInitialHooks] ?= []
        switch
          when options.only?
            @[cplInitialHooks].push method: method, type: 'only', actions: options.only
          when options.except?
            @[cplInitialHooks].push method: method, type: 'except', actions: options.except
          else
            @[cplInitialHooks].push method: method, type: 'all'
        return

    @public @static beforeHook: Function,
      default: (method, options = {})->
        @[cplBeforeHooks] ?= []
        switch
          when options.only?
            @[cplBeforeHooks].push method: method, type: 'only', actions: options.only
          when options.except?
            @[cplBeforeHooks].push method: method, type: 'except', actions: options.except
          else
            @[cplBeforeHooks].push method: method, type: 'all'
        return

    @public @static afterHook: Function,
      default: (method, options = {})->
        @[cplAfterHooks] ?= []
        switch
          when options.only?
            @[cplAfterHooks].push method: method, type: 'only', actions: options.only
          when options.except?
            @[cplAfterHooks].push method: method, type: 'except', actions: options.except
          else
            @[cplAfterHooks].push method: method, type: 'all'
        return

    @public @static finallyHook: Function,
      default: (method, options = {})->
        @[cplFinallyHooks] ?= []
        switch
          when options.only?
            @[cplFinallyHooks].push method: method, type: 'only', actions: options.only
          when options.except?
            @[cplFinallyHooks].push method: method, type: 'except', actions: options.except
          else
            @[cplFinallyHooks].push method: method, type: 'all'
        return

    @public @static errorHook: Function,
      default: (method, options = {})->
        @[cplErrorHooks] ?= []
        switch
          when options.only?
            @[cplErrorHooks].push method: method, type: 'only', actions: options.only
          when options.except?
            @[cplErrorHooks].push method: method, type: 'except', actions: options.except
          else
            @[cplErrorHooks].push method: method, type: 'all'
        return

    @public @static initialHooks: Function,
      default: (AbstractClass = null)->
        AbstractClass ?= @
        vlHooksFromSuper = if AbstractClass.superclass?()?
          @initialHooks AbstractClass.superclass?()
        _.uniq [].concat (vlHooksFromSuper ? []), AbstractClass[cplInitialHooks] ? []

    @public @static beforeHooks: Function,
      default: (AbstractClass = null)->
        AbstractClass ?= @
        vlHooksFromSuper = if AbstractClass.superclass?()?
          @beforeHooks AbstractClass.superclass?()
        _.uniq [].concat (vlHooksFromSuper ? []), AbstractClass[cplBeforeHooks] ? []

    @public @static afterHooks: Function,
      default: (AbstractClass = null)->
        AbstractClass ?= @
        vlHooksFromSuper = if AbstractClass.superclass?()?
          @afterHooks AbstractClass.superclass?()
        _.uniq [].concat (vlHooksFromSuper ? []), AbstractClass[cplAfterHooks] ? []

    @public @static finallyHooks: Function,
      default: (AbstractClass = null)->
        AbstractClass ?= @
        vlHooksFromSuper = if AbstractClass.superclass?()?
          @finallyHooks AbstractClass.superclass?()
        _.uniq [].concat (vlHooksFromSuper ? []), AbstractClass[cplFinallyHooks] ? []

    @public @static errorHooks: Function,
      default: (AbstractClass = null)->
        AbstractClass ?= @
        vlHooksFromSuper = if AbstractClass.superclass?()?
          @errorHooks AbstractClass.superclass?()
        _.uniq [].concat (vlHooksFromSuper ? []), AbstractClass[cplErrorHooks] ? []

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
        console.log '555'
        @constructor.errorHooks().forEach ({method, type, actions})=>
          err = switch
            when type is 'all'
                , type is 'only' and action in actions
                , type is 'except' and action not in actions
              @[ipmCallWithChainNameOnSingle] method, action, data
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
