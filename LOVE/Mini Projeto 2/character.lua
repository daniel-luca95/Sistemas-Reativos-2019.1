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
    
    hero["width"],hero["height"] = hero["image"]:getDimensions()
    
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
                        _, x, y = scene.canMove(x, y, x + dt*speed, y) -- Atualiza posição de personagem em x se for possível
                        success, x, y = scene.canMove(x, y, x, y + dt*vy(t)) -- Atualiza posição de personagem em y se for possível
                        if not success then 
                          t = 0
                          height = 0
                        end                       
                      end
                      
    return hero
  end


return characterPackage