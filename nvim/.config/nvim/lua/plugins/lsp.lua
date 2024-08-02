return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"tsserver",
					"gopls",
					"rust_analyzer",
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local util = require("lspconfig.util")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")

			lspconfig.lua_ls.setup({
				capabilities = capabilities,
			})
			lspconfig.tsserver.setup({
				capabilities = capabilities,
			})
			lspconfig.gopls.setup({
				capabilities = capabilities,
				cmd = { "gopls" },
				filetypes = { "go", "gomod", "gowork", "gotmpl" },
				root_dir = function(fname)
					-- see: https://github.com/neovim/nvim-lspconfig/issues/804
					local mod_cache = vim.trim(vim.fn.system("go env GOMODCACHE"))
					if fname:sub(1, #mod_cache) == mod_cache then
						local clients = vim.lsp.get_active_clients({ name = "gopls" })
						if #clients > 0 then
							return clients[#clients].config.root_dir
						end
					end
					return util.root_pattern("go.work")(fname) or util.root_pattern("go.mod", ".git")(fname)
				end,
			})
			lspconfig.rust_analyzer.setup({
				capabilities = capabilities,
			})

			vim.keymap.set("n", "<leader>h", vim.lsp.buf.hover, {
				noremap = true,
				silent = true,
				buffer = bufnr,
			})
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
			vim.keymap.set("n", "<leader>e", vim.diagnostic.goto_next, {
				noremap = true,
				silent = true,
				buffer = bufnr,
			})
		end,
	},
}
