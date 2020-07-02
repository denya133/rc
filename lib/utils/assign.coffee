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

_       = require 'lodash'

customizer = (objValue, srcValue)->
  if _.isArray objValue
    objValue.concat srcValue

module.exports = ->
  target = _.head arguments
  if _.isArray target
    others = _.tail arguments
    _.concat target, others...
  else
    args = _.slice arguments
    args.push customizer
    _.mergeWith args...
