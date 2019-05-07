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
                    
    local function move(deltaX, deltaY)
      x = x + deltaX
      y = y + deltaY
    end
    
    local vy
    vy = function (t, height) 
      height = height or 80
      return - 8*height + 32*height * t 
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
                          function (dt)
                            t = 0
                            while (not scene.hitAWall( x, y + vy(t)*dt )) do
                              y = y+vy(t)*dt
                              t = t + dt
                              dt = coroutine.yield()
                            end
                          end
                        )
                      end
                    end
    
    hero["update"] =  function(dt)
                        if not scene.hitAWall(x + dt*speed, y) then
                          x = x + dt*speed
                        end
                        if is_valid(movementY) then
                          coroutine.resume(movementY, dt)
                        end
                      end
    
    return hero
  end


return characterPackage