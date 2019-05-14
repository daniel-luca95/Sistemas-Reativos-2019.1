local sceneManager = require "sceneManager"
local characterPackage = require "character"

function love.load()
  sceneManager.setScene(1)
  hero = characterPackage.newHero("hero.png", 20, 200)
  hero.setScene(sceneManager)
end

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


function love.draw()
  sceneManager.draw(width, height)
  hero.draw()
end

function love.update(dt)
  hero.update(dt)
end