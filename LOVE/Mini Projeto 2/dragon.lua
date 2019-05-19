local Dragon
Dragon = {}

Dragon["newDragon"] = 
  function (sprite, x, y)
    local troll    
    local is_attacking, enemies, xrock, yrock, range, rockSpeed, damage, distance
    range = 120
    is_attacking = false
    damage = 5
    
    troll = Character.newCharacter(sprite, x, y, 60)
    
    local superDraw, superUpdate
    superDraw = troll["draw"]
    superUpdate = troll["update"]
    
    troll["draw"] = 
      function ()
        if is_attacking then
          local r, g, b, a
          r, g, b, a = love.graphics.getColor()
          love.graphics.setColor(1,0,0,1)
          love.graphics.rectangle("fill", xrock, yrock, 4*rockSpeed/math.abs(rockSpeed), 5)
          love.graphics.setColor(r, g, b, a)
        end
        superDraw()
      end
        
    troll["update"] =
      function(dt)
        if is_attacking then
          deltaXrock = rockSpeed*dt
          for index, enemy in ipairs(enemies) do
            if yrock <= enemy.y + enemy.h and yrock >= enemy.y  then
              local xEnemyReference
              if rockSpeed > 0 then xEnemyReference = enemy.x else xEnemyReference = enemy.x + enemy.w end
              if math.abs(deltaXrock) >= math.abs(xrock - xEnemyReference) + math.abs(xrock + deltaXrock - xEnemyReference) then
                enemy.HP = enemy.HP - damage
                is_attacking = false
              end -- if
            end -- if
          end -- for
          xrock = xrock + deltaXrock
          distance = distance + deltaXrock
          if math.abs(distance) >= range then
            is_attacking = false
          end
        end -- if
        superUpdate(dt)
      end
    
    troll["attack"] = 
      function (enemyList)
        is_attacking = true
        distance = 0
        enemies = enemyList
        rockSpeed = 400
        if troll.orientation == "backward" then 
          rockSpeed = - rockSpeed 
          xrock = troll.x
        else
          xrock = troll.x + troll.w
        end
        yrock = troll.y + troll.h/2.0
      end -- attack
    return troll
  end

return Dragon