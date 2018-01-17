###
  ```
  ```
###


module.exports = (RC)->
  {
    ANY
    NILL

    CoreObject
    Class
    Utils: { inflect }
  } = RC::

  class RC::Module extends CoreObject
    @inheritProtected()
    @module RC


    Utils:      null # must be defined as {} in child classes
    # Constants:  null # must be defined as {} in child classes

    @public @static Module: Class,
      get: -> @

    @public @static root: Function,
      default: (path)-> @::ROOT = path

    # чтобы в базовом коде мог через DI искать классы, по строковым константам, которые объявляются в унаследованных классах
    @public @static lookup: Function,
      args: [String]
      return: [Class, NILL]
      default: (fullname)->
        [section, name] = fullname.split ':'
        vsSection = inflect.camelize section
        vsName = inflect.camelize name
        @::["#{vsName}#{vsSection}"] ? null

    @public @static defineMixin: Function,
      default: (args...) ->
        t1 = Date.now()
        [BaseClass, amFunction] = args
        if args.length is 2
          [BaseClass, amFunction] = args
        else if args.length is 1
          [amFunction] = args
          BaseClass = CoreObject
        else
          throw new Error 'In defineMixin() method required min one lambda argument'

        sample = amFunction BaseClass
        Reflect.defineProperty amFunction, 'reification',
          value: sample
        res = @const "#{sample.name}": amFunction
        @____dt += Date.now() - t1
        res

    @public @static defineInterface: Function,
      default: (args...) ->
        t1 = Date.now()
        [BaseClass, amFunction] = args
        if args.length is 2
          [BaseClass, amFunction] = args
        else if args.length is 1
          [amFunction] = args
          BaseClass = CoreObject
        else
          throw new Error 'In defineMixin() method required min one lambda argument'

        sample = amFunction BaseClass
        Reflect.defineProperty amFunction, 'reification',
          value: sample
        res = @const "#{sample.name}": amFunction
        @____dt += Date.now() - t1
        res


  RC::Module.initialize()
