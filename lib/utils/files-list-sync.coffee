


module.exports = (RC) ->
  RC::Utils.filesListSync = (asFoldername, ahOptions) ->
    { isArangoDB } = RC::Utils
    fs = require 'fs'
    if isArangoDB()
      # Is ArangoDB !!!
      fs.list asFoldername
    else
      # Is Node.js !!!
      fs.readdirSync asFoldername, ahOptions
