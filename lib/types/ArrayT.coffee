

module.exports = (Module)->
  {
    IrreducibleG
    Utils: { t }
  } = Module::

  Module.defineType IrreducibleG 'ArrayT', (x)-> t.Array.is x
