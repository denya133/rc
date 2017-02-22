```coffee
  class CoreObject
    @new: (args...)->
      new @ args...

  GenericF = (Type)->
    class F extends CoreObject
      n: null
      s: null
      type: Type
      constructor: (@n, @s)->


  #g = new (GenericF String) 7, 'fgfg'
  g = GenericF(String).new 7, 'fgfg'
  alert "#{g.type.name} #{g.n} #{g.s}"
  h = GenericF(String).new 8, 'f888gfg'
  alert "#{h.type.name} #{h.n} #{h.s}"
  Number(crypto.genRandomNumbers 16) %% 16
  Math.random() * 16 | 0
```
