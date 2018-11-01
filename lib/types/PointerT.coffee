

module.exports = (Module)->
  {
    IrreducibleG
    Utils: { _ }
  } = Module::

  Module.defineType IrreducibleG 'PointerT', (x)->
    _.isSymbol(x) or _.isString x
