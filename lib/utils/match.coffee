

module.exports = (Module) ->
  {
    PRODUCTION
    Utils: {
      _
      t: { assert }
    }
  } = Module::

  Module.util match: (x, args...)->
    for i in [0 ... args.length]
      type = args[i]
      guard = args[i+1]
      f = args[i+2]

      if _.isFunction(f) and not Module::TypeT.is(f)
        i = i+3
      else
        f = guard
        guard = Module::AnyT.is
        i = i+2
      if Module.environment isnt PRODUCTION
        count = (count ? 0) + 1
        assert Module::TypeT.is(type), "Invalid type in clause ##{count}"
        assert _.isFunction(guard), "Invalid guard in clause ##{count}"
        assert _.isFunction(f), "Invalid block in clause ##{count}"

      if type.is(x) and guard(x)
        return f(x)
    assert.fail 'Match error'
