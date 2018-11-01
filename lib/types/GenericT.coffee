# по задумке это тип всех генериков (от DictG до UnionG)
# он нужен для того, чтобы при вызове метода можно было проверить аргумент, в качестве которого передан один из существующих генериков.


module.exports = (Module)->
  {
    IrreducibleG
    Utils: { _ }
  } = Module::

  Module.defineType IrreducibleG 'GenericT', (x)->
    _.isFunction(x) and _.isPlainObject(x.meta) and x.meta.kind is 'generic'
