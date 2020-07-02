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
    NilT
    FuncG
    ASYNC

    CoreObject
    HookedObjectInterface
    Utils: { isGeneratorFunction, _ }
  } = Module::

  class HookedObject extends CoreObject
    @inheritProtected()
    @implements HookedObjectInterface
    @module Module

    ipoAnchor = @protected anchor: Object

    ipmDoHook = @protected @async doHook: Function,
      default: (asHook, alArguments, asErrorMessage, aDefaultValue) ->
        anchor = @[ipoAnchor] ? @
        if asHook?
          if _.isFunction anchor[asHook]
            if anchor.constructor.instanceMethods?[asHook]?.async is ASYNC
              return yield anchor[asHook] alArguments...
            else if isGeneratorFunction anchor[asHook].body ? anchor[asHook]
              return yield from anchor[asHook] alArguments...
            else
              return yield Module::Promise.resolve anchor[asHook] alArguments...
          else if _.isString anchor[asHook]
            return yield Module::Promise.resolve anchor.emit? anchor[asHook], alArguments...
          else
            throw new Error asErrorMessage
        else
          return yield Module::Promise.resolve aDefaultValue

    @public name: String

    @public init: FuncG([String, Object], NilT),
      default: (@name, anchor) ->
        @super arguments...
        @[ipoAnchor] = anchor  if anchor?
        return


    @initialize()
