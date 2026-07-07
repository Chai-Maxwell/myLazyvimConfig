return {
  {
    "folke/edgy.nvim",
    config = function(_, opts)
      -- Ensure winminheight/winminwidth are set to minimize E36 risk
      vim.o.winminheight = 0
      vim.o.winminwidth = 1

      require("edgy").setup(opts)

      -- Monkey-patch edgebar:layout() to gracefully handle E36: Not enough room
      -- This is a neovim race condition (neovim/neovim#19464) where wincmd J/K/L/H
      -- may check available room against the wrong window during layout transitions.
      -- Fixed upstream in PR #25192 for floating windows, but wincmd path is unaffected.
      local ok, edgebar = pcall(require, "edgy.edgebar")
      if not ok then
        return
      end

      local orig_layout = edgebar.layout
      edgebar.layout = function(self, ...)
        local success, err = pcall(orig_layout, self, ...)
        if not success then
          if err and tostring(err):find("E36") then
            require("edgy.util").debug("E36 suppressed, will retry: " .. tostring(err))
          else
            vim.notify("Edgy layout error: " .. tostring(err), vim.log.levels.ERROR)
          end
        end
      end
    end,
  },
}
