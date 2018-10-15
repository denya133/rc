

module.exports = (Module)->
  {
    SubtypeG
    TypeT
  } = Module::

  Module.defineType SubtypeG TypeT, 'ListT', (x)-> x.meta.kind is 'list'
