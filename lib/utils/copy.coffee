_       = require 'lodash'
extend  = require './extend'

module.exports = (aObject)->
  if _.isArray aObject
    extend [], aObject
  else if _.isObject aObject
    extend {}, aObject
  else
    _.cloneDeep aObject
