; extends

; Azure Pipelines step shorthands.

; - bash: echo hello
(block_mapping_pair
  key: (flow_node) @_run
  (#eq? @_run "bash")
  value: (flow_node
    (plain_scalar
      (string_scalar) @injection.content)
    (#set! injection.language "bash")))

; - bash: |
;     echo hello
(block_mapping_pair
  key: (flow_node) @_run
  (#eq? @_run "bash")
  value: (block_node
    (block_scalar) @injection.content
    (#set! injection.language "bash")
    (#offset! @injection.content 0 1 0 0)))

; - bash:
;     - echo hello
(block_mapping_pair
  key: (flow_node) @_run
  (#eq? @_run "bash")
  value: (block_node
    (block_sequence
      (block_sequence_item
        (flow_node
          (plain_scalar
            (string_scalar) @injection.content))
        (#set! injection.language "bash")))))

; - bash:
;     - |
;       echo hello
(block_mapping_pair
  key: (flow_node) @_run
  (#eq? @_run "bash")
  value: (block_node
    (block_sequence
      (block_sequence_item
        (block_node
          (block_scalar) @injection.content
          (#set! injection.language "bash")
          (#offset! @injection.content 0 1 0 0))))))

; - pwsh: |
;     Write-Host "hi"
(block_mapping_pair
  key: (flow_node) @_run
  (#any-of? @_run "pwsh" "powershell")
  value: (flow_node
    (plain_scalar
      (string_scalar) @injection.content)
    (#set! injection.language "powershell")))

(block_mapping_pair
  key: (flow_node) @_run
  (#any-of? @_run "pwsh" "powershell")
  value: (block_node
    (block_scalar) @injection.content
    (#set! injection.language "powershell")
    (#offset! @injection.content 0 1 0 0)))
