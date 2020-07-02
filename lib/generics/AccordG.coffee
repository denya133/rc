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
    Generic
    Utils: {
      _
      t: { assert }
      getTypeName
    }
  } = Module::

  cache = new Map()

  Module.defineGeneric Generic 'AccordG', (AnyClass) ->
    if Module.environment isnt PRODUCTION
      assert _.isFunction(AnyClass), "Invalid argument AnyClass #{assert.stringify AnyClass} supplied to AccordG(AnyClass) (expected a function)"

    if AnyClass in [
      Module::ANY
      Module::NILL
      Module::LAMBDA
      Promise, Module::Promise
      Generic
      Module::Class
      Module::Mixin
      Module::Module
      Module::Interface
    ]
      displayName = getTypeName AnyClass
      if (cachedType = cache.get AnyClass)?
        return cachedType
      Type = switch AnyClass
        when Module::ANY
          Module::['AnyT']
        when Module::NILL
          Module::['NilT']
        when Module::LAMBDA
          Module::['LambdaT']
        when Promise, Module::Promise
          Module::['PromiseT']
        when Generic
          Module::['GenericT']
        when Module::Class
          Module::['ClassT']
        when Module::Mixin
          Module::['MixinT']
        when Module::Module
          Module::['ModuleT']
        when Module::Interface
          Module::['InterfaceT']
      cache.set AnyClass, Type
      return Type

    if Module::TypeT.is AnyClass
      return AnyClass

    displayName = getTypeName AnyClass

    if (cachedType = cache.get AnyClass)?
      return cachedType

    Type = switch AnyClass
      when Function
        Module::['FunctionT']
      when String
        Module::['StringT']
      when Number
        Module::['NumberT']
      when Boolean
        Module::['BooleanT']
      when Date
        Module::['DateT']
      when Object
        Module::['ObjectT']
      when Array
        Module::['ArrayT']
      when Map
        Module::['MapT']
      when Set
        Module::['SetT']
      when RegExp
        Module::['RegExpT']
      when Symbol
        Module::['SymbolT']
      when Error
        Module::['ErrorT']
      when Buffer
        Module::['BufferT']
      when (require 'stream')
        Module::['StreamT']
      when (require 'events')
        Module::['EventEmitterT']
      else
        AnyClass

    cache.set AnyClass, Type

    Type
