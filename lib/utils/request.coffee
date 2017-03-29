_ = require 'lodash'
URL = require 'url'

isArangoDB = (try require '@arangodb/request')?

module.exports = (RC) ->
  RC::Utils.request = (asMethod, asUrl, ..., ahOptions = {}) ->
    RC::Promise.new (resolve, reject) ->
      if isArangoDB
        # Is ArangoDB !!!
        promise = require '@arangodb/request'
        vhOptions = _.assign {}, ahOptions,
          method: asMethod
          url: asUrl
        try
          result = request vhOptions
        catch err
          reject err
        resolve
          body: result.body
          headers: result.headers
          status: result.statusCode
          message: result.message
      else
        # Is Node.js !!!
        vhOptions = _.assign {}, ahOptions, URL.parse(asUrl), method: asMethod
        { request } = if vhOptions.protocol is 'https:' or vhOptions.port is 443
          require 'https'
        else
          require 'http'
        req = request vhOptions, (res) ->
          results = []
          res.on 'data', (chunk) ->
            results.push chunk
          res.on 'end', ->
            result = Buffer.concat results
            encoding = if vhOptions.encoding is null
              vhOptions.encoding
            else
              vhOptions.encoding ? 'utf-8'
            body = switch
              when vhOptions.json and encoding?
                stringResult = result.toString encoding
                (try JSON.parse stringResult.replace /\n/g, '') ? stringResult
              when encoding?
                result.toString encoding
              else
                result
            resolve
              body: body
              headers: res.headers
              status: res.statusCode
              message: res.statusMessage
          return
        req.on 'error', (err) ->
          reject err
        if vhOptions.postData?
          req.write vhOptions.postData
        req.end()
      return
  RC::Utils.request.head = (asUrl, ..., ahOptions = {}) ->
    RC::Utils.request 'HEAD', asUrl, ahOptions
  RC::Utils.request.options = (asUrl, ..., ahOptions = {}) ->
    RC::Utils.request 'OPTIONS', asUrl, ahOptions
  RC::Utils.request.get = (asUrl, ..., ahOptions = {}) ->
    RC::Utils.request 'GET', asUrl, ahOptions
  RC::Utils.request.post = (asUrl, ..., ahOptions = {}) ->
    RC::Utils.request 'POST', asUrl, ahOptions
  RC::Utils.request.put = (asUrl, ..., ahOptions = {}) ->
    RC::Utils.request 'PUT', asUrl, ahOptions
  RC::Utils.request.patch = (asUrl, ..., ahOptions = {}) ->
    RC::Utils.request 'PATCH', asUrl, ahOptionsahOptions
  RC::Utils.request.delete = (asUrl, ..., ahOptions = {}) ->
    RC::Utils.request 'DELETE', asUrl, ahOptionsahOptions
  return RC::Utils.request
