

class RC
  Utils:
    copy:       require './utils/copy'
    error:      require './utils/error'
    extend:     require './utils/extend'
    uuid:       require './utils/uuid'
    isThenable: require './utils/is-thenable'
  Constants:    require './Constants'

  require('./CoreObject') RC
  require('./Interface') RC
  require('./Mixin') RC
  require('./Module') RC

  require('./interfaces/PromiseInterface') RC
  require('./Promise') RC
  require('./statemachine/HookedObject') RC
  require('./statemachine/State') RC
  require('./statemachine/Transition') RC
  require('./statemachine/StateMachine') RC
  require('./utils/read-file') RC
  require('./utils/co') RC
  require('./utils/sync-set-timeout') RC
  require('./mixins/chainsMixin') RC
  require('./mixins/stateMachineMixin') RC


module.exports = RC
