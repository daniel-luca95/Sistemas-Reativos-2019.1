
local SceneManager = {}

-------------------------------------------------------------------

-- Recebe uma posição (px, py)
-- "line" é uma tabela {a, b, -d} tal que a*x + b*y = d é a equação de uma reta e (a, b) a sua normal
-- Retorna true se o ponto está dentro da região definida (oposto à normal)
-- Receives a position described by (px, py). 
-- line is a table {a, b, -d} where a*x + b*y = d is the line equation and (a, b) is its normal
-- Returns true if the point provided is in the region defined by the line
local function isInRegion(px, py, line)
  return px*line[1] + py*line[2] + line[3] < 0
end

-- Calcula a interseção entre uma reta definida por dois pontos e uma linha no formato {a, b, -d} com a*x + b*y = d
-- Calculares the intersection between a line defined by two points and a line {a, b, -d} where a*x + b*y = d
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

-- tabela de fases do jogo
-- game stages' table
local scenes = {require "degrau", require "escada", require "cave" }

SceneManager["draw"] = 
  function ()
    love.graphics.draw(currentImage)    
  end

SceneManager["setScene"] =   
  function (sceneNumber)
    currentScene = scenes[sceneNumber]
    SceneManager["gravity"] = currentScene["gravity"]
    currentImage = love.graphics.newImage(currentScene["image"])
    love.window.setMode(currentScene["width"], currentScene["height"])
  end
  
-- recebe um ponto inicial e um ponto final
-- retorna se o movimento foi completo e também qual deltaX e qual deltaY foi possível percorrer da trajetória pretendida
-- receives an initial and a final point
-- returns whether the movement was complete and the offset 
SceneManager["canMove"] = 
  function (x0, y0, xf, yf)
    -- cada cena possui diversas barreiras
    -- each scene defines multiple constraints
    for index, constraint in ipairs(currentScene["constraints"]) do
      -- é preciso checar se o personagem está tentando atravessar cada região
      -- we must check if the character intends to cross any constraint
      if not isInRegion(x0, y0, constraint["equation"]) and isInRegion( xf, yf, constraint["equation"]) then
        x, y = getIntersection(x0, y0, xf, yf, constraint["equation"])
        if constraint["domain"](x, y) then
          return false, x - x0, y - y0
        end
      end
    end
    return true, xf - x0, yf - y0
  end

return SceneManager