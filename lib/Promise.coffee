# здесь должна быть синхронная реализация Промиса. А в ноде будет использоваться нативный класс с тем же интерфейсом.
# внутри этой реализации надо в приватное свойство положить синхронный промис с предпроверкой (если нативный определен - то должен быть положен нативный)

module.exports = (RC)->
  class RC::Promise extends RC::CoreObject
    @inheritProtected()
    @implements RC::PromiseInterface

    @Module: RC

    cpcPromise = @private @static Promise: [Function, RC::Constants.NILL],
      get: ->
        try
          new global.Promise (resolve, reject)-> resolve yes
          return global.Promise
        catch
          null

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
          voError = null
          vlResults = []
          iterable.forEach (item) ->
            RC::Promise.resolve item
            .then (resolved) ->
              vlResults.push resolved
            .catch (err) ->
              voError ?= err
          if voError?
            RC::Promise.reject voError
          else
            RC::Promise.resolve vlResults

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
          try
            switch @[ipsState]
              when FULFILLED
                voResult = onFulfilled? @[ipoData]
                @[ipsState] = FULFILLED
              when REJECTED
                if onRejected?
                  voResult = onRejected? @[ipoData]
                  @[ipsState] = FULFILLED
                else
                  voResult = @[ipoData]
                  @[ipsState] = REJECTED
          catch err
            voResult = err
            @[ipsState] = REJECTED
          switch @[ipsState]
            when REJECTED
              RC::Promise.reject voResult
            when FULFILLED
              RC::Promise.resolve voResult

    constructor: (lambda = ->)->
      super arguments...
      if (vcPromise = RC::Promise[cpcPromise])?
        @[ipsState] = NATIVE
        @[ipoPromise] = new vcPromise lambda
      else
        @[ipsState] = PENDING
        try
          lambda.apply @, [@onFulfilled.bind(@), @onRejected.bind(@)]
        catch e
          @onRejected e


  return RC::Promise.initialize()
