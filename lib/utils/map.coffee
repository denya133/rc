

module.exports = (RC) ->
  RC::Utils.map = (items, lambda, context) ->
    result = []
    for item, index in items
      yield from do (item, index, items, context) ->
        result.push yield from lambda.call context, item, index, items
    yield return result
