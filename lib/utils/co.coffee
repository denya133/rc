_ = require 'lodash'


module.exports = (RC)->
  toPromise = (obj) ->
    switch
      when not obj?
        obj
      when isPromise obj
        obj
      when isGeneratorFunction(obj) or isGenerator(obj)
        co.call @, obj
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
    RC::Promise (resolve, reject) ->
      fn.call context, (err, res...) ->
        return reject err  if err?
        resolve res

  arrayToPromise = (obj) ->
    RC::Promise.all obj.map toPromise, @

  objectToPromise = (obj) ->
    results = new obj.constructor()
    keys = Object.keys obj
    promises = []
    for key in keys
      promise = toPromise.call @, obj[key]
      if promise? and isPromise promise
        defer promise, key
      else
        results[key] = obj[key]
    defer = (promise, key) ->
      results[key] = undefined
      promises.push promise.then (res) ->
        results[key] = res
      return
    RC::Promise.all promises
    .then ->
      results

  isPromise = RC::Utils.isThenable
  isGenerator = (obj) ->
    _.isFunction(obj?.next) and _.isFunction(obj?.throw)

  isGeneratorFunction = (obj) ->
    { constructor } = obj
    return no  unless constructor?
    if constructor.name is 'GeneratorFunction' or
        constructor.displayName is 'GeneratorFunction'
      return yes
    isGenerator constructor::

  isObject = _.isPlainObject

  RC::Utils.co = (generator, args...) ->
    context = @
    RC::Promise.new (resolve, reject) ->
      if _.isFunction(generator)
        generator = generator.apply context, args
      if not generator? or not _.isFunction(generator?.next)
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
        You may need only yield a function, promise, generator, array, or object,
        but the following object was passed: '#{String ret.value}'
        "

      onFulfilled()
