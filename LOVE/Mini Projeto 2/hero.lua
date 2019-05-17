local Hero
Hero = {}

Character = require "character"

Hero["newHero"] = 
 function (sprite, x, y)
    local hero
    hero = Character.newCharacter(sprite, x, y, 20)
    hero["attack"] = 
      function (enemyList)
        local damage, horizontal_range
        damage = 3
        horizontal_range = 40
        for index, enemy in ipairs(enemyList) do
          if enemy.y + enemy.h <= hero.y + hero.h and enemy.y >= hero.y then
            
            local delta
            delta = hero.x - enemy.x
            if hero.orientation == "backward" then 
              delta = - delta 
            end
            
            if delta <= horizontal_range then
              enemy.HP = enemy.HP - damage
            end
            
          end -- if
        end -- for
      end -- attack
      
    return hero
 end
 
 return Hero