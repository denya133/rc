fs = require 'fs'
_ = require 'lodash'

module.exports = (RC) ->
  RC::Utils.readFile = (asFilename) ->
    RC::Promise.new (resolve, reject) ->
      if RC::Utils.isArangoDB()
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
