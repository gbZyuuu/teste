local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local jogador = Players.LocalPlayer
local farmAtivo = false

-- Criação da ScreenGui principal
local gui = Instance.new("ScreenGui")
gui.Name = "AutoFarmGUI"
gui.Parent = game.CoreGui

-- Criação do frame principal da GUI
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0.2, 0, 0.3, 0)
frame.Position = UDim2.new(0.05, 0, 0.7, 0)
frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
frame.Visible = true

local titulo = Instance.new("TextLabel", frame)
titulo.Text = "Auto-Farm System"
titulo.Size = UDim2.new(1, 0, 0.2, 0)
titulo.Font = Enum.Font.SourceSansBold
titulo.TextColor3 = Color3.new(1, 1, 1)
titulo.BackgroundTransparency = 1

local missaoText = Instance.new("TextLabel", frame)
missaoText.Text = "Missão: Nenhuma"
missaoText.Position = UDim2.new(0, 0, 0.3, 0)
missaoText.Size = UDim2.new(1, 0, 0.2, 0)
missaoText.TextColor3 = Color3.new(1, 1, 1)
missaoText.BackgroundTransparency = 1

local levelText = Instance.new("TextLabel", frame)
levelText.Text = "Level: 1"
levelText.Position = UDim2.new(0, 0, 0.5, 0)
levelText.Size = UDim2.new(1, 0, 0.2, 0)
levelText.TextColor3 = Color3.new(1, 1, 1)
levelText.BackgroundTransparency = 1

local toggleButton = Instance.new("TextButton", frame)
toggleButton.Text = "Iniciar Auto-Farm"
toggleButton.Position = UDim2.new(0, 0, 0.7, 0)
toggleButton.Size = UDim2.new(1, 0, 0.2, 0)
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)

-- Tabela de missões
local Missoes = {
    { Level = 1, Nome = "Bandidos", NPC = "Bandido", EXP = 50 },
    { Level = 5, Nome = "Piratas", NPC = "Pirata", EXP = 100 },
    { Level = 10, Nome = "Chefes", NPC = "Chefe", EXP = 200 }
}

-- Função que atualiza a GUI conforme o nível
local function AtualizarGUI(nivel)
    local melhorMissao = nil
    for _, missao in pairs(Missoes) do
        if nivel >= missao.Level then
            melhorMissao = missao
        end
    end
    missaoText.Text = melhorMissao and "Missão: " .. melhorMissao.Nome or "Missão: Nenhuma"
    levelText.Text = "Level: " .. nivel
end

-- Simulação de sistema de ataque
local function AtacarNPC(npc)
    if npc and npc:FindFirstChild("Humanoid") then
        game:GetService("ReplicatedStorage").Remotes.Dano:FireServer(npc.Humanoid)
    end
end

-- Loop de Auto-Farm
toggleButton.MouseButton1Click:Connect(function()
    farmAtivo = not farmAtivo
    toggleButton.Text = farmAtivo and "Parar Auto-Farm" or "Iniciar Auto-Farm"
    
    while farmAtivo do
        task.wait(1)
        local nivel = 1 -- Substitua por sua lógica de nível (ex.: utilizando leaderstats)
        local missao = nil
        
        for _, m in pairs(Missoes) do
            if nivel >= m.Level then
                missao = m
            end
        end
        
        if missao then
            local npc = workspace:FindFirstChild(missao.NPC, true) -- Procura NPCs em subpastas
            if npc and npc:FindFirstChild("HumanoidRootPart") and jogador.Character and jogador.Character:FindFirstChild("HumanoidRootPart") then
                -- Move-se até o NPC
                jogador.Character:MoveTo(npc.HumanoidRootPart.Position)
                task.wait(0.5)
                AtacarNPC(npc)
                AtualizarGUI(nivel)
            end
        end
    end
end)

-- Criação do botão movível para esconder/mostrar a GUI principal
local toggleGUIButton = Instance.new("TextButton", gui)
toggleGUIButton.Name = "ToggleGUIButton"
toggleGUIButton.Text = "Esconder GUI"
toggleGUIButton.Size = UDim2.new(0, 100, 0, 50)
toggleGUIButton.Position = UDim2.new(0.8, 0, 0, 0)
toggleGUIButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
toggleGUIButton.TextColor3 = Color3.new(1, 1, 1)

toggleGUIButton.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
    toggleGUIButton.Text = frame.Visible and "Esconder GUI" or "Mostrar GUI"
end)

-- Função para permitir que o botão seja arrastado
local dragging = false
local dragInput, dragStart, startPos

toggleGUIButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = toggleGUIButton.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

toggleGUIButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        toggleGUIButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
