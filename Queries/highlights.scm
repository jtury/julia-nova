; Generated with Anthropic's Claude Language Model

; Identifiers
(identifier) @identifier

(field_expression
  (identifier) @identifier.property .)

; Symbols
(quote_expression
  ":" @value.symbols
  [
    (identifier)
    (operator)
  ] @value.symbols)

; Function calls
(call_expression
  (identifier) @identifier.function)

(call_expression
  (field_expression
    (identifier) @identifier.function .))

(broadcast_call_expression
  (identifier) @identifier.function)

(broadcast_call_expression
  (field_expression
    (identifier) @identifier.function .))

(binary_expression
  (_)
  (operator) @_pipe
  (identifier) @identifier.function
  (#eq? @_pipe "|>" ".|>"))

; Macros
(macro_identifier
  "@" @identifier.decorator
  (identifier) @identifier.decorator)

(macro_definition
  (signature
    (call_expression
      .
      (identifier) @identifier.decorator)))

; Built-in functions
; print.("\"", filter(name -> getglobal(Core, name) isa Core.Builtin, names(Core)), "\" ")
((identifier) @identifier.function.core
  (#eq? @identifier.function.core
    "applicable" "fieldtype" "getfield" "getglobal" "invoke" "isa" "isdefined" "isdefinedglobal"
    "modifyfield!" "modifyglobal!" "nfields" "replacefield!" "replaceglobal!" "setfield!"
    "setfieldonce!" "setglobal!" "setglobalonce!" "swapfield!" "swapglobal!" "throw" "tuple"
    "typeassert" "typeof"))

; Type definitions
(type_head
  (_) @definition.type)

; Type annotations
(parametrized_type_expression
  [
    (identifier) @identifier.type
    (field_expression
      (identifier) @identifier.type .)
  ]
  (curly_expression
    (_) @identifier.type))

(typed_expression
  (identifier) @identifier.type .)

(unary_typed_expression
  (identifier) @identifier.type .)

(where_expression
  [
    (curly_expression
      (_) @identifier.type)
    (_) @identifier.type
  ] .)

(unary_expression
  (operator) @operator
  (_) @identifier.type
  (#eq? @operator "<:" ">:"))

(binary_expression
  (_) @identifier.type
  (operator) @operator
  (_) @identifier.type
  (#eq? @operator "<:" ">:"))

; Built-in types
; print.("\"", filter(name -> typeof(Base.eval(Core, name)) in [DataType, UnionAll], names(Core)), "\" ")
((identifier) @identifier.type.core
  (#eq? @identifier.type.core
    "AbstractArray" "AbstractChar" "AbstractFloat" "AbstractString" "Any" "ArgumentError" "Array"
    "AssertionError" "AtomicMemory" "AtomicMemoryRef" "Bool" "BoundsError" "Char"
    "ConcurrencyViolationError" "Cvoid" "DataType" "DenseArray" "DivideError" "DomainError"
    "ErrorException" "Exception" "Expr" "FieldError" "Float16" "Float32" "Float64" "Function"
    "GenericMemory" "GenericMemoryRef" "GlobalRef" "IO" "InexactError" "InitError" "Int" "Int128"
    "Int16" "Int32" "Int64" "Int8" "Integer" "InterruptException" "LineNumberNode" "LoadError"
    "Memory" "MemoryRef" "Method" "MethodError" "Module" "NTuple" "NamedTuple" "Nothing" "Number"
    "OutOfMemoryError" "OverflowError" "Pair" "Ptr" "QuoteNode" "ReadOnlyMemoryError" "Real" "Ref"
    "SegmentationFault" "Signed" "StackOverflowError" "String" "Symbol" "Task" "Tuple" "Type"
    "TypeError" "TypeVar" "UInt" "UInt128" "UInt16" "UInt32" "UInt64" "UInt8" "UndefInitializer"
    "UndefKeywordError" "UndefRefError" "UndefVarError" "Union" "UnionAll" "Unsigned" "VecElement"
    "WeakRef"))

; Keywords
[
  "global"
  "local"
] @keyword.modifier

(compound_statement
  [
    "begin"
    "end"
  ] @keyword)

(quote_statement
  [
    "quote"
    "end"
  ] @keyword)

(let_statement
  [
    "let"
    "end"
  ] @keyword)

(if_statement
  [
    "if"
    "end"
  ] @keyword.condition)

(elseif_clause
  "elseif" @keyword.condition)

(else_clause
  "else" @keyword.condition)

(ternary_expression
  [
    "?"
    ":"
  ] @keyword.condition.ternary)

(try_statement
  [
    "try"
    "end"
  ] @keyword.condition.exception)

(catch_clause
  "catch" @keyword.condition.exception)

(finally_clause
  "finally" @keyword.condition.exception)

(for_statement
  [
    "for"
    "end"
  ] @keyword.condition.repeat)

(for_binding
  "outer" @keyword.condition.repeat)

; comprehensions
(for_clause
  "for" @keyword.condition.repeat)

(if_clause
  "if" @keyword.condition)

(while_statement
  [
    "while"
    "end"
  ] @keyword.condition.repeat)

[
  (break_statement)
  (continue_statement)
] @keyword.condition.repeat

[
  "const"
  "mutable"
] @keyword.modifier

(function_definition
  [
    "function"
    "end"
  ] @keyword.construct)

(do_clause
  [
    "do"
    "end"
  ] @keyword.construct)

(macro_definition
  [
    "macro"
    "end"
  ] @keyword.construct)

(return_statement
  "return" @keyword)

(module_definition
  [
    "module"
    "baremodule"
    "end"
  ] @keyword.modifier)

(export_statement
  "export" @keyword.modifier)

(public_statement
  "public" @keyword.modifier)

(import_statement
  "import" @keyword.modifier)

(using_statement
  "using" @keyword.modifier)

(import_alias
  "as" @keyword.modifier)

(selected_import
  ":" @punctuation.delimiter)

(struct_definition
  [
    "mutable"
    "struct"
    "end"
  ] @keyword.construct)

(abstract_definition
  [
    "abstract"
    "type"
    "end"
  ] @keyword.construct)

(primitive_definition
  [
    "primitive"
    "type"
    "end"
  ] @keyword.construct)

; Operators & Punctuation
(operator) @operator

(adjoint_expression
  "'" @operator)

(range_expression
  ":" @operator)

(arrow_function_expression
  "->" @operator)

[
  "."
  "..."
] @operator

[
  ","
  ";"
  "::"
] @punctuation.delimiter

; Treat `::` as operator in type contexts, see
; https://github.com/nvim-treesitter/nvim-treesitter/pull/7392
(typed_expression
  "::" @operator)

(unary_typed_expression
  "::" @operator)

[
  "("
  ")"
  "["
  "]"
  "{"
  "}"
] @bracket

; Interpolation
(string_interpolation
  .
  "$" @string-template)

(interpolation_expression
  .
  "$" @string-template)

; Keyword operators
((operator) @keyword.operator
  (#eq? @keyword.operator "in" "isa"))

(where_expression
  "where" @keyword.operator)

; Built-in constants
((identifier) @value.null
  (#eq? @value.null "nothing" "missing"))

((identifier) @identifier.core
  (#eq? @identifier.core "begin" "end")
  (#has-ancestor? @identifier.core index_expression))

; Literals
(boolean_literal) @value.boolean

(integer_literal) @value.number

(float_literal) @value.number.float

((identifier) @value.number.float
  (#eq? @value.number.float "NaN" "NaN16" "NaN32" "Inf" "Inf16" "Inf32"))

(character_literal) @string.character

(escape_sequence) @string.escape

(string_literal) @string

(prefixed_string_literal
  prefix: (identifier) @identifier.decorator) @string

(command_literal) @string.special

(prefixed_command_literal
  prefix: (identifier) @identifier.decorator) @string.special

((string_literal) @string.documentation
  .
  [
    (abstract_definition)
    (assignment)
    (const_statement)
    (function_definition)
    (macro_definition)
    (module_definition)
    (struct_definition)
  ])

(source_file
  (string_literal) @string.documentation
  .
  [
    (identifier)
    (call_expression)
  ])

[
  (line_comment)
  (block_comment)
] @comment
