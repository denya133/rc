

module.exports = (RC) ->
  RC::Utils.filesTree = (asFoldername, ahOptions = {}) ->
    {
      _
      isArangoDB
      hasNativePromise
    } = RC::Utils
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
