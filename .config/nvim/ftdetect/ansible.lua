vim.filetype.add({
  pattern = {
    -- Top-level project directories.
    [".*/host_vars/.*%.ya?ml"] = "yaml.ansible",
    [".*/group_vars/.*%.ya?ml"] = "yaml.ansible",
    [".*/playbooks/.*%.ya?ml"] = "yaml.ansible",
    -- Playbook files by naming convention.
    [".*/playbook.*%.ya?ml"] = "yaml.ansible",
    -- Role directories (valid at any nesting level).
    [".*/tasks/.*%.ya?ml"] = "yaml.ansible",
    [".*/handlers/.*%.ya?ml"] = "yaml.ansible",
    [".*/defaults/.*%.ya?ml"] = "yaml.ansible",
    -- Role-only directories (require roles/ ancestor).
    [".*/roles/.*/vars/.*%.ya?ml"] = "yaml.ansible",
    [".*/roles/.*/meta/.*%.ya?ml"] = "yaml.ansible",
    -- Molecule testing
    [".*/molecule/.*%.ya?ml"] = "yaml.ansible",
  },
})
