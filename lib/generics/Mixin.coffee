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
    SOFT
    Utils: {
      _
      t: { assert }
    }
  } = Module::

  Mixin = (name, definition) ->
    if Module.environment isnt PRODUCTION
      assert _.isString(name), "Invalid argument name #{assert.stringify name} supplied to Mixin(name, definition) (expected a string)"
      assert _.isFunction(definition), "Invalid argument definition #{assert.stringify definition} supplied to Mixin(name, definition) (expected a function)"
      assert not(definition instanceof Mixin), "Cannot use the new operator to instantiate the type Mixin"

    MixinID = name

    Reflect.defineProperty definition, 'cacheStrategy',
      configurable: no
      enumerable: yes
      writable: no
      value: SOFT

    Reflect.defineProperty definition, 'ID',
      configurable: no
      enumerable: yes
      writable: no
      value: MixinID

    Reflect.defineProperty definition, 'name',
      configurable: no
      enumerable: yes
      writable: no
      value: name

    Reflect.defineProperty definition, 'displayName',
      configurable: no
      enumerable: yes
      writable: no
      value: definition.name

    Reflect.defineProperty definition, 'meta',
      configurable: no
      enumerable: yes
      writable: no
      value: {
        kind: 'mixin'
        name: definition.name
        identity: yes
      }

    CACHE.set definition, MixinID

    definition

  Reflect.defineProperty Mixin, 'name',
    configurable: no
    enumerable: yes
    writable: no
    value: 'Mixin'

  Reflect.defineProperty Mixin, 'displayName',
    configurable: no
    enumerable: yes
    writable: no
    value: 'Mixin'

  Reflect.defineProperty Mixin, 'meta',
    configurable: no
    enumerable: yes
    writable: no
    value: {
      kind: 'generic'
      name: 'Mixin'
      identity: yes
    }

  Module.defineGeneric Mixin
