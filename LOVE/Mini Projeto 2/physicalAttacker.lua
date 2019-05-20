local PhysicalAttacker
PhysicalAttacker = {}

-------------------------------------------------------------------
-- Um atacante físico é um personagem que pode inflingir dano a um conjunto de inimigos quando eles estão próximos
-- A physical attacker is a character that may inflict damage to a set of enemies if they are close enough

local Character
Character = require "character"

PhysicalAttacker["newAttacker"] = 
 function (sprite, x, y, healthPoints, strength)
    local physicalAttacker
    local has_attacked, visualFeedBackTimeout, attackImage, superUpdate, superDraw
    visualFeedBackTimeout = 0 -- tempo em que o feedback visual do ataque deve aparecer / timeout during which an attack's visual feedback must be shown
    physicalAttacker = Character.newCharacter(sprite, x, y, healthPoints)
    attackImage = love.graphics.newImage("attacks/attackfeedbackcorrected.png")
    
    superDraw = physicalAttacker["draw"]
    physicalAttacker["draw"] =
      function ()
        if has_attacked then
          local shear, scale
          if physicalAttacker["orientation"] == "backward" then
            shear = 0
            scale = -1
          else
            shear = physicalAttacker.w
            scale = 1
          end
          love.graphics.draw(attackImage, physicalAttacker.x + shear, physicalAttacker.y, 0, scale, 1)
        end
        superDraw()
      end
      
      superUpdate = physicalAttacker["update"]
      physicalAttacker["update"] =
        function (dt)
          visualFeedBackTimeout = visualFeedBackTimeout + dt
          if visualFeedBackTimeout > 0.5 then has_attacked = false end
          superUpdate(dt)
        end
    
    physicalAttacker["attack"] = 
      function (enemyList)
        local horizontal_range
        has_attacked = true
        visualFeedBackTimeout = 0.0 
        horizontal_range = attackImage:getWidth()
        for index, enemy in ipairs(enemyList) do
          local attackY
          attackY = physicalAttacker.y + attackImage:getHeight()
          if attackY >= enemy.y and attackY <= enemy.y + enemy.h then
            local attackInterval, targetInterval
            if physicalAttacker.orientation == "forward" then
              attackInterval = { physicalAttacker.x + physicalAttacker.w, 
                                 physicalAttacker.x + physicalAttacker.w + horizontal_range }
            else
              attackInterval = { physicalAttacker.x - horizontal_range, 
                                 physicalAttacker.x }
            end
            targetInterval = {enemy.x, enemy.x + enemy.w}
            local first, second
            if attackInterval[1] < targetInterval[1] then 
              first = attackInterval
              second = targetInterval
            else
              first = targetInterval
              second = attackInterval
            end
            if second[1] < first[2] then
              enemy.HP = enemy.HP - strength
            end
          end -- if
        end -- for
      end -- attack
      
    return physicalAttacker
 end
 
 return PhysicalAttacker