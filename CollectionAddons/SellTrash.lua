local L = LibStub('AceLocale-3.0'):GetLocale('FriskesUI')

function RunSellTrash()
-- Автоматически продаёт серый хлам и ремонтирует шмот
local g = CreateFrame("Frame")
g:RegisterEvent("MERCHANT_SHOW")
g:SetScript("OnEvent", function()
    local bag, slot
    for bag = 0, 4 do
        for slot = 0, GetContainerNumSlots(bag) do
            local link = GetContainerItemLink(bag, slot)
            if link and (select(3, GetItemInfo(link)) == 0) then
                UseContainerItem(bag, slot)
            end
        end
    end
    if (CanMerchantRepair()) then
        local cost = GetRepairAllCost()
        if cost > 0 then
            local money = GetMoney()
            if IsInGuild() then
                local guildMoney = GetGuildBankWithdrawMoney()
                if guildMoney > GetGuildBankMoney() then
                    guildMoney = GetGuildBankMoney()
                end
                if guildMoney > cost and CanGuildBankRepair() then
                    RepairAllItems(1)
                    print(format(
                        L.SellTrashInfo1,
                        cost * 0.0001))
                    return
                end
            end
            if money > cost then
                RepairAllItems()
                print(format(L.SellTrashInfo2, cost * 0.0001))
            else
                print(
                    L.SellTrashInfo3)
            end
        end
    end
end)
end
