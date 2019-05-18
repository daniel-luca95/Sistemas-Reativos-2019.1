-- Aqui setamos todas as propriedades do cenário da primeira fase
local stair= {}

-- First up: scene dimensions and background image

stair["height"] = 800
stair["width"] = 1200

stair["image"] = "cenarios/Scene1.png"

-- After that we define the solid constraints

local constraints = {}
constraints[1] = { ["domain"] = function (x,y) return true end, ["equation"] = {0, -1, 732} } -- Chão
constraints[2] = { ["domain"] = function (x,y) return (x > 148 and x < 314 ) or x > 492 end, ["equation"] = {0, -1, 671} } -- Chão
constraints[3] = { ["domain"] = function (x,y) return x > 639 end, ["equation"] = {0, -1, 605} } -- Chão
constraints[4] = { ["domain"] = function (x,y) return x > 951 end, ["equation"] = {0, -1, 544} } -- Chão
constraints[5] = { ["domain"] = function (x,y) return x < 10  end, ["equation"] = {1, 0, 0} }
constraints[6] = { ["domain"] = function (x,y) return y >= 671  end, ["equation"] = {-1, 0, 147} }
constraints[7] = { ["domain"] = function (x,y) return y >= 671  end, ["equation"] = { 1, 0, -314} }
constraints[8] = { ["domain"] = function (x,y) return y >= 671  end, ["equation"] = {-1, 0, 492} }
constraints[9] = { ["domain"] = function (x,y) return y >= 605  end, ["equation"] = {-1, 0, 639} }
constraints[10] = { ["domain"] = function (x,y) return y >= 544  end, ["equation"] = {-1, 0, 951} } 
constraints[11] = { ["domain"] = function (x,y) return true  end, ["equation"] = {-1, 0, 1200} }

stair["constraints"] = constraints

return stair