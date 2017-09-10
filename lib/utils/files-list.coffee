
_ = require 'lodash'
fs = require 'fs'


module.exports = (RC) ->
  isArango = RC::Utils.isArangoDB()
  RC::Utils.filesList = (asFoldername, ahOptions) ->
    RC::Promise.new (resolve, reject) ->
      if isArango or not RC::Utils.hasNativePromise()
        # Is ArangoDB !!!
        try
          data = fs.list asFoldername
        catch e
          return reject e
        resolve data
      else
        # Is Node.js !!!
        fs.readdir asFoldername, ahOptions, (err, data) ->
          if err?
            reject err
          else
            resolve data
          return
      return
