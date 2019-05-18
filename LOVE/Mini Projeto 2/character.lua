--Contém todas as funções e atributos necessários para a criação de um personagem

local characterPackage = {}

local gravity = 120*32
characterPackage["setImage"] =
function (sprite)
  print(sprite)
  character["image"] = love.graphics.newImage(sprite) --carrega sprite do personagem
end

characterPackage["newCharacter"] = 
  function (sprite, x, y, healthPoints) -- Inicializa o herói com o sprite(nome de um arquivo de imagem), e posição inicial
    local image
    local scene
    local t, height
    t = 0
    height = 0
    
    local function deathCallback ()
      return
    end
    
    local character
    character = {}
    character["HP"] = healthPoints
    character["x"] = x --posição atual em x do personagem
    character["y"] = y --posição atual em y do personagem
    character["orientation"] = "forward"
    
    character["setScene"] = function(newScene) scene = newScene end 
    
    character["image"] = love.graphics.newImage(sprite) --carrega sprite do personagem
    character["w"], character["h"] = character["image"]:getDimensions()
    
    character["draw"] =  
      function () -- desenha o personagem em determinada posição atual
        if character["HP"] > 0 then
          -- HP bar
          local r, g, b, a
          r, g, b, a = love.graphics.getColor()
          love.graphics.setColor(0.2, 1, 0.2, 1)
          love.graphics.rectangle( "fill", character.x - 4, character.y - 10, character.HP, 3, 3)
          love.graphics.setColor(r, g, b, a)
          local shear, scale
          if character["orientation"] == "backward" then
            shear = character.w
            scale = -1
          else
            shear = 0
            scale = 1
          end
          love.graphics.draw(character["image"], character.x, character.y, 0, scale, 1, shear)
        end
      end
    
    local speed = 0 -- velocidade em x, começa zerada
    character["accelerate"] =  
      function (deltaSpeed) --função que atualiza velocidade a somando com uma aceleração
        speed = speed + deltaSpeed
        if speed > 0 then
          character["orientation"] = "forward"
        elseif speed < 0 then
          character["orientation"] = "backward"
        end
      end
    
    local vy -- Função que calcula velocidade em y e à atualiza, baseada na equação do movimento v = v0 + at
    vy = function (t)
      return - 8*height + gravity * t 
    end
    
    character["jump"] =  
      function () -- Função chamada quando o personagem pula.Ele só pula se tiver no chão (height = 0)
        if height == 0 then
          t = 0 
          height = 120 --Seta a altura do pulo
        end
      end
    
    character["update"] =  
      function(dt)
        if character["HP"] <= 0 then
          deathCallback()
        end
        t = t + dt
        local deltaX, deltaY, success, xtest, ytest
        deltaX = 0
        deltaY = 0
        if speed < 0 then
          success, deltaX, _ = scene.canMove( character.x, 
                                              character.y, 
                                              character.x + dt*speed, 
                                              character.y )  -- Atualiza posição de personagem em x se for possível
          if success then
            _, deltaX, _ = scene.canMove( character.x, 
                                          character.y + character.h, 
                                          character.x + dt*speed, 
                                          character.y + character.h )
          end
        elseif speed > 0 then
          success, deltaX, _ = scene.canMove( character.x + character.w, 
                                              character.y, 
                                              character.x + character.w + dt*speed, 
                                              character.y )
          if success then
            _, deltaX, _ = scene.canMove( character.x + character.w, 
                                          character.y + character.h, 
                                          character.x + character.w + dt*speed, 
                                          character.y + character.h )
--            print("deltaX: ",deltaX)
          end
        end
        character.x = character.x + deltaX
        
        if vy(t) < 0 then
          success, _, deltaY = scene.canMove( character.x, 
                                              character.y, 
                                              character.x, 
                                              character.y + dt*vy(t)  )
          if success then
            success, _, deltaY = scene.canMove( character.x + character.w, 
                                                character.y, 
                                                character.x + character.w, 
                                                character.y + dt*vy(t)  )
          end
        elseif vy(t) > 0 then
          success, _, deltaY = scene.canMove( character.x, 
                                              character.y + character.h, 
                                              character.x, 
                                              character.y + character.h + dt*vy(t)  ) 
          if success then
            success, _, deltaY = scene.canMove( character.x + character.w, 
                                                character.y + character.h, 
                                                character.x + character.w, 
                                                character.y + character.h + dt*vy(t)  ) 
          end
        end
        character.y = character.y + deltaY
        if not success then 
          t = 0
          height = 0
        end
      end
    
    character["setDeathEvent"] = 
      function (callback)
        deathCallback = callback
      end
    
--    character["attack"]
    
    return character
  end


return characterPackage