

module.exports = (Module)->
  {
    SubtypeG
    TypeT
  } = Module::

  Module.defineType SubtypeG TypeT, 'TupleT', (x)-> x.meta.kind is 'tuple'
