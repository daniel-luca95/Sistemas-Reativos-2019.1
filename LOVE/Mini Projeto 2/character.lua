--Contém todas as funções e atributos necessários para a criação de um personagem

local characterPackage = {}

local gravity = 120*32

local function is_valid(co)
  return co and coroutine.status(co) ~= "dead"
end

characterPackage["newCharacter"] = 
  function (sprite, x, y) -- Inicializa o herói com o sprite(nome de um arquivo de imagem), e posição inicial
    local image
    local scene
    local t, height
    t = 0
    height = 0
    
    character = {}
    character["x"] = x --posição atual em x do personagem
    character["y"] = y --posição atual em y do personagem
    
    character["setScene"] = function(newScene) scene = newScene end 
    
    character["image"] = love.graphics.newImage(sprite) --carrega sprite do personagem
    character["w"], character["h"] = character["image"]:getDimensions()
    
    character["draw"] =  function () --desenha o personagem em determinada posição atual
                      love.graphics.draw(character["image"], x, y)
                    end
    
    local speed = 0 -- velocidade em x, começa zerada
    character["accelerate"] =  function (deltaSpeed) --função que atualiza velocidade a somando com uma aceleração
                            speed = speed + deltaSpeed 
                          end
    
    local movementY 
    movementY = nil
    
    local vy -- Função que calcula velocidade em y e à atualiza, baseada na equação do movimento v = v0 + at
    vy = function (t)
      return - 8*height + gravity * t 
    end
    
    character["jump"] =  function () -- Função chamada quando o personagem pula.Ele só pula se tiver no chão (height = 0)
                      if height == 0 then
                        t = 0 
                        height = 120 --Seta a altura do pulo
                      end
                    end
    
    character["update"] =  function(dt)
                        t = t + dt
                        local deltaX, deltaY, success, xtest, ytest
                        deltaX = 0
                        deltaY = 0
                        if speed < 0 then
                          success, deltaX, _ = scene.canMove(x, y, x + dt*speed, y)  -- Atualiza posição de personagem em x se for possível
                          if success then
                            _, deltaX, _ = scene.canMove(x, y + character.h, x + dt*speed, y + character.h)
                          end
                        elseif speed > 0 then
                          success, deltaX, _ = scene.canMove(x + character.w, y, x + character.w + dt*speed, y)
                          if success then
                            _, deltaX, _ = scene.canMove(x + character.w, y + character.h, x + character.w + dt*speed, y + character.h)
                          end
                        end
                        x = x + deltaX
                        
                        if vy(t) < 0 then
                          success, _, deltaY = scene.canMove(x, y, x, y + dt*vy(t))
                          if success then
                            success, _, deltaY = scene.canMove(x + character.w, y, x + character.w, y + dt*vy(t))
                          end
                        elseif vy(t) > 0 then
                          success, _, deltaY = scene.canMove(x, y + character.h, x, y + character.h + dt*vy(t)) 
                          if success then
                            success, _, deltaY = scene.canMove(x + character.w, y + character.h, x + character.w, y + character.h + dt*vy(t)) 
                          end
                        end
                        y = y + deltaY
                        if not success then 
                          t = 0
                          height = 0
                        end
                      end
                      
    return character
  end


return characterPackage