local sceneManager = require "sceneManager"
local characterPackage = require "character"
local HeroPackage = require "hero"
local DragonPackage = require "dragon"
local TrollPackage = require "troll"
local menu = require "menu"
enemies = {}

function overrideUpdate(enemy, period, speed, tolerance, angerFactor)
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
  
  local function distanceToHero()
    return hero.x + hero.w/2.0 - enemy.x - enemy.w/2.0
  end
  
  local function pursue()
    local distance
    distance = distanceToHero()
    enemy.accelerate(distance/math.abs(distance)*speed)
    if hero.y+ hero.h < enemy.y then
      enemy.jump()
    end
    enemy.attack({hero})
  end
  
  local update = enemy["update"]
  enemy["update"] = 
    function (dt)
      t = t + dt
      if t > period then
        t = t - period
        if math.abs(distanceToHero()) < tolerance then
          state = "attack"
        end
        if state == "initial" then
          goBackAndForth()
        else
          pursue()
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
  hero.setDeathEvent(
    function ()
      print("GAME OVER")
       love.event.quit(0)
    end
  )
  
  menu.loadMenu()
  initialPositions = {{395, 640}, {820,520}, {1100,440}}
  for index, position in pairs(initialPositions) do
    local enemy
    enemy = HeroPackage.newHero("trollcorrected.png", position[1], position[2])
    enemies[enemy] = true
    enemy.setDeathEvent( 
      function () 
        enemies[enemy] = nil
      end
    )
    
  end
  for enemy, _ in pairs(enemies) do
    enemy.setScene(sceneManager)
    overrideUpdate(enemy, 3, 20, 65, 3)
  end
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
      local enemyList = {}
      for enemy, _ in pairs(enemies) do
        table.insert(enemyList, enemy)
      end    
      hero.attack(enemyList)
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
    for enemy, _ in pairs(enemies) do
      enemy.draw()
    end
  else
    menu.draw()
  end
end



function love.update(dt)
  if menu.start then
    hero.update(dt)
    dt = math.min(dt, 0.1)
    for enemy, _ in pairs(enemies) do
      enemy.update(dt)
    end
  end
end