local chooseMenu = {}

-- Um botão tem um texto e uma função que é chamada quando ele é apertado 
local function newButton(text, image, fn)
  return
  {
    text = text,
    image = image,
    fn = fn,
    
    now = false,
    last = false
  }
end

local buttons = {} --Tabela de botões do menu
local font = nil -- Tamanho da fonte 
chooseMenu["show"] = false
chooseMenu["imageHero"] = "hero/herocorrected.png"
chooseMenu["imageSaved"] = "hero/princecorrected.png"
chooseMenu["clicked"] = false
--Função que cria botões do Menu

chooseMenu["load"] =
  
  function()
    font = love.graphics.newFont(32)
    buttons = {}
    table.insert(buttons,newButton(
        "PrinceHero",
        "hero/princecorrected.png",
        function ()
          chooseMenu["imageHero"] = "hero/princecorrected.png"
        end))
    
    table.insert(buttons,newButton(
        "PrincessHero",
        "hero/princesscorrected.png",
        function ()
          chooseMenu["imageHero"] = "hero/princesscorrected.png"
        end))
    
    table.insert(buttons,newButton(
        "defaultHero",
        "hero/herocorrected.png",
        function ()
          chooseMenu["imageHero"] = "hero/herocorrected.png"
        end))
    
    table.insert(buttons,newButton(
        "PrinceSaved",
        "hero/princecorrected.png",
        function ()
          chooseMenu["imageSaved"] = "hero/princecorrected.png"
        end))
    
    table.insert(buttons,newButton(
        "PrincessSaved",
        "hero/princesscorrected.png",
        function ()
          chooseMenu["imageSaved"] = "hero/princesscorrected.png"
        end))
    
    table.insert(buttons,newButton(
        "defaultSaved",
        "hero/herocorrected.png",
        function ()
          chooseMenu["imageSaved "] = "hero/herocorrected.png"
        end))
    end
  
  --Função responsável por desenhar tudo relacionado ao menu
    chooseMenu["draw"] =
    function()
      love.graphics.setBackgroundColor(0,0,0,1) -- Cor de fundo
      local widthCanvas = love.graphics.getWidth() -- largura da tela
      local heightCanvas = love.graphics.getHeight() -- altura da tela
      
      local button_width = widthCanvas * (1/3) -- largura do botão é 1/3 da largura da tela
      local button_height = 64
      local total_height = button_height * #buttons -- altura total dos botões juntos
      local margin = 16 -- margem entre os botões
      local cursory = 0
      local bx = (widthCanvas * 0.5) - (button_width * 0.5) -- Posição inicial em x do botão meio da tela menos metade da largura do botão  
      local by = (heightCanvas * 0.5) - (button_height * 0.5) - (total_height * 0.5) + cursory -- Posição inicial em y do botão considerando espaço entre botões
      
      --Desenha todos os botões
      for i, button in ipairs(buttons) do
        by = (heightCanvas * 0.5) - (button_height * 0.5) - (total_height * 0.5) + cursory
        
        -- Atualiza estado do botão
        button.last = button.now
        local color = {0.8,0.5,0.6,1} -- Cor dos botões
        local mx,my = love.mouse.getPosition() -- Pega posição do mouse
        
        -- Faz cálculo de interseção para ver se está com mouse em cima do botão ou não 
        local hot = mx > bx  and mx < bx + button_width and 
                    my > by  and my < by + button_height
                    
        -- Se o mouse estiver em cima do botão bota highlight nele
        if hot then
          color = {1,0.8,0.9,1}
        end
        
        -- Checa se mouse tá apertando o botão
        button.now = love.mouse.isDown(1)
        
        -- Se o mouse estiver pressionado, ele tiver mudado de estado e o mouse estiver em cima chama a função do botão
        if button.now and not button.last and hot then
          chooseMenu["clicked"] = true
          button.fn()
        end 
          
        love.graphics.setColor(unpack(color)) -- unpack pega conteúdo da table e espalha nos argumentos da função  
        
        --Desenha o personagem em cima do botão
        --love.draw(love.graphics.newImage(button.image), bx,by)
        --Um botão é um retângulo preenchido
        love.graphics.rectangle(
          "fill",
          bx, -- Posição inicial em x do botão meio da tela menos metade da largura do botão
          by , -- Posição inicial em y do botão considerando espaço entre botões
          button_width, -- largura do botão
          button_height -- altura do botão
        )
          
        
        local texW = font:getWidth(button.text) 
        local texH = font:getHeight(button.text)
        if not chooseMenu.show then
          love.graphics.setColor(0,0,0,1) -- Cor da letra 
        else 
          love.graphics.setColor(1,1,1,1) -- Cor da letra 
        end
        --Escrevendo texto do botão
        love.graphics.print(
          button.text,
          font,
          (widthCanvas * 0.5) - (texW * 0.5), 
          (heightCanvas * 0.5) - (button_height * 0.5) - (total_height * 0.5) + cursory + texH * 0.5
          )
      cursory = cursory + (button_height + margin) -- Fazendo cálculo para ter espaço vertical entre botões
      end

  end
return chooseMenu 