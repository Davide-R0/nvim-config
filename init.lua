-- For nixos nixCats
require('nixCats').setup({
    non_nix_value = true, -- questo serve se vuoi usare la config anche su Windows/Mac senza Nix
})

require("config.lazy")

require("config.keymaps")
require("config.options")
require("config.trasparency")
