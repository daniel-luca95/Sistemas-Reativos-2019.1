local sceneManager = require "sceneManager"
local characterPackage = require "character"
local HeroPackage = require "hero"
local DragonPackage = require "dragon"
local TrollPackage = require "troll"
--local menu = require "menu"

function love.load()
  sceneManager.setScene(2) 
  math.randomseed(require "socket".gettime())
  hero = HeroPackage.newHero("herocorrected.png", 20, 200) --inicia herói com um sprite e posição inicial
  troll = TrollPackage.newTroll("trollcorrected.png", 1100, 300)
  heroine = HeroPackage.newHero("heroinecorrected.png", 850, 150)
  mate = DragonPackage.newDragon("dragoncorrected.png", 600, 200)
  hero.setScene(sceneManager) --Seta a cena em que o heroi está no jogo
  heroine.setScene(sceneManager)
  mate.setScene(sceneManager)
  troll.setScene(sceneManager)
--  menu.loadMenu()
  
end

function love.keypressed(key) 
  if key == "up" then
    hero.jump()
  elseif key == "left" then
    hero.accelerate(-180)
  elseif key == "right" then
    hero.accelerate(180)
  elseif key == "space" then
    hero.attack({mate, heroine, troll})
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
  heroine.draw()
  troll.draw()
--  menu.draw()
end

index = 1
vel = {-100, -100, -100, 400, 400, 400, -300, -300, -300}

function love.update(dt)
  dt = math.min(dt, 0.1)
  hero.update(dt)
  mate.update(dt)
  heroine.update(dt)
  troll.update(dt)
--  local action 
--  action = math.random(1, 15)
--  if action > 9 then
--    mate.accelerate(vel[index])
--    index = (index + 1) % #vel + 1
--  elseif action == 1 then
--    mate.jump()
--  end

end