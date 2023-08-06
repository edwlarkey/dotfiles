vim.filetype.add({
  extension = {
    ["gotmpl"] = "gotmpl",
    ["tmpl"] = "gotmpl",
  },
  filename = {
    [".editorconfig"] = "toml",
    [".dockerignore"] = "gitignore",
  },
  pattern = {
    ["Dockerfile.*"] = "dockerfile",
  },
})
