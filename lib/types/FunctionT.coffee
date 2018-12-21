

module.exports = (Module)->
  {
    NON
    IrreducibleG
    Utils: { t }
  } = Module::

  Module.defineType IrreducibleG 'FunctionT', ((x)-> t.Function.is x), NON
