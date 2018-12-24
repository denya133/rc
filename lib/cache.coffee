module.exports = {
  'BooleanT': [ no, yes ]
  'NumberT': [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 ]
  '{NumberT | IntegerT}': [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 ]
  'NilT': [ null, undefined ]
  'PointerT': [
    'Symbol(~doHook)'
    'Symbol(~getChains)'
  ],
  'StringT': [
    ''
    'string'
    'Interface'
    'str'
    'result'
    'key'
    'default'
  ]
  'SymbolT': []
  'true | false': [ yes, no ]
}
