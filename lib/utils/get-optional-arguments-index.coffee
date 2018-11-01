

module.exports = (Module) ->
  Module.util getOptionalArgumentsIndex: (types)->
    if types.length is 0
      return 0
    end = types.length
    areAllMaybes = no
    for i in [end - 1 .. 0]
      type = types[i]
      if not Module::TypeT.is(type) or type.meta.kind isnt 'maybe'
        return (i + 1)
      else
        areAllMaybes = yes
    return if areAllMaybes then 0 else end
