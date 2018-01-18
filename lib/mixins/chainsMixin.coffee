

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


module.exports = (Module)->
  {
    ASYNC
    CoreObject
    Utils: { co, _ }
  } = Module::

  Module.defineMixin 'ChainsMixin', (BaseClass = CoreObject) ->
    class extends BaseClass
      @inheritProtected()

      cpmChains = @protected @static getChains: Function,
        default: (AbstractClass = null) ->
          AbstractClass ?= @
          Object.keys AbstractClass.metaObject.getGroup 'chains'

      @public @static chains: Function,
        default: (alChains)->
          t1 = Date.now()
          alChains = [ alChains ]  unless _.isArray alChains
          for vsChainName in alChains
            @metaObject.addMetaData 'chains', vsChainName, ''
          @____dt += Date.now() - t1
          return

      @public callAsChain: Function,
        default: (methodName, args...) ->
          if @constructor.instanceMethods[methodName].async is ASYNC
            self = @
            co ->
              try
                initialData = yield self.initialAction methodName, args...
                initialData ?= []
                initialData = [initialData]  unless _.isArray initialData
                data = yield self.beforeAction methodName, initialData...
                data ?= []
                data = [data]  unless _.isArray data
                result = yield self[Symbol.for "~chain_#{methodName}"]? data...
                afterResult = yield self.afterAction methodName, result
                yield self.finallyAction methodName, afterResult
              catch err
                yield self.errorAction methodName, err
                throw err
          else
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

      ipmCallWithChainNameOnSingleAsync = @private @async callWithChainNameOnSingleAsync: Function,
        default: (methodName, actionName, singleData) ->
          if _.isFunction @[methodName]
            @[methodName].chainName = actionName
            res = yield Module::Promise.resolve @[methodName] singleData
            delete @[methodName].chainName
            yield return res
          else
            yield return singleData

      ipmCallWithChainNameOnArrayAsync = @private @async callWithChainNameOnArrayAsync: Function,
        default: (methodName, actionName, arrayData) ->
          arrayData = [arrayData]  unless _.isArray arrayData
          if _.isFunction @[methodName]
            @[methodName].chainName = actionName
            res = yield Module::Promise.resolve @[methodName] arrayData...
            delete @[methodName].chainName
            yield return res
          else
            yield return arrayData

      cpmDefineHookMethods = @private @static defineHookMethods: Function,
        default: ([asHookName, isArray]) ->
          vsHookNames = "#{asHookName}s"
          vsActionName = "#{asHookName.replace 'Hook', ''}Action"

          @public @static "#{asHookName}": Function,
            default: (method, options = {}) ->
              t1 = Date.now()
              switch
                when options.only?
                  @metaObject.appendMetaData 'hooks', vsHookNames,
                    method: method
                    type: 'only'
                    actions: options.only
                when options.except?
                  @metaObject.appendMetaData 'hooks', vsHookNames,
                    method: method
                    type: 'except'
                    actions: options.except
                else
                  @metaObject.appendMetaData 'hooks', vsHookNames,
                    method: method
                    type: 'all'
              @____dt += Date.now() - t1
              return

          @public @static "#{vsHookNames}": Function,
            default: ->
              _.uniqWith @metaObject.getGroup('hooks')[vsHookNames] ? []
              , (first, second)->
                first.method is second.method and
                first.type is second.type and
                first.actions?.join(',') is second.actions?.join(',')

          callWithChainName = (isAsync = no)->
            if isArray
              if isAsync
                ipmCallWithChainNameOnArrayAsync
              else
                ipmCallWithChainNameOnArray
            else
              if isAsync
                ipmCallWithChainNameOnSingleAsync
              else
                ipmCallWithChainNameOnSingle

          @public "#{vsActionName}": Function,
            default: (action, data...) ->
              unless isArray
                data = data[0]
              vlHooks = @constructor[vsHookNames]()
              self = @
              if @constructor.instanceMethods[action].async is ASYNC
                co ->
                  for { method, type, actions } in vlHooks
                    data = switch
                      when type is 'all'
                          , type is 'only' and action in actions
                          , type is 'except' and action not in actions
                        yield self[callWithChainName yes] method, action, data
                      else
                        data
                  data
              else
                vlHooks.forEach ({method, type, actions}) ->
                  data = switch
                    when type is 'all'
                        , type is 'only' and action in actions
                        , type is 'except' and action not in actions
                      self[callWithChainName()] method, action, data
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

      @public @static defineChains: Function,
        default: (args...) ->
          t1 = Date.now()
          vlChains = @[cpmChains]()
          if _.isArray vlChains
            self = @
            for methodName in vlChains
              do (methodName, self, proto = self::) ->
                name = "chain_#{methodName}"
                pointer = Symbol.for "~#{name}"
                meta = self.instanceMethods[methodName]
                if meta? and not meta.wrapper.isChain
                  descriptor =
                    configurable: yes
                    enumerable: yes
                    value: meta.wrapper

                  Reflect.defineProperty descriptor.value, 'name',
                    value: name
                    configurable: yes
                  Reflect.defineProperty descriptor.value, 'pointer',
                    value: pointer
                    configurable: yes
                    enumerable: yes
                  Reflect.defineProperty descriptor.value.body, 'name',
                    value: name
                    configurable: yes
                  Reflect.defineProperty descriptor.value.body, 'pointer',
                    value: pointer
                    configurable: yes
                    enumerable: yes

                  # unless (Symbol.for "~chain_#{methodName}") of self::
                  Reflect.defineProperty proto, pointer, descriptor
                  if meta.async is ASYNC
                    self.public self.async "#{methodName}": Function,
                      default: (args...) ->
                        yield @callAsChain methodName, args...
                  else
                    self.public "#{methodName}": Function,
                      default: (args...) ->
                        @callAsChain methodName, args...
                  self::[methodName].isChain = yes
          @____dt += Date.now() - t1
          return

      @public @static initialize: Function,
        default: (args...) ->
          @super args...
          @defineChains()
          return @

      @public @static initializeMixin: Function,
        default: (args...) ->
          @super args...
          @defineChains()
          return @


      @initializeMixin()
