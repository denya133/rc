copy =          require './utils/copy'
extend =        require './utils/extend'
uuid =          require './utils/uuid'
isThenable =    require './utils/is-thenable'
isArangoDB =    require './utils/is-arangodb'
jsonStringify = require './utils/json-stringify'
inflect =       do require 'i'
lodash =        require 'lodash'


class Proto
  Proto::ROOT = __dirname

  Utils:
    extend:   extend
    lodash:   lodash
    _:        lodash
    inflect:  inflect
  NILL:       1  # when value is null and undefined
  ANY:        2   # for any instance class
  SELF:       3
  VIRTUAL:    4
  STATIC:     5
  ASYNC:      6
  CONST:      7
  PUBLIC:     8
  PRIVATE:    9
  PROTECTED:  10

  require('./MetaObject') Proto
  require('./CoreObject') Proto
  require('./Module') Proto


class RC extends Proto::Module
  @inheritProtected()

  @root __dirname

  Utils:
    copy:           copy
    extend:         extend
    uuid:           uuid
    isThenable:     isThenable
    isArangoDB:     isArangoDB
    jsonStringify:  jsonStringify
    lodash:         lodash
    _:              lodash
    inflect:        inflect

  @const NILL:      1  # when value is null and undefined
  @const ANY:       2   # for any instance class
  @const SELF:      3
  @const VIRTUAL:   4
  @const STATIC:    5
  @const ASYNC:     6
  @const CONST:     7
  @const PUBLIC:    8
  @const PRIVATE:   9
  @const PROTECTED: 10
  @const LAMBDA:    11

  require('./MetaObject') RC
  require('./CoreObject') RC
  require('./Module') RC

  RC.const MetaObject: RC::MetaObject
  RC.const CoreObject: RC::CoreObject
  RC.const Class: RC::Class

  # require('./interfaces/PromiseInterface') RC
  require('./Promise') RC
  require('./utils/has-native-promise') RC
  require('./utils/read-file') RC
  require('./utils/files-list') RC
  require('./utils/files-list-sync') RC
  require('./utils/files-tree') RC
  require('./utils/files-tree-sync') RC
  require('./utils/co') RC
  require('./utils/for-each') RC
  require('./utils/map') RC
  require('./utils/filter') RC
  require('./utils/sync-set-timeout') RC
  require('./utils/request') RC
  require('./statemachine/HookedObject') RC
  require('./statemachine/State') RC
  require('./statemachine/Transition') RC
  require('./statemachine/Event') RC
  require('./statemachine/StateMachine') RC
  require('./mixins/chainsMixin') RC
  require('./mixins/stateMachineMixin') RC


module.exports = RC.initialize().freeze()
