

module.exports = (RC) ->
  RC.util forEach: (items, lambda, context) ->
    for item, index in items
      yield from do (item, index, items, context) ->
        yield from lambda.call context, item, index, items
    yield return
