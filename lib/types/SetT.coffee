

module.exports = (Module)->
  {
    IrreducibleG
    Utils: { t }
  } = Module::

  Module.defineType IrreducibleG 'SetT', (x)-> x instanceof Set
