

module.exports = (Module)->
  {
    STRONG
    IrreducibleG
    Utils: { _ }
  } = Module::

  Module.defineType IrreducibleG 'SymbolT', ((x)-> _.isSymbol x), STRONG
