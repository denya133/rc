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
  RC.util filesTreeSync: (asFoldername, ahOptions = {}) ->
    {
      isArangoDB
    } = RC::
    if isArangoDB()
      # Is ArangoDB !!!
      fs = require 'fs'
      data = fs.listTree asFoldername
        .filter (asPath) -> asPath?.length > 0
      if ahOptions.filesOnly
        data = data.filter (asPath) -> fs.isFile fs.join asFoldername, asPath
      data
    else
      # Is Node.js !!!
      glob = require 'glob'
      path = require 'path'
      fs = require 'fs'
      data = glob.sync "#{asFoldername}/**/*", ahOptions
      if ahOptions.filesOnly
        data
          .map (asPath) ->
            try
              [asPath, fs.statSync(asPath).isFile()]
            catch err
              [asPath, no]
          .filter ([asPath, abIsFile]) -> abIsFile
          .map ([asPath, abIsFile]) -> path.relative asFoldername, asPath
      else
        data = data.map (asPath) -> path.relative asFoldername, asPath
        data
