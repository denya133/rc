

module.exports = (Module) ->
  Module.util getTypeName: (ctor)->
    ctor.displayName ? ctor.name ? "<function #{ctor.length} >"
