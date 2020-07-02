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

module.exports = (RC)->
  class RC::MetaObject
    iphData = Symbol.for '~data'
    ipoParent = Symbol.for '~parent'
    ipoTarget = Symbol.for '~target'

    Reflect.defineProperty @::, 'data',
      get: -> @[iphData]

    Reflect.defineProperty @::, 'parent',
      get: -> @[ipoParent]
      set: (newParent)->
        @[ipoParent] = newParent
        newParent

    Reflect.defineProperty @::, 'target',
      get: -> @[ipoTarget]

    Reflect.defineProperty @::, 'addMetaData',
      value: (asGroup, asKey, ahMetaData) ->
        @[iphData][asGroup] ?= {}
        Reflect.defineProperty @[iphData][asGroup], asKey,
          configurable: yes
          enumerable: yes
          value: ahMetaData
        return

    Reflect.defineProperty @::, 'appendMetaData',
      value: (asGroup, asKey, ahMetaData) ->
        @[iphData][asGroup] ?= {}
        if (list = @[iphData][asGroup][asKey])?
          list.push ahMetaData
        else
          list = [ ahMetaData ]
          Reflect.defineProperty @[iphData][asGroup], asKey,
            configurable: yes
            enumerable: yes
            value: list
        return

    Reflect.defineProperty @::, 'removeMetaData',
      value: (asGroup, asKey) ->
        if @[iphData][asGroup]?
          Reflect.deleteProperty @[iphData][asGroup], asKey
        return

    Reflect.defineProperty @::, 'collectGroup',
      value: (asGroup, collector = []) ->
        collector = collector.concat @[ipoParent]?.collectGroup?(asGroup, collector) ? []
        collector.push @[iphData][asGroup] ? {}
        collector

    Reflect.defineProperty @::, 'getGroup',
      value: (asGroup, abDeep = yes) ->
        assign = if abDeep then RC::assign else Object.assign
        vhGroup = assign {}, (@collectGroup asGroup)...
        vhGroup

    Reflect.defineProperty @::, 'getOwnGroup',
      value: (asGroup) -> @[iphData][asGroup] ? {}

    constructor: (target, parent) ->
      @[ipoTarget] = target
      @[ipoParent] = parent
      @[iphData] = {}
      for own key of parent?.data
        @[iphData][key] = {}


  RC::MetaObject
