-- Catppuccin Mocha in dark mode, Latte in light mode, following macOS live.
-- Its colors are swapped for the Ghostty "T3 Dark" and "T3 Light" palettes: neutral grays in dark
-- mode, T3 Code's zinc grays and blue in light mode, and the same accent colors as the terminal.
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
          text = "#18181b",
          subtext1 = "#27272a",
          subtext0 = "#3f3f46",
          overlay2 = "#71717b",
          overlay1 = "#868690",
          overlay0 = "#9f9fa9",
          surface2 = "#b5b5bd",
          surface1 = "#d4d4d8",
          surface0 = "#e4e4e7",
          base = "#fcfcfc",
          mantle = "#fafafa",
          crust = "#f4f4f5",
          red = "#e7000b",
          maroon = "#fb2c36",
          peach = "#e17100",
          yellow = "#a87a00",
          green = "#009966",
          teal = "#0092b8",
          sky = "#00a6d6",
          sapphire = "#0092b8",
          blue = "#1b4ed8",
          lavender = "#2b7fff",
          mauve = "#7f22fe",
          pink = "#9810fa",
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
