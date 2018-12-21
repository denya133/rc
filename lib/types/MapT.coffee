

module.exports = (Module)->
  {
    WEAK
    IrreducibleG
    Utils: { t }
  } = Module::

  Module.defineType IrreducibleG 'MapT', ((x)-> x instanceof Map), WEAK
