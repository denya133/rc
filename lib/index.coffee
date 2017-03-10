

class RC
  Utils:
    copy:     require './utils/copy'
    error:    require './utils/error'
    extend:   require './utils/extend'
    uuid:     require './utils/uuid'
  Constants:  require './Constants'

  require('./CoreObject') RC
  require('./Interface') RC
  require('./Mixin') RC
  require('./Module') RC

  require('./interfaces/PromiseInterface') RC
  require('./Promise') RC


module.exports = RC
