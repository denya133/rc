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
  RC.util filesTree: (asFoldername, ahOptions = {}) ->
    {
      _
      isArangoDB
      hasNativePromise
    } = RC::
    RC::Promise.new (resolve, reject) ->
      if isArangoDB() or not hasNativePromise()
        # Is ArangoDB !!!
        try
          fs = require 'fs'
          data = fs.listTree asFoldername
            .filter (asPath) -> asPath?.length > 0
          if ahOptions.filesOnly
            data = data.filter (asPath) -> fs.isFile fs.join asFoldername, asPath
        catch e
          return reject e
        resolve data
      else
        # Is Node.js !!!
        glob  = require 'glob'
        path  = require 'path'
        fs    = require 'fs'
        glob "#{asFoldername}/**/*", ahOptions, (err, data) ->
          if err?
            reject err
          else
            if ahOptions.filesOnly
              promise = RC::Promise.all data.map (asPath) ->
                RC::Promise.new (resolveStats) ->
                  fs.stat asPath, (aoErr, aoStats) ->
                    if aoErr?
                      resolveStats [asPath, no]
                    else
                      resolveStats [asPath, aoStats.isFile()]
                  return
              .then (alPaths) ->
                alPaths
                  .filter ([asPath, abIsFile]) -> abIsFile
                  .map ([asPath, abIsFile]) -> path.relative asFoldername, asPath
              resolve promise
            else
              data = data.map (asPath) -> path.relative asFoldername, asPath
              resolve data
          return
      return
