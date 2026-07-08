-- Detect Helm charts and set the `helm` filetype so helm_ls attaches.
local function in_chart(path)
  return vim.fs.root(path, "Chart.yaml") ~= nil and "helm" or nil
end

vim.filetype.add({
  filename = {
    ["Chart.yaml"] = "helm",
    ["values.yaml"] = { in_chart },
  },
  pattern = {
    [".*/templates/.*%.ya?ml"] = { in_chart },
    [".*/templates/.*%.tpl"] = { in_chart },
    [".*/templates/.*%.txt"] = { in_chart },
    [".*/values.*%.ya?ml"] = { in_chart },
  },
})
