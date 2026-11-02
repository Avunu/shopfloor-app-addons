# Copyright 2026 Avunu LLC (avu.nu)
# License AGPL-3.0 or later (https://www.gnu.org/licenses/agpl.html).

from odoo import models


class ShopfloorApp(models.Model):
    _inherit = "shopfloor.app"

    def _make_app_info(self, demo=False):
        """Inline the current company's resolved Carbon palette.

        Reuses `web_theme_carbon`'s own `res.company._carbon_palette()` -
        the exact same call its webclient `<style>` injection already
        makes - rather than re-deriving brand/hover/header colors here.
        That matters because a company's `carbon_brand_light` can be
        customized away from Carbon's stock blue (e.g. a company whose brand
        is a dark red), so a fixed color baked into the frontend would
        drift from whatever the backend actually shows.

        `_carbon_is_dark()` reads the `color_scheme` cookie via the
        active request, which is present here - this runs inside
        `ShopfloorMobileAppController.load_app`'s own request, the same
        as every other `_make_app_info()` caller.
        """
        info = super()._make_app_info(demo=demo)
        company = self.env.company
        info["theme"] = company._carbon_palette(dark=company._carbon_is_dark())
        return info
