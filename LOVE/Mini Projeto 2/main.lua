local scene = require "sceneManager"
local characterPackage = require "character"

function love.keypressed(key)
  if key == "up" then
    hero.jump()
  elseif key == "left" then
    hero.accelerate(-80)
  elseif key == "right" then
    hero.accelerate(80)
  end
end

function love.keyreleased(key)
  if key == "left" then
    hero.accelerate(80)
  elseif key == "right" then
    hero.accelerate(-80)
  end
end

function love.load()
  width, height = love.graphics.getDimensions()
  scene.setScene(1)
  
  hero = characterPackage.newHero("hero.png", 20, 200)
end


function love.draw()
  scene.draw(width, height)
  hero.draw()
end

function love.update(dt)
  hero.update(dt, scene)
end