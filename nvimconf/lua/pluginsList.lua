local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

-- using { } when using a different branch of the plugin or loading the plugin with certain commands
return require("packer").startup(
  function(use)
    use "wbthomason/packer.nvim"

    -- Shows indentation
    use "lukas-reineke/indent-blankline.nvim"

    use {
      "catppuccin/nvim",
      as = "catppuccin"
    }

    -- File icons
    use "kyazdani42/nvim-web-devicons"
    use "ryanoasis/vim-devicons"
    use "yamatsum/nvim-nonicons"
    -- File explorer, go back to ChadTree?
    use "kyazdani42/nvim-tree.lua"
    -- Show changes in the gutter
    use {
      "lewis6991/gitsigns.nvim",
      config = function()
        require("plugins/monokai")
      end,
      requires = {
        "nvim-lua/plenary.nvim",
      }
    }
    -- Tab/buffers on the top
    -- TODO - evaluate romgrk/barbar.nvim
    use "akinsho/bufferline.nvim"
    -- Statusline replacement
    use "glepnir/galaxyline.nvim"

    -- Syntax highlighting
    use {
      "nvim-treesitter/nvim-treesitter",
      run = function()
        pcall(require('nvim-treesitter.install').update { with_sync = true })
      end,
    }
    use {
      'nvim-treesitter/nvim-treesitter-textobjects',
      after = 'nvim-treesitter',
    }

    -- Highlight hex colors
    use "norcalli/nvim-colorizer.lua"
    -- Code formatting
    use "sbdchd/neoformat"

    -- Language server
    use {
      "neovim/nvim-lspconfig",
      requires = {
        -- LSP status updates
        {
          'j-hui/fidget.nvim',
          tag = 'legacy'
        },

        -- LSP completions for neovim configs
        'folke/neodev.nvim',
      },
    }

    use "onsails/lspkind-nvim"
    use "ray-x/lsp_signature.nvim"
    use "simrat39/rust-tools.nvim"
    use {
      "jose-elias-alvarez/nvim-lsp-ts-utils",
      ft = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx"
      },
    }
    -- Auto completion
    use {
      'hrsh7th/nvim-cmp',
      requires = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' },
    }

    -- Auto pair some stuff
    use "windwp/nvim-autopairs"
    use "alvan/vim-closetag"
    -- Profile startup time for bottlenecks use with :StartupTime
    use "tweekmonster/startuptime.vim"

    -- Fuzzy finder
    use {
      "nvim-telescope/telescope.nvim",
      requires = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-media-files.nvim"
      }
    }
    -- Popup windows
    use "nvim-lua/popup.nvim"
    -- Highlight trailing whitespace
    use "ntpeters/vim-better-whitespace"
    -- Live preview for search and replace
    use "markonm/traces.vim"
    -- Include snake_case and camelCase word skips
    use "chaoren/vim-wordmotion"
    -- Highlight merge conflicts
    use "rhysd/conflict-marker.vim"
    -- Show buffer contents
    use "junegunn/vim-peekaboo"
    -- Highlight yanks
    use "machakann/vim-highlightedyank"
    -- use "simrat39/symbols-outline.nvim"
    use "mg979/vim-visual-multi"
    -- better folds
    use {
      "kevinhwang91/nvim-ufo",
      requires = {
        "kevinhwang91/promise-async"
      }
    }

    use "christoomey/vim-tmux-navigator"

    if packer_bootstrap then
      require('packer').sync()
    end
  end
)
