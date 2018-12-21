

module.exports = (Module)->
  {
    STRONG
    SubtypeG
    NumberT
  } = Module::

  Module.defineType SubtypeG NumberT, 'IntegerT', ((x)-> x % 1 is 0), STRONG
