# Avunu Shopfloor app addons

Google and Apple sign-in, device-camera barcode scanning, and a brand colour taken from the backend's Carbon theme, for the Shopfloor mobile apps. These are Odoo 18.0 modules that extend [OCA/shopfloor-app](https://github.com/OCA/shopfloor-app), built and maintained by [Avunu LLC](https://avunu.net) for our own client work and published for anyone to use.

## Modules

| Module | What it does | Licence |
| --- | --- | --- |
| [`shopfloor_mobile_base_auth_oauth`](shopfloor_mobile_base_auth_oauth/README.md) | Google and Apple sign-in for OCA Shopfloor mobile apps, in place of typing an API key by hand | AGPL-3.0-or-later |
| [`shopfloor_mobile_camera_scan`](shopfloor_mobile_camera_scan/README.md) | Device-camera barcode scanning for the Shopfloor mobile app: a camera button in every scenario's search bar, delivered through the same code path as a hardware scanner | LGPL-3.0-or-later |
| `shopfloor_mobile_base_theme_carbon` | Gives Shopfloor mobile apps the company's brand colour from `web_theme_carbon`, so they match the Carbon-themed backend | AGPL-3.0-or-later |

Each module's README explains why it exists and how to set it up. `shopfloor_mobile_base_theme_carbon` has no README yet. It is a bridge between `shopfloor_mobile_base` and `web_theme_carbon`, which do not depend on each other, so install it explicitly where you use both. When a Shopfloor app page loads, it adds the company's Carbon palette (light or dark, by the same `color_scheme` cookie the backend uses) to the app info inlined in the page, and the app takes the palette's brand colour as the `primary` and `secondary` colours of its theme. Every other theme colour (error, success, warning, …) stays as `shopfloor_mobile_base` defines it.

## Branches

`develop` is the default branch and the one pull requests go to. Its code targets Odoo 18.0, the series named in `.odoo-series`. `18.0` follows `develop` automatically (a workflow fast-forwards it after every push) and is the branch to install or pin. When a newer Odoo series is maintained, it gets its own branch (`19.0`, …) and changes flow up to it from `develop`.

## Install

Requires Odoo 18.0 and a PostgreSQL database. Pick the module or modules you want; each pulls in the modules it depends on (see below), and those must be on your `addons_path` first.

With a plain Odoo checkout, clone this repository on its `18.0` branch and add it to the addons path:

```sh
git clone --branch 18.0 https://github.com/Avunu/shopfloor-app-addons.git
odoo-bin --addons-path=odoo/addons,/path/to/shopfloor-app-addons,<your other addons paths> \
  -d <database> -i <module> --stop-after-init
```

With [odoo-nix](https://github.com/Avunu/odoo-nix), add the repository from the dev shell. `odoo module add` accepts an `owner/repo` and a branch, adds it as a submodule, and the addons path is regenerated from the folders present (run `direnv reload` afterwards):

```sh
odoo module add Avunu/shopfloor-app-addons 18.0
```

## Dependencies

Each module's `__manifest__.py` is the source of truth. None of the modules lists an Odoo core module directly; they depend on the following. The OCA repositories listed are the 18.0 branches; clone the ones your chosen modules need, along with whatever those modules need in turn (their own manifests list it).

| Module | Needs from OCA or others | Python packages |
| --- | --- | --- |
| `shopfloor_mobile_base_auth_oauth` | `shopfloor_mobile_base` and `shopfloor_mobile_base_auth_api_key` ([OCA/shopfloor-app](https://github.com/OCA/shopfloor-app)), `auth_oidc` ([OCA/server-auth](https://github.com/OCA/server-auth)), `server_environment` ([OCA/server-env](https://github.com/OCA/server-env)) | none |
| `shopfloor_mobile_camera_scan` | `shopfloor_mobile_base` ([OCA/shopfloor-app](https://github.com/OCA/shopfloor-app)) | none |
| `shopfloor_mobile_base_theme_carbon` | `shopfloor_mobile_base` ([OCA/shopfloor-app](https://github.com/OCA/shopfloor-app)), `web_theme_carbon` ([Avunu/web-addons](https://github.com/Avunu/web-addons)) | none |

`web_theme_carbon` in turn needs `web_responsive` and `web_dark_mode` from [OCA/web](https://github.com/OCA/web).

## Development

The repository carries its own development environment, built by [odoo-nix](https://github.com/Avunu/odoo-nix) in addons mode. OCB and the repositories these modules depend on are flake inputs pinned in `flake.lock`, and the Python environment is locked in `nix/`. You need Nix with flakes, and optionally direnv.

```sh
git clone https://github.com/Avunu/shopfloor-app-addons.git && cd shopfloor-app-addons
direnv allow                  # or: nix develop --no-pure-eval
devenv up                     # PostgreSQL, Odoo and Mailpit
odoo db provision             # a database with every module here installed
odoo test shopfloor_mobile_base_auth_oauth
```

After `nix flake update`, or when a module gains a `depends` or a Python requirement, run `odoo project relock` and commit `flake.lock` and `nix/`. A new dependency on another repository also needs its input and an `externalSources` entry in `flake.nix`. See odoo-nix's [A repository of addons](https://github.com/Avunu/odoo-nix/blob/main/docs/scaffolding/addons-repository.md).

## Tests

Odoo runs a module's tests when you install or update it with `--test-enable`. Select a module's tests with a `--test-tags` filter and use a throwaway database:

```sh
odoo-bin -c odoo.conf -d <testdb> -i <module> \
  --test-enable --test-tags /<module> --stop-after-init
```

None of the modules has automated tests yet, so for now the command only checks that a module installs. Notes from the module READMEs:

- `shopfloor_mobile_base_auth_oauth`'s Google and Apple sign-in flow has no automated harness and is verified by hand.
- `shopfloor_mobile_camera_scan` is tried by hand in a working Shopfloor mobile app: open any scenario and tap the camera button in its search bar. Camera access needs HTTPS or `localhost`; otherwise the browser blocks it.

## Licence

Every module is licensed under the [GNU Affero General Public License v3.0 or later](LICENSE), except `shopfloor_mobile_camera_scan`, which is licensed under the [GNU Lesser General Public License v3.0 or later](LICENSES/LGPL-3.0-or-later.txt). Each module's `__manifest__.py` also states its licence (`AGPL-3` or `LGPL-3`, Odoo's identifiers for version 3).

`shopfloor_mobile_camera_scan` vendors `html5-qrcode` 2.3.8 (Apache-2.0) under `static/lib/html5-qrcode/`. It keeps its own licence, whose text sits next to the vendored file.

## Provenance

`shopfloor_mobile_base_auth_oauth` and `shopfloor_mobile_camera_scan` moved here, with their history, from [Avunu/avunu-odoo-addons](https://github.com/Avunu/avunu-odoo-addons) in November 2026, when Avunu split that repository into one repository per OCA area. `shopfloor_mobile_base_theme_carbon` was first developed in a private Avunu project and imported here.
