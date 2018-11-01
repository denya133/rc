

module.exports = (Module)->
  {
    IrreducibleG
    Utils: { t }
  } = Module::

  GeneratorFunction = Object.getPrototypeOf(-> yield return).constructor

  Module.defineType IrreducibleG 'GeneratorFunctionT', (x)->
    t.Function.is(x) and x instanceof GeneratorFunction
