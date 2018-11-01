

module.exports = (Module)->
  {
    IrreducibleG
    Utils: { t }
  } = Module::

  Module.defineType IrreducibleG 'ObjectT', (x)-> t.Object.is x
