module.exports = (RC) ->
  RC.util hasNativePromise: ->
    RC::isThenable global.Promise?.prototype
