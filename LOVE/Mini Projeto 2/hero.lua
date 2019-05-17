local Hero
Hero = {}

Character = require "character"

Hero["newHero"] = 
 function (sprite, x, y)
    local hero
    local has_attacked, t, attackImage, superUpdate, superDraw
    t = 0.1
    hero = Character.newCharacter(sprite, x, y, 30)
    attackImage = love.graphics.newImage("attackfeedbackcorrected.png")
    
    superDraw = hero["draw"]
    hero["draw"] =
      function ()
        if has_attacked then
          local shear, scale
          if hero["orientation"] == "backward" then
            shear = 0
            scale = -1
          else
            shear = hero.w
            scale = 1
          end
          love.graphics.draw(attackImage, hero.x + shear, hero.y, 0, scale, 1)
        end
        superDraw()
      end
      
      superUpdate = hero["update"]
      hero["update"] =
        function (dt)
          t = t + dt
          if t > 0.5 then has_attacked = false end
          superUpdate(dt)
        end
    
    hero["attack"] = 
      function (enemyList)
        local damage, horizontal_range
        has_attacked = true
        t = 0.0 
        damage = 3
        horizontal_range = attackImage:getWidth()
        for index, enemy in ipairs(enemyList) do
          local attackY
          attackY = hero.y + attackImage:getHeight()
          if attackY >= enemy.y and attackY <= enemy.y + enemy.h then
            local attackInterval, targetInterval
            if hero.orientation == "forward" then
              attackInterval = {hero.x + hero.w, hero.x + hero.w + horizontal_range}
            else
              attackInterval = {hero.x - horizontal_range, hero.x}
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
              enemy.HP = enemy.HP - damage
            end
          end -- if
        end -- for
      end -- attack
      
    return hero
 end
 
 return Hero