local firstChalenge= {}

-- First up: scene dimensions and background image

firstChalenge["height"] = 800
firstChalenge["width"] = 1200

firstChalenge["image"] = "Scene2.png"

-- After that we define the solid constraints

local constraints = {}
constraints[1] = { ["domain"] = function (x,y) return true end, ["equation"] = {0, -1, 500} }
constraints[2] = { ["domain"] = function (x,y) return x > 1040 and y > 400  end, ["equation"] = {-1, 0, 1040} }
  
firstChalenge["constraints"] = constraints

return firstChalenge