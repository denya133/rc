

module.exports = (Module) ->
  {
    PRODUCTION
    Utils: {
      t: { assert }
      getTypeName
      instanceOf
    }
  } = Module::

  Module.util createByType: (type, value, path)->
    if Module::TypeT.is type
      if not type.meta.identity and typeof value is 'object' and value isnt null
        return new type(value, path)
      else
        return type(value, path)

    if Module.environment isnt PRODUCTION
      path = path ? [getTypeName type]
      assert instanceOf(value, type), "Invalid value #{assert.stringify value} supplied to #{path.join '.'}"

    return value
