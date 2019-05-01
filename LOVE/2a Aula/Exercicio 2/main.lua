local function wait(segundos, meublip)
  meublip.deactivate(segundos)
  coroutine.yield()
end

local function newblip (vel)
  local x, y = 0, 0
  local tempo_de_desativacao = 0
  local momento_de_desativacao = 0
  local width, height = love.graphics.getDimensions( )
  local blip = {}
  blip["active"] = true
  local function up()
    while true do
      --print("entered coroutine   "..vel.." at "..hora_corrente)
      --print("is it active?       "..tostring(blip["active"]))
      if blip["active"] then
        x = x + 6
        if x > width then
          -- volta para a esquerda da janela
          x = 0
        end
        --print("antes   "..hora_corrente)
        wait(0.3/vel, blip)
        --print("depois  "..hora_corrente)
      elseif momento_de_desativacao + tempo_de_desativacao < hora_corrente then
        blip["active"] = true
      end
      --print("left coroutine "..vel)
      coroutine.yield()
    end

  end
  blip["update"] = coroutine.wrap(up)
  blip["affected"] =  function (pos)
                        if pos>x and pos<x+10 then
                        -- "pegou" o blip
                          return true
                        else
                          return false
                        end
                      end
  blip["draw"] =  function ()
                    love.graphics.rectangle("line", x, y, 10, 10)
                  end
  blip["deactivate"] =  function (timeout)
                          --print("deactivated coroutine "..vel.."for "..timeout)
                          blip["active"] = false
                          momento_de_desativacao = hora_corrente
                          tempo_de_desativacao = timeout
                        end
  return blip
end

local function newplayer ()
  local x, y = 0, 200
  local width, height = love.graphics.getDimensions( )
  return {
  try = function ()
          return x
        end,
  update =  function (dt)
              x = x + 0.5
              if x > width then
                x = 0
              end
            end,
  draw =  function ()
            love.graphics.rectangle("line", x, y, 30, 10)
          end
  }
end

function love.keypressed(key)
  if key == 'a' then
    pos = player.try()
    for i in ipairs(listabls) do
      local hit = listabls[i].affected(pos)
      if hit then
        table.remove(listabls, i) -- esse blip "morre" 
        return -- assumo que apenas um blip morre
      end
    end
  end
end

function love.load()
  hora_corrente = 0
  player =  newplayer()
  listabls = {}
  for i = 1, 5 do
    listabls[i] = newblip(1.5+0.5*i)
  end
end

function love.draw()
  player.draw()
  for i = 1,#listabls do
    listabls[i].draw()
  end
end

function love.update(dt)
  hora_corrente = hora_corrente + dt
  player.update(dt)
  for i = 1,#listabls do
    listabls[i].update()
  end
end