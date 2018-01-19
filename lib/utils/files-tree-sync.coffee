

module.exports = (RC) ->
  RC::Utils.filesTreeSync = (asFoldername, ahOptions = {}) ->
    {
      isArangoDB
      _
    } = RC::Utils
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
