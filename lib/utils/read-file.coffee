

module.exports = (RC) ->
  RC.util readFile: (asFilename) ->
    {
      isArangoDB
      hasNativePromise
    } = RC::Utils
    RC::Promise.new (resolve, reject) ->
      if isArangoDB() or not hasNativePromise()
        # Is ArangoDB !!!
        try
          fs = require 'fs'
          data = fs.readFileSync asFilename, 'utf8'
        catch e
          return reject e
        resolve data
      else
        # Is Node.js !!!
        fs = require 'fs'
        fs.readFile asFilename, { encoding: 'utf8' }, (err, data) ->
          if err?
            reject err
          else
            resolve data
          return
      return
