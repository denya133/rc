# здесь должна быть синхронная реализация Промиса. А в ноде будет использоваться нативный класс с тем же интерфейсом.
# внутри этой реализации надо в приватное свойство положить синхронный промис с предпроверкой (если нативный определен - то должен быть положен нативный)

module.exports = (RC)->
  class RC::Promise extends RC::CoreObject
    @inheritProtected()
    @implements RC::PromiseInterface

    @Module: RC

    cpcPromise = @private @static Promise: [Function, RC::Constants.NILL],
      default: {}
      get: (_data)->
        return _data.Promise if _data.Promise isnt undefined
        try
          new global.Promise (resolve, reject)-> resolve yes
          _data.Promise = global.Promise
        catch
          _data.Promise = null
        _data.Promise

    INITIAL = 'initial'
    PENDING = 'pending'
    FULFILLED = 'fulfilled'
    REJECTED = 'rejected'
    NATIVE = 'native'

    ipoPromise = @private promise: RC::Constants.ANY
    ipoData = @private data: RC::Constants.ANY
    ipsState = @private state: String,
      default: INITIAL

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
        if @[ipsState] is PENDING
          @[ipsState] = FULFILLED
          @[ipoData] = aoData
        return

    @public onRejected: Function,
      default: (aoError)->
        if @[ipsState] is PENDING
          @[ipsState] = REJECTED
          @[ipoData] = aoError
        return

    @public 'then': Function,
      default: (onFulfilled, onRejected)->
        if (voPromise = @[ipoPromise])?
          voPromise.then onFulfilled, onRejected
        else
          switch @[ipsState]
            when FULFILLED
              voResult = @tryCallHandler onFulfilled
            when REJECTED
              if onRejected?
                voResult = @tryCallHandler onRejected
              else
                voResult = @[ipoData]
          switch @[ipsState]
            when REJECTED
              RC::Promise.reject voResult
            when FULFILLED
              RC::Promise.resolve voResult

    tryCallHandler: (handler)->
      try
        voResult = handler? @[ipoData]
        @[ipsState] = FULFILLED
        voResult
      catch err
        @[ipsState] = REJECTED
        err

    tryCallWrapper: (lambda, resolve, reject)->
      try
        lambda resolve, reject
      catch e
        @onRejected e

    constructor: (lambda = ->)->
      super arguments...
      if (vcPromise = RC::Promise[cpcPromise])?
        @[ipsState] = NATIVE
        @[ipoPromise] = new vcPromise lambda
      else
        @[ipsState] = PENDING
        @tryCallWrapper lambda.bind(@), @onFulfilled.bind(@), @onRejected.bind(@)


  return RC::Promise.initialize()
