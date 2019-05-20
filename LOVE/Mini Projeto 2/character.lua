-- Contém todas as funções e atributos necessários para a criação de um personagem
-- This module is responsible for characters general behavior

local characterPackage = {}

-------------------------------------------------------------------

characterPackage["setImage"] =
function (sprite)
  print(sprite)
  character["image"] = love.graphics.newImage(sprite) --carrega sprite do personagem / loads and stores character sprite
  character["w"], character["h"] = character["image"]:getDimensions()
end

-- Character factory
characterPackage["newCharacter"] =      -- Receives this character's sprite file name, its initial position and health points
  function (sprite, x, y, healthPoints) -- Recebe o nome do arquivo da sprite do personagem, sua posição inicial e os pontos de vida
    local image -- imagem do personagem / character's image object
    local scene -- cena que o personagem percorre / scene where the character is moving
    local t, impulse -- parâmetros necessários para o pulo do personagem na cena / parameters required to perform a jump
    t = 0
    impulse = 0
    
    local function deathCallback () -- Função que deve ser chamada após a morte do personagem / An event that is triggered by this character's death
      return -- Inicialmente não faz nada / Initially doesn't do anything
    end
    
    local character
    character = {}
    character["HP"] = healthPoints
    character["x"] = x --posição atual em x do personagem / current character's X position
    character["y"] = y --posição atual em y do personagem / current character's Y position
    character["orientation"] = "forward" -- para onde o personagem está "olhando" / the direction the character is facing
    
    -- a cena encapsula as informações de paredes e chão
    -- this object encapsulates floor and walls information
    character["setScene"] = 
      function(newScene) 
        scene = newScene 
      end 
    
    character["image"] = love.graphics.newImage(sprite)
    character["w"], character["h"] = character["image"]:getDimensions()
    
    character["draw"] =  
      function ()
        if character["HP"] > 0 then -- personagem não é desenhado se já não tiver pontos de vida
                                    -- character is only drawn if it's alive
          -- barra de vida / HP bar
          local r, g, b, a
          r, g, b, a = love.graphics.getColor()
          love.graphics.setColor(0.2, 1, 0.2, 1)
          love.graphics.rectangle( "fill", character.x - 4, character.y - 10, character.HP, 3, 3) 
          love.graphics.setColor(r, g, b, a)
          
          -- transformações na imagem para desenhar corretamente sua orientação
          -- parameter necessary to drawn the sprite facing the right direction
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
      end -- draw
    
    
    local vx = 0
    
    local function adjustOrientation ()
        if vx > 0 then
          character["orientation"] = "forward"
        elseif vx < 0 then
          character["orientation"] = "backward"
        end
    end
     
    character["accelerate"] =  -- função que atualiza velocidade a somando com uma aceleração
      function (deltaSpeed)    -- sums a deltaSpeed value to characters's current speed
        vx = vx + deltaSpeed
        adjustOrientation()
      end
      
    character["setSpeed"] =
      function (newSpeed)
        vx = newSpeed
        adjustOrientation()
      end
    
    -- velocidade em y e função de um tempo, baseada na equação do movimento v = v0 + at (eixo y aponta para baixo)
    -- speed in y axis (a function of a certain time), y axis goes down the screen
    local function vy(t)
      return - 8*impulse + scene["gravity"] * t 
    end
    
    character["jump"] =  
      function () -- parâmetros para início do pulo são setados aqui - requer que o personagem esteja no chão
                  -- this function sets vy initial coefficients - the character must be on the floor for this function to work
        if impulse == 0 and t == 0 then
          impulse = 120 -- velocidade inicial com que o personagem vai pra cima / initial speed with which the character goes up
        end
      end -- jump
    
    character["update"] =  -- função que atualiza o estado do personagem
      function(dt)
        if character["HP"] <= 0 then
          deathCallback() -- personagem morreu / character's death
        end
        
        ------     simulação física da posição do personagem     ------
        ------  physical simulation of the character's position  ------
        t = t + dt
        local deltaX, deltaY, success, xreference, yreference
        deltaX = 0
        deltaY = 0
        
        if vx <= 0 then
          xreference = character.x
        else
          xreference = character.x + character.w
        end

        if vy(t) <= 0 then
          yreference = character.y
        else
          yreference = character.y + character.h
        end
        
        success, deltaX, _ = scene.canMove( xreference, 
                                            character.y, 
                                            xreference + dt*vx, 
                                            character.y )  
        if success then
          _, deltaX, _ = scene.canMove( xreference, 
                                        character.y + character.h, 
                                        xreference + dt*vx, 
                                        character.y + character.h )
        end

        success, _, deltaY = scene.canMove( character.x, 
                                            yreference, 
                                            character.x, 
                                            yreference + dt*vy(t)  )
        if success then
          success, _, deltaY = scene.canMove( character.x + character.w, 
                                              yreference, 
                                              character.x + character.w, 
                                              yreference + dt*vy(t)  )
        end

        character.x = character.x + deltaX
        character.y = character.y + deltaY
        -- ultimo "success" só é falso caso o personagem tenha pousado em algo
        -- last "success" is whether or not the character landed on somethingse 
        if not success then -- se o pulo acabou não há impulso para o alto / if it has landed there's no initial speed upwards
          t = 0
          impulse = 0
        end
      end -- update
    
    character["setDeathEvent"] = 
      function (callback)
        deathCallback = callback
      end
    
    return character
  end

return characterPackage