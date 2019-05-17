local sceneManager = require "sceneManager"
local characterPackage = require "character"
local HeroPackage = require "hero"
local DragonPackage = require "dragon"
local TrollPackage = require "troll"
--local menu = require "menu"

enemies = {}

function love.load()
  sceneManager.setScene(2) 
  math.randomseed(require "socket".gettime())
  hero = HeroPackage.newHero("herocorrected.png", 20, 200) --inicia herói com um sprite e posição inicial
  hero.setScene(sceneManager) --Seta a cena em que o heroi está no jogo
    
  initialPositions = {{395, 640}, {820,520}, {1100,440}}
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
  end
end

function love.keypressed(key) 
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
  for enemy, _ in pairs(enemies) do
    enemy.draw()
  end
end

function love.update(dt)
  dt = math.min(dt, 0.1)
  hero.update(dt)
  for enemy, _ in pairs(enemies) do
    enemy.update(dt)
  end
end