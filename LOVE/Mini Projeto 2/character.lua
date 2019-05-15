--Contém todas as funções e atributos necessários para a criação de um personagem

local characterPackage = {}

local gravity = 120*32

local function is_valid(co)
  return co and coroutine.status(co) ~= "dead"
end

characterPackage["newHero"] = 
  function (sprite, x, y) -- Inicializa o heroi com o sprite(nome de um arquivo de imagem), e posição inicial
    local image
    local scene
    local t, height
    t = 0
    height = 0
    
    hero = {}
    hero["x"] = x --posição atual em x do personagem
    hero["y"] = y --posição atual em y do personagem
    
    hero["setScene"] = function(newScene) scene = newScene end 
    
    hero["image"] = love.graphics.newImage(sprite) --carrega sprite do personagem
    hero["w"], hero["h"] = hero["image"]:getDimensions()
    
    hero["draw"] =  function () --desenha o personagem em determinada posição atual
                      love.graphics.draw(hero["image"], x, y)
                    end
    
    local speed = 0 -- velocidade em x, começa zerada
    hero["accelerate"] =  function (deltaSpeed) --função que atualiza velocidade a somando com uma aceleração
                            speed = speed + deltaSpeed 
                          end
    
    local movementY 
    movementY = nil
    
    local vy -- Função que calcula velocidade em y e à atualiza, baseada na equação do movimento v = v0 + at
    vy = function (t)
      return - 8*height + gravity * t 
    end
    
    hero["jump"] =  function () -- Função chamada quando o personagem pula.Ele só pula se tiver no chão (height = 0)
                      if height == 0 then
                        t = 0 
                        height = 120 --Seta a altura do pulo
                      end
                    end
    
    hero["update"] =  function(dt)
                        t = t + dt
                        local xcan, ycan
                        if speed < 0 then
                          _, xcan, ycan = scene.canMove(x, y, x + dt*speed, y)  -- Atualiza posição de personagem em x se for possível
                          x = xcan
                        elseif speed > 0 then
                          _, xcan, ycan = scene.canMove(x + hero.w, y, x + hero.w + dt*speed, y)
                          x = xcan - hero.w
                        end
                        local success
                        if vy(t) < 0 then
                          success, xcan, ycan = scene.canMove(x, y, x, y + dt*vy(t))
                          y = ycan
                        elseif vy(t) > 0 then
                          success, xcan, ycan = scene.canMove(x, y + hero.h, x, y + hero.h + dt*vy(t))
                          y = ycan - hero.h 
                        end
                        if not success then 
                          t = 0
                          height = 0
                        end                       
                      end
                      
    return hero
  end


return characterPackage