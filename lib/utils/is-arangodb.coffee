isArangoDB = null

module.exports = ->
  isArangoDB ?= (try require '@arangodb')?
  isArangoDB
