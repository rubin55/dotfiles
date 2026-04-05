return {
  settings = {
    ['rust-analyzer'] = {
      check = {
        command = 'clippy',
      },
      completion = {
        fullFunctionSignatures = {
          enable = true,
        },
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
