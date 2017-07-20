

module.exports =
  v4: ->
    'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace /[xy]/g, (c)->
      # we use `Math.random` for cross platform compatibility between NodeJS and ArangoDB
      # when we will be use uuid.v4() for setting value in some attribute
      # then it attribute must has unique constraint index,
      # and logic for setting must check existing record with its value
      sixteenNumber = Number.parseInt Math.random()*10**16
      r = sixteenNumber %% 16
      v = if c is 'x' then r else r & 0x3 | 0x8
      v.toString 16
