; Replaces bundled injections.scm.
; - Uses our own (#set-lang-from-info-string!) directive so info strings
;   like ```path/to/file.rb +23 highlight as ruby (registered in
;   lua/plugins/init.lua nvim-treesitter config). The bundled query on
;   nvim-treesitter main uses raw @injection.language and only handles
;   exact parser names.
; - markdown_inline injection still disabled (Neovim 0.12 nil node:range()).

(fenced_code_block
  (info_string
    (language) @_lang)
  (code_fence_content) @injection.content
  (#set-lang-from-info-string! @_lang))

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
