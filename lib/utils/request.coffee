_ = require 'lodash'
URL = require 'url'

module.exports = (RC) ->
  isArango = RC::Utils.isArangoDB()
  RC::Utils.request = (asMethod, asUrl, ..., ahOptions = {}) ->
    RC::Promise.new (resolve, reject) ->
      if isArango
        # Is ArangoDB !!!
        request = require '@arangodb/request'
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
        try
          result = request vhOptions
        catch err
          reject err ? new Error 'HTTP error'
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
        needle.request asMethod, asUrl, vhOptions.postData ? vhOptions.form, vhOptions, (err, res) ->
          if err?
            reject err
          else
            resolve
              body: res.body
              headers: res.headers
              status: res.statusCode
              message: res.statusMessage
          return
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
