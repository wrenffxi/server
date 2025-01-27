-----------------------------------
-- Area: Windurst Woods
--  NPC: Apururu
-- Involved in Quests: The Kind Cardian, Can Cardians Cry?
-- !pos -11 -2 13 241
-----------------------------------
local ID = require("scripts/zones/Windurst_Woods/IDs")
require("scripts/globals/keyitems")
require("scripts/globals/missions")
require("scripts/globals/npc_util")
require("scripts/globals/quests")
require("scripts/globals/titles")
-----------------------------------
local entity = {}

local TrustMemory = function(player)
    local memories = 0
    -- 2 - Saw him at the start of the game
    if player:getNation() == xi.nation.WINDURST then
        memories = memories + 2
    end
    -- 4 - WONDER_WANDS
    if player:hasCompletedQuest(xi.quest.log_id.WINDURST, xi.quest.id.windurst.WONDER_WANDS) then
        memories = memories + 4
    end
    -- 8 - THE_TIGRESS_STIRS
    if player:hasCompletedQuest(xi.quest.log_id.CRYSTAL_WAR, xi.quest.id.crystalWar.THE_TIGRESS_STIRS) then
        memories = memories + 8
    end
    -- 16 - I_CAN_HEAR_A_RAINBOW
    if player:hasCompletedQuest(xi.quest.log_id.WINDURST, xi.quest.id.windurst.I_CAN_HEAR_A_RAINBOW) then
        memories = memories + 16
    end
    -- 32 - Hero's Combat (BCNM)
    -- if (playervar for Hero's Combat) then
    --  memories = memories + 32
    -- end
    -- 64 - MOON_READING
    if player:hasCompletedMission(xi.mission.log_id.WINDURST, xi.mission.id.windurst.MOON_READING) then
        memories = memories + 64
    end
    return memories
end

entity.onTrade = function(player, npc, trade)
    -- THE KIND CARDIAN
    if player:getQuestStatus(xi.quest.log_id.JEUNO, xi.quest.id.jeuno.THE_KIND_CARDIAN) == QUEST_ACCEPTED and
        npcUtil.tradeHas(trade, 969) then
        player:startEvent(397)

        -- CAN CARDIANS CRY?
    elseif player:getQuestStatus(xi.quest.log_id.WINDURST, xi.quest.id.windurst.CAN_CARDIANS_CRY) == QUEST_ACCEPTED and
        npcUtil.tradeHas(trade, 551) then
        player:startEvent(325, 0, 20000, 5000)
    end
end

entity.onTrigger = function(player, npc)
    local missionStatus = player:getMissionStatus(player:getNation())
    local kindCardian = player:getQuestStatus(xi.quest.log_id.JEUNO, xi.quest.id.jeuno.THE_KIND_CARDIAN)
    local kindCardianCS = player:getCharVar("theKindCardianVar")
    local allNewC3000 = player:getQuestStatus(xi.quest.log_id.WINDURST, xi.quest.id.windurst.THE_ALL_NEW_C_3000)
    local canCardiansCry = player:getQuestStatus(xi.quest.log_id.WINDURST, xi.quest.id.windurst.CAN_CARDIANS_CRY)
    local Rank6 = player:getRank() >= 6 and 1 or 0

    -- WINDURST 1-2: THE HEART OF THE MATTER
    if player:getCurrentMission(WINDURST) == xi.mission.id.windurst.THE_HEART_OF_THE_MATTER then
        if missionStatus == 0 then
            player:startEvent(137)
        elseif missionStatus < 4 then
            player:startEvent(138)
        elseif missionStatus == 6 then
            player:startEvent(143) -- Mission's over - Bad end (ish anyway, you lost the orbs)
        elseif missionStatus == 5 then
            player:startEvent(145) -- Mission's over - Good end (you came back with the orbs)
        end

        -- WINDURST 8-2: THE JESTER WHO'D BE KING
    elseif player:getCurrentMission(WINDURST) == xi.mission.id.windurst.THE_JESTER_WHO_D_BE_KING then
        if missionStatus == 0 then
            player:startEvent(588)
        elseif missionStatus == 2 then
            player:startEvent(601)
        elseif missionStatus == 6 then
            player:startEvent(590)
        elseif missionStatus == 7 then
            player:startEvent(589)
        elseif missionStatus == 8 then
            player:startEvent(592)
        elseif missionStatus == 10 then
            player:startEvent(609)
        end

        -- WINDURST 9-1: DOLL OF THE DEAD
    elseif player:getCurrentMission(WINDURST) == xi.mission.id.windurst.DOLL_OF_THE_DEAD then
        if missionStatus == 0 then
            player:startEvent(619)
        elseif missionStatus == 3 then
            player:startEvent(620)
        elseif missionStatus == 6 then
            player:startEvent(621)
        end

        -- THE KIND CARDIAN
    elseif kindCardian == QUEST_ACCEPTED then
        if kindCardianCS == 0 then
            player:startEvent(392)
        elseif kindCardianCS == 1 then
            player:startEvent(393)
        elseif kindCardianCS == 2 then
            player:startEvent(398)
        end

        -- CAN CARDIANS CRY?
    elseif allNewC3000 == QUEST_COMPLETED and canCardiansCry == QUEST_AVAILABLE and player:getFameLevel(WINDURST) >= 5 then
        player:startEvent(319, 0, 20000) -- start quest
    elseif canCardiansCry == QUEST_ACCEPTED then
        player:startEvent(320, 0, 20000) -- reminder
    elseif canCardiansCry == QUEST_COMPLETED then
        player:startEvent(330) -- new standard dialog

        -- TRUST
    elseif player:hasKeyItem(xi.ki.WINDURST_TRUST_PERMIT) and not player:hasSpell(904) then
        player:startEvent(866, 0, 0, 0, TrustMemory(player), 0, 0, 0, Rank6)

        -- STANDARD DIALOG
    else
        player:startEvent(274)
    end
end

entity.onEventUpdate = function(player, csid, option)
end

entity.onEventFinish = function(player, csid, option)

    -- WINDURST 1-2: THE HEART OF THE MATTER
    if csid == 137 then
        player:setMissionStatus(player:getNation(), 1)

        npcUtil.giveKeyItem(player, {
            xi.ki.FIRST_DARK_MANA_ORB,
            xi.ki.SECOND_DARK_MANA_ORB,
            xi.ki.THIRD_DARK_MANA_ORB,
            xi.ki.FOURTH_DARK_MANA_ORB,
            xi.ki.FIFTH_DARK_MANA_ORB,
            xi.ki.SIXTH_DARK_MANA_ORB
        })

        player:setCharVar("MissionStatus_orb1", 1) -- Set the orb variables: 1 = not handled, 2 = handled
        player:setCharVar("MissionStatus_orb2", 1)
        player:setCharVar("MissionStatus_orb3", 1)
        player:setCharVar("MissionStatus_orb4", 1)
        player:setCharVar("MissionStatus_orb5", 1)
        player:setCharVar("MissionStatus_orb6", 1)
    elseif csid == 143 or csid == 145 then
        finishMissionTimeline(player, 1, csid, option)

        player:setCharVar("MissionStatus_orb1", 0)
        player:setCharVar("MissionStatus_orb2", 0)
        player:setCharVar("MissionStatus_orb3", 0)
        player:setCharVar("MissionStatus_orb4", 0)
        player:setCharVar("MissionStatus_orb5", 0)
        player:setCharVar("MissionStatus_orb6", 0)

        player:delKeyItem(xi.ki.FIRST_GLOWING_MANA_ORB) -- Remove the glowing orb key items
        player:delKeyItem(xi.ki.SECOND_GLOWING_MANA_ORB)
        player:delKeyItem(xi.ki.THIRD_GLOWING_MANA_ORB)
        player:delKeyItem(xi.ki.FOURTH_GLOWING_MANA_ORB)
        player:delKeyItem(xi.ki.FIFTH_GLOWING_MANA_ORB)
        player:delKeyItem(xi.ki.SIXTH_GLOWING_MANA_ORB)

        -- WINDURST 8-2: THE JESTER WHO'D BE KING
    elseif csid == 588 then
        player:setMissionStatus(player:getNation(), 1)
        npcUtil.giveKeyItem(player, xi.ki.MANUSTERY_RING)
    elseif csid == 601 then
        player:setMissionStatus(player:getNation(), 3)
    elseif csid == 590 then
        player:setMissionStatus(player:getNation(), 7)
    elseif csid == 592 then
        player:setMissionStatus(player:getNation(), 9)
    elseif csid == 609 then
        player:setCharVar("ShantottoCS", 1)
        finishMissionTimeline(player, 3, csid, option)

        -- WINDURST 9-1: DOLL OF THE DEAD
    elseif csid == 619 then
        player:setMissionStatus(player:getNation(), 1)
    elseif csid == 620 then
        player:setMissionStatus(player:getNation(), 4)
    elseif csid == 621 then
        player:setMissionStatus(player:getNation(), 7)
        player:messageSpecial(ID.text.KEYITEM_LOST, xi.ki.LETTER_FROM_ZONPAZIPPA)
        player:delKeyItem(xi.ki.LETTER_FROM_ZONPAZIPPA)

        -- THE KIND CARDIAN
    elseif csid == 392 and option == 1 then
        player:setCharVar("theKindCardianVar", 1)
    elseif csid == 397 then
        player:delKeyItem(xi.ki.TWO_OF_SWORDS)
        player:setCharVar("theKindCardianVar", 2)
        player:addFame(WINDURST, 30)
        player:confirmTrade()

        -- CAN CARDIANS CRY?
    elseif csid == 319 then
        player:addQuest(xi.quest.log_id.WINDURST, xi.quest.id.windurst.CAN_CARDIANS_CRY)
    elseif csid == 325 and npcUtil.completeQuest(player, WINDURST, xi.quest.id.windurst.CAN_CARDIANS_CRY, {
        gil = 5000
    }) then
        player:confirmTrade()

        -- TRUST
    elseif csid == 866 and option == 2 then
        player:addSpell(904, true, true)
        player:messageSpecial(ID.text.YOU_LEARNED_TRUST, 0, 904)
    end
end

return entity
