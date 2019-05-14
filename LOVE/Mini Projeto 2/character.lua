local characterPackage = {}

local function is_valid(co)
  return co and coroutine.status(co) ~= "dead"
end

characterPackage["newHero"] = 
  function (sprite, x, y) -- sprite should be a file name
    local image
    local scene
    
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
    vy = function (t, height) 
      height = height or 120
      return - 8*height + 32*height * t 
    end
    
    hero["jump"] =  function ()
                      if not is_valid(movementY) then
                        movementY = coroutine.create(
                          function (dt)
                            local t
                            t = 0
                            local dy
                            while true do
                              dy = vy(t)*dt
                              t = t + dt
                              success, x, y = scene.canMove(x, y, x, y+dy)
                              if not success then break end
                              dt = coroutine.yield()
                            end
                          end
                        )
                      end
                    end
    
    hero["update"] =  function(dt)
                        _, x, y = scene.canMove(x, y, x + dt*speed, y)
                        if is_valid(movementY) then
                          coroutine.resume(movementY, dt)
                        end
                      end
    
    return hero
  end


return characterPackage