local sceneManager = require "sceneManager"
local characterPackage = require "character"

function love.load()
  sceneManager.setScene(1) 
  hero = characterPackage.newHero("hero.png", 20, 200) --inicia herói com um sprite, e posição inicial
  hero.setScene(sceneManager) --Seta a cena em que o heroi está no jogo
end

function love.keypressed(key) 
  if key == "up" then
    hero.jump()
  elseif key == "left" then
    hero.accelerate(-180)
  elseif key == "right" then
    hero.accelerate(180)
  end
end

function love.keyreleased(key)
  if key == "left" then
    hero.accelerate(180)
  elseif key == "right" then
    hero.accelerate(-180)
  end
end


function love.draw()
  sceneManager.draw(width, height)
  hero.draw()
end

function love.update(dt)
  hero.update(dt)
end