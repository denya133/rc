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
  START = 'start'
  oldSetImmediate = global.setImmediate # presave global.setImmediate
  oldSetTimeout = global.setTimeout # presave global.setTimeout
  global.setImmediate = null
  global.setTimeout = null

  RC::EPromise = require 'promise-polyfill'
  RC::EPromise.new = (args...) -> Reflect.construct RC::EPromise, args
  RC::EPromise.createEmitter = (args...) ->
    EventEmitter  = require 'events'
    new EventEmitter
  RC::EPromise._immediateFn = (fn) ->
    RC::EPromise.createEmitter()
      .once START, fn
      .emit START
  RC::EPromise._unhandledRejectionFn = ->

  global.setImmediate = oldSetImmediate # restore global.setImmediate
  global.setTimeout = oldSetTimeout # restore global.setTimeout

  RC::EPromise
