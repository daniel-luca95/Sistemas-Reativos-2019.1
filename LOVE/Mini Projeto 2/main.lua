local sceneManager = require "sceneManager"
local characterPackage = require "character"
local menu = require "menu"
local HeroPackage = require "hero"

function love.load()
  sceneManager.setScene(1) 
  math.randomseed(require"socket".gettime())
  hero = HeroPackage.newHero("hero.png") --inicia herói com um sprite, posição inicial e pontos de vida
  mate = characterPackage.newCharacter("enemy.png", 20, 200, 14)
  hero.setScene(sceneManager) --Seta a cena em que o heroi está no jogo
  mate.setScene(sceneManager)
  menu.loadMenu()
  
end

function love.keypressed(key) 
  if key == "up" then
    hero.jump()
  elseif key == "left" then
    hero.accelerate(-180)
  elseif key == "right" then
    hero.accelerate(180)
  elseif key == "space" then
    hero.attack({mate})
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
  sceneManager.draw()
  hero.draw()
  mate.draw()
  --menu.draw()
end

index = 1
vel = {-100, -100, -100, 400, 400, 400, -300, -300, -300}

function love.update(dt)
  hero.update(dt)
  mate.update(dt)
  local action 
  action = math.random(1, 10)
  if action > 9 then
    mate.accelerate(vel[index])
    index = (index + 1) % #vel + 1
  elseif action < 2 then
    mate.jump()
 
  end
end