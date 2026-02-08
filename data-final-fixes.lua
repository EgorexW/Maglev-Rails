-- #AI CODE
-- Space Age surface construction conditions (match base prototypes).

if mods and mods["space-age"] then
  local function copy_surface_conditions(dst, src)
    if not (dst and src) then return end
    if src.surface_conditions then
      dst.surface_conditions = table.deepcopy(src.surface_conditions)
    end
  end

  copy_surface_conditions(
    data.raw["rail-planner"]["maglev-rail"],
    data.raw["rail-planner"]["rail"]
  )
  copy_surface_conditions(
    data.raw["straight-rail"]["maglev-straight-rail"],
    data.raw["straight-rail"]["straight-rail"]
  )
  copy_surface_conditions(
    data.raw["locomotive"]["maglev-locomotive"],
    data.raw["locomotive"]["locomotive"]
  )
  copy_surface_conditions(
    data.raw["item-with-entity-data"]["maglev-locomotive"],
    data.raw["item-with-entity-data"]["locomotive"]
  )
end
