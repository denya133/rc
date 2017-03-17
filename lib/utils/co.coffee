_ = require 'lodash'

module.exports = (RC)->
  toPromise = (obj) ->
    switch
      when not obj?
        obj
      when isPromise obj
        obj
      when isGeneratorFunction(obj) or isGenerator(obj)
        RC::Utils.co.call @, obj
      when _.isFunction obj
        thunkPromise.call @, obj
      when _.isArray obj
        arrayToPromise.call @, obj
      when isObject obj
        objectToPromise.call @, obj
      else
        obj

  thunkPromise = (fn) ->
    context = @
    RC::Promise.new (resolve, reject) ->
      fn.call context, (err, res...) ->
        if err?
          reject err
        else
          resolve if res.length > 1 then res else res[0]
        return

  arrayToPromise = (obj) ->
    RC::Promise.all obj.map toPromise, @

  objectToPromise = (obj) ->
    results = new obj.constructor()
    keys = Object.keys obj
    promises = []
    defer = (promise, key) ->
      results[key] = undefined
      promises.push promise.then (res) ->
        results[key] = res
        return
    for key in keys
      promise = toPromise.call @, obj[key]
      if promise? and isPromise promise
        defer promise, key
      else
        results[key] = obj[key]
    RC::Promise.all promises
    .then ->
      results

  isPromise = RC::Utils.isThenable
  isObject = _.isPlainObject

  isGenerator = (obj) ->
    _.isFunction(obj?.next) and _.isFunction(obj?.throw)

  isGeneratorFunction = (obj) ->
    { constructor } = obj
    return no  unless constructor?
    if constructor.name is 'GeneratorFunction' or
        constructor.displayName is 'GeneratorFunction'
      return yes
    isGenerator constructor::

  RC::Utils.co = (generator, args...) ->
    context = @
    RC::Promise.new (resolve, reject) ->
      if _.isFunction generator
        generator = generator.apply context, args
      unless isGenerator generator
        return resolve generator

      onFulfilled = (res) ->
        try
          ret = generator.next res
        catch e
          return reject e
        next ret
        null

      onRejected = (err) ->
        try
          ret = generator.throw err
        catch e
          return reject e
        next ret
        return

      next = (ret) ->
        if ret?.done
          return resolve ret.value
        value = toPromise.call context, ret.value
        if value? and isPromise value
          return value.then onFulfilled, onRejected
        onRejected new TypeError "
        You may only yield a function, promise, generator, array, or object,
        but the following object was passed: '#{String ret.value}'
        "

      onFulfilled()
      return

  RC::Utils.co.wrap = (fn) ->
    createPromise = (args...) ->
      RC::Utils.co.call @, fn.apply @, args
    createPromise.__generatorFunction__ = fn
    createPromise
  return
