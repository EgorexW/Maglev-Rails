-- #AI CODE
-- Maglev locomotive prototype definitions.
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

local train = table.deepcopy(data.raw["locomotive"]["locomotive"])
train.name = "maglev-locomotive"
train.max_speed = 3
--train.max_power = "2000kW"
train.weight = 1000
train.localised_name = {"entity-name.maglev-locomotive"}
train.color = MAGLEV_TINT
train.allow_manual_color = false
tint_icons(train, MAGLEV_TINT)

local train_item = table.deepcopy(data.raw["item-with-entity-data"]["locomotive"])
train_item.name = "maglev-locomotive"
train_item.place_result = "maglev-locomotive"
train_item.localised_name = {"item-name.maglev-locomotive"}
tint_icons(train_item, MAGLEV_TINT)

local train_recipe = table.deepcopy(data.raw["recipe"]["locomotive"])
train_recipe.name = "maglev-locomotive"
train_recipe.result = nil
train_recipe.results = {{type = "item", name = "maglev-locomotive", amount = 1}}

data:extend({
  train,
  train_item,
  train_recipe
})
