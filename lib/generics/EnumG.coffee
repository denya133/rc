# This file is part of RC.
#
# RC is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# RC is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with RC.  If not, see <https://www.gnu.org/licenses/>.

module.exports = (Module)->
  {
    PRODUCTION
    CACHE
    STRONG
    Generic
    Utils: {
      _
      t: { assert }
    }
  } = Module::

  typesCache = new Map()

  Module.defineGeneric Generic 'EnumG', (args...) ->
    if Module.environment isnt PRODUCTION
      assert args.length > 0, 'EnumG must be call with Array, Object or many arguments'
      config = if args.length is 1
        args[0]
      else
        args
      assert _.isArray(config) or _.isPlainObject(config), 'EnumG must be call with Array or Plain Object'
      if _.isPlainObject(config)
        enums = []
        def = new Set( for own k, v of config
          enums.push assert.stringify k
          v
        )
        displayName = enums.join ' | '
      else if _.isArray(config)
        def = new Set config
        displayName = []
        config = config.reduce (prev, i)->
          item = assert.stringify i
          displayName.push item
          prev[item] ?= item
          prev
        , {}
        displayName = displayName.join ' | '

    # NOTE: так как кроме примитивов Строка и Число другие не смогут дать положительный результат в строкой проверке, в енуме не могут быть объявлены объекты, массивы и даты, следователно можно использовать в качестве ключа displayName
    if (cachedType = typesCache.get displayName)?
      return cachedType

    Enum = (value, path)->
      if Module.environment is PRODUCTION
        return value
      Enum.isNotSample @
      if Enum.has value
        return value
      path ?= [Enum.displayName]
      assert Enum.is(value), "Invalid value #{assert.stringify value} supplied to #{path.join '.'} (expected one of #{displayName})"
      Enum.keep value
      return value

    # Reflect.defineProperty Enum, 'cache',
    #   configurable: no
    #   enumerable: yes
    #   writable: no
    #   value: new Set()

    Reflect.defineProperty Enum, 'cacheStrategy',
      configurable: no
      enumerable: yes
      writable: no
      value: STRONG

    Reflect.defineProperty Enum, 'ID',
      configurable: no
      enumerable: yes
      writable: no
      value: displayName

    unless Module::STRONG_CACHE.has displayName
      Module::STRONG_CACHE.set displayName, new Set

    Reflect.defineProperty Enum, 'has',
      configurable: no
      enumerable: yes
      writable: no
      value: (value)-> Module::STRONG_CACHE.get(displayName).has value

    Reflect.defineProperty Enum, 'keep',
      configurable: no
      enumerable: yes
      writable: no
      value: (value)-> Module::STRONG_CACHE.get(displayName).add value

    Reflect.defineProperty Enum, 'name',
      configurable: no
      enumerable: yes
      writable: no
      value: displayName

    Reflect.defineProperty Enum, 'displayName',
      configurable: no
      enumerable: yes
      writable: no
      value: displayName

    Reflect.defineProperty Enum, 'is',
      configurable: no
      enumerable: yes
      writable: no
      value: (x)->
        if Enum.has x
          return yes
        result = def.has x
        if result
          Enum.keep x
        return result

    Reflect.defineProperty Enum, 'meta',
      configurable: no
      enumerable: yes
      writable: no
      value: {
        kind: 'enums'
        config: config
        map: def
        name: Enum.displayName
        identity: yes
      }

    Reflect.defineProperty Enum, 'isNotSample',
      configurable: no
      enumerable: yes
      writable: no
      value: Module::NotSampleG Enum

    typesCache.set displayName, Enum
    CACHE.set Enum, displayName

    Enum
