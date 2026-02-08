-- #AI CODE
-- Main runtime behavior for maglev rails and locomotives.

local rails = require("Scripts.Control.rails")
local util = require("Scripts.Control.util")

local M = {}

local function has_maglev_rail_at(surface, position)
  local found = surface.find_entities_filtered({
    position = position,
    name = "maglev-straight-rail"
  })
  return found and #found > 0
end

function M.enforce_maglev_lock(event)
  local entity = event.created_entity or event.entity
  if not (entity and entity.valid) then return end
  if entity.type ~= "locomotive" then return end
  if entity.name ~= "maglev-locomotive" then return end

  -- Maglev locomotives can only be placed on maglev rails.
  if not has_maglev_rail_at(entity.surface, entity.position) then
    util.destroy_and_refund(entity, event, "maglev-straight-rail", "maglev-rail")
  end
end

function M.enforce_rail_separation(event)
  local entity = event.created_entity or event.entity
  if not util.is_rail_entity(entity) then return end

  -- Prevent any connection between maglev rails and normal/elevated rails.
  if entity.name == "maglev-straight-rail" then
    if rails.connects_to_non_maglev(entity, "maglev-straight-rail") then
      util.destroy_and_refund(entity, event, "maglev-straight-rail", "maglev-rail")
    end
  else
    if rails.connects_to_maglev(entity, "maglev-straight-rail") then
      util.destroy_and_refund(entity, event, "maglev-straight-rail", "maglev-rail")
    end
  end
end

function M.cleanup_maglev_connections()
  -- On load, remove any existing maglev rails that touch non-maglev rails.
  for _, surface in pairs(game.surfaces) do
    local maglev_rails = surface.find_entities_filtered({name = "maglev-straight-rail"})
    for _, rail in pairs(maglev_rails) do
      if rail.valid and rails.connects_to_non_maglev(rail, "maglev-straight-rail") then
        util.destroy_and_refund(rail, nil, "maglev-straight-rail", "maglev-rail")
      end
    end
  end
end

function M.register_events()
  local build_events = {
    defines.events.on_built_entity,
    defines.events.on_robot_built_entity,
    defines.events.script_raised_built,
    defines.events.script_raised_revive
  }

  for _, event_id in pairs(build_events) do
    script.on_event(event_id, function(event)
      M.enforce_maglev_lock(event)
      M.enforce_rail_separation(event)
    end)
  end

  script.on_init(M.cleanup_maglev_connections)
  script.on_configuration_changed(M.cleanup_maglev_connections)
end

return M
