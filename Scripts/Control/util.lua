-- #AI CODE
-- Small runtime helpers shared by the control scripts.

local M = {}

function M.has_method(obj, name)
  local ok, value = pcall(function() return obj[name] end)
  return ok and type(value) == "function"
end

function M.refund_item(item_name, surface, position, force, event)
  -- Try to return the item to the builder (player/robot), otherwise drop it.
  if not item_name then return end

  if event and event.player_index then
    local player = game.get_player(event.player_index)
    if player and player.valid then
      if player.insert({name = item_name, count = 1}) == 1 then return end
    end
  end

  if event and event.robot and event.robot.valid then
    local cargo = event.robot.get_inventory(defines.inventory.robot_cargo)
    if cargo and cargo.valid then
      if cargo.insert({name = item_name, count = 1}) == 1 then return end
    end
  end

  surface.create_entity({
    name = "item-on-ground",
    stack = {name = item_name, count = 1},
    position = position,
    force = force
  })
end

function M.get_place_item_name(entity, maglev_rail_name, maglev_rail_item)
  if not (entity and entity.valid) then return nil end
  local proto = entity.prototype
  if proto and proto.items_to_place_this and proto.items_to_place_this[1] then
    return proto.items_to_place_this[1].name
  end
  if entity.name == maglev_rail_name then return maglev_rail_item end
  return nil
end

function M.destroy_and_refund(entity, event, maglev_rail_name, maglev_rail_item)
  if not (entity and entity.valid) then return end
  local item_name = M.get_place_item_name(entity, maglev_rail_name, maglev_rail_item)
  local surface = entity.surface
  local position = entity.position
  local force = entity.force
  if entity.destroy({raise_destroy = true}) then
    M.refund_item(item_name, surface, position, force, event)
  end
end

function M.is_rail_entity(entity)
  if not (entity and entity.valid) then return false end
  return M.has_method(entity, "get_connected_rails") or M.has_method(entity, "get_connected_rail")
end

return M
