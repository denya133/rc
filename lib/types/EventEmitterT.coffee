

module.exports = (Module)->
  {
    WEAK
    IrreducibleG
    Utils: { t }
  } = Module::

  Module.defineType IrreducibleG 'EventEmitterT', (x)->
    x instanceof require 'events'
  , WEAK
