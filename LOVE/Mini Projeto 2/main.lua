local sceneManager = require "sceneManager"
local characterPackage = require "character"
local HeroPackage = require "hero"
local DragonPackage = require "dragon"
local TrollPackage = require "troll"
local menu = require "menu"

function love.load()
  sceneManager.setScene(1) 
  math.randomseed(require "socket".gettime())
--  hero = HeroPackage.newHero("hero.png") --inicia herói com um sprite, posição inicial e pontos de vida
  hero = DragonPackage.newDragon("dragon.png", 10, 10)
  troll = TrollPackage.newTroll("troll.png", 1100, 300)
  heroine = HeroPackage.newHero("heroine.png", 850, 150)
  mate = HeroPackage.newHero("heroagain.png", 600, 200)
  hero.setScene(sceneManager) --Seta a cena em que o heroi está no jogo
  heroine.setScene(sceneManager)
  mate.setScene(sceneManager)
  troll.setScene(sceneManager)
  menu.loadMenu()
  
end

function love.keypressed(key) 
  if(menu.start) then
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
end

function love.keyreleased(key)
  if menu.start then
    if key == "left" then
      hero.accelerate(180)
    elseif key == "right" then
      hero.accelerate(-180)
    end
  end
end


function love.draw()
  if(menu.start) then 
    sceneManager.draw()
    hero.draw()
    mate.draw()
    heroine.draw()
    troll.draw()
  else
    menu.draw()
  end
end

index = 1
vel = {-100, -100, -100, 400, 400, 400, -300, -300, -300}

function love.update(dt)
  if menu.start then
    hero.update(dt)
    mate.update(dt)
    heroine.update(dt)
    troll.update(dt)
  end
--  local action 
--  action = math.random(1, 15)
--  if action > 9 then
--    mate.accelerate(vel[index])
--    index = (index + 1) % #vel + 1
--  elseif action == 1 then
--    mate.jump()
--  end

end