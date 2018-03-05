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
    inflect, _
  } = RC::

  class RC::Module extends CoreObject
    @inheritProtected()
    @module RC

    cphUtilsMap = @private @static utilsMap: Object
    cpoUtils = @private @static utils: Object
    cpoUtilsMeta = @private @static utilsMeta: Object

    cpmUtilsHandler = @private @static utilsHandler: Function,
      default: (Class) ->
        ownKeys: (aoTarget) ->
          Reflect.ownKeys Class.utilities
        has: (aoTarget, asName) ->
          asName in Class.utilities
        set: (aoTarget, asName, aValue, aoReceiver) ->
          unless Reflect.get Class::, asName
            Class.util asName, aValue
        get: (aoTarget, asName) ->
          unless Reflect.get Class::, asName
            vsPath = Class[cphUtilsMap][asName]
            if vsPath
              require(vsPath) Class
          Reflect.get Class::, asName


    # Utils:      null # must be defined as {} in child classes
    # Constants:  null # must be defined as {} in child classes

    @public @static utilities: Object,
      get: ->
        @[cpoUtilsMeta] ?= @metaObject.getGroup 'utilities', no

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

    @public @static util: Function,
      default: (args...) ->
        switch args.length
          when 1
            [ voConfig ] = args
            [ vsName ] = Object.keys voConfig ? {}
            vmLambda = (voConfig ? {})[vsName]
          when 2
            [ vsName, vmLambda ] = args
        unless _.isString(vsName) and (_.isObject(vmLambda) or _.isFunction(vmLambda))
          throw new Error 'Util should be defined as { "name": lambda } object or as name, lambda arguments'
        @[cpoUtilsMeta] = undefined
        @public "#{vsName}": Object,
          default: vmLambda
          isUtility: yes
          const: yes

    @public Utils: Object,
      set: (ahConfig) ->
        for own vsKey, vValue of ahConfig
          unless @Module::[vsKey]
            @constructor.util vsKey, vValue
        return
      get: ->
        Class = @constructor
        Class[cphUtilsMap] ?= do ->
          vsRoot = "#{Class::ROOT}/utils"
          Class::filesTreeSync vsRoot, filesOnly: yes
            .reduce (vhResult, vsItem) ->
              if /\.(js|coffee)$/.test vsItem
                [ blackhole, vsName ] = vsItem.match(/([\w\-\_]+)\.(js|coffee)$/) ? []
                if vsItem and vsName
                  vhResult[_.camelCase vsName] = "#{vsRoot}/#{vsItem}"
              vhResult
            , {}
        Class[cpoUtils] ?= new Proxy {}, Class[cpmUtilsHandler] Class

    @public @static inheritProtected: Function,
      default: (args...) ->
        @super args...
        @[cpoUtilsMeta] = undefined
        @[cphUtilsMap] = undefined
        @[cpoUtils] = undefined


  RC::Module.initialize()
