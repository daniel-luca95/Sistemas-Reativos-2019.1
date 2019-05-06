
local SceneManager = {}

local currentImage

sceneImages = {"Scene1.png"}

SceneManager["draw"] = 
  function (width, height)
    --imageWidth, imageHeight= currentImage.getDimensions()
    love.graphics.draw(currentImage, 0, 0, 0, width/1200, height/800)
    
  end

SceneManager["setScene"] =   
  function (sceneNumber)
    currentImage = love.graphics.newImage(sceneImages[sceneNumber])
  end

SceneManager["get
                      
                      
                      
                      
                      
                      
return SceneManager