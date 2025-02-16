-- AVISO: Use apenas em ambientes PRIVADOS!
local Players = game:GetService("Players")
local jogador = Players.LocalPlayer
local farmAtivo = false

-- Cria a GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "BloxFruitsAutoFarm"

local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0.3, 0, 0.4, 0)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

local toggleButton = Instance.new("TextButton", gui)
toggleButton.Text = "☰"
toggleButton.Size = UDim2.new(0.05, 0, 0.05, 0)
toggleButton.Position = UDim2.new(0.95, 0, 0.05, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)

-- Missões do Blox Fruits (ajuste os NPCs!)
local Missoes = {
    { Level = 1, Nome = "Bandidos [Lv. 5]", NPC = "Bandit", EXP = 500 },
    { Level = 15, Nome = "Piratas [Lv. 20]", NPC = "Pirate", EXP = 1500 },
    { Level = 50, Nome = "Soldados [Lv. 60]", NPC = "Military Soldier", EXP = 5000 }
}

-- Função para atacar NPCs
local function AtacarNPC(npc)
    if npc and npc:FindFirstChild("Humanoid") then
        local args = { [1] = npc.Humanoid, [2] = npc.HumanoidRootPart }
        game:GetService("ReplicatedStorage").Remotes.MeleeRemote:FireServer(unpack(args))
    end
end

-- Loop de Farm
toggleButton.MouseButton1Click:Connect(function()
    farmAtivo = not farmAtivo
    mainFrame.Visible = farmAtivo
    while farmAtivo do
        task.wait(1)
        local nivel = jogador.Data.Level.Value -- Caminho do nível no Blox Fruits
        local missao = nil
        
        -- Escolhe a missão
        for _, m in pairs(Missoes) do
            if nivel >= m.Level then
                missao = m
            end
        end
        
        if missao then
            -- Encontra o NPC mais próximo
            local npcMaisProximo = nil
            local distanciaMinima = math.huge
            for _, npc in ipairs(workspace.Enemies:GetChildren()) do
                if npc.Name == missao.NPC and npc:FindFirstChild("HumanoidRootPart") then
                    local distancia = (jogador.Character.HumanoidRootPart.Position - npc.HumanoidRootPart.Position).Magnitude
                    if distancia < distanciaMinima then
                        npcMaisProximo = npc
                        distanciaMinima = distancia
                    end
                end
            end
            
            -- Move e ataca
            if npcMaisProximo then
                jogador.Character.HumanoidRootPart.CFrame = npcMaisProximo.HumanoidRootPart.CFrame
                task.wait(0.5)
                AtacarNPC(npcMaisProximo)
            end
        end
    end
end)
