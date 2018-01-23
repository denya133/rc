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

  class RC::EPromise extends CoreObject
    @inheritProtected()
    # @implements PromiseInterface

    cpcPromise = @private @static _Promise: [Function, NILL],
      get: (_data)->
        if isArango or not Utils.hasNativePromise()
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
              RC::EPromise.resolve item
            .then (resolved) ->
              data.push resolved
              return
          , RC::EPromise.resolve()
          return voPromise.then -> data

    @public @static reject: Function,
      default: (aoError)->
        if (vcPromise = @[cpcPromise])?
          vcPromise.reject aoError
        else
          RC::EPromise.new (resolve, reject)->
            reject aoError

    @public @static resolve: Function,
      default: (aoData)->
        if (vcPromise = @[cpcPromise])?
          vcPromise.resolve aoData
        else
          if Utils.isThenable aoData
            aoData
          else
            RC::EPromise.new (resolve, reject)->
              resolve aoData

    @public catch: Function,
      default: (onRejected)->
        @then null, onRejected

    @public onFulfilled: Function,
      default: (aoData)->
        if @[ipsState] is RC::EPromise::PENDING
          @[ipsState] = RC::EPromise::FULFILLED
          @[ipoData] = aoData
        return

    @public onRejected: Function,
      default: (aoError)->
        if @[ipsState] is RC::EPromise::PENDING
          @[ipsState] = RC::EPromise::REJECTED
          @[ipoData] = aoError
        return

    @public 'then': Function,
      default: (onFulfilled, onRejected)->
        if (voPromise = @[ipoPromise])?
          voPromise.then onFulfilled, onRejected
        else
          switch @[ipsState]
            when RC::EPromise::FULFILLED
              voResult = @tryCallHandler onFulfilled
            when RC::EPromise::REJECTED
              if onRejected?
                voResult = @tryCallHandler onRejected
              else
                voResult = @[ipoData]
          switch @[ipsState]
            when RC::EPromise::REJECTED
              RC::EPromise.reject voResult
            when RC::EPromise::FULFILLED
              RC::EPromise.resolve voResult
            else
              @then onFulfilled, onRejected


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

    @public init: Function,
      default: (lambda = ->)->
        @super arguments...
        if (vcPromise = RC::EPromise[cpcPromise])?
          @[ipsState] = RC::EPromise::NATIVE
          @[ipoPromise] = new vcPromise lambda
        else
          @[ipsState] = RC::EPromise::PENDING
          @tryCallWrapper lambda.bind(@), @onFulfilled.bind(@), @onRejected.bind(@)


  RC::EPromise.initialize()
