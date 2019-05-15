
local SceneManager = {}

-------------------------------------------------------------------

-- Receives a position described by (px, py). 
-- LineTable is {a, b, -d} where a*x + b*y = d is the line equation
-- Returns true if the point provided is not in the region defined by the line
local function isOutOfRegion(px, py, line)
  return px*line[1] + py*line[2] + line[3] >= 0
end

-- Checa se a reta formada pelos pontos (x0,y0) e (xf,yf) intersectam a linha que defini um obstáculo ou um delimite de região
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
  d = -line[3]/n_norm
  
  c0 = x0*n[1] + y0*n[2] - d
  cf = xf*n[1] + yf*n[2] - d
  
  x0n = x0 - c0 * n[1]
  y0n = y0 - c0 * n[2]
  
  xfn = xf - cf * n[1]
  yfn = yf - cf * n[2]
  
  local hitx, hity
  
  if math.abs(x0n - xfn) < 1.e-6 then
    hitx = x0n
  else
    hitx = (x0n * math.abs(cf) + xfn * math.abs(c0)) / (math.abs(cf) + math.abs(c0))
  end
  if math.abs(y0n - yfn) < 1.e-6 then
    hity = y0n
  else
    hity = (y0n * math.abs(cf) + yfn * math.abs(c0)) / (math.abs(cf) + math.abs(c0))
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
  
 --Basicamente, essa função retorna se é possível se mover no cenário, ou seja, primeiro vê se o caminho de onde ele está pra onde ele quer ir tem algum obstáculo entre esses dois pontos, os demais retornos são quanto o boneco pode percorrer para completar o movimento.
 
SceneManager["canMove"] = 
  function (x0, y0, xf, yf)
    for index, constraint in ipairs(currentScene["constraints"]) do
      if (isOutOfRegion(x0, y0, constraint["equation"])) and (not isOutOfRegion( xf, yf, constraint["equation"])) then
        x, y = getIntersection(x0, y0, xf, yf, constraint["equation"])
        if constraint["domain"](x, y) then
          return false, x - x0, y - y0
        end
      end
    end
    return true, xf - x0, yf - y0
  end

return SceneManager