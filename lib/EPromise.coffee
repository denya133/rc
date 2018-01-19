# здесь должна быть синхронная реализация Промиса. А в ноде будет использоваться нативный класс с тем же интерфейсом.
# внутри этой реализации надо в приватное свойство положить синхронный промис с предпроверкой (если нативный определен - то должен быть положен нативный)

module.exports = (RC)->
  {
    ANY
    NILL

    CoreObject
    # PromiseInterface
    Utils
  } = RC::

  isArango = Utils.isArangoDB()

  class Handler
    constructor: (onFulfilled, onRejected, @promise) ->
      @onFulfilled = if typeof onFulfilled is 'function' then onFulfilled else null
      @onRejected = if typeof onRejected is 'function' then onRejected else null

  class RC::EPromise
    Module: RC
    @Module: RC

    INITIAL: Symbol.for 'initial'
    PENDING: Symbol.for 'pending'
    FULFILLED: Symbol.for 'fulfilled'
    REJECTED: Symbol.for 'rejected'
    NATIVE: Symbol.for 'native'

    START: Symbol.for 'start'
    RESOLVE: Symbol.for 'resolve'
    REJECT: Symbol.for 'reject'

    cpcPromise = Symbol '_Promise'
    ipoPromise = Symbol '_promise'
    ipoData = Symbol '_data'
    ipsState = Symbol '_state'
    ipoEmitter = Symbol '_emitter'
    ipoResult = Symbol '_result'
    ipmLambda = Symbol '_lambda'

    @new = (args...) -> Reflect.construct RC::EPromise, args

    noop = ->

    @createEmitter = ->
      EventEmitter = require 'events'
      new EventEmitter

    Reflect.defineProperty @, 'length',
      enumerable: yes
      configurable: no
      get: -> 1

    Reflect.defineProperty @, cpcPromise,
      enumerable: no
      configurable: no
      get: (_data)->
        if isArango or not Utils.hasNativePromise()
          null
        else
          global.Promise

    Reflect.defineProperty @, 'all',
      enumerable: yes
      configurable: no
      value: (iterable)->
        if (vcPromise = @[cpcPromise])?
          vcPromise.all iterable
        else
          data = []
          voPromise = iterable.reduce (aoPromise, item) ->
            aoPromise.then ->
              RC::EPromise.resolve item
            .then (resolved) ->
              data.push resolved
              return
          , RC::EPromise.resolve()
          return voPromise.then -> data

    Reflect.defineProperty @, 'reject',
      enumerable: yes
      configurable: no
      value: (aoError)->
        if (vcPromise = @[cpcPromise])?
          vcPromise.reject aoError
        else
          RC::EPromise.new (resolve, reject)->
            reject aoError

    Reflect.defineProperty @, 'resolve',
      enumerable: yes
      configurable: no
      value: (aoData)->
        if (vcPromise = @[cpcPromise])?
          vcPromise.resolve aoData
        else
          if Utils.isThenable aoData
            aoData
          else
            RC::EPromise.new (resolve, reject)->
              resolve aoData

    Reflect.defineProperty @::, 'catch',
      enumerable: yes
      configurable: no
      value: (onRejected)->
        @then null, onRejected

    Reflect.defineProperty @::, 'onFulfilled',
      enumerable: no
      configurable: no
      value: (aoData)->
        if @[ipsState] is RC::EPromise::PENDING
          @[ipsState] = RC::EPromise::FULFILLED
          @[ipoData] = aoData
          @[ipoEmitter].emit RC::EPromise::RESOLVE, aoData
        return

    Reflect.defineProperty @::, 'onRejected',
      enumerable: no
      configurable: no
      value: (aoError)->
        if @[ipsState] is RC::EPromise::PENDING
          @[ipsState] = RC::EPromise::REJECTED
          @[ipoData] = aoError
          @[ipoEmitter].emit RC::EPromise::REJECT, aoError
        return

    handle = (promise, handler) ->
      emitter = promise[ipoEmitter]
      emitter.once RC::EPromise::RESOLVE, (aoData) ->
        voResult = promise.tryCallHandler handler.onFulfilled
        handler.promise.onFulfilled? voResult
        return
      emitter.once RC::EPromise::REJECT, (aoError) ->
        if onRejected?
          voResult = promise.tryCallHandler handler.onRejected
        else
          voResult = promise[ipoData]
        handler.promise.onRejected? voResult
        return
      promise.tryCallWrapper promise[ipmLambda].bind(promise), promise.onFulfilled.bind(promise), promise.onRejected.bind(promise)

    Reflect.defineProperty @::, 'then',
      enumerable: yes
      configurable: no
      value: (onFulfilled, onRejected)->
        if (voPromise = @[ipoPromise])?
          voPromise.then onFulfilled, onRejected
        else
          res = RC::EPromise.new noop
          handle @, new Handler onFulfilled, onRejected, res
          res
          # switch @[ipsState]
          #   when RC::EPromise::FULFILLED
          #     voResult = @tryCallHandler onFulfilled
          #   when RC::EPromise::REJECTED
          #     if onRejected?
          #       voResult = @tryCallHandler onRejected
          #     else
          #       voResult = @[ipoData]
          # switch @[ipsState]
          #   when RC::EPromise::REJECTED
          #     RC::EPromise.reject voResult
          #   when RC::EPromise::FULFILLED
          #     RC::EPromise.resolve voResult
          #   else
          #     @then onFulfilled, onRejected


    tryCallHandler: (handler)->
      try
        data = @[ipoData]
        if Utils.isThenable data
          data.then (res) ->
            data = res
        voResult = handler? data
        @[ipsState] = RC::EPromise::FULFILLED
        voResult
      catch err
        @[ipsState] = RC::EPromise::REJECTED
        err

    tryCallWrapper: (lambda, resolve, reject)->
      try
        lambda resolve, reject
      catch e
        @onRejected e

    constructor: (lambda = ->)->
      @[ipsState] = RC::EPromise::INITIAL
      if (vcPromise = RC::EPromise[cpcPromise])?
        @[ipsState] = RC::EPromise::NATIVE
        @[ipoPromise] = new vcPromise lambda
      else
        @[ipsState] = RC::EPromise::PENDING
        @[ipoEmitter] = RC::EPromise.createEmitter()
        @[ipmLambda] = lambda
        # @tryCallWrapper lambda.bind(@), @onFulfilled.bind(@), @onRejected.bind(@)
