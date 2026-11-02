# Copyright 2026 Avunu LLC (avu.nu)
# License AGPL-3.0 or later (https://www.gnu.org/licenses/agpl.html).
{
    "name": "Shopfloor Mobile Base theming via Carbon",
    "summary": "Matches Shopfloor mobile apps' brand color to the backend's "
    "Carbon theme (web_theme_carbon), when both are installed",
    "version": "18.0.1.0.1",
    "category": "Inventory",
    "author": "Avunu LLC",
    "website": "https://github.com/Avunu/shopfloor-app-addons",
    "license": "AGPL-3",
    "installable": True,
    "depends": [
        # Neither of these depends on the other - this is a bridge between
        # two otherwise-independent modules, so it lives on its own rather
        # than teaching either side about the other.
        "shopfloor_mobile_base",
        "web_theme_carbon",
    ],
    "data": [
        "templates/assets.xml",
    ],
}
