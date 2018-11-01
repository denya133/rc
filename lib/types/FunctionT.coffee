

module.exports = (Module)->
  {
    IrreducibleG
    Utils: { t }
  } = Module::

  Module.defineType IrreducibleG 'FunctionT', (x)-> t.Function.is x
