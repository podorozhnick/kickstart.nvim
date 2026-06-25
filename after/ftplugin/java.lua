-- Start the Eclipse JDT language server for this Java buffer.
--
-- Loaded automatically by Neovim whenever a `java` filetype buffer is opened.
-- See lua/custom/plugins/jdtls.lua for why Java needs this dedicated launcher
-- instead of going through the normal lspconfig `servers` table.

local ok, jdtls = pcall(require, 'jdtls')
if not ok then
  return
end

-- Determine the project root. Real projects are detected via build files;
-- a bare single-file project (no pom.xml/gradle/.git) falls back to the file's
-- own directory so jdtls still has a workspace to operate in.
local root_markers = { 'gradlew', 'mvnw', '.git', 'pom.xml', 'build.gradle', 'build.gradle.kts', 'settings.gradle' }
local root_dir = jdtls.setup.find_root(root_markers) or vim.fn.expand '%:p:h'

-- jdtls keeps per-project state in a dedicated workspace directory. Key it by
-- the project path so different projects don't clobber each other's index.
local workspace = vim.fn.stdpath 'data' .. '/jdtls-workspace/' .. vim.fn.fnamemodify(root_dir, ':p:h:t')

-- Reuse the same completion capabilities as the other servers (init.lua).
local capabilities = require('blink.cmp').get_lsp_capabilities()

-- Java's convention is 4-space indentation; keep the editor and the server's
-- formatter in agreement.
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.expandtab = true

local config = {
  -- `jdtls` is the Mason-installed launcher script (on Neovim's PATH); it sorts
  -- out the equinox launcher jar and platform config dir for us.
  cmd = {
    'jdtls',
    -- Keep Eclipse metadata (.project/.classpath/.settings) out of the source
    -- tree; it lives in the -data workspace dir instead.
    '--jvm-arg=-Djava.import.generatesMetadataFilesAtProjectRoot=false',
    '-data',
    workspace,
  },
  root_dir = root_dir,
  capabilities = capabilities,
  settings = {
    java = {
      -- Point at the OpenJDK 21 install. Its bundled src.zip is what makes
      -- "go to definition" into stdlib classes (String, System, ...) work.
      configuration = {
        runtimes = {
          {
            name = 'JavaSE-21',
            path = '/usr/lib/jvm/java-21-openjdk',
          },
        },
      },
      format = {
        enabled = true,
        comments = { enabled = false },
        tabSize = 4,
      },
    },
  },
}

-- start_or_attach also registers the jdt:// content provider, which is what
-- lets go-to-definition open library/JDK classes packaged inside .jar files.
jdtls.start_or_attach(config)
