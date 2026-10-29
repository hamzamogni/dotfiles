-- Catppuccin Mocha in dark mode, Latte in light mode, following macOS live.
-- Its colors are swapped for the Ghostty "T3 Dark" and "T3 Light" palettes: neutral grays with no
-- tint, and the same accent colors as the terminal.
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "auto",
      background = { light = "latte", dark = "mocha" },
      color_overrides = {
        mocha = {
          text = "#e6e6e6",
          subtext1 = "#c6c6c6",
          subtext0 = "#a8a8a8",
          overlay2 = "#919191",
          overlay1 = "#7a7a7a",
          overlay0 = "#6b6b6b",
          surface2 = "#4a4a4a",
          surface1 = "#333333",
          surface0 = "#262626",
          base = "#101010",
          mantle = "#1c1c1c",
          crust = "#141414",
          red = "#f2555a",
          maroon = "#ff7b80",
          peach = "#feaf62",
          yellow = "#f5c451",
          green = "#4cc38a",
          teal = "#3fc1d9",
          sky = "#6fd8ec",
          sapphire = "#3fc1d9",
          blue = "#4c96ed",
          lavender = "#75b2ff",
          mauve = "#b08cf5",
          pink = "#c9adff",
        },
        latte = {
          text = "#171717",
          subtext1 = "#333333",
          subtext0 = "#4d4d4d",
          overlay2 = "#666666",
          overlay1 = "#7a7a7a",
          overlay0 = "#8f8f8f",
          surface2 = "#a8a8a8",
          surface1 = "#c7c7c7",
          surface0 = "#e0e0e0",
          base = "#ffffff",
          mantle = "#f2f2f2",
          crust = "#e8e8e8",
          red = "#d92d33",
          maroon = "#e5484d",
          peach = "#d9730d",
          yellow = "#a87a00",
          green = "#1a8a52",
          teal = "#0e8a9e",
          sky = "#14a3b8",
          sapphire = "#0e8a9e",
          blue = "#0068d6",
          lavender = "#0091fe",
          mauve = "#7c3aed",
          pink = "#9d6bf5",
        },
      },
    },
  },
  {
    "f-person/auto-dark-mode.nvim",
    lazy = false,
    priority = 999,
    opts = {
      set_dark_mode = function()
        vim.o.background = "dark"
        vim.cmd.colorscheme("catppuccin-mocha")
      end,
      set_light_mode = function()
        vim.o.background = "light"
        vim.cmd.colorscheme("catppuccin-latte")
      end,
      fallback = "dark",
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
