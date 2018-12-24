

module.exports = (Module)->
  {
    WEAK
    IrreducibleG
    Utils: { t }
  } = Module::

  Module.defineType IrreducibleG 'SetT', ((x)-> x instanceof Set), WEAK
