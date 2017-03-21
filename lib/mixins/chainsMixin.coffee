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

    cplInitialHooks = @protected @static "initialHooks",
      default: []
    cplBeforeHooks = @protected @static "beforeHooks",
      default: []
    cplAfterHooks = @protected @static "afterHooks",
      default: []
    cplFinallyHooks = @protected @static "finallyHooks",
      default: []
    cplErrorHooks = @protected @static "errorHooks",
      default: []
    cplChains = @protected @static "chains",
      default: []

    cpmChains = @protected @static 'chains',
      default: (AbstractClass = null) ->
        AbstractClass ?= @
        vlChainsFromSuper = if @superclass?
          @[cpmChains] @superclass
        _.uniq [].concat (vlChainsFromSuper ? []), AbstractClass[cplChains] ? []

    @public @static 'chains',
      default: (alChains)->
        alChains = [ alChains ]  unless _.isArray alChains
        @[cplChains] ?= []
        @[cplChains].push alChains...

        @[cplChains].forEach (methodName) =>
          # @::["_#{methodName}Collections"] = ->
          #   @collectionsInChain methodName
          # @::["_#{methodName}Methods"] = ->
          #   @methodsInChain methodName
        return

    @public 'callAsChain',
      default: (methodName, args...) ->
        # try
        #   initialData = @initialAction methodName, args...
        #   if initialData?.constructor isnt Array
        #     initialData = [initialData]
        #   data = @beforeAction methodName, initialData...
        #   if data?.constructor isnt Array
        #     data = [data]
        #   result = @["_#{methodName}"]? data...
        #   afterResult = @afterAction methodName, result
        #   @finallyAction methodName, afterResult
        # catch err
        #   @errorInAction methodName, err
        #   throw err

    @public 'collectionsInChain',
      default: (methodName)->
        obj = read: [], write: []
        updateObj = (_method)=>
          if _.isFunction @[_method]
            { read, write } = @[_method]()
            read ?= []
            read = [ read ]  unless _.isArray read
            obj.read = _.uniq obj.read.concat read
            write ?= []
            write = [ write ]  unless _.isArray write
            obj.write = _.uniq obj.write.concat write
          return
        @constructor.initialHooks().forEach ({method, type, actions})->
          if type is 'all'
            updateObj "#{method}Collections"
          else if type is 'only' and methodName in actions
            updateObj "#{method}Collections"
          else if type is 'except' and methodName not in actions
            updateObj "#{method}Collections"
          return
        @constructor.beforeHooks().forEach ({method, type, actions})->
          if type is 'all'
            updateObj "#{method}Collections"
          else if type is 'only' and methodName in actions
            updateObj "#{method}Collections"
          else if type is 'except' and methodName not in actions
            updateObj "#{method}Collections"
          return
        # updateObj "_#{method}Collections"
        @constructor.afterHooks().forEach ({method, type, actions})->
          if type is 'all'
            updateObj "#{method}Collections"
          else if type is 'only' and methodName in actions
            updateObj "#{method}Collections"
          else if type is 'except' and methodName not in actions
            updateObj "#{method}Collections"
          return
        @constructor.finallyHooks().forEach ({method, type, actions})->
          if type is 'all'
            updateObj "#{method}Collections"
          else if type is 'only' and methodName in actions
            updateObj "#{method}Collections"
          else if type is 'except' and methodName not in actions
            updateObj "#{method}Collections"
          return
        obj

    @public 'methodsInChain',
      default: (methodName)->
        array = []
        updateArray = (_method)=>
          if _.isFunction @[_method]
            _array = @[_method]()
            _array = [ _array ]  unless _.isArray _array
          if @[_method]? and @[_method].constructor is Function
            array = _.uniq array.concat _array
          return
        @constructor.initialHooks().forEach ({method, type, actions})=>
          if type is 'all'
            updateArray "#{method}Methods"
          else if type is 'only' and methodName in actions
            updateArray "#{method}Methods"
          else if type is 'except' and methodName not in actions
            updateArray "#{method}Methods"
          return
        @constructor.beforeHooks().forEach ({method, type, actions})=>
          if type is 'all'
            updateArray "#{method}Methods"
          else if type is 'only' and methodName in actions
            updateArray "#{method}Methods"
          else if type is 'except' and methodName not in actions
            updateArray "#{method}Methods"
          return
        # updateArray "_#{method}Methods"
        @constructor.afterHooks().forEach ({method, type, actions})=>
          if type is 'all'
            updateArray "#{method}Methods"
          else if type is 'only' and methodName in actions
            updateArray "#{method}Methods"
          else if type is 'except' and methodName not in actions
            updateArray "#{method}Methods"
          return
        @constructor.finallyHooks().forEach ({method, type, actions})=>
          if type is 'all'
            updateArray "#{method}Methods"
          else if type is 'only' and methodName in actions
            updateArray "#{method}Methods"
          else if type is 'except' and methodName not in actions
            updateArray "#{method}Methods"
          return
        array

    @public @static 'initialHook', default: (method, options = {})->
      @[cplInitialHooks] ?= []
      switch
        when options.only?
          @[cplInitialHooks].push method: method, type: 'only', actions: options.only
        when options.except?
          @[cplInitialHooks].push method: method, type: 'except', actions: options.except
        else
          @[cplInitialHooks].push method: method, type: 'all'
      return

    @public @static 'beforeHook', default: (method, options = {})->
      @[cplBeforeHooks] ?= []
      switch
        when options.only?
          @[cplBeforeHooks].push method: method, type: 'only', actions: options.only
        when options.except?
          @[cplBeforeHooks].push method: method, type: 'except', actions: options.except
        else
          @[cplBeforeHooks].push method: method, type: 'all'
      return

    @public @static 'afterHook', default: (method, options = {})->
      @[cplAfterHooks] ?= []
      switch
        when options.only?
          @[cplAfterHooks].push method: method, type: 'only', actions: options.only
        when options.except?
          @[cplAfterHooks].push method: method, type: 'except', actions: options.except
        else
          @[cplAfterHooks].push method: method, type: 'all'
      return

    @public @static 'finallyHook', default: (method, options = {})->
      @[cplFinallyHooks] ?= []
      switch
        when options.only?
          @[cplFinallyHooks].push method: method, type: 'only', actions: options.only
        when options.except?
          @[cplFinallyHooks].push method: method, type: 'except', actions: options.except
        else
          @[cplFinallyHooks].push method: method, type: 'all'
      return

    @public @static 'errorHook', default: (method, options = {})->
      @[cplErrorHooks] ?= []
      switch
        when options.only?
          @[cplErrorHooks].push method: method, type: 'only', actions: options.only
        when options.except?
          @[cplErrorHooks].push method: method, type: 'except', actions: options.except
        else
          @[cplErrorHooks].push method: method, type: 'all'
      return

    @public @static 'initialHooks', default: (AbstractClass = null)->
      AbstractClass ?= @
      vlHooksFromSuper = if AbstractClass.superclass?
        @initialHooks AbstractClass.superclass
      _.uniq [].concat (vlHooksFromSuper ? []), AbstractClass[cplInitialHooks] ? []

    @public @static 'beforeHooks', default: (AbstractClass = null)->
      AbstractClass ?= @
      vlHooksFromSuper = if AbstractClass.superclass?
        @beforeHooks AbstractClass.superclass
      _.uniq [].concat (vlHooksFromSuper ? []), AbstractClass[cplBeforeHooks] ? []

    @public @static 'afterHooks', default: (AbstractClass = null)->
      AbstractClass ?= @
      vlHooksFromSuper = if AbstractClass.superclass?
        @afterHooks AbstractClass.superclass
      _.uniq [].concat (vlHooksFromSuper ? []), AbstractClass[cplAfterHooks] ? []

    @public @static 'finallyHooks', default: (AbstractClass = null)->
      AbstractClass ?= @
      vlHooksFromSuper = if AbstractClass.superclass?
        @finallyHooks AbstractClass.superclass
      _.uniq [].concat (vlHooksFromSuper ? []), AbstractClass[cplFinallyHooks] ? []

    @public @static 'errorHooks', default: (AbstractClass = null)->
      AbstractClass ?= @
      vlHooksFromSuper = if AbstractClass.superclass?
        @errorHooks AbstractClass.superclass
      _.uniq [].concat (vlHooksFromSuper ? []), AbstractClass[cplErrorHooks] ? []

    @public 'initialAction', default: (action, data...)->
      @constructor.initialHooks().forEach ({method, type, actions})=>
        callWithChainName = (_data=data)=>
          _data = [_data]  unless _.isArray _data
          if _.isFunction @[method]
            @[method].chainName = action
            res = @[method] _data...
            delete @[method].chainName
            res
          else
            _data
        data = switch
          when type is 'all'
              , type is 'only' and action in actions
              , type is 'except' and action not in actions
            do callWithChainName
          else
            data
        return
      data

    @public 'beforeAction', default: (action, data...)->
      @constructor.beforeHooks().forEach ({method, type, actions})=>
        callWithChainName = (_data=data)=>
          _data = [_data]  unless _.isArray _data
          if _.isFunction @[method]
            @[method].chainName = action
            res = @[method] _data...
            delete @[method].chainName
            res
          else
            _data
        data = switch
          when type is 'all'
              , type is 'only' and action in actions
              , type is 'except' and action not in actions
            do callWithChainName
          else
            data
        return
      data

    @public 'afterAction', default: (action, data)->
      @constructor.afterHooks().forEach ({method, type, actions})=>
        callWithChainName = (_data=data)=>
          if _.isFunction @[method]
            @[method].chainName = action
            res = @[method] _data
            delete @[method].chainName
            res
          else
            _data
        data = switch
          when type is 'all'
              , type is 'only' and action in actions
              , type is 'except' and action not in actions
            do callWithChainName
          else
            data
        return
      data

    @public 'finallyAction', default: (action, data)->
      @constructor.finallyHooks().forEach ({method, type, actions})=>
        callWithChainName = (_data=data)=>
          if _.isFunction @[method]
            @[method].chainName = action
            res = @[method] _data
            delete @[method].chainName
            res
          else
            _data
        data = switch
          when type is 'all'
              , type is 'only' and action in actions
              , type is 'except' and action not in actions
            do callWithChainName
          else
            data
        return
      data

    @public 'errorInAction', default: (action, err)->
      @constructor.errorHooks().forEach ({method, type, actions})=>
        callWithChainName = (_err=err)=>
          if _.isFunction @[method]
            @[method].chainName = action
            res = @[method] _err
            delete @[method].chainName
            res
          else
            _err
        err = switch
          when type is 'all'
              , type is 'only' and action in actions
              , type is 'except' and action not in actions
            do callWithChainName
          else
            err
        return
      err

    @public @static 'including', default: ->
      vlChains = @[cpmChains]()
      if _.isArray vlChains
        vlChains.forEach (methodName) =>
          @::["_#{methodName}"] = @::[methodName]
          @::[methodName] = (args...) ->
            @callAsChain methodName, args...
      return


  return RC::ChainsMixin.initialize()
