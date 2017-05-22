

module.exports = (RC) ->
  isArango = RC::Utils.isArangoDB()
  RC::Utils.jwtDecode = (asKey, asToken, abNoVerify = no) ->
    RC::Promise.new (resolve, reject) ->
      if isArango or not RC::Utils.hasNativePromise()
        # Is ArangoDB !!!
        try
          crypto = require '@arangodb/crypto'
          decoded = crypto.jwtDecode asKey, asToken, abNoVerify
        catch e
          return reject e
        resolve decoded
      else
        # Is Node.js !!!
        try
          jwt = require 'jsonwebtoken'
          decoded = if abNoVerify
            jwt.decode asToken
          else
            jwt.verify asToken, asKey
        catch e
          return reject e
        resolve decoded
      return
