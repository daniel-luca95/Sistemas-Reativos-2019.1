local xinit = 50
local yinit = 50


function retangulo (x,y,w,h)
  local originalx, originaly, rx, ry, rw, rh = x, y, x, y, w, h
  local mousedentro = function()
                        local mx, my = love.mouse.getPosition()
                        return (mx>rx) and (mx<rx+rw) and (my>ry) and (my<ry+rh)
                      end
  return {
    draw =  function ()
              love.graphics.rectangle("line", rx, ry, rw, rh)
            end,
    keypressed =  function (key)
                    if mousedentro() then
                      if key == 'b' then
                        rx = originalx
                        ry = originaly
                      elseif key == "down" then
                        ry = ry + 10
                      elseif key == "right" then
                        rx = rx + 10
                      end
                    end
                  end
  }
end

function love.load()
  retangulos = {}
  retangulos[1] = retangulo(50,50,200,300)
  retangulos[2] = retangulo(500,50,30,50)
  retangulos[3] = retangulo(50,500,30,50)
  --x = xinit 
  --y = yinit
  --w = 200 h = 300
end

function love.keypressed(key)
  for k, value in pairs(retangulos) do
    value.keypressed(key)
  end
end

function love.update (dt)
end

function love.draw ()
  for k, value in pairs(retangulos) do
    value.draw(key)
  end
end

