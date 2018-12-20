

module.exports = (Module) ->
  {
    PRODUCTION
    CACHE
    Utils: { _, uuid, t: { assert }, instanceOf }
  } = Module::

  resultsCache = new Map()

  Module.util valueIsType: (x, Type)->
    if Module.environment is PRODUCTION
      return yes

    _ids = []
    unless (id = CACHE.get x)?
      id = uuid.v4()
      CACHE.set x, id
    _ids.push id
    unless (id = CACHE.get Type)?
      id = uuid.v4()
      CACHE.set Type, id
    _ids.push id
    ID = _ids.join()

    if (cachedResult = resultsCache.get ID)?
      return cachedResult

    assert _.isFunction(Type), "Invalid argument Type #{assert.stringify Type} supplied to valueIsType(x, Type) (expected a function)"

    if Module::TypeT.is Type
      result = Type.is x

    else if (nonCustomType = Module::AccordG Type) isnt Type
      result = nonCustomType.is x
    else
      result = instanceOf x, Type

    resultsCache.set ID, result
    return result
