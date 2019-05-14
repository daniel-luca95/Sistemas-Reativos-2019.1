local characterPackage = {}

local gravity = 120*32

local function is_valid(co)
  return co and coroutine.status(co) ~= "dead"
end

characterPackage["newHero"] = 
  function (sprite, x, y) -- sprite should be a file name
    local image
    local scene
    
    local t, height
    t = 0
    height = 0
    
    hero = {}
    hero["x"] = x
    hero["y"] = y
    hero["setScene"] = function(newScene) scene = newScene end
    
    hero["image"] = love.graphics.newImage(sprite)
    
    hero["draw"] =  function ()
                      love.graphics.draw(hero["image"], x, y)
                    end
    
    local speed = 0
    hero["accelerate"] =  function (deltaSpeed) 
                            speed = speed + deltaSpeed 
                          end
    
    local movementY 
    movementY = nil
    
    local vy
    vy = function (t)
      return - 8*height + gravity * t 
    end
    
    hero["jump"] =  function ()
                      if height == 0 then
                        t = 0
                        height = 120
                      end
                    end
    
    hero["update"] =  function(dt)
                        t = t + dt
                        _, x, y = scene.canMove(x, y, x + dt*speed, y)
                        success, x, y = scene.canMove(x, y, x, y + dt*vy(t))
                        if not success then 
                          t = 0
                          height = 0
                        end                       
                      end
                      
    return hero
  end


return characterPackage