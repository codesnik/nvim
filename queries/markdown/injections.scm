; Replaces bundled injections.scm to disable markdown_inline
; (Neovim 0.12 crash: nil node:range() in injected parser)

(fenced_code_block
  (info_string
    (language) @injection.language)
  (code_fence_content) @injection.content)

((html_block) @injection.content
  (#set! injection.language "html")
  (#set! injection.combined)
  (#set! injection.include-children))

((minus_metadata) @injection.content
  (#set! injection.language "yaml")
  (#offset! @injection.content 1 0 -1 0)
  (#set! injection.include-children))

((plus_metadata) @injection.content
  (#set! injection.language "toml")
  (#offset! @injection.content 1 0 -1 0)
  (#set! injection.include-children))

; markdown_inline injection removed — was:
; ([inline] [pipe_table_cell]) @injection.content
;   (#set! injection.language "markdown_inline")
