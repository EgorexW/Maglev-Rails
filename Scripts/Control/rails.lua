-- #AI CODE
-- Rail connection helpers for keeping maglev isolated.

local util = require("Scripts.Control.util")

local M = {}

local function add_connected(connected, value)
  if not value then return end
  if type(value) == "table" and value.valid ~= nil then
    connected[#connected + 1] = value
    return
  end
  if type(value) == "table" then
    for _, v in pairs(value) do
      add_connected(connected, v)
    end
  end
end

function M.get_connected_rails(rail)
  local connected = {}
  if not util.is_rail_entity(rail) then return connected end

  if util.has_method(rail, "get_connected_rails") then
    local ok, result = pcall(function() return rail.get_connected_rails() end)
    if ok then
      add_connected(connected, result)
      return connected
    end
  end

  -- Fallback: older API that exposes get_connected_rail with directions.
  for _, rail_dir in pairs(defines.rail_direction) do
    if type(rail_dir) == "number" then
      for _, conn_dir in pairs(defines.rail_connection_direction) do
        if type(conn_dir) == "number" then
          local ok, other = pcall(function()
            return rail.get_connected_rail({
              rail_direction = rail_dir,
              rail_connection_direction = conn_dir
            })
          end)
          if ok and other and other.valid then
            connected[#connected + 1] = other
          end
        end
      end
    end
  end

  return connected
end

function M.connects_to_maglev(rail, maglev_rail_name)
  for _, other in pairs(M.get_connected_rails(rail)) do
    if other.name == maglev_rail_name then
      return true
    end
  end
  return false
end

function M.connects_to_non_maglev(rail, maglev_rail_name)
  for _, other in pairs(M.get_connected_rails(rail)) do
    if other.name ~= maglev_rail_name then
      return true
    end
  end
  return false
end

return M
