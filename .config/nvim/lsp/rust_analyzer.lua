return {
  settings = {
    ['rust-analyzer'] = {
      cargo = {
        features = "all",
      },
      check = {
        command = 'clippy',
      },
      completion = {
        fullFunctionSignatures = {
          enable = true,
        },
      },
      diagnostics = {
        disabled = { "unlinked-file" },
      },
      hover = {
        maxSubstitutionLength = nil,
        show = {
          enumVariants = 100,
          fields = 100,
        },
      },
    },
  },
}
