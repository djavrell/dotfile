require("trouble").setup {
  mode = "workspace_diagnostics",
  height = 20,
  auto_preview = false,
  auto_jump = {"lsp_definitions", "workspace_diagnostics", "document_diagnostics"}
}
