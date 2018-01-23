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
    Utils: { inflect, _ }
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
        if args.length is 2
          [BaseClass, amFunction] = args
        else if args.length is 1
          [amFunction] = args
          BaseClass = CoreObject
        else
          throw new Error 'In defineMixin() method required min one lambda argument'

        # TODO: пока что для обратной совестимости оставляем код выше и проверяем что если BaseClass == строка, то не делаем семпл - новая логика. После обновления всего старого кода в приложениях надо будет удалить лишнюю логику из этого метода
        if _.isString BaseClass
          Reflect.defineProperty amFunction, 'name',
            value: BaseClass
          res = @const "#{BaseClass}": amFunction
        else
          sample = amFunction BaseClass
          Reflect.defineProperty amFunction, 'name',
            value: sample.name
          res = @const "#{sample.name}": amFunction
        res

    @public @static defineInterface: Function,
      default: (args...) ->
        if args.length is 2
          [BaseClass, amFunction] = args
        else if args.length is 1
          [amFunction] = args
          BaseClass = CoreObject
        else
          throw new Error 'In defineMixin() method required min one lambda argument'

        # TODO: пока что для обратной совестимости оставляем код выше и проверяем что если BaseClass == строка, то не делаем семпл - новая логика. После обновления всего старого кода в приложениях надо будет удалить лишнюю логику из этого метода
        if _.isString BaseClass
          Reflect.defineProperty amFunction, 'name',
            value: BaseClass
          res = @const "#{BaseClass}": amFunction
        else
          sample = amFunction BaseClass
          Reflect.defineProperty amFunction, 'name',
            value: sample.name
          res = @const "#{sample.name}": amFunction
        res


  RC::Module.initialize()
