local sceneManager = require "sceneManager"
local characterPackage = require "character"
local attackerPackage = require "physicalAttacker"
local dragonPackage = require "dragon"
local menu = require "menu"
local resumeMenu = require "resumeMenu"
local chooseMenu = require "chooseMenu"
enemies = {}

function loadSecondPhase()
  blockKeyReleaseOnce = true
  sceneManager.setScene(2)
  prisoner = nil
  hero = attackerPackage.newAttacker(chooseMenu.imageHero, 20, 600, 30, 5) --inicia herói com um sprite e posição inicial
  hero.setScene(sceneManager) --Seta a cena em que o heroi está no jogo
  hero.setDeathEvent(
    function ()
      print("GAME OVER")
       love.event.quit(0)
    end
  )
  initialPositions = {{1100,440}, {820,520}, {395, 640}}
  enemies = {}
  for index, position in pairs(initialPositions) do
    local enemy
    enemy = attackerPackage.newAttacker("enemies/trollcorrected.png", position[1], position[2], 40, 8)
    enemies[enemy] = true
    enemy.setDeathEvent( 
      function () 
        enemies[enemy] = nil
        if next(enemies) == nil then
          loadThirdPhase()
        end
      end
    )
    overrideUpdate(enemy, 1+index/2.0, 20+index*3, 65, index)
    enemy.setScene(sceneManager)
  end
end

function loadThirdPhase()
  blockKeyReleaseOnce = true
  sceneManager.setScene(3)
  prisoner = characterPackage.newCharacter(chooseMenu["imagePrisoner"], 613, 100, 22)
  prisoner.setScene(sceneManager)
  hero = attackerPackage.newAttacker(chooseMenu.imageHero, 20, 200, 30, 5) --inicia herói com um sprite e posição inicial
  hero.setScene(sceneManager) --Seta a cena em que o heroi está no jogo
  hero.setDeathEvent( 
    function ()
      print("GAME OVER")
       love.event.quit(0)
    end
  )
  local enemy
  enemy = dragonPackage.newDragon("enemies/dragoncorrected.png", 600, 500, 30)
  enemy.setScene(sceneManager)
  enemy.setDeathEvent(
    function ()
      print("Won!")
      love.event.quit(0)
    end
  )
  overrideUpdate(enemy, 1, 40, 300, 3)
  enemies[enemy] = true  
end

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
    enemy.setSpeed(distance/math.abs(distance)*speed)
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
  enemies = {}
  prisoner = nil 
  sceneManager.setScene(1) 
  hero = attackerPackage.newAttacker("hero/herocorrected.png", 20, 200, 30, 5 ) --inicia herói com um sprite e posição inicial
  hero.setScene(sceneManager) --Seta a cena em que o heroi está no jogo
  local update
  update = hero["update"]
  hero["update"] =
    function (dt)
      update(dt)
      if hero.x > 1150 then
        loadSecondPhase()
      end
    end
  menu.loadMenu()
  resumeMenu.load()
  chooseMenu.load()
end

function love.keypressed(key) 
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
  end -- if key
end

function love.keyreleased(key)
  if not blockKeyReleaseOnce then
      if key == "left" then
        hero.accelerate(180)
      elseif key == "right" then
        hero.accelerate(-180)
      end
  else 
    blockKeyReleaseOnce = false
  end
end


function love.draw()
  sceneManager.draw()
  
  -- Se o menu de configuração foi acionado
  if chooseMenu.show then
      if chooseMenu.clicked then -- Se algum botão do menu de seleção for clicado volta ao menu principal  
        chooseMenu.show = false
        chooseMenu.clicked = false
      else
        chooseMenu.draw() -- Desenha menu de escolher personagens
      end
  elseif not menu.start and not resumeMenu.show then --  Se o jogo não tiver começado e o resume menu não tiver aparecendo desenha menu principal
      menu.draw()
  else
    hero.draw()
    if prisoner then
      prisoner.draw()
    end
    for enemy, _ in pairs(enemies) do
      enemy.draw()
    end
    if resumeMenu.show then
      resumeMenu.draw()
    end
  end
end

function love.update(dt)
  if chooseMenu.clicked  then
      hero.image = love.graphics.newImage(chooseMenu.imageHero)
      if(prisoner ) then
        prisoner.image = love.graphics.newImage(chooseMenu.imagePrisoner)
      end 
  end
  if menu.start then
    dt = math.min(dt, 0.1)
    hero.update(dt) 
    if prisoner  then
       prisoner.update(dt)
    end
    for enemy, _ in pairs(enemies) do
      enemy.update(dt)
    end
    
  -- Se o botão de resume for apertado o menu de resume fecha e o jogo continua
  elseif resumeMenu.resume then
    menu.start = true
    resumeMenu.resume = false
    resumeMenu.show = false
    
  -- Se o botão de restart for apertado o menu de resume fecha e recomeça o jogo chamando função de load
  elseif resumeMenu.restart then
    menu.start = true
    resumeMenu.restart = false
    resumeMenu.show = false
    love.load()
  end
end