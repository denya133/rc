# здесь должна быть синхронная реализация Промиса. А в ноде будет использоваться нативный класс с тем же интерфейсом.
# внутри этой реализации надо в приватное свойство положить синхронный промис с предпроверкой (если нативный определен - то должен быть положен нативный)


module.exports = (RC)->
  {
    ANY, NILL
  } = RC::

  isArango = RC::Utils.isArangoDB()
  class RC::Promise extends RC::CoreObject
    @inheritProtected()
    @implements RC::PromiseInterface

    @Module: RC

    cpcPromise = @private @static _Promise: [Function, NILL],
      get: (_data)->
        if isArango or not RC::Utils.hasNativePromise()
          null
        else
          global.Promise

    @const INITIAL: 0 # 'initial'
    @const PENDING: 1 # 'pending'
    @const FULFILLED: 2 # 'fulfilled'
    @const REJECTED: 3 # 'rejected'
    @const NATIVE: 4 # 'native'

    ipoPromise = @private _promise: ANY
    ipoData = @private _data: ANY
    ipsState = @private _state: String,
      default: @::INITIAL

    @public @static all: Function,
      default: (iterable)->
        if (vcPromise = @[cpcPromise])?
          vcPromise.all iterable
        else
          data = []
          voPromise = iterable.reduce (aoPromise, item) ->
            aoPromise.then ->
              RC::Promise.resolve item
            .then (resolved) ->
              data.push resolved
              return
          , RC::Promise.resolve()
          return voPromise.then -> data

    @public @static reject: Function,
      default: (aoError)->
        if (vcPromise = @[cpcPromise])?
          vcPromise.reject aoError
        else
          RC::Promise.new (resolve, reject)->
            reject aoError

    @public @static resolve: Function,
      default: (aoData)->
        if (vcPromise = @[cpcPromise])?
          vcPromise.resolve aoData
        else
          if RC::Utils.isThenable aoData
            aoData
          else
            RC::Promise.new (resolve, reject)->
              resolve aoData

    @public catch: Function,
      default: (onRejected)->
        @then null, onRejected

    @public onFulfilled: Function,
      default: (aoData)->
        if @[ipsState] is RC::Promise::PENDING
          @[ipsState] = RC::Promise::FULFILLED
          @[ipoData] = aoData
        return

    @public onRejected: Function,
      default: (aoError)->
        if @[ipsState] is RC::Promise::PENDING
          @[ipsState] = RC::Promise::REJECTED
          @[ipoData] = aoError
        return

    @public 'then': Function,
      default: (onFulfilled, onRejected)->
        if (voPromise = @[ipoPromise])?
          voPromise.then onFulfilled, onRejected
        else
          switch @[ipsState]
            when RC::Promise::FULFILLED
              voResult = @tryCallHandler onFulfilled
            when RC::Promise::REJECTED
              if onRejected?
                voResult = @tryCallHandler onRejected
              else
                voResult = @[ipoData]
          switch @[ipsState]
            when RC::Promise::REJECTED
              RC::Promise.reject voResult
            when RC::Promise::FULFILLED
              RC::Promise.resolve voResult
            else
              @then onFulfilled, onRejected


    tryCallHandler: (handler)->
      try
        data = @[ipoData]
        if RC::Utils.isThenable data
          data.then (res) ->
            data = res
        voResult = handler? data
        @[ipsState] = RC::Promise::FULFILLED
        voResult
      catch err
        @[ipsState] = RC::Promise::REJECTED
        err

    tryCallWrapper: (lambda, resolve, reject)->
      try
        lambda resolve, reject
      catch e
        @onRejected e

    @public init: Function,
      default: (lambda = ->)->
        @super arguments...
        if (vcPromise = RC::Promise[cpcPromise])?
          @[ipsState] = RC::Promise::NATIVE
          @[ipoPromise] = new vcPromise lambda
        else
          @[ipsState] = RC::Promise::PENDING
          @tryCallWrapper lambda.bind(@), @onFulfilled.bind(@), @onRejected.bind(@)


  RC::Promise.initialize()
