return {
  "JavaHello/spring-boot.nvim",
  enabled = true,
  ft = {"java", "yaml", "jproperties"},
  dependencies = {
    "mfussenegger/nvim-jdtls", -- or nvim-java, nvim-lspconfig
    "ibhagwan/fzf-lua", -- optional
  },
  config = false,
}
