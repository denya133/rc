module.exports = (RC) ->
  RC::Utils.hasNativePromise = ->
    RC::Utils.isThenable global.Promise?.prototype
