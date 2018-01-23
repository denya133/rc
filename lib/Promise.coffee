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
  isArango = yes #isArangoDB() #TODO remove after testing

  if isArango
    oldSetImmediate = global.setImmediate # presave global.setImmediate
    oldSetTimeout = global.setTimeout # presave global.setTimeout
    global.setImmediate = null
    global.setTimeout = null

  RC::Promise = require 'promise-polyfill'
  RC::Promise.new = (args...) -> Reflect.construct RC::Promise, args
  if isArango
    RC::Promise.createEmitter = (args...) ->
      EventEmitter  = require 'events'
      new EventEmitter
    RC::Promise._emitter = RC::Promise.createEmitter()
    RC::Promise._immediateFn = (fn) ->
      START = "#{Date.now()}#{Date.now()}"
      RC::Promise._emitter
        .once START, fn
        .emit START
    RC::Promise._unhandledRejectionFn = ->

    global.setImmediate = oldSetImmediate # restore global.setImmediate
    global.setTimeout = oldSetTimeout # restore global.setTimeout

  RC::Promise
