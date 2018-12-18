

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
    AnyT, NilT, PointerT
    FuncG, UnionG, ListG, SubsetG, TupleG, MaybeG, InterfaceG, EnumG
    CoreObject
    Mixin
    Utils: { co, _ }
  } = Module::

  Module.defineMixin Mixin 'ChainsMixin', (BaseClass = CoreObject) ->
    class extends BaseClass
      @inheritProtected()

      cpmChains = PointerT @protected @static getChains: FuncG([MaybeG SubsetG CoreObject], ListG String),
        default: (AbstractClass = null) ->
          AbstractClass ?= @
          Object.keys AbstractClass.metaObject.getOwnGroup 'chains'

      @public @static chains: FuncG([UnionG String, ListG String], NilT),
        default: (alChains)->
          alChains = _.castArray alChains
          for vsChainName in alChains
            @metaObject.addMetaData 'chains', vsChainName, ''
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

      ipmCallWithChainNameOnSingle = PointerT @private callWithChainNameOnSingle: FuncG([String, String, MaybeG AnyT], MaybeG AnyT),
        default: (methodName, actionName, singleData) ->
          if _.isFunction @[methodName]
            @[methodName].chainName = actionName
            res = @[methodName] singleData
            delete @[methodName].chainName
            res
          else
            singleData

      ipmCallWithChainNameOnArray = PointerT @private callWithChainNameOnArray: FuncG([String, String, Array], Array),
        default: (methodName, actionName, arrayData) ->
          arrayData = _.castArray arrayData
          if _.isFunction @[methodName]
            @[methodName].chainName = actionName
            res = @[methodName] arrayData...
            delete @[methodName].chainName
            res
          else
            arrayData

      ipmCallWithChainNameOnSingleAsync = PointerT @private @async callWithChainNameOnSingleAsync: FuncG([String, String, MaybeG AnyT], MaybeG AnyT),
        default: (methodName, actionName, singleData) ->
          if _.isFunction @[methodName]
            @[methodName].chainName = actionName
            res = yield Module::Promise.resolve @[methodName] singleData
            delete @[methodName].chainName
            yield return res
          else
            yield return singleData

      ipmCallWithChainNameOnArrayAsync = PointerT @private @async callWithChainNameOnArrayAsync: FuncG([String, String, Array], Array),
        default: (methodName, actionName, arrayData) ->
          arrayData = _.castArray arrayData
          if _.isFunction @[methodName]
            @[methodName].chainName = actionName
            res = yield Module::Promise.resolve @[methodName] arrayData...
            delete @[methodName].chainName
            yield return res
          else
            yield return arrayData

      cpmDefineHookMethods = PointerT @private @static defineHookMethods: FuncG([TupleG String, Boolean], NilT),
        default: ([asHookName, isArray]) ->
          vsHookNames = "#{asHookName}s"
          vsActionName = "#{asHookName.replace 'Hook', ''}Action"

          @public @static "#{asHookName}": FuncG([String, MaybeG InterfaceG {
            only: MaybeG UnionG String, ListG String
            except: MaybeG UnionG String, ListG String
          }], NilT),
            default: (method, options = {}) ->
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
              return

          @public @static "#{vsHookNames}": FuncG([], ListG InterfaceG {
            method: String
            type: EnumG 'only', 'except', 'all'
            actions: MaybeG UnionG String, ListG String
          }),
            default: ->
              _.uniqWith @metaObject.getGroup('hooks')[vsHookNames] ? []
              , (first, second)->
                first.method is second.method and
                first.type is second.type and
                first.actions?.join(',') is second.actions?.join(',')

          callWithChainName = FuncG([MaybeG Boolean], PointerT) (isAsync = no)->
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
        default: ->
          vlChains = @[cpmChains]()
          unless _.isEmpty vlChains
            { instanceMethods } = self = @
            for methodName in vlChains
              do (methodName, self, proto = self::) ->
                name = "chain_#{methodName}"
                pointer = Symbol.for "~#{name}"
                meta = instanceMethods[methodName]
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
                    self.public self.async "#{methodName}": meta.attrType,
                      default: (args...) ->
                        yield @callAsChain methodName, args...
                  else
                    self.public "#{methodName}": meta.attrType,
                      default: (args...) ->
                        @callAsChain methodName, args...
                  self::[methodName].isChain = yes
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
