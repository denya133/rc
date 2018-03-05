

module.exports = (RC) ->
  RC.util setTimeout: (callback, time) ->
    if callback? and time?
      current = Date.now()
      if time > 0
        finishTime = current + time
        while Date.now() < finishTime then
      callback?()
    return
