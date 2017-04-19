

class TempRC
  Utils:
    extend:     require './utils/extend'
  Constants:    require './Constants'

  require('./MetaObject') TempRC
  require('./CoreObject') TempRC
  require('./Module') TempRC


class RC extends TempRC::Module
  @inheritProtected()
  Utils:
    copy:       require './utils/copy'
    error:      require './utils/error'
    extend:     require './utils/extend'
    uuid:       require './utils/uuid'
    isThenable: require './utils/is-thenable'
    isArangoDB: require './utils/is-arangodb'
  Constants:    require './Constants'

  require('./MetaObject') RC
  require('./CoreObject') RC
  require('./Module') RC

  RC.const MetaObject: RC::MetaObject
  RC.const CoreObject: RC::CoreObject
  RC.const Class: RC::Class

  require('./Interface') RC
  require('./Mixin') RC

  require('./interfaces/PromiseInterface') RC
  require('./Promise') RC
  require('./statemachine/HookedObject') RC
  require('./statemachine/State') RC
  require('./statemachine/Transition') RC
  require('./statemachine/Event') RC
  require('./statemachine/StateMachine') RC
  require('./utils/has-native-promise') RC
  require('./utils/read-file') RC
  require('./utils/co') RC
  require('./utils/sync-set-timeout') RC
  require('./utils/request') RC
  require('./mixins/chainsMixin') RC
  require('./mixins/stateMachineMixin') RC


module.exports = RC.initialize()
