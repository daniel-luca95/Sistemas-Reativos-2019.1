
local cave = {}

-- First up: scene dimensions and background image

cave["height"] = 800
cave["width"] = 1200
cave["gravity"] = 120*32

cave["image"] = "cenarios/Scene3.png"

-- After that we define the solid constraints
-- As constraints são as retas que delimitam os objetos da cena
local constraints = {}
constraints[1] = { ["domain"] = function (x,y) return true end, ["equation"] = {1, 0, 0} } -- borda de entrada
constraints[2] = { ["domain"] = function (x,y) return true end, ["equation"] = {-1, 0, 1200} }
constraints[3] = { ["domain"] = function (x,y) return x < 170 end, ["equation"] = {0, -1, 498}  }
constraints[4] = { ["domain"] = function (x,y) return x > 1038 end, ["equation"] = {0, -1, 471}  }
constraints[5] = { ["domain"] = function (x,y) return (x > 170 and x < 234) or (x > 956 and x < 1038 ) end, ["equation"] = {0, -1, 530} }
constraints[6] = { ["domain"] = function (x,y) return (x > 234 and x < 310) or (x > 860 and x < 956 ) end, ["equation"] = {0, -1, 579} }
constraints[7] = { ["domain"] = function (x,y) return (x > 310 and x < 397) or (x > 770 and x < 860 ) end, ["equation"] = {0, -1, 640} }
constraints[8] = { ["domain"] = function (x,y) return x > 397 or x < 770 end, ["equation"] = {0, -1, 707} }

constraints[9] = { ["domain"] = function (x,y) return y >= 498 end, ["equation"] = {1, 0, -170} }
constraints[10] = { ["domain"] = function (x,y) return y >= 530 end, ["equation"] = {1, 0, -234} }
constraints[11] = { ["domain"] = function (x,y) return y >= 579 end, ["equation"] = {1, 0, -310} }
constraints[12] = { ["domain"] = function (x,y) return y >= 640 end, ["equation"] = {1, 0, -397} }
constraints[13] = { ["domain"] = function (x,y) return y >= 640 end, ["equation"] = {-1, 0, 770} }
constraints[14] = { ["domain"] = function (x,y) return y >= 579 end, ["equation"] = {-1, 0, 860} }
constraints[15] = { ["domain"] = function (x,y) return y >= 530 end, ["equation"] = {-1, 0, 956} }
constraints[16] = { ["domain"] = function (x,y) return y >= 471 end, ["equation"] = {-1, 0, 1038} }
constraints[17] = { ["domain"] = function (x,y) return x > 556 or x < 690 end, ["equation"] = {0, -1, 162} }

cave["constraints"] = constraints

return cave