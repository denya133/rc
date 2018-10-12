

module.exports = (Module)->
  {
    IrreducibleG
    Utils: { t }
  } = Module::

  Module.defineType IrreducibleG 'PromiseT', (x)->
    typeof x?.then is 'function'
