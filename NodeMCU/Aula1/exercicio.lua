local led1 = 3
local led2 = 6
local sw1 = 1
local sw2 = 2

gpio.mode(led1, gpio.OUTPUT)
gpio.mode(led2, gpio.OUTPUT)

gpio.write(led1, gpio.LOW);
gpio.write(led2, gpio.LOW);

gpio.mode(sw1,gpio.INT,gpio.PULLUP)
gpio.mode(sw2,gpio.INT,gpio.PULLUP)

local tempoaceso = 200000
local seqrodada = {}
local seqentrada = {}
local tamseq = 5

local function exibeResultado()
    local equal
    equal = true
    for indice, entrada in pairs(seqentrada) do
        if seqrodada[indice] ~= entrada then
            equal = false
            break
        end
    end
    if equal then
        gpio.write(led2, gpio.HIGH)
    else
        gpio.write(led1, gpio.HIGH)
    end
    gpio.trig(sw1)
    gpio.trig(sw2)
end

tolerance = 250000

local function ativaEntradaDoUsuario()
  local function registerButton(button)
    local ultimoAperto
    ultimoAperto = 0
    gpio.trig(button, "down",   function (level, timestamp)
                                    if timestamp > ultimoAperto + tolerance  then
                                        ultimoAperto = timestamp
                                        print(button)
                                        seqentrada[#seqentrada+1] = button
                                        if #seqentrada == 5 then
                                            exibeResultado()
                                        end
                                    end
                                end
    )
  end
  registerButton(sw1)
  registerButton(sw2)
end

local function geraseq (semente)
  print ("veja a sequencia:")
  tmr.delay(2*tempoaceso)
  print ("(" .. tamseq .. " itens)")
  math.randomseed(semente)
  for i = 1,tamseq do
    seqrodada[i] = math.floor(math.random(1.5,2.5))
    print(seqrodada[i])
    gpio.write(3*seqrodada[i], gpio.HIGH)
    tmr.delay(3*tempoaceso)
    gpio.write(3*seqrodada[i], gpio.LOW)
    tmr.delay(2*tempoaceso)
  end
  print ("agora (seria) sua vez:")
end

local function cbchave1 (_,contador)
  -- corta tratamento de interrupções
  -- (passa a ignorar chave)
  gpio.trig(sw1)
  -- chama função que trata chave
  geraseq (contador)
  ativaEntradaDoUsuario()
end


gpio.trig(sw1, "down", cbchave1)
