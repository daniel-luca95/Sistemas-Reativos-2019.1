
local SceneManager = {}

local currentImage
local currentScene = 1

sceneImages = {"Scene1.png"}
sceneConstraints = {
  function(x,y) 
    local width, height
    width, height = love.graphics.getDimensions()
    return y > 5 * height/8 
  end
}

SceneManager["draw"] = 
  function (width, height)
    --imageWidth, imageHeight= currentImage.getDimensions()
    love.graphics.draw(currentImage, 0, 0, 0, width/1200, height/800)
    
  end

SceneManager["setScene"] =   
  function (sceneNumber)
    currentScene = sceneNumber
    currentImage = love.graphics.newImage(sceneImages[sceneNumber])
  end

SceneManager["hitAWall"] = 
  function (xf, yf)
    return sceneConstraints[currentScene](xy, yf)
  end
                      
                      
                      
                      
                      
                      
return SceneManager