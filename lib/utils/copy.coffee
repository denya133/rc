_       = require 'lodash'
assign  = require './assign'

module.exports = (aObject)->
  if _.isArray aObject
    assign [], aObject
  else if _.isObject aObject
    assign {}, aObject
  else
    _.cloneDeep aObject
