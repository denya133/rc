

module.exports = (Module)->
  {
    IrreducibleG
    Utils: { _ }
  } = Module::

  Module.defineType IrreducibleG 'GeneratorT', (x)->
    _.isFunction(x?.next) and _.isFunction(x?.throw)
