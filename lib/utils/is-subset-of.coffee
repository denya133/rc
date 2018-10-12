

module.exports = (Module) ->
  {
    PRODUCTION
    Utils: {
      _
      t: { assert }
      getTypeName
      createByType
    }
  } = Module::

  isRefinement = (type)->
    Module::TypeT.is(type) and type.meta.kind is 'subtype'

  getPredicates = (type)->
    if isRefinement type
      [type.meta.predicate].concat getPredicates type.meta.type
    else
      []

  getUnrefinedType = (type)->
    if isRefinement type
      getUnrefinedType type.meta.type
    else
      type

  decompose = (type)->
    {
      predicates: getPredicates type
      unrefinedType: getUnrefinedType type
    }

  leqList = (As, Bs)->
    As.length is Bs.length and As.every (A, i)-> recurse A, Bs[i]

  leqPredicates = (ps1, ps2)->
    ps2.length <= ps1.length and ps2.every (p)-> p in ps1

  index = new Map()#[]

  find = (A, B)->
    index.get "#{getTypeName A}<<#{getTypeName B}"
    # for item in index when item.A is A and item.B is B
    #   return item

  leq = (A, B)->

    # Fast results
    # (1) if B === t.Any then A <= B for all A
    # (2) if B === A then A <= B for all A
    if A is B or B is Module::AnyT
      return yes

    kindA = A.meta.kind
    kindB = B.meta.kind

    # Reductions

    # (3) if B = maybe(C) and A is not a maybe then A <= B if and only if A === t.Nil or A <= C
    if kindB is 'maybe' and kindA isnt 'maybe'
      return ( A is Module::NilT ) or recurse A, B.meta.type

    gte = (type)-> recurse A, type

    # (4) if B is a union then A <= B if exists B' in B.meta.types such that A <= B'
    if kindB is 'union'
      if B.meta.types.some gte
        return yes

    # (5) if B is an intersection then A <= B if A <= B' for all B' in B.meta.types
    if kindB is 'intersection'
      if B.meta.types.every gte
        return yes

    # Let A be a maybe then A <= B if B is a maybe and A.meta.type <= B.meta.type
    if kindA is 'maybe'
      return kindB is 'maybe' and recurse A.meta.type, B.meta.type

    # Let A be an union then A <= B if A' <= B for all A' in A.meta.types
    else if kindA is 'union'
      return A.meta.types.every (T)-> recurse T, B

    # Let A be an intersection then A <= B if exists A' in A.meta.types such that A' <= B
    else if kindA is 'intersection'
      return A.meta.types.some (T)-> recurse T, B

    # Let A be irreducible then A <= B if B is irreducible and A.is === B.is
    else if kindA is 'irreducible'
      return kindB is 'irreducible' and A.meta.predicate is B.meta.predicate

    # Let A be an enum then A <= B if and only if B.is(a) === true for all a in keys(A.meta.map)
    else if kindA is 'enums'
      return Object.keys(A.meta.map).every B.is

    # Let A be a refinement then A <= B if decompose(A) <= decompose(B)
    else if kindA is 'subtype'
      dA = decompose A
      dB = decompose B
      return leqPredicates(dA.predicates, dB.predicates) and recurse dA.unrefinedType, dB.unrefinedType

    # Let A be a list then A <= B if one of the following holds:
    else if kindA is 'list'
      # B === t.Array
      if B is Module::ArrayT
        return yes
      # B is a list and A.meta.type <= B.meta.type
      return kindB is 'list' and recurse A.meta.type, B.meta.type

    # Let A be a set then A <= B if one of the following holds:
    else if kindA is 'set'
      # B === t.Array
      if B is Module::ArrayT
        return yes
      # B is a list and A.meta.type <= B.meta.type
      return kindB is 'list' and recurse A.meta.type, B.meta.type

    # Let A be a list then A <= B if one of the following holds:
    else if kindA is 'dict'
      # B === t.Object
      if B is Module::ObjectT
        return yes
      # B is a dictionary and [A.meta.domain, A.meta.codomain] <= [B.meta.domain, B.meta.codomain]
      return kindB is 'dict' and recurse(A.meta.domain, B.meta.domain) and recurse(A.meta.codomain, B.meta.codomain)

    # Let A be a map then A <= B if one of the following holds:
    else if kindA is 'map'
      # B === t.Object
      if B is Module::ObjectT
        return yes
      # B is a dictionary and [A.meta.domain, A.meta.codomain] <= [B.meta.domain, B.meta.codomain]
      return kindB is 'dict' and recurse(A.meta.domain, B.meta.domain) and recurse(A.meta.codomain, B.meta.codomain)

    # Let A be a tuple then A <= B if one of the following holds:
    else if kindA is 'tuple'
      # B === t.Array
      if B is Module::ArrayT
        return yes
      # B is a tuple and A.meta.types <= B.meta.types
      return kindB is 'tuple' and leqList(A.meta.types, B.meta.types)

    # Let A be a function then then A <= B if one of the following holds:
    else if kindA is 'func'
      # B === t.Function
      if B is Module::FunctionT
        return yes
      # B is a function and [A.meta.domain, A.meta.codomain] <= [B.meta.domain, B.meta.codomain]
      return kindB is 'func' and recurse(A.meta.codomain, B.meta.codomain) and leqList(A.meta.domain, B.meta.domain)

    # Let A be an interface then A <= B if one of the following holds:
    else if kindA in ['interface', 'struct']
      # B === t.Object
      if B is Module::ObjectT
        return yes
      if kindB is 'interface'
        keysB = Object.keys B.meta.props
        compatible = keysB.every (k)->
          return A.meta.props.hasOwnProperty(k) and recurse(A.meta.props[k], B.meta.props[k])
        # B is an interface, B.meta.strict === no, keys(B.meta.props) <= keys(A.meta.props) and A.meta.props[k] <= B.meta.props[k] for all k in keys(B.meta.props)
        if B.meta.strict is no
          return compatible
        # B is an interface, B.meta.strict === true, A.meta.strict === true, keys(B.meta.props) = keys(A.meta.props) and A.meta.props[k] <= B.meta.props[k] for all k in keys(B.meta.props)
        return compatible and A.meta.strict is yes and keysB.length is Object.keys(A.meta.props).length

    return no


  recurse = (A, B)->
    # handle recursive types
    if (hit = find A, B)?
      return hit.leq

    hit = { A, B, leq: yes }
    index.set "#{getTypeName A}<<#{getTypeName B}", hit
    hit.leq = leq A, B
    return hit.leq

  Module.util isSubsetOf: (A, B)->
    if Module.environment isnt PRODUCTION
      assert Module::TypeT.is(A), -> "Invalid argument subset #{assert.stringify A} supplied to isSubsetOf(subset, superset) (expected a type)"
      assert Module::TypeT.is(B), -> "Invalid argument superset #{assert.stringify B} supplied to isSubsetOf(subset, superset) (expected a type)"
    recurse A, B
