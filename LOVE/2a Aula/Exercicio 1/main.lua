local TAM = 700
local status = 1
local quantos = 10
local dist = 0.5
local raio = 0.3

local function desenhacirculo(x,y,raio)
  love.graphics.setColor(0.6, 0.5, 0.3)
  love.graphics.circle("line", x, y, raio)   
end

local desenha

local desenha_rec
desenha_rec = function (quantos, dist, raio)
    if raio > TAM/100000 then
      for i = 1, quantos do
        love.graphics.push()
        love.graphics.rotate(-i*(2*math.pi)/quantos)
        love.graphics.setLineWidth(TAM/100000)
        desenhacirculo (0, dist, raio)
        love.graphics.pop()
      end
      coroutine.yield()
      love.timer.sleep(0.5)
      desenha_rec((4/3)*quantos, dist, (3/4)*raio)
    end
  end

desenha = coroutine.create( 
  function (quantos, dist, raio)
    desenha_rec(quantos, dist, raio)
  end
)

function love.load ()
  love.window.setTitle("circulos")
  love.window.setMode(TAM,TAM)
  love.graphics.setBackgroundColor(255,255,255)
end

function love.update (dt)

end

function love.draw ()
  -- sistema normalizado [0,1]
  love.graphics.push()
  love.graphics.translate(TAM/2,TAM/2)
  love.graphics.scale(TAM/2,-TAM/2)
  coroutine.resume(desenha, quantos, dist, raio)
  love.graphics.pop()
end