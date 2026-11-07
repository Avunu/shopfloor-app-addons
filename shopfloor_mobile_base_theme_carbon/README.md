# Shopfloor Mobile Base theming via Carbon

Matches a Shopfloor mobile app's brand color to the backend's Carbon theme
(`web_theme_carbon`). It is a bridge between `shopfloor_mobile_base` and
`web_theme_carbon`: neither depends on the other, so it lives in its own module.

## How it works

- `shopfloor.app`'s `_make_app_info()` adds the current company's resolved palette as
  `theme`, from `web_theme_carbon`'s `res.company._carbon_palette()`. The color
  therefore follows a company that has customized its brand away from Carbon's stock
  blue.
- `static/src/theme_carbon.esm.js` loads right after `shopfloor_mobile_base`'s own
  `theme.esm.js`. It replaces the `primary` and `secondary` colors of the registered
  `light` theme with the palette's `brand`, and leaves every functional and status color
  as it was.

## Usage

Install this module. There is nothing to configure: the color comes from the company's
Carbon theme settings.
