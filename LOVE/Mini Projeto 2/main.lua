local sceneManager = require "sceneManager"
local characterPackage = require "character"
local HeroPackage = require "hero"
local DragonPackage = require "dragon"
local TrollPackage = require "troll"
local menu = require "menu"
local resumeMenu = require "resumeMenu"
enemies = {}

function overrideUpdate(enemy, period, speed)
  local t
  t = 0
  local counter
  counter = 1
  local state
  state = "initial"
  
  local function goBackAndForth()
    counter = (counter + 1) % 4
    if counter == 0 or counter == 3 then
      enemy.accelerate(-speed)
    else
      enemy.accelerate(speed)
    end
  end
  
  local update = enemy["update"]
  enemy["update"] = 
    function (dt)
      t = t + dt
      if t > period then
        t = t - period
        if state == "initial" then
          goBackAndForth()
        end
      end  
      update(dt)
    end
end

function love.load()
  sceneManager.setScene(2) 
  math.randomseed(require "socket".gettime())
  hero = HeroPackage.newHero("herocorrected.png", 20, 200) --inicia herói com um sprite e posição inicial
  hero.setScene(sceneManager) --Seta a cena em que o heroi está no jogo
  --heroine.setScene(sceneManager)
  --mate.setScene(sceneManager)
  --troll.setScene(sceneManager)
  menu.loadMenu()
  resumeMenu.load()
  initialPositions = {{395, 640}, {820,520}, {1100,440}}
  enemies = {}
  for index, position in pairs(initialPositions) do
    local enemy
    enemy = TrollPackage.newTroll("trollcorrected.png", position[1], position[2])
    enemies[enemy] = true
    enemy.setDeathEvent( 
      function () 
        enemies[enemy] = nil
      end
    )
    
  end
  for enemy, _ in pairs(enemies) do
    enemy.setScene(sceneManager)
    overrideUpdate(enemy, 3, 20)
  end
end

function love.keypressed(key) 
  if(menu.start) then
    if key == "m" then
      menu.start = false
      resumeMenu.show = true
    elseif key == "up" then
      hero.jump()
    elseif key == "left" then
      hero.accelerate(-180)
    elseif key == "right" then
      hero.accelerate(180)
    elseif key == "space" then
      local enemyList = {}
      for enemy, _ in pairs(enemies) do
        table.insert(enemyList, enemy)
      end    
      hero.attack(enemyList)
    end
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
  if(menu.start) then 
    sceneManager.draw()
    hero.draw()
    --mate.draw()
    --heroine.draw()
    --troll.draw()
    hero.draw()
    for enemy, _ in pairs(enemies) do
      enemy.draw()
    end
  else
    if resumeMenu.show then
      resumeMenu.draw()
    else
      menu.draw()
    end
  end
end



function love.update(dt)
  if menu.start then
    hero.update(dt)
    --mate.update(dt)
    --heroine.update(dt)
    --troll.update(dt)
    dt = math.min(dt, 0.1)
    for enemy, _ in pairs(enemies) do
      enemy.update(dt)
    end
    
  elseif resumeMenu.resume then
    menu.start = true
    resumeMenu.resume = false
    menu.show = false
    
  elseif resumeMenu.restart then
    menu.start = true
    resumeMenu.restart = false
    menu.show = false
    love.load()
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