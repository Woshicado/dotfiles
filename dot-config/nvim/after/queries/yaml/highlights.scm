; extends

; foo: bar
(block_mapping_pair
  value: (flow_node
    [
      (double_quote_scalar)
      (single_quote_scalar)
      (plain_scalar (string_scalar))
    ] @string.value))

; foo: |
;   bar
(block_mapping_pair
  value: (block_node
    (block_scalar) @string.value))

; - bar
(block_sequence_item
  (flow_node
    [
      (double_quote_scalar)
      (single_quote_scalar)
      (plain_scalar (string_scalar))
    ] @string.value))

; { foo: bar }
(flow_mapping
  (_
    value: (flow_node
      [
        (double_quote_scalar)
        (single_quote_scalar)
        (plain_scalar (string_scalar))
      ] @string.value)))

; [ bar, baz ]
(flow_sequence
  (flow_node
    [
      (double_quote_scalar)
      (single_quote_scalar)
      (plain_scalar (string_scalar))
    ] @string.value))
