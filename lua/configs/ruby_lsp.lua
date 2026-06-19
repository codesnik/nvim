-- Eager start + indexing-aware helpers for ruby_lsp.
--
-- nvim-lspconfig is lazy (event = "User FilePost"), so opening nvim with no
-- file (or a non-ruby file) never runs its config and never starts ruby_lsp.
-- This module force-loads that plugin when needed and starts the client at the
-- project root, attached to the current buffer (telescope's workspace-symbol
-- pickers only query clients attached to the current buffer).
--
-- ruby_lsp also indexes asynchronously (~13s here); querying a half-built index
-- returns stale results, so we track indexing completion and let callers defer
-- until it's done.

local M = { indexed = {} } -- set of client ids that have finished indexing

local function in_ruby_project()
  local cwd = vim.fn.getcwd()
  return vim.fn.filereadable(cwd .. "/Gemfile") == 1
    or vim.fn.filereadable(cwd .. "/.ruby-version") == 1
    or vim.fn.glob(cwd .. "/*.gemspec") ~= ""
end

local function is_index_end(ev)
  local c = vim.lsp.get_client_by_id(ev.data.client_id)
  if not c or c.name ~= "ruby_lsp" then return false end
  local v = ev.data.params and ev.data.params.value
  -- 0.12 carries the `begin` title onto `end`, so match "Indexing" here.
  return v ~= nil and (v.title or ""):lower():find("index") ~= nil
end

-- Ensure ruby_lsp is running for the current project; returns the client (or
-- nil if not a ruby project / failed to start).
function M.ensure_started()
  if not in_ruby_project() then return nil end
  local existing = vim.lsp.get_clients({ name = "ruby_lsp" })[1]
  if existing then return existing end
  require("lazy").load({ plugins = { "nvim-lspconfig" } }) -- sets vim.lsp.config/enable
  local cfg = vim.deepcopy(vim.lsp.config["ruby_lsp"])
  cfg.name = "ruby_lsp"
  cfg.root_dir = vim.fn.getcwd()
  local id = vim.lsp.start(cfg)
  return id and vim.lsp.get_client_by_id(id) or nil
end

-- Run cb once ruby_lsp has finished indexing (immediately if already done, or
-- right away if this isn't a ruby project so the caller can fall back).
function M.when_indexed(cb)
  local c = M.ensure_started()
  if not c or M.indexed[c.id] then return cb() end
  local group = vim.api.nvim_create_augroup("RubyLspWhenIndexed", { clear = true })
  vim.api.nvim_create_autocmd("LspProgress", {
    group = group,
    pattern = "end",
    callback = function(ev)
      if ev.data.client_id ~= c.id or not is_index_end(ev) then return end
      vim.api.nvim_del_augroup_by_id(group)
      cb()
    end,
  })
end

-- Register indexing tracking and kick off the eager start. Call once at startup,
-- synchronously, so the tracking autocmd exists before any LSP starts.
function M.setup()
  vim.api.nvim_create_autocmd("LspProgress", {
    pattern = "end",
    callback = function(ev)
      if is_index_end(ev) then M.indexed[ev.data.client_id] = true end
    end,
  })
  vim.schedule(function() M.ensure_started() end) -- start indexing at launch
end

return M
