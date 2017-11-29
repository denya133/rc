

fs = require 'fs'


module.exports = (RC) ->
  isArango = RC::Utils.isArangoDB()
  RC::Utils.filesListSync = (asFoldername, ahOptions) ->
    if isArango
      # Is ArangoDB !!!
      fs.list asFoldername
    else
      # Is Node.js !!!
      fs.readdirSync asFoldername, ahOptions
