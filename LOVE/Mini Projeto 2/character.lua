local characterPackage = {}

local function is_valid(co)
  return co and coroutine.status(co) ~= "dead"
end

characterPackage["newHero"] = 
  function (sprite, x, y) -- sprite should be a file name
    local image
    hero = {}
    hero["x"] = x
    hero["y"] = y
    hero["image"] = love.graphics.newImage(sprite)
    
    hero["draw"] =  function ()
                      love.graphics.draw(hero["image"], x, y)
                    end
                    
    local function move(deltaX, deltaY)
      x = x + deltaX
      y = y + deltaY
    end
    
    local movementY 
    movementY = nil
    local speed = 0
    hero["move"] = move
    hero["accelerate"] =  function (deltaSpeed) 
                            speed = speed + deltaSpeed 
                          end
            
    hero["jump"] =  function ()
                      if not is_valid(movementY) then
                        movementY = coroutine.create(
                          function (dt, scene)
                            t = -dt
                            v = function (t, height) 
                                  height = height or 80
                                  return - 8*height + 32*height * t 
                                end
                            while (t <= 0.5) do
                              t = t + dt
                              y = y + v(math.min(t, 0.5))*dt
                              dt = coroutine.yield()
                            end
                          end
                        )
                      end
                    end
    
    hero["update"] =  function(dt)
                        if is_valid(movementY) then
                          coroutine.resume(movementY, dt)
                        end
                        x = x + dt*speed
                      end
    
    return hero
  end


return characterPackage