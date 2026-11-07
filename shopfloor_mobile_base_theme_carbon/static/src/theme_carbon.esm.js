/**
 * Copyright 2026 Avunu LLC (avu.nu)
 * License AGPL-3.0 or later (https://www.gnu.org/licenses/agpl.html).
 */

/* global shopfloor_app_info */

import {color_registry} from "/shopfloor_mobile_base/static/src/services/color_registry.esm.js";

/**
 * `shopfloor_mobile_base`'s own theme.esm.js (loaded immediately before
 * this script, per templates/assets.xml's anchor) has already registered
 * the "light" theme. Only the brand-identity keys get replaced here -
 * `primary` (drives the top bar and primary actions) and `secondary`
 * (Vuetify's own default for anything explicitly colored "secondary" -
 * e.g. `btn-back`, which otherwise renders with the stock lavender
 * `#CFD2FF` and doesn't match the reskinned brand at all) - by spreading
 * the *existing* registered theme first, so every functional/status
 * color it defines (error, success, warning, btn_action_*,
 * item_selected_*, spinner, etc.) is left exactly as designed.
 * `shopfloor_app_info.theme` is inlined server-side by this module's own
 * shopfloor_app.py, from web_theme_carbon's own
 * res.company._carbon_palette() - the company's actual resolved brand
 * color, not a fixed value, since it can be customized
 * away from Carbon's stock blue.
 */
const base = color_registry.get_themes().light || {};
const carbon = shopfloor_app_info.theme || {};
if (carbon.brand) {
    color_registry.add_theme(
        {
            ...base,
            primary: carbon.brand,
            secondary: carbon.brand,
        },
        "light"
    );
}
