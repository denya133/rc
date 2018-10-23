

module.exports = (Module) ->
  {
    PRODUCTION
    Utils: {
      _
      t: { assert }
      getTypeName
      createByType
    }
  } = Module::

  Module.util fromJSON: fromJSON = (value, type, path)->
    if Module.environment isnt PRODUCTION
      assert _.isFunction(type), "Invalid argument type #{assert.stringify type} supplied to fromJSON(value, type) (expected a type)"

    path ?= [getTypeName type]

    if _.isFunction type.fromJSON
      return createByType type, type.fromJSON(value), path

    unless Module::TypeT.is type
      return if value instanceof type then value else new type value

    return switch type.meta.kind
      when 'maybe'
        if Module.environment is PRODUCTION
          value
        else
          if value?
            fromJSON value, type.meta.type, path
          value
      when 'subtype'
        if Module.environment is PRODUCTION
          value
        else
          ret = fromJSON value, type.meta.type, path
          assert type.meta.predicate(ret), "Invalid argument value #{assert.stringify value} supplied to fromJSON(value, type) (expected a valid #{getTypeName type})"
          value
      when 'interface'
        if Module.environment is PRODUCTION
          value
        else
          assert _.isPlainObject(value), "Invalid argument value #{assert.stringify value} supplied to fromJSON(value, type) (expected an object)"
          for own k, v of type.meta.props
            fromJSON value[k], v, path.concat "#{k}: #{getTypeName v}"
          value
      when 'list'
        if Module.environment is PRODUCTION
          value
        else
          assert _.isArray(value), "Invalid argument value #{assert.stringify value} supplied to fromJSON(value, type) (expected an array for type #{getTypeName type})"
          eType = type.meta.type
          value.forEach (e, i)->
            fromJSON e, eType, path.concat "#{i}: #{getTypeName eType}"
          value
      when 'union'
        if Module.environment is PRODUCTION
          value
        else
          aType = type.dispatch value
          assert _.isFunction(aType), "Invalid argument value #{assert.stringify value} supplied to fromJSON(value, type) (no constructor returned by dispatch of union #{getTypeName type})"
          fromJSON(value, actualType, path)
          value
      when 'tuple'
        if Module.environment is PRODUCTION
          value
        else
          assert _.isArray(value), "Invalid argument value #{assert.stringify value} supplied to fromJSON(value, type) (expected an array for type #{getTypeName type})"
          types = type.meta.types
          assert _.isArray(value) and value.length is types.length, "Invalid value #{assert.stringify value} supplied to fromJSON(value, type) (expected an array of length #{types.length} for type #{getTypeName type})"
          value.forEach (e, i)->
            fromJSON e, types[i], path.concat "#{i}: #{getTypeName types[i]}"
          value
      when 'dict'
        if Module.environment is PRODUCTION
          value
        else
          assert _.isPlainObject(value), "Invalid argument value #{assert.stringify value} supplied to fromJSON(value, type) (expected an object for type #{getTypeName type})"
          {domain, codomain} = type.meta
          domainName = getTypeName domain
          codomainName = getTypeName codomain
          for own k, v of value
            domain k, path.concat domainName
            fromJSON v, codomain, path.concat "#{k}: #{codomainName}"
          value
      when 'intersection'
        if Module.environment is PRODUCTION
          value
        else
          type.meta.types.forEach (type, i)->
            fromJSON value, type, path.concat "#{i}: #{getTypeName type}"
          type value, path
          value
      else # enums, irreducible
        # NOTE: func, map, set sample тоже могли бы попасть сюда, НО они не могут прийти из JSON'а, т.к. могут существовать только в оперативной памяти
        if Module.environment is PRODUCTION
          value
        else
          type value, path
          value
