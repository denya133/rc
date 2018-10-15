

module.exports = (Module)->
  {
    SubtypeG
    TypeT
  } = Module::

  Module.defineType SubtypeG TypeT, 'DictT', (x)-> x.meta.kind is 'dict'
