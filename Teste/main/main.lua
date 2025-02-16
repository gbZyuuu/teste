--[[ 
  Instruções:
  1. Execute via executor (Ex.: Synapse, ScriptWare).
  2. A GUI aparecerá automaticamente no centro.
  3. Clique no botão flutuante para mostrar/esconder.
]]

loadstring(game:HttpGet("https://raw.githubusercontent.com/gbZyuuu/teste/refs/heads/main/Teste/main/main.lua"))()

-- Caso o loadstring falhe, use o código abaixo:

local Players = game:GetService("Players")
local jogador = Players.LocalPlayer
local mouse = jogador:GetMouse()
local farmAtivo = false

-- Configuração da GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "BloxFruitsAutoFarm"
gui.Enabled = true

-- Frame principal (centro da tela)
local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0.3, 0, 0.4, 0)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

-- Botão flutuante para mostrar/esconder
local toggleButton = Instance.new("TextButton", gui)
toggleButton.Size = UDim2.new(0.05, 0, 0.05, 0)
toggleButton.Position = UDim2.new(0.95, 0, 0.05, 0)
toggleButton.Text = "☰"
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)

-- Elementos da GUI
local title = Instance.new("TextLabel", mainFrame)
title.Text = "Auto-Farm Blox Fruits"
title.Size = UDim2.new(1, 0, 0.2, 0)
title.Font = Enum.Font.SourceSansBold

local missaoText = Instance.new("TextLabel", mainFrame)
missaoText.Text = "Missão: Nenhuma"
missaoText.Position = UDim2.new(0, 0, 0.3, 0)
missaoText.Size = UDim2.new(1, 0, 0.2, 0)

local levelText = Instance.new("TextLabel", mainFrame)
levelText.Text = "Level: Carregando..."
levelText.Position = UDim2.new(0, 0, 0.5, 0)
levelText.Size = UDim2.new(1, 0, 0.2, 0)

-- Tabela de missões (ajuste conforme Blox Fruits)
local Missoes = {
    { Level = 1, Nome = "Bandidos", NPC = "Bandit", EXP = 500 },
    { Level = 15, Nome = "Piratas", NPC = "Pirate", EXP = 1500 },
    { Level = 50, Nome = "Soldados", NPC = "Military Soldier", EXP = 5000 }
}

-- Função para mover o botão flutuante
local dragging = false
toggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        local startPos = input.Position
        local framePos = toggleButton.Position
        while dragging do
            local delta = Vector2.new(mouse.X - startPos.X, mouse.Y - startPos.Y)
            toggleButton.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
            task.wait()
        end
    end
end)

toggleButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Toggle da GUI
toggleButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

-- Sistema de Auto-Farm
local function GetClosestNPC(npcName)
    local closestNPC, minDistance = nil, math.huge
    for _, npc in ipairs(workspace.Enemies:GetChildren()) do
        if npc.Name == npcName and npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
            local distance = (jogador.Character.HumanoidRootPart.Position - npc.HumanoidRootPart.Position).Magnitude
            if distance < minDistance then
                closestNPC = npc
                minDistance = distance
            end
        end
    end
    return closestNPC
end

local function AtacarNPC(npc)
    if npc then
        -- Ajuste o RemoteEvent de acordo com Blox Fruits (ex.: MeleeRemote)
        local args = { [1] = npc.Humanoid, [2] = npc.HumanoidRootPart }
        game:GetService("ReplicatedStorage").Remotes.MeleeRemote:FireServer(unpack(args))
    end
end

-- Loop principal
spawn(function()
    while task.wait(1) do
        if farmAtivo then
            local nivel = jogador:WaitForChild("Data"):WaitForChild("Level").Value
            local missaoAtual = nil
            
            for _, missao in ipairs(Missoes) do
                if nivel >= missao.Level then
                    missaoAtual = missao
                end
            end
            
            if missaoAtual then
                missaoText.Text = "Missão: " .. missaoAtual.Nome
                levelText.Text = "Level: " .. nivel
                
                local npc = GetClosestNPC(missaoAtual.NPC)
                if npc then
                    jogador.Character:MoveTo(npc.HumanoidRootPart.Position)
                    task.wait(0.5)
                    AtacarNPC(npc)
                end
            end
        end
    end
end)

-- Iniciar/Parar Farm
local startButton = Instance.new("TextButton", mainFrame)
startButton.Text = "Iniciar Auto-Farm"
startButton.Position = UDim2.new(0, 0, 0.7, 0)
startButton.Size = UDim2.new(1, 0, 0.2, 0)
startButton.MouseButton1Click:Connect(function()
    farmAtivo = not farmAtivo
    startButton.Text = farmAtivo and "Parar Auto-Farm" or "Iniciar Auto-Farm"
end)
