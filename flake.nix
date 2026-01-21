# Copyright (c) 2023 BirdeeHub
# Licensed under the MIT license

# This is an empty nixCats config.
# you may import this template directly into your nvim folder
# and then add plugins to categories here,
# and call the plugins with their default functions
# within your lua, rather than through the nvim package manager's method.
# Use the help, and the example config github:BirdeeHub/nixCats-nvim?dir=templates/example

# It allows for easy adoption of nix,
# while still providing all the extra nix features immediately.
# Configure in lua, check for a few categories, set a few settings,
# output packages with combinations of those categories and settings.

# All the same options you make here will be automatically exported in a form available
# in home manager and in nixosModules, as well as from other flakes.
# each section is tagged with its relevant help section.

{
  description = "A Lua-natic's neovim flake, with extra cats! nixCats!";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";

    # Rust overlay
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #????
    #plugins-treesitter-textobjects = {
      #  url = "github:nvim-treesitter/nvim-treesitter-textobjects/main";
      #  flake = false;
      #};


    # see :help nixCats.flake.inputs
    # If you want your plugin to be loaded by the standard overlay,
    # i.e. if it wasnt on nixpkgs, but doesnt have an extra build step.
    # Then you should name it "plugins-something"
    # If you wish to define a custom build step not handled by nixpkgs,
    # then you should name it in a different format, and deal with that in the
    # overlay defined for custom builds in the overlays directory.
    # for specific tags, branches and commits, see:
    # https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake.html#examples

    # Se vuoi usare plugins non presenti in nixpkgs, aggiungili qui col prefisso "plugins-"
    # plugins-my-plugin = { url = "github:owner/repo"; flake = false; };
  };

  # see :help nixCats.flake.outputs
  outputs = { self, nixpkgs, nixCats, ... }@inputs: let
    inherit (nixCats) utils;
  luaPath = ./.;
  forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;
  # the following extra_pkg_config contains any values
  # which you want to pass to the config set of nixpkgs
  # import nixpkgs { config = extra_pkg_config; inherit system; }
  # will not apply to module imports
  # as that will have your system values
  extra_pkg_config = {
    allowUnfree = true;
  };
  # management of the system variable is one of the harder parts of using flakes.

  # so I have done it here in an interesting way to keep it out of the way.
  # It gets resolved within the builder itself, and then passed to your
  # categoryDefinitions and packageDefinitions.

  # this allows you to use ${pkgs.stdenv.hostPlatform.system} whenever you want in those sections
  # without fear.

  # see :help nixCats.flake.outputs.overlays
  dependencyOverlays = /* (import ./overlays inputs) ++ */ [
    # This overlay grabs all the inputs named in the format
    # `plugins-<pluginName>`
    # Once we add this overlay to our nixpkgs, we are able to
    # use `pkgs.neovimPlugins`, which is a set of our plugins.
    (utils.standardPluginOverlay inputs)
      # add any other flake overlays here.

      # when other people mess up their overlays by wrapping them with system,
      # you may instead call this function on their overlay.
      # it will check if it has the system in the set, and if so return the desired overlay
      # (utils.fixSystemizedOverlay inputs.codeium.overlays
          #   (system: inputs.codeium.overlays.${system}.default)
          # )

      # Rust overlay
      (import inputs.rust-overlay)
  ];

  # see :help nixCats.flake.outputs.categories
  # and
  # :help nixCats.flake.outputs.categoryDefinitions.scheme
  categoryDefinitions = { pkgs, settings, categories, extra, name, mkPlugin, ... }@packageDef: {
    # to define and use a new category, simply add a new list to a set here, 
    # and later, you will include categoryname = true; in the set you
    # provide when you build the package using this builder function.
    # see :help nixCats.flake.outputs.packageDefinitions for info on that section.

    lspsAndRuntimeDeps = with pkgs; {
      general = [
        tree-sitter
        tree-sitter-grammars.tree-sitter-markdown-inline
        
        # manual for nix options
        manix
        
        # For latex
        #texlive.combined.scheme-full # O scheme-medium (Il compilatore LaTeX)
        zathura                      # Il visualizzatore PDF
        xdotool                      # FONDAMENTALE: serve a VimTeX per comunicare con Zathura

        # ====================
        # LSP
        # ====================
        # Lua & Nix
        lua-language-server
        nixd
        # C / C++
        clang-tools
        cmake-language-server
        # Rust overlay
        (rust-bin.stable.latest.default.override { extensions = [ "rust-src" "rust-analyzer" ]; })
        # Web (HTML/CSS/JS/TS)
        vscode-langservers-extracted # Fornisce html, css, json
        typescript-language-server
        nodePackages.bash-language-server
        # Python
        pyright
        # Latex 
        texlab
        texlivePackages.latexindent
        # Markdown
        markdown-oxide
        # Openscad
        openscad-lsp
        # Hardware / Low level
        arduino-language-server
        asm-lsp
        # toml files
        taplo

        # For telescope
        ripgrep
        fd
        
        # For git
        git
        lazygit

        # Lean # NOTE: After the first installation: `elan default stable`
        elan

        # For images, pdf, videos, ecc...
        chafa
        ueberzugpp
        imagemagick
        ffmpegthumbnailer # Opzionale per video
        poppler-utils     # Opzionale per PDF

        # For startup page
        fortune
        cowsay
        
        # General
        wget
        curl
        gnumake
        gcc

        # AI
        #ollama-cuda
        #ollama-vulkan
        #ollama-rocm
      ];
      kickstart-debug = [
        #delve #?
      ];
      kickstart-lint = [
        #markdownlint-cli  #?
      ];
    };

    # This is for plugins that will load at startup without using packadd:
    startupPlugins =  with pkgs.vimPlugins; {
      general = [
        # for dms automatic color creation
        base16-nvim 
        # Pakage manager
        lazy-nvim

        # General
        lualine-nvim # Lualine
        alpha-nvim # Startup page
        oil-nvim # Filemanager
        fidget-nvim # Notifications
        lazydev-nvim # lua lsp for nvim configurations
        todo-comments-nvim # Todo comments
        nvim-spectre # for searching in multiple files
        popup-nvim # for extra window managment
        undotree # undotree
        image-nvim # Images
        nvim-web-devicons # For special icons (Lualine, Telescope, Oil, ...)
        
        # AI
        codecompanion-nvim

        # Git
        lazygit-nvim # TODO: da mettere in gitPlugins ?
        diffview-nvim
        vim-fugitive # NOTE: da togliere?
        gitsigns-nvim

        # Lean
        lean-nvim
        
        # For rust Cargo.toml files
        crates-nvim

        # Telescope
        telescope-nvim
        telescope-fzf-native-nvim
        telescope-ui-select-nvim
        telescope-file-browser-nvim
        telescope-media-files-nvim
        plenary-nvim
        telescope-manix

        # Lsp
        nvim-lspconfig

        # Autocomplition
        nvim-cmp
        cmp_luasnip
        cmp-nvim-lsp
        cmp-path
        cmp-buffer
        cmp-cmdline
        luasnip
        friendly-snippets

        # Markdown
        render-markdown-nvim
        nvim-treesitter-parsers.markdown_inline

        # Latex watching
        vimtex

        # Treesitter
        nvim-treesitter.withAllGrammars
        #(nvim-treesitter.withPlugins (plugins: with plugins; [ nix lua python javascript markdown markdown_inline bash vim vimdoc query c cpp rust ]))
      ];
      debug = [
      ];
      gitPlugins = [
      ];
    };

    # not loaded automatically at startup.
    # use with packadd and an autocommand in config to achieve lazy loading
    optionalPlugins = {
      gitPlugins = with pkgs.neovimPlugins; [ ];
      general = with pkgs.vimPlugins; [ ];
    };

    # shared libraries to be added to LD_LIBRARY_PATH
    # variable available to nvim runtime
    sharedLibraries = {
      general = with pkgs; [
        # libgit2
      ];
    };

    # environmentVariables:
    # this section is for environmentVariables that should be available
    # at RUN TIME for plugins. Will be available to path within neovim terminal
    environmentVariables = {
      test = {
        CATTESTVAR = "It worked!";
      };
    };

    # If you know what these are, you can provide custom ones by category here.
    # If you dont, check this link out:
    # https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh
    extraWrapperArgs = {
      test = [
        '' --set CATTESTVAR2 "It worked again!"''
      ];
    };

    # lists of the functions you would have passed to
    # python.withPackages or lua.withPackages
    # do not forget to set `hosts.python3.enable` in package settings

    # get the path to this python environment
    # in your lua config via
    # vim.g.python3_host_prog
    # or run from nvim terminal via :!<packagename>-python3
    python3.libraries = {
      test = (_:[]);
    };
    # populates $LUA_PATH and $LUA_CPATH
    extraLuaPackages = {
      test = [ (_:[]) ];
    };
  };



  # And then build a package with specific categories from above here:
  # All categories you wish to include must be marked true,
  # but false may be omitted.
  # This entire set is also passed to nixCats for querying within the lua.

  # see :help nixCats.flake.outputs.packageDefinitions
  packageDefinitions = {
    # These are the names of your packages
    # you can include as many as you wish.
    nvim = {pkgs , name, ... }: {
      # they contain a settings set defined above
      # see :help nixCats.flake.outputs.settings
      settings = {
        suffix-path = true;
        suffix-LD = true;
        wrapRc = true;
        # IMPORTANT:
        # your alias may not conflict with your other packages.
        #aliases = [ "vim" ];
        # neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.neovim;
      };
      # and a set of categories that you want
      # (and other information to pass to lua)
      categories = {
        general = true;
        gitPlugins = true;
        #test = true;
        #example = {
          #  youCan = "add more than just booleans";
          #  toThisSet = [
          #    "and the contents of this categories set"
          #    "will be accessible to your lua with"
          #    "nixCats('path.to.value')"
          #    "see :help nixCats"
          #  ];
          #};
      };
    };
  };
  # In this section, the main thing you will need to do is change the default package name
  # to the name of the packageDefinitions entry you wish to use as the default.
  defaultPackageName = "nvim";
  in
    # see :help nixCats.flake.outputs.exports
    forEachSystem (system: let
        nixCatsBuilder = utils.baseBuilder luaPath {
        inherit nixpkgs system dependencyOverlays extra_pkg_config;
        } categoryDefinitions packageDefinitions;
        defaultPackage = nixCatsBuilder defaultPackageName;
        # this is just for using utils such as pkgs.mkShell
        # The one used to build neovim is resolved inside the builder
        # and is passed to our categoryDefinitions and packageDefinitions
        pkgs = import nixpkgs { inherit system; };
        in
        {
        # these outputs will be wrapped with ${system} by utils.eachSystem

        # this will make a package out of each of the packageDefinitions defined above
        # and set the default package to the one passed in here.
        packages = utils.mkAllWithDefault defaultPackage;

        # choose your package for devShell
        # and add whatever else you want in it.
        devShells = {
        default = pkgs.mkShell {
          name = defaultPackageName;
          packages = [ defaultPackage ];
          inputsFrom = [ ];
          shellHook = ''
            '';
        };
        };

        }) // (let
  # we also export a nixos module to allow reconfiguration from configuration.nix
  nixosModule = utils.mkNixosModules {
    moduleNamespace = [ defaultPackageName ];
    inherit defaultPackageName dependencyOverlays luaPath
      categoryDefinitions packageDefinitions extra_pkg_config nixpkgs;
  };
  # and the same for home manager
  homeModule = utils.mkHomeModules {
    moduleNamespace = [ defaultPackageName ];
    inherit defaultPackageName dependencyOverlays luaPath
      categoryDefinitions packageDefinitions extra_pkg_config nixpkgs;
  };
  in {
    # these outputs will be NOT wrapped with ${system}

    # this will make an overlay out of each of the packageDefinitions defined above
    # and set the default overlay to the one named here.
    overlays = utils.makeOverlays luaPath {
      inherit nixpkgs dependencyOverlays extra_pkg_config;
    } categoryDefinitions packageDefinitions defaultPackageName;

    nixosModules.default = nixosModule;
    homeModules.default = homeModule;

    inherit utils nixosModule homeModule;
    inherit (utils) templates;
  });

}
