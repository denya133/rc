_ = require 'lodash'

module.exports = (RC) ->
  RC::Utils.forEach = (items, lambda, context) ->
    for item, index in items
      yield from do (item, index, items, context) ->
        yield from lambda.call context, item, index, items
    yield return
