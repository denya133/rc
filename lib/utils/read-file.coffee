fs = require 'fs'
_ = require 'lodash'

module.exports = (RC) ->
  isArango = RC::Utils.isArangoDB()
  RC::Utils.readFile = (asFilename) ->
    RC::Promise.new (resolve, reject) ->
      if isArango or not RC::Utils.hasNativePromise()
        # Is ArangoDB !!!
        try
          data = fs.readFileSync asFilename, 'utf8'
        catch e
          return reject e
        resolve data
      else
        # Is Node.js !!!
        fs.readFile asFilename, { encoding: 'utf8' }, (err, data) ->
          if err?
            reject err
          else
            resolve data
          return
      return
