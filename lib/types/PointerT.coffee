

module.exports = (Module)->
  {
    STRONG
    IrreducibleG
    Utils: { _ }
  } = Module::

  Module.defineType IrreducibleG 'PointerT', (x)->
    _.isSymbol(x) or _.isString x
  , STRONG
