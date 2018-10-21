--[[
   util.lua - Authored by Thomas Smallridge (sundowns)
   Handy module containing various handy functions for game development in lua,
   particularly with Love2D.


]]

--TODO: Modularise the rest of this before it gets massive (filesystem, maths, debug, etc)

local meta = {
   __index = function(table, key)
      if key == "l" then
         return rawget(table, "love")
      elseif key == "m" then
         return rawget(table, "maths")
      elseif key == "t" then
         return rawget(table, "table")
      elseif key == "f" then
         return rawget(table, "file")
      elseif key == "d" then
         return rawget(table, "debug")
      else
         return rawget(table, key)
      end
   end;
}

local util = {}
util.love = {}
util.maths = {}
util.table = {}
util.file = {}
util.debug = {}

setmetatable(util, meta)

---------------------- TABLES

function util.table.print(table, name)
  print("==================")
  if not table then
    print("<EMPTY TABLE>")
    return
   end
  if type(table) ~= "table" then
    assert(false,"Attempted to print NON-TABLE TYPE: "..type(table))
    return
  end
  if name then print("Printing table: " .. name) end
  deepprint(table)
end

function deepprint(table, depth)
  local d = depth or 0
  local spacer = ""
  for i=0,d do
    spacer = spacer.." "
  end
  for k, v in pairs(table) do
    if type(v) == "table" then
      print(spacer.."["..k.."]:")
      deepprint(v, d + 1)
    else
      print(spacer.."[" .. tostring(k) .. "]: " .. tostring(v))
    end
  end
  -- for i, v in ipairs(table) do
  --   if type(v) == "table" then
  --     print(spacer.."["..i.."]:")
  --     deepprint(v, d + 1)
  --   else
  --     print(spacer.."[" .. tostring(i) .. "]: " .. tostring(v))
  --   end
  -- end
end

function util.table.concat(t1,t2)
    for i=1,#t2 do
        t1[#t1+1] = t2[i]
    end
    return t1
end

-- Recursively creates a copy of the given table.
-- Not my code, taken from: https://www.youtube.com/watch?v=dZ_X0r-49cw#t=9m30s
function util.table.copy(orig)
   local orig_type = type(orig)
   local copy
   if orig_type == 'table' then
      copy = {}
      for orig_key, orig_value in next, orig, nil do
         copy[util.table.copy(orig_key)] = util.table.copy(orig_value)
      end
   else
      copy = orig
   end
   return copy
end

---------------------- MATHS

function util.maths.roundToNthDecimal(num, n)
  local mult = 10^(n or 0)
  return math.floor(num * mult + 0.5) / mult
end

function util.maths.withinVariance(val1, val2, variance)
  local diff = math.abs(val1 - val2)
  if diff < variance then
    return true
  else
    return false
  end
end

function util.maths.clamp(val, min, max)
    if min - val > 0 then
        return min
    end
    if max - val < 0 then
        return max
    end
    return val
end

---------------------- DEBUG
debug = false

function util.debug.log(text)
    if debug then
        print(text)
    end
end

---------------------- FILE

--Only use this outside of Love2d scope
function util.file.exists(name)
   if love then assert(false, "Not to be used in love games, use love.filesystem.getInfo") end
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

function util.file.getLuaFileName(url)
   return string.gsub(url, ".lua", "")
end

---------------------- LOVE2D

function util.love.resetColour()
   love.graphics.setColor(1,1,1,1)
end

function util.love.renderStats(x, y)
   if not x then x = 0 end
   if not y then y = 0 end
   local stats = love.graphics.getStats()
   love.graphics.print("texture memory (MB): ".. stats.texturememory / 1024 / 1024, 3, 60)
   love.graphics.print("drawcalls: ".. stats.drawcalls, 3, 80)
   love.graphics.print("canvasswitches: ".. stats.canvasswitches , 3, 100)
   love.graphics.print("images loaded: ".. stats.images, 3, 120)
   love.graphics.print("canvases loaded: ".. stats.canvases, 3, 140)
   love.graphics.print("fonts loaded: ".. stats.fonts, 3, 160)
end

if not love then util.love = nil end

return util
