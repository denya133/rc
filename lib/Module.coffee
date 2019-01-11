###
  ```
  ```
###


module.exports = (RC)->
  {
    PUBLIC
    PRODUCTION
    DEVELOPMENT
    CACHE
    SOFT
    CoreObject
  } = RC::

  _ = RC::_ ? RC::Utils._
  t = RC::t ? RC::Utils.t
  inflect = RC::inflect ? RC::Utils.inflect
  isArangoDB = RC::isArangoDB ? RC::Utils.isArangoDB
  { assert } = t

  class RC::Module extends CoreObject
    @inheritProtected()
    @module RC

    cphUtilsMap = Symbol.for '~utilsMap'
    cpoUtils = Symbol.for '~utils'
    cpoUtilsMeta = Symbol.for '~utilsMeta'
    cpmUtilsHandler = Symbol.for '~utilsHandler'

    cpmDefineProperty = Symbol.for '~defineProperty'

    constructor: ->
      super()
      assert.fail 'new operator unsupported' if @ instanceof RC::Module

    Reflect.defineProperty @, 'new',
      enumerable: yes
      value: -> assert.fail 'new method unsupported for Module'

    Reflect.defineProperty @, cphUtilsMap,
      enumerable: yes
      writable: yes
      value: null

    Reflect.defineProperty @, cpoUtils,
      enumerable: yes
      writable: yes
      value: null

    Reflect.defineProperty @, cpoUtilsMeta,
      enumerable: yes
      writable: yes
      value: null

    Reflect.defineProperty @, cpmUtilsHandler,
      enumerable: yes
      value: (aClass) ->
        ownKeys: (aoTarget) ->
          Reflect.ownKeys aClass.utilities
        has: (aoTarget, asName) ->
          asName in aClass.utilities
        set: (aoTarget, asName, aValue, aoReceiver) ->
          unless Reflect.get aClass::, asName
            aClass.util asName, aValue
        get: (aoTarget, asName) ->
          unless Reflect.get aClass::, asName
            vsPath = aClass[cphUtilsMap][asName]
            if vsPath
              require(vsPath) aClass
          Reflect.get aClass::, asName

    Reflect.defineProperty @, 'utilities',
      enumerable: yes
      get: -> @[cpoUtilsMeta] ?= @metaObject.getGroup 'utilities', no

    Reflect.defineProperty @, 'Module',
      enumerable: yes
      get: -> @

    Reflect.defineProperty @, 'environment',
      enumerable: yes
      get: ->
        if isArangoDB()
          if module.context.isProduction
            PRODUCTION
          else
            DEVELOPMENT
        else
          if process?.env?.NODE_ENV is 'production'
            PRODUCTION
          else
            DEVELOPMENT

    Reflect.defineProperty @, 'root',
      enumerable: yes
      value: (path)-> @::ROOT = path

    # чтобы в базовом коде мог через DI искать классы, по строковым константам, которые объявляются в унаследованных классах
    Reflect.defineProperty @, 'lookup',
      enumerable: yes
      value: (fullname)->
        [section, name] = fullname.split ':'
        vsSection = inflect.camelize section
        vsName = inflect.camelize name
        @::["#{vsName}#{vsSection}"] ? null

    Reflect.defineProperty @, 'defineMixin',
      enumerable: yes
      value: (args...) ->
        assert args.length > 0, 'defineMixin() method required min one lambda argument'
        if args.length is 2
          [vsBaseClass, vmFunction] = args
          vmFunction = @Module::Mixin vsBaseClass, vmFunction
        else if args.length is 1
          [vmFunction] = args
        res = @const "#{vmFunction.name}": vmFunction
        res

    Reflect.defineProperty @, 'defineGeneric',
      enumerable: yes
      value: (amFunction) ->
        assert _.isFunction(amFunction), "Invalid argument amFunction #{assert.stringify amFunction} supplied to defineGeneric(amFunction) (expected a function)"
        res = @const "#{amFunction.name}": amFunction
        res

    Reflect.defineProperty @, 'defineType',
      enumerable: yes
      value: (amFunction) ->
        assert _.isFunction(amFunction), "Invalid argument amFunction #{assert.stringify amFunction} supplied to defineInterface(amFunction) (expected a function)"
        res = @const "#{amFunction.name}": amFunction
        res

    Reflect.defineProperty @, 'defineInterface',
      enumerable: yes
      value: (amFunction) ->
        assert _.isFunction(amFunction), "Invalid argument amFunction #{assert.stringify amFunction} supplied to defineInterface(amFunction) (expected a function)"
        res = @const "#{amFunction.name}": amFunction
        res

    Reflect.defineProperty @, 'util',
      enumerable: yes
      value: (args...) ->
        switch args.length
          when 1
            [ voConfig ] = args
            [ vsName ] = Object.keys voConfig ? {}
            vmLambda = (voConfig ? {})[vsName]
          when 2
            [ vsName, vmLambda ] = args
        assert _.isString(vsName) and (_.isObject(vmLambda) or _.isFunction(vmLambda)), 'Util should be defined as { "name": lambda } object or as name, lambda arguments'
        @[cpoUtilsMeta] = undefined
        @[cpmDefineProperty] {
          attr: vsName
          attrType: null
          level: PUBLIC
          isUtility: yes
          default: vmLambda

        }

    Reflect.defineProperty @::, 'Utils',
      enumerable: yes
      set: (ahConfig) ->
        for own vsKey, vValue of ahConfig
          unless @Module::[vsKey]
            @constructor.util vsKey, vValue
        return
      get: ->
        MClass = @constructor
        MClass[cphUtilsMap] ?= do ->
          vsRoot = "#{MClass::ROOT}/utils"
          MClass::filesTreeSync vsRoot, filesOnly: yes
            .reduce (vhResult, vsItem) ->
              if /\.(js|coffee)$/.test vsItem
                [ blackhole, vsName ] = vsItem.match(/([\w\-\_]+)\.(js|coffee)$/) ? []
                if vsItem and vsName
                  vhResult[_.camelCase vsName] = "#{vsRoot}/#{vsItem}"
              vhResult
            , {}
        MClass[cpoUtils] ?= new Proxy {}, MClass[cpmUtilsHandler] MClass

    Reflect.defineProperty @, 'displayName',
      configurable: no
      enumerable: yes
      get: -> @name

    Reflect.defineProperty @, 'cacheStrategy',
      configurable: no
      enumerable: yes
      writable: no
      value: SOFT

    Reflect.defineProperty @, 'meta',
      configurable: no
      enumerable: yes
      get: -> {
        kind: 'module'
        name: @name
        identity: yes
      }

  CACHE.set RC::Module, 'Module'
