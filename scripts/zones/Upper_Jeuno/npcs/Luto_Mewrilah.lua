-----------------------------------
-- Area: Upper Jeuno
--  NPC: Luto Mewrilah
-- !pos -53 0 45 244
-----------------------------------
require("scripts/globals/settings")
require("scripts/globals/quests")
require("scripts/globals/utils")
-----------------------------------
local entity = {}

entity.onTrade = function(player, npc, trade)
end

entity.onTrigger = function(player, npc)
    local WildcatJeuno = player:getCharVar("WildcatJeuno")
    if (player:getQuestStatus(xi.quest.log_id.JEUNO, xi.quest.id.jeuno.LURE_OF_THE_WILDCAT) == QUEST_ACCEPTED and not utils.mask.getBit(WildcatJeuno, 7)) then
        player:startEvent(10085)
    else
        player:startEvent(10034) -- Standard dialog
    end
end

-- 10031  10032  10033  10034  10039  10041  10044  10042  10048  10045  10047  10071  10053  10049
-- 10050  10051  10068  10069  10070  10076  10077  10052  10043  10046  10055  10056  10057  10058
-- 10060  10059  10061  10062  10063  10064  10067  10065  10066  10072  10073  10074  10075  10078
-- 10079  10080  10081  10082  10085  10174  10175
entity.onEventUpdate = function(player, csid, option)
end

entity.onEventFinish = function(player, csid, option)
    if (csid == 10085) then
        player:setCharVar("WildcatJeuno", utils.mask.setBit(player:getCharVar("WildcatJeuno"), 7, true))
    end
end

return entity
