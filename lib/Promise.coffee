# здесь должна быть синхронная реализация Промиса. А в ноде будет использоваться нативный класс с тем же интерфейсом.
# внутри этой реализации надо в приватное свойство положить синхронный промис с предпроверкой (если нативный определен - то должен быть положен нативный)

module.exports = (RC)->
  {
    ANY
    NILL

    CoreObject
    # PromiseInterface
    Utils: { isArangoDB }
  } = RC::
  isArango = isArangoDB()

  if isArango
    RC::Promise = require 'promise-polyfill'
    RC::Promise.new = (args...) -> Reflect.construct RC::Promise, args
    ###
    RC::Promise.createEmitter = (args...) ->
      EventEmitter  = require 'events'
      new EventEmitter
    RC::Promise._emitter = RC::Promise.createEmitter()
    ###
    RC::Promise._immediateFn = (fn) -> fn()
    ###
      START = "#{Date.now()}#{Date.now()}"
      RC::Promise._emitter
        .once START, fn
        .emit START
    ###
    RC::Promise._unhandledRejectionFn = ->
  else
    class RC::Promise extends global.Promise
      @new: (args...) -> Reflect.construct RC::Promise, args

  RC::Promise
