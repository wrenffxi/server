-----------------------------------
-- Gravitic Horn
-- Family: Antlion (Only used by Formiceros subspecies)
-- Description: Heavy wind, Throat Stab-like damage in a fan-shaped area of effect. Resets enmity.
-- Type: Magical
-- Can be dispelled: N/A
-- Utsusemi/Blink absorb: Ignores shadows
-- Range: Conal AoE
-- Notes: If Orcus uses this, it gains an aura which inflicts Weight & Defense Down to targets in range.
-- Shell lowers the damage of this, and items like Jelly Ring can get you killed.
-----------------------------------
require("scripts/globals/monstertpmoves")
require("scripts/globals/settings")
require("scripts/globals/status")
require("scripts/globals/magic")
-----------------------------------
local mobskill_object = {}

mobskill_object.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskill_object.onMobWeaponSkill = function(target, mob, skill)
    local currentHP = target:getHP()
    -- remove all by 5%
    local damage = 0

    -- estimation based on "Throat Stab-like damage"
    if (currentHP / target:getMaxHP() > 0.2) then
        baseDamage = currentHP * .95
    else
        baseDamage = currentHP
    end

    -- Because shell matters, but we don't want to calculate damage normally via MobMagicalMove since this is a % attack
    local damage = baseDamage * getElementalDamageReduction(target, xi.magic.ele.WIND)
    -- we still need final adjustments to handle stoneskin etc though
    damage = MobFinalAdjustments(damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.WIND, MOBPARAM_WIPE_SHADOWS)

    target:takeDamage(finalDamage, mob, xi.attackType.MAGICAL, xi.damageType.WIND)
    mob:resetEnmity(target)
    return finalDamage
end

return mobskill_object
