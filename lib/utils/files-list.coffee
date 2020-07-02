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

module.exports = (RC) ->
  RC.util filesList: (asFoldername, ahOptions) ->
    {
      isArangoDB
      hasNativePromise
    } = RC::Utils
    RC::Promise.new (resolve, reject) ->
      if isArangoDB() or not hasNativePromise()
        # Is ArangoDB !!!
        try
          fs = require 'fs'
          data = fs.list asFoldername
        catch e
          return reject e
        resolve data
      else
        # Is Node.js !!!
        fs = require 'fs'
        fs.readdir asFoldername, ahOptions, (err, data) ->
          if err?
            reject err
          else
            resolve data
          return
      return
