

module.exports = (RC) ->
  RC.util request: request = (asMethod, asUrl, ahOptions = {}) ->
    {
      _
      isArangoDB
    } = RC::Utils
    unless asUrl
      asUrl = asMethod
      asMethod = 'GET'
    RC::Promise.new (resolve, reject) ->
      ahOptions.headers ?= {}
      unless ahOptions.headers['Accept']? or ahOptions.headers['accept']?
        ahOptions.headers['Accept'] = '*/*'
      if isArangoDB()
        # Is ArangoDB !!!
        arangoRequest = require '@arangodb/request'
        vhOptions = _.assign {}, ahOptions,
          method: asMethod
          url: asUrl
        if vhOptions.follow > 0 or vhOptions.follow_max > 0
          vhOptions.followRedirect ?= yes
          vhOptions.maxRedirects ?= Number vhOptions.follow ? vhOptions.follow_max
        else
          vhOptions.followRedirect ?= no
        delete vhOptions.follow
        delete vhOptions.follow_max
        result = arangoRequest vhOptions
        resolve
          body: result.body
          headers: result.headers
          status: result.statusCode
          message: result.message
      else
        # Is Node.js !!!
        needle = require 'needle'
        vhOptions = _.assign {}, ahOptions,
          method: asMethod
          url: asUrl
        if vhOptions.followRedirect
          vhOptions.follow_max ?= vhOptions.maxRedirects ? 10
        delete vhOptions.maxRedirects
        delete vhOptions.followRedirect
        needle.request asMethod, asUrl, vhOptions.body ? vhOptions.form, vhOptions, (err, res) ->
          if err?
            resolve
              body: undefined
              headers: {}
              status: 500
              message: err.message
          else
            resolve
              body: res.body
              headers: res.headers
              status: res.statusCode
              message: res.statusMessage
          return
      return
  request.head = (asUrl, ahOptions = {}) ->
    request 'HEAD', asUrl, ahOptions
  request.options = (asUrl, ahOptions = {}) ->
    request 'OPTIONS', asUrl, ahOptions
  request.get = (asUrl, ahOptions = {}) ->
    request 'GET', asUrl, ahOptions
  request.post = (asUrl, ahOptions = {}) ->
    request 'POST', asUrl, ahOptions
  request.put = (asUrl, ahOptions = {}) ->
    request 'PUT', asUrl, ahOptions
  request.patch = (asUrl, ahOptions = {}) ->
    request 'PATCH', asUrl, ahOptions
  request.delete = (asUrl, ahOptions = {}) ->
    request 'DELETE', asUrl, ahOptions
  return request
