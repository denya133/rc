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
  {
    ASYNC
  } = RC::

  class RC::ChainsMixin extends RC::Mixin
    @inheritProtected()

    cpmChains = @protected @static getChains: Function,
      default: (AbstractClass = null) ->
        AbstractClass ?= @
        Object.keys AbstractClass.metaObject.getGroup 'chains'

    @public @static chains: Function,
      default: (alChains)->
        alChains = [ alChains ]  unless _.isArray alChains
        for vsChainName in alChains
          @metaObject.addMetaData 'chains', vsChainName, ''
        return

    @public callAsChain: Function,
      default: (methodName, args...) ->
        if @constructor.instanceMethods[methodName].async is ASYNC
          try
            initialData = @initialAction methodName, args...
            initialData ?= []
            initialData = [initialData]  unless _.isArray initialData
            data = @beforeAction methodName, initialData...
            data ?= []
            data = [data]  unless _.isArray data
            result = @[Symbol.for "~chain_#{methodName}"]? data...
            afterResult = @afterAction methodName, result
            @finallyAction methodName, afterResult
          catch err
            @errorAction methodName, err
            throw err
        else
          RC::Utils.co =>
            try
              initialData = yield @initialAction methodName, args...
              initialData ?= []
              initialData = [initialData]  unless _.isArray initialData
              data = yield @beforeAction methodName, initialData...
              data ?= []
              data = [data]  unless _.isArray data
              result = yield @[Symbol.for "~chain_#{methodName}"]? data...
              afterResult = yield @afterAction methodName, result
              yield @finallyAction methodName, afterResult
            catch err
              yield @errorAction methodName, err
              throw err

    ipmCallWithChainNameOnSingle = @private _callWithChainNameOnSingle: Function,
      default: (methodName, actionName, singleData) ->
        if _.isFunction @[methodName]
          @[methodName].chainName = actionName
          res = @[methodName] singleData
          delete @[methodName].chainName
          res
        else
          singleData

    ipmCallWithChainNameOnArray = @private _callWithChainNameOnArray: Function,
      default: (methodName, actionName, arrayData) ->
        arrayData = [arrayData]  unless _.isArray arrayData
        if _.isFunction @[methodName]
          @[methodName].chainName = actionName
          res = @[methodName] arrayData...
          delete @[methodName].chainName
          res
        else
          arrayData

    cpmDefineHookMethods = @private @static _defineHookMethods: Function,
      default: ([asHookName, isArray]) ->
        vsHookNames = "#{asHookName}s"
        vsActionName = "#{asHookName.replace 'Hook', ''}Action"

        @public @static "#{asHookName}": Function,
          default: (method, options = {}) ->
            vlHooks = @metaObject.getGroup('hooks')[vsHookNames] ? []
            switch
              when options.only?
                vlHooks.push method: method, type: 'only', actions: options.only
              when options.except?
                vlHooks.push method: method, type: 'except', actions: options.except
              else
                vlHooks.push method: method, type: 'all'
            @metaObject.addMetaData 'hooks', vsHookNames, vlHooks
            return

        @public @static "#{vsHookNames}": Function,
          default: (AbstractClass = @) ->
            @metaObject.getGroup('hooks')[vsHookNames] ? []

        vsCallWithChainName = if isArray
          ipmCallWithChainNameOnArray
        else
          ipmCallWithChainNameOnSingle

        @public "#{vsActionName}": Function,
          default: (action, data...) ->
            if @constructor.instanceMethods[action].async is ASYNC
              RC::Utils.co =>
                @constructor[vsHookNames]().forEach ({method, type, actions})=>
                  data = switch
                    when type is 'all'
                        , type is 'only' and action in actions
                        , type is 'except' and action not in actions
                      yield @[vsCallWithChainName] method, action, data
                    else
                      data
                  return
                data
            else
              @constructor[vsHookNames]().forEach ({method, type, actions})=>
                data = switch
                  when type is 'all'
                      , type is 'only' and action in actions
                      , type is 'except' and action not in actions
                    @[vsCallWithChainName] method, action, data
                  else
                    data
                return
              data
        return

    @[cpmDefineHookMethods] methodName  for methodName in [
      ['initialHook', yes]
      ['beforeHook', yes]
      ['afterHook', no]
      ['finallyHook', no]
      ['errorHook', no]
    ]

    @public @static initialize: Function,
      configurable: yes
      default: (args...) ->
        @super args...
        vlChains = @[cpmChains]()
        if _.isArray vlChains
          self = @
          for methodName in vlChains
            unless (key = Symbol.for "~chain_#{methodName}") of self::
              do (methodName, self, proto = self::) ->
                descriptor = Reflect.getOwnPropertyDescriptor proto, methodName
                Reflect.defineProperty proto, key, descriptor
                self.public "#{methodName}": Function,
                  default: (args...) ->
                    @callAsChain methodName, args...
        return


  return RC::ChainsMixin.initialize()
