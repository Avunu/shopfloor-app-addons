{
  description = "shopfloor-app-addons: Avunu's Odoo addons, developed with odoo-nix (addons mode)";

  inputs = {
    # flake-parts resolves perSystem `pkgs` from an input literally named `nixpkgs`.
    nixpkgs.follows = "odoo-nix/nixpkgs";

    # OCB and every repository the addons depend on, on this branch's series
    # (.odoo-series): source trees (`flake = false`) pinned by flake.lock.
    # `nix flake update` moves them; follow it with `odoo project relock`.
    # Generated from the addons' `depends`: keep it in step with them.
    ocb = {
      url = "github:OCA/OCB/18.0";
      flake = false;
    };
    avunu-web-addons = {
      url = "github:Avunu/web-addons/18.0";
      flake = false;
    };
    oca-connector = {
      url = "github:OCA/connector/18.0";
      flake = false;
    };
    oca-rest-framework = {
      url = "github:OCA/rest-framework/18.0";
      flake = false;
    };
    oca-server-auth = {
      url = "github:OCA/server-auth/18.0";
      flake = false;
    };
    oca-server-env = {
      url = "github:OCA/server-env/18.0";
      flake = false;
    };
    oca-server-tools = {
      url = "github:OCA/server-tools/18.0";
      flake = false;
    };
    oca-shopfloor-app = {
      url = "github:OCA/shopfloor-app/18.0";
      flake = false;
    };
    oca-web = {
      url = "github:OCA/web/18.0";
      flake = false;
    };
    oca-web-api = {
      url = "github:OCA/web-api/18.0";
      flake = false;
    };
    # >>> odoo-nix: inputs (managed) >>>
    odoo-nix.url = "github:Avunu/odoo-nix/release-2";
    standards-profile = {
      url = "github:Avunu/odoo-standards-profile/v1";
      flake = false;
    };
    # <<< odoo-nix: inputs (managed) <<<
  };

  nixConfig = {
    extra-substituters = [ "https://devenv.cachix.org" ];
    extra-trusted-public-keys = [
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
    ];
  };

  # Outputs:
  #   devShells.<system>.default  devenv: PostgreSQL, Odoo, Mailpit
  #   apps.<system>.relock        regenerate nix/pyproject.toml and nix/uv.lock
  outputs =
    { odoo-nix, ... }@inputs:
    odoo-nix.lib.mkFlake { inherit inputs; } (
      { ... }:
      {
        imports = [ odoo-nix.flakeModules.default ];

        systems = [
          "aarch64-darwin"
          "aarch64-linux"
          "x86_64-linux"
        ];

        perSystem =
          { lib, ... }:
          {
            odoo-nix = {
              enable = true;
              name = "shopfloor-app-addons";
              workspaceRoot = ./.;
              # The one per-branch fact: the series this branch's code targets.
              odooSeries = lib.fileContents ./.odoo-series;
              addons.enable = true;
              coreSource = inputs.ocb;
              externalSources = [
                {
                  name = "web-addons";
                  src = inputs.avunu-web-addons;
                }
                {
                  name = "connector";
                  src = inputs.oca-connector;
                }
                {
                  name = "rest-framework";
                  src = inputs.oca-rest-framework;
                }
                {
                  name = "server-auth";
                  src = inputs.oca-server-auth;
                }
                {
                  name = "server-env";
                  src = inputs.oca-server-env;
                }
                {
                  name = "server-tools";
                  src = inputs.oca-server-tools;
                }
                {
                  name = "shopfloor-app";
                  src = inputs.oca-shopfloor-app;
                }
                {
                  name = "web";
                  src = inputs.oca-web;
                }
                {
                  name = "web-api";
                  src = inputs.oca-web-api;
                }
              ];
            };
          };
      }
    );
}
