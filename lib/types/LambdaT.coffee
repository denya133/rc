

module.exports = (Module)->
  {
    NON
    SubtypeG
    FunctionT
  } = Module::

  Module.defineType SubtypeG FunctionT, 'LambdaT', ((x)-> yes), NON
