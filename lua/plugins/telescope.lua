return {
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      extensions = {
        project = {
          base_dirs = {
            "~/stuff",
          },
          hidden_files = false,
          order_by = "recent",
          search_by = "title",
        },
      },
    },
  },
  {
    "nvim-telescope/telescope-project.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension("project")
    end,
  },
}
