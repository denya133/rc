
_ = require 'lodash'
fs = require 'fs'


module.exports = (RC) ->
  isArango = RC::Utils.isArangoDB()
  RC::Utils.filesTree = (asFoldername, ahOptions) ->
    RC::Promise.new (resolve, reject) ->
      if isArango or not RC::Utils.hasNativePromise()
        # Is ArangoDB !!!
        try
          data = fs.listTree asFoldername
        catch e
          return reject e
        resolve data
      else
        # Is Node.js !!!
        glob = require 'glob'
        glob asFoldername, ahOptions, (err, data) ->
          if err?
            reject err
          else
            resolve data
          return
      return
