

module.exports = (RC) ->
  RC::Utils.filesList = (asFoldername, ahOptions) ->
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
