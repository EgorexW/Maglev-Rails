-- #AI CODE
-- Maglev rail prototype definitions.
local collision_mask_util = require("collision-mask-util")
local MAGLEV_TINT = {r = 0.2, g = 0.9, b = 1.0, a = 1}

local function tint_icons(proto, tint)
  if proto.icons then
    for _, icon in pairs(proto.icons) do
      icon.tint = tint
    end
    return
  end
  if proto.icon then
    proto.icons = {{
      icon = proto.icon,
      icon_size = proto.icon_size or 64,
      icon_mipmaps = proto.icon_mipmaps,
      tint = tint
    }}
  end
end

local function apply_tint(sprite, tint)
  if type(sprite) ~= "table" then return end
  if sprite.filename then
    if not sprite.draw_as_shadow then
      sprite.tint = tint
    end
    return
  end
  if sprite.layers then
    for _, layer in pairs(sprite.layers) do
      apply_tint(layer, tint)
    end
  end
  for _, value in pairs(sprite) do
    if type(value) == "table" then
      apply_tint(value, tint)
    end
  end
end

data:extend({
  {type = "collision-layer", name = "maglev-layer", order = "zz"}
})

local rail_item = table.deepcopy(data.raw["rail-planner"]["rail"])
rail_item.name = "maglev-rail"
rail_item.order = "a[train-system]-a[maglev-rail]"
rail_item.place_result = "maglev-straight-rail"
rail_item.rails = {"maglev-straight-rail"}
rail_item.straight_rail = nil
rail_item.curved_rail = nil
rail_item.localised_name = {"item-name.maglev-rail"}

rail_item.icon = "__base__/graphics/icons/rail.png"
rail_item.icon_size = 64
tint_icons(rail_item, MAGLEV_TINT)

local straight_rail = table.deepcopy(data.raw["straight-rail"]["straight-rail"])
straight_rail.name = "maglev-straight-rail"
--straight_rail.minable = straight_rail.minable or {}
straight_rail.minable.result = "maglev-rail"
straight_rail.placeable_by = {item = "maglev-rail", count = 1}
straight_rail.localised_name = {"entity-name.maglev-straight-rail"}

local mask = collision_mask_util.get_default_mask("straight-rail")
mask.layers["maglev-layer"] = true
straight_rail.collision_mask = mask

straight_rail.icon = "__base__/graphics/icons/rail.png"
straight_rail.icon_size = 64
tint_icons(straight_rail, MAGLEV_TINT)
apply_tint(straight_rail.pictures, MAGLEV_TINT)

local rail_recipe = table.deepcopy(data.raw["recipe"]["rail"])
rail_recipe.name = "maglev-rail"
rail_recipe.result = nil
rail_recipe.results = {{type = "item", name = "maglev-rail", amount = 2}}

local technology = data.raw["technology"]["railway"]
table.insert(technology.effects, {
  type = "unlock-recipe",
  recipe = "maglev-rail"
})

data:extend({
  rail_item,
  straight_rail,
  rail_recipe
})
