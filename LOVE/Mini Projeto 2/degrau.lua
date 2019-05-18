-- Aqui setamos todas as propriedades do cenário da primeira fase
local firstChalenge= {}

-- First up: scene dimensions and background image

firstChalenge["height"] = 800
firstChalenge["width"] = 1200

firstChalenge["image"] = "Scene2.png"

-- After that we define the solid constraints

local constraints = {}
constraints[1] = { ["domain"] = function (x,y) return true end, ["equation"] = {0, -1, 498} } -- Chão
--Degrau
constraints[2] = { ["domain"] = function (x,y) return x >= 1000 and y >= 390  end, ["equation"] = {-1, 0, 1040} } 
constraints[3] = { ["domain"] = function (x,y) return x > 1040  end, ["equation"] = {0, -1, 400} }
constraints[4] = { ["domain"] = function (x,y) return true  end, ["equation"] = {1, 0, 0} }
constraints[5] = { ["domain"] = function (x,y) return true  end, ["equation"] = {-1, 0, 1200} }
  
firstChalenge["constraints"] = constraints

return firstChalenge