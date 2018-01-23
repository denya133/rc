

module.exports = (RC) ->
  RC::Utils.filter = (items, lambda, context) ->
    result = []
    for item, index in items
      yield from do (item, index, items, context) ->
        if yield from lambda.call context, item, index, items
          result.push item
    yield return result
