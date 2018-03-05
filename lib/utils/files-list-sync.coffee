


module.exports = (RC) ->
  RC.util filesListSync: (asFoldername, ahOptions) ->
    { isArangoDB } = RC::
    fs = require 'fs'
    if isArangoDB()
      # Is ArangoDB !!!
      fs.list asFoldername
    else
      # Is Node.js !!!
      fs.readdirSync asFoldername, ahOptions
