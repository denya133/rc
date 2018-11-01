

module.exports = (Module)->
  {
    SubtypeG
    TypeT
  } = Module::

  Module.defineType SubtypeG TypeT, 'IntersectionT', (x)-> x.meta.kind is 'intersection'
