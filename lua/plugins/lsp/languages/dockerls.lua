local M = {}
local util = require 'plugins.lsp.lsp_util'

M.dockerls = {
  default_config = {
    cmd = { 'docker-langserver', '--stdio' },
    filetypes = { 'dockerfile' },
    root_dir = util.root_pattern('Dockerfile'),
    single_file_support = true,
    settings = {
      docker = {
        languageserver = {
          formatter = {
            ignoreMultilineInstructions = true,
          }
        }
      }
    },
  },
  docs = {
    description = [[
https://github.com/rcjsuen/dockerfile-language-server-nodejs

`docker-langserver` can be installed via `npm`:
```sh
npm install -g dockerfile-language-server-nodejs
```

Additional configuration can be applied in the following way:
```lua
require("lspconfig").dockerls.setup {
    settings = {
        docker = {
	    languageserver = {
	        formatter = {
		    ignoreMultilineInstructions = true,
		},
	    },
	}
    }
}
```
    ]],
  },
}

return M
