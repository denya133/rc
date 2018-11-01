

module.exports = (Module)->
  {
    IrreducibleG
    Utils: { t }
  } = Module::

  Module.defineType IrreducibleG 'DateT', (x)-> t.Date.is x
