function RunScalingAuras()
local SMALL_AURA_SIZE = 22 -- размер баффов
local LARGE_AURA_SIZE = 26 -- размер дебаффов
local AURA_OFFSET_Y = 2.5 -- расстояние между аурами по вертикали

hooksecurefunc("TargetFrame_UpdateAuraPositions", function(self, auraName, numAuras, numOppositeAuras, largeAuraList, updateFunc, maxRowWidth, offsetX)
    local size
    local offsetY = AURA_OFFSET_Y
    local rowWidth = 0
    local firstBuffOnRow = 1
    maxRowWidth = 126

    for i = 1, numAuras do

        if ( largeAuraList[i] ) then
            size = LARGE_AURA_SIZE
            offsetY = AURA_OFFSET_Y + AURA_OFFSET_Y
        else
            size = SMALL_AURA_SIZE
        end

        if ( i == 1 ) then
            rowWidth = size
        else
            rowWidth = rowWidth + size + offsetX
        end

        if ( rowWidth > maxRowWidth ) then
            updateFunc(self, auraName, i, numOppositeAuras, firstBuffOnRow, size, offsetX, offsetY)

            rowWidth = size
            firstBuffOnRow = i
            offsetY = AURA_OFFSET_Y
        else
            updateFunc(self, auraName, i, numOppositeAuras, i - 1, size, offsetX, offsetY)
        end
    end
end)
end
