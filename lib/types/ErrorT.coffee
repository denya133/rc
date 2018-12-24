

module.exports = (Module)->
  {
    NON
    IrreducibleG
    Utils: { t }
  } = Module::

  Module.defineType IrreducibleG 'ErrorT', ((x)-> t.Error.is x), NON
