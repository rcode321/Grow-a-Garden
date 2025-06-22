local plant = script.Parent

-- Collect all BaseParts inside Plant
local parts = {}
for _, child in ipairs(plant:GetChildren()) do
    if child:IsA("BasePart") then
        table.insert(parts, child)
    end
end

local growTime = 1        -- total grow duration in seconds
local growSteps = 20      -- number of steps for smooth growth
local growInterval = growTime / growSteps
local finalHeight = 10    -- final height for Parts (stem)

while true do
    -- Store original sizes and mesh scales for reset
    local originalPartSizes = {}
    local originalMeshScales = {}

    -- Initialize all parts and meshes to small size/scale to start growth
    for i, part in ipairs(parts) do
        originalPartSizes[i] = part.Size

        local mesh = part:FindFirstChildWhichIsA("SpecialMesh") or part:FindFirstChildWhichIsA("Mesh")
        if mesh then
            originalMeshScales[i] = mesh.Scale
            -- Start mesh with very small Y scale
            mesh.Scale = Vector3.new(mesh.Scale.X, 0.1, mesh.Scale.Z)
        else
            originalMeshScales[i] = nil
            -- Start part with small Y size
            part.Size = Vector3.new(part.Size.X, 1, part.Size.Z)
        end
    end

    -- Grow loop: gradually increase size and scale
    for step = 1, growSteps do
        local alpha = step / growSteps
        for i, part in ipairs(parts) do
            local mesh = part:FindFirstChildWhichIsA("SpecialMesh") or part:FindFirstChildWhichIsA("Mesh")
            if mesh and originalMeshScales[i] then
                local startScale = originalMeshScales[i]
                local newYScale = 0.1 + (startScale.Y - 0.1) * alpha
                mesh.Scale = Vector3.new(startScale.X, newYScale, startScale.Z)
                print(part.Name, "Mesh scale Y:", newYScale)
            else
                local startSize = originalPartSizes[i]
                local newYSize = 1 + (finalHeight - 1) * alpha
                part.Size = Vector3.new(startSize.X, newYSize, startSize.Z)
                print(part.Name, "Part size Y:", newYSize)
            end
        end
        wait(growInterval)
    end

    wait(0.5)  -- pause before repeating growth
end

