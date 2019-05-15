-- Aqui setamos todas as propriedades do cenário da primeira fase

local firstChalenge= {}

-- First up: scene dimensions and background image

firstChalenge["height"] = 800
firstChalenge["width"] = 1200

firstChalenge["image"] = "Scene1.png"

-- After that we define the solid constraints
-- As constraints são as retas que delimitam os objetos da cena
local constraints = {}
constraints[1] = { ["domain"] = function (x,y) return true end, ["equation"] = {0, -1, 500} }
  
firstChalenge["constraints"] = constraints

return firstChalenge