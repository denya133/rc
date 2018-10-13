copy =          require './utils/copy'
extend =        require './utils/extend'
uuid =          require './utils/uuid'
isThenable =    require './utils/is-thenable'
isArangoDB =    require './utils/is-arangodb'
jsonStringify = require './utils/json-stringify'
inflect =       do require 'i'
lodash =        require 'lodash'
t =             require 'tcomb'

t.fail = (message)-> throw new TypeError "[RC::TypeT] #{message}"

class Proto
  Proto::ROOT = __dirname

  extend:   extend
  lodash:   lodash
  _:        lodash
  t:        t
  inflect:  inflect
  isArangoDB: isArangoDB

  NILL:      'NILL'  # when value is null and undefined
  ANY:       'ANY'   # for any instance class
  SELF:      'SELF'
  VIRTUAL:   'VIRTUAL'
  STATIC:    'STATIC'
  ASYNC:     'ASYNC'
  CONST:     'CONST'
  PUBLIC:    'PUBLIC'
  PRIVATE:   'PRIVATE'
  PROTECTED: 'PROTECTED'
  LAMBDA:    'LAMBDA' # удалять не надо. надо будет продумать ее использование в тех случаях, когда в качестве значения в атрибут надо сохранить некоторую лямбду.
  PRODUCTION: 'production'
  DEVELOPMENT: 'development'

  require('./MetaObject') Proto
  require('./CoreObject') Proto
  require('./Module') Proto


class RC extends Proto::Module
  @inheritProtected()

  cphUtilsMap = Symbol.for '~utilsMap'
  cpoUtils = Symbol.for '~utils'
  cpoUtilsMeta = Symbol.for '~utilsMeta'

  @[cpoUtilsMeta] = undefined
  @[cphUtilsMap] = undefined
  @[cpoUtils] = undefined

  @root __dirname

  @util copy          : copy
  @util extend        : extend
  @util uuid          : uuid
  @util isThenable    : isThenable
  @util isArangoDB    : isArangoDB
  @util jsonStringify : jsonStringify
  @util lodash        : lodash
  @util _             : lodash
  @util t             : t
  @util inflect       : inflect

  require('./utils/has-native-promise') RC
  require('./utils/read-file') RC
  require('./utils/files-list') RC
  require('./utils/files-list-sync') RC
  require('./utils/files-tree') RC
  require('./utils/files-tree-sync') RC

  require('./utils/get-optional-arguments-index') RC
  require('./utils/get-type-name') RC
  require('./utils/create-by-type') RC
  require('./utils/from-json') RC
  require('./utils/is-subset-of') RC
  require('./utils/value-is-type') RC
  require('./utils/match') RC

  require('./utils/co') RC
  require('./utils/for-each') RC
  require('./utils/map') RC
  require('./utils/filter') RC
  require('./utils/set-timeout') RC
  require('./utils/request') RC

  @const NILL:      'NILL'  # when value is null and undefined
  @const ANY:       'ANY'   # for any instance class
  @const SELF:      'SELF'
  @const VIRTUAL:   'VIRTUAL'
  @const STATIC:    'STATIC'
  @const ASYNC:     'ASYNC'
  @const CONST:     'CONST'
  @const PUBLIC:    'PUBLIC'
  @const PRIVATE:   'PRIVATE'
  @const PROTECTED: 'PROTECTED'
  @const LAMBDA:    'LAMBDA' # удалять не надо. надо будет продумать ее использование в тех случаях, когда в качестве значения в атрибут надо сохранить некоторую лямбду.
  @const PRODUCTION: 'production'
  @const DEVELOPMENT: 'development'

  require('./MetaObject') RC
  require('./CoreObject') RC
  require('./Module') RC
  require('./Promise') RC

  RC.const MetaObject: RC::MetaObject
  RC.const CoreObject: RC::CoreObject
  RC.const Class: RC::Class
  RC.const Module: RC::Module
  RC.const Promise: RC::Promise

  require('./generics/Mixin') RC
  require('./generics/Generic') RC
  require('./generics/Declare') RC

  require('./generics/AccordG') RC
  require('./generics/AsyncFuncG') RC
  require('./generics/DictG') RC
  require('./generics/EnumG') RC
  require('./generics/FuncG') RC
  require('./generics/InterfaceG') RC
  require('./generics/IntersectionG') RC
  require('./generics/IrreducibleG') RC
  require('./generics/ListG') RC
  require('./generics/MapG') RC
  require('./generics/MaybeG') RC
  require('./generics/NotSampleG') RC
  require('./generics/SampleG') RC
  require('./generics/SetG') RC
  require('./generics/StructG') RC
  require('./generics/SubtypeG') RC
  require('./generics/TupleG') RC
  require('./generics/UnionG') RC

  require('./types/TypeT') RC
  require('./types/AnyT') RC
  require('./types/ArrayT') RC
  require('./types/BooleanT') RC
  require('./types/BufferT') RC
  require('./types/ClassT') RC
  require('./types/DateT') RC
  require('./types/DictT') RC
  require('./types/EnumT') RC
  require('./types/ErrorT') RC
  require('./types/EventEmitterT') RC
  require('./types/FunctionT') RC
  require('./types/FunctorT') RC
  require('./types/GeneratorFunctionT') RC
  require('./types/GeneratorT') RC
  require('./types/GenericT') RC
  require('./types/NumberT') RC
  require('./types/IntegerT') RC
  require('./types/InterfaceT') RC
  require('./types/IntersectionT') RC
  require('./types/ListT') RC
  require('./types/MapT') RC
  require('./types/MaybeT') RC
  require('./types/MixinT') RC
  require('./types/ModuleT') RC
  require('./types/NilT') RC
  require('./types/ObjectT') RC
  require('./types/PointerT') RC
  require('./types/PromiseT') RC
  require('./types/RegExpT') RC
  require('./types/SetT') RC
  require('./types/StreamT') RC
  require('./types/StringT') RC
  require('./types/StructT') RC
  require('./types/SymbolT') RC
  require('./types/TupleT') RC
  require('./types/UnionT') RC

  # RC::Declare 'EventInterface'
  # RC::Declare 'HookedObjectInterface'
  # RC::Declare 'StateInterface'
  RC::Declare 'StateMachineInterface'
  # RC::Declare 'TransitionInterface'

  require('./Interface') RC
  require('./interfaces/PromiseInterface') RC
  require('./interfaces/HookedObjectInterface') RC
  require('./interfaces/StateInterface') RC
  require('./interfaces/TransitionInterface') RC
  require('./interfaces/StateMachineInterface') RC
  require('./interfaces/EventInterface') RC

  require('./statemachine/HookedObject') RC
  require('./statemachine/State') RC
  require('./statemachine/Transition') RC
  require('./statemachine/Event') RC
  require('./statemachine/StateMachine') RC
  require('./mixins/chainsMixin') RC
  require('./mixins/stateMachineMixin') RC

  @public @static inheritProtected: Function,
    default: (args...) ->
      @super args...
      @[cpoUtilsMeta] = undefined
      @[cphUtilsMap] = undefined
      @[cpoUtils] = undefined


module.exports = RC.initialize().freeze()
