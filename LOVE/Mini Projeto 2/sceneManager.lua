
local SceneManager = {}

-------------------------------------------------------------------

-- Receives a position described by (px, py). 
-- LineTable is {a, b, -d} where a*x + b*y = d is the line equation
-- Returns true if the point provided is not in the region defined by the line
local function isOutOfRegion(px, py, line)
  return px*line[1] + py*line[2] + line[3] >= 0
end

local function getIntersection(x0, y0, xf, yf, line)
  local n 
  local n_norm
  local d
  local c0, cf
  local x0n, y0n, xfn, yfn
  
  n = {line[1], line[2]}
  
  n_norm = math.sqrt(n[1]*n[1] + n[2]*n[2])
  n[1] = n[1] /n_norm
  n[2] = n[2] /n_norm
  print(n[1], n[2])
  d = -line[3]/n_norm
  
  c0 = x0*n[1] + y0*n[2] - d
  cf = xf*n[1] + y0*n[2] - d
  
  x0n = x0 - c0 * n[1]
  y0n = y0 - c0 * n[2]
  
  xfn = xf - cf * n[1]
  yfn = yf - cf * n[2]
  
  local hitx, hity
  
  if math.abs(x0n - xfn) < 1.e-6 then
    hitx = x0n
  else
    hitx = (x0n * cf + xfn * c0) / (cf+ c0)
  end
  
  if math.abs(y0n - yfn) < 1.e-6 then
    hity = y0n
  else
    hity = (y0n * cf + yfn * c0) / (cf+ c0)
  end
  return hitx, hity
end

-------------------------------------------------------------------

local currentImage
local currentScene = 1

local scenes = {require "degrau"}

SceneManager["draw"] = 
  function (width, height)
    love.graphics.draw(currentImage)    
  end

SceneManager["setScene"] =   
  function (sceneNumber)
    currentScene = scenes[1]
    currentImage = love.graphics.newImage(currentScene["image"])
    love.window.setMode(currentScene["width"], currentScene["height"])
  end
  
SceneManager["canMove"] = 
  function (x0, y0, xf, yf)
    for index, constraint in ipairs(currentScene["constraints"]) do
      if (isOutOfRegion(x0, y0, constraint["equation"])) and (not isOutOfRegion( xf, yf, constraint["equation"])) then
        x, y = getIntersection(x0, y0, xf, yf, constraint["equation"])
        if constraint["domain"](x, y) then
          return false, x, y
        end
      end
    end
    return true, xf, yf
  end

return SceneManager