

module.exports = (Module)->
  {
    IrreducibleG
    Utils: { _ }
  } = Module::

  Module.defineType IrreducibleG 'StructT', (x)->
    _.isFunction(x) and _.isPlainObject(x.meta) and x.meta.kind is 'interface' and x.meta.strict is yes
