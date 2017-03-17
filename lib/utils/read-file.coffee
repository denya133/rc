fs = require 'fs'
_ = require 'lodash'

module.exports = (RC) ->
  RC::Utils.readFile = (asFilename) ->
    RC::Promise.new (resolve, reject) ->
      if _.isFunction(fs.readFile) and global.Promise?
        # Is Node.js !!!
        fs.readFile asFilename, { encoding: 'utf8' }, (err, data) ->
          if err?
            reject err
          else
            resolve data
          return
      else
        # Is ArangoDB !!!
        try
          data = fs.readFileSync asFilename, 'utf8'
        catch e
          return reject e
        resolve data
      return
