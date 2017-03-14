

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
  require('./utils/read-file') RC
  require('./utils/co') RC


module.exports = RC
