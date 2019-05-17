local Troll
Troll = {}

Character = require "character"

Troll["newTroll"] = 
 function (sprite, x, y)
    local troll
    troll = Character.newCharacter(sprite, x, y, 20)
    troll["attack"] = 
      function (enemyList)
        local damage, horizontal_range
        damage = 10
        horizontal_range = 10
        for index, enemy in ipairs(enemyList) do
          if enemy.y + enemy.h <= troll.y + troll.h and enemy.y >= troll.y then
            
            local delta
            delta = troll.x - enemy.x
            if troll.orientation == "backward" then 
              delta = - delta 
            end
            
            if delta <= horizontal_range then
              enemy.HP = enemy.HP - damage
            end
            
          end -- if
        end -- for
      end -- attack
      
    return troll
 end
 
 return Troll