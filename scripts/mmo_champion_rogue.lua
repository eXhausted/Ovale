local OVALE, Ovale = ...
local OvaleScripts = Ovale.OvaleScripts

do
	local name = "MMO-Champion: Rogue"
	local desc = "[6.0.3] MMO-Champion: Combat"
	local code = [[
# Based on APL from "Simulationcraft results for WoD" thread (last update 2014-12-02).
# http://www.mmo-champion.com/threads/1601753-Simulationcraft-results-for-WoD
#	class=rogue
#	spec=combat
#    talents=3111123
#    glyphs=energy/disappearance

Include(ovale_common)
Include(ovale_rogue_spells)

AddCheckBox(opt_potion_agility ItemName(draenic_agility_potion) default)
AddCheckBox(opt_blade_flurry SpellName(blade_flurry) default)

AddFunction UsePotionAgility
{
	if CheckBoxOn(opt_potion_agility) and target.Classification(worldboss) Item(draenic_agility_potion usable=1)
}

AddFunction UseItemActions
{
	Item(HandSlot usable=1)
	Item(Trinket0Slot usable=1)
	Item(Trinket1Slot usable=1)
}

AddFunction GetInMeleeRange
{
	if not target.InRange(kick)
	{
		Spell(shadowstep)
		Texture(misc_arrowlup help=L(not_in_melee_range))
	}
}

AddFunction InterruptActions
{
	if not target.IsFriend() and target.IsInterruptible()
	{
		if target.InRange(kick) Spell(kick)
		if not target.Classification(worldboss)
		{
			if target.InRange(cheap_shot) Spell(cheap_shot)
			if target.InRange(deadly_throw) and ComboPoints() == 5 Spell(deadly_throw)
			if target.InRange(kidney_shot) Spell(kidney_shot)
			Spell(arcane_torrent_energy)
			if target.InRange(quaking_palm) Spell(quaking_palm)
		}
	}
}

# ActionList: CombatDefaultActions --> main, shortcd, cd

AddFunction CombatDefaultActions
{
	#ambush
	Spell(ambush)
	#slice_and_dice,if=buff.slice_and_dice.remains<2|(target.time_to_die>45&combo_points=5&buff.slice_and_dice.remains<10.8)
	if { BuffRemaining(slice_and_dice_buff) < 2 or target.TimeToDie() > 45 and ComboPoints() == 5 and BuffRemaining(slice_and_dice_buff) < 10.8 } and BuffRemaining(slice_and_dice_buff) < BaseDuration(slice_and_dice_buff) Spell(slice_and_dice)
	#call_action_list,name=generator,if=combo_points<5|!dot.revealing_strike.ticking|(talent.anticipation.enabled&anticipation_charges<=4&buff.deep_insight.down)
	if ComboPoints() < 5 or not target.DebuffPresent(revealing_strike_debuff) or Talent(anticipation_talent) and BuffStacks(anticipation_buff) <= 4 and BuffExpires(deep_insight_buff) CombatGeneratorActions()
	#call_action_list,name=finisher,if=combo_points=5&dot.revealing_strike.ticking&(buff.deep_insight.up|!talent.anticipation.enabled|(talent.anticipation.enabled&anticipation_charges>=4))
	if ComboPoints() == 5 and target.DebuffPresent(revealing_strike_debuff) and { BuffPresent(deep_insight_buff) or not Talent(anticipation_talent) or Talent(anticipation_talent) and BuffStacks(anticipation_buff) >= 4 } CombatFinisherActions()
}

AddFunction CombatDefaultShortCdActions
{
	# CHANGE: Get within melee range of the target.
	GetInMeleeRange()
	#blade_flurry,if=(active_enemies>=2&!buff.blade_flurry.up)|(active_enemies<2&buff.blade_flurry.up)
	if { Enemies() >= 2 and not BuffPresent(blade_flurry_buff) or Enemies() < 2 and BuffPresent(blade_flurry_buff) } and CheckBoxOn(opt_blade_flurry) Spell(blade_flurry)

	unless Spell(ambush)
	{
		#vanish,if=time>10&(combo_points<=3|(talent.anticipation.enabled&anticipation_charges<3)|(combo_points<4|(talent.anticipation.enabled&anticipation_charges<4)))&((talent.shadow_focus.enabled&buff.adrenaline_rush.down&energy<60)|(talent.subterfuge.enabled&energy>=90)|(!talent.shadow_focus.enabled&!talent.subterfuge.enabled&energy>=60))
		if TimeInCombat() > 10 and { ComboPoints() <= 3 or Talent(anticipation_talent) and BuffStacks(anticipation_buff) < 3 or ComboPoints() < 4 or Talent(anticipation_talent) and BuffStacks(anticipation_buff) < 4 } and { Talent(shadow_focus_talent) and BuffExpires(adrenaline_rush_buff) and Energy() < 60 or Talent(subterfuge_talent) and Energy() >= 90 or not Talent(shadow_focus_talent) and not Talent(subterfuge_talent) and Energy() >= 60 } Spell(vanish)

		unless { BuffRemaining(slice_and_dice_buff) < 2 or target.TimeToDie() > 45 and ComboPoints() == 5 and BuffRemaining(slice_and_dice_buff) < 10.8 } and BuffRemaining(slice_and_dice_buff) < BaseDuration(slice_and_dice_buff) and Spell(slice_and_dice)
		{
			#marked_for_death,if=combo_points<=1&dot.revealing_strike.ticking&(!talent.shadow_reflection.enabled|buff.shadow_reflection.up|cooldown.shadow_reflection.remains>30)
			if ComboPoints() <= 1 and target.DebuffPresent(revealing_strike_debuff) and { not Talent(shadow_reflection_talent) or BuffPresent(shadow_reflection_buff) or SpellCooldown(shadow_reflection) > 30 } Spell(marked_for_death)
		}
	}
}

AddFunction CombatDefaultCdActions
{
	#potion,name=draenic_agility,if=buff.bloodlust.react|target.time_to_die<40|(buff.adrenaline_rush.up&buff.archmages_greater_incandescence_agi.up)
	if BuffPresent(burst_haste_buff any=1) or target.TimeToDie() < 40 or BuffPresent(adrenaline_rush_buff) and BuffPresent(archmages_greater_incandescence_agi_buff) UsePotionAgility()
	#kick
	InterruptActions()
	#preparation,if=!buff.vanish.up&cooldown.vanish.remains>30
	if not BuffPresent(vanish_buff) and SpellCooldown(vanish) > 30 Spell(preparation)
	#use_item,slot=trinket2
	UseItemActions()
	#blood_fury
	Spell(blood_fury_ap)
	#berserking
	Spell(berserking)
	#arcane_torrent,if=energy<60
	if Energy() < 60 Spell(arcane_torrent_energy)

	unless Enemies() >= 2 and not BuffPresent(blade_flurry_buff) or Enemies() < 2 and BuffPresent(blade_flurry_buff) and Spell(blade_flurry)
	{
		#shadow_reflection,if=(cooldown.killing_spree.remains<10&combo_points>3)|buff.adrenaline_rush.up
		if SpellCooldown(killing_spree) < 10 and ComboPoints() > 3 or BuffPresent(adrenaline_rush_buff) Spell(shadow_reflection)

		unless Spell(ambush)
			or { BuffRemaining(slice_and_dice_buff) < 2 or target.TimeToDie() > 45 and ComboPoints() == 5 and BuffRemaining(slice_and_dice_buff) < 10.8 } and BuffRemaining(slice_and_dice_buff) < BaseDuration(slice_and_dice_buff) and Spell(slice_and_dice)
		{
			#killing_spree,if=(energy<40|(buff.bloodlust.up&time<10)|buff.bloodlust.remains>20)&buff.adrenaline_rush.down&(!talent.shadow_reflection.enabled|cooldown.shadow_reflection.remains>30|buff.shadow_reflection.remains>3)&!time_to_die<44|(time_to_die<44&(buff.archmages_greater_incandescence_agi.remains>3|buff.deep_insight.remains>3|buff.detonation.remains>3|time_to_die<4))
			if { Energy() < 40 or BuffPresent(burst_haste_buff any=1) and TimeInCombat() < 10 or BuffRemaining(burst_haste_buff any=1) > 20 } and BuffExpires(adrenaline_rush_buff) and { not Talent(shadow_reflection_talent) or SpellCooldown(shadow_reflection) > 30 or BuffRemaining(shadow_reflection_buff) > 3 } and not TimeToDie() < 44 or TimeToDie() < 44 and { BuffRemaining(archmages_greater_incandescence_agi_buff) > 3 or BuffRemaining(deep_insight_buff) > 3 or BuffRemaining(detonation_buff) > 3 or TimeToDie() < 4 } Spell(killing_spree)
			#adrenaline_rush,if=(energy<35|buff.bloodlust.up)&cooldown.killing_spree.remains>10&!time_to_die<44|(time_to_die<44&(buff.archmages_greater_incandescence_agi.remains>buff.archmages_greater_incandescence_agi.duration*0.8|buff.deep_insight.remains>buff.deep_insight.duration*0.8|buff.detonation.remains>buff.detonation.duration*0.8|time_to_die<4))
			if { Energy() < 35 or BuffPresent(burst_haste_buff any=1) } and SpellCooldown(killing_spree) > 10 and not TimeToDie() < 44 or TimeToDie() < 44 and { BuffRemaining(archmages_greater_incandescence_agi_buff) > BaseDuration(archmages_greater_incandescence_agi_buff) * 0.8 or BuffRemaining(deep_insight_buff) > BaseDuration(deep_insight_buff) * 0.8 or BuffRemaining(detonation_buff) > BaseDuration(detonation_buff) * 0.8 or TimeToDie() < 4 } Spell(adrenaline_rush)
		}
	}
}

# ActionList: CombatFinisherActions --> main

AddFunction CombatFinisherActions
{
	#pool_resource,for_next=1
	#death_from_above
	Spell(death_from_above)
	unless SpellUsable(death_from_above) and SpellCooldown(death_from_above) < TimeToEnergyFor(death_from_above)
	{
		#crimson_tempest,if=active_enemies>6&remains<2
		if Enemies() > 6 and target.DebuffRemaining(crimson_tempest_debuff) < 2 Spell(crimson_tempest)
		#crimson_tempest,if=active_enemies>8
		if Enemies() > 8 Spell(crimson_tempest)
		#eviscerate
		Spell(eviscerate)
	}
}

# ActionList: CombatGeneratorActions --> main

AddFunction CombatGeneratorActions
{
	#revealing_strike,if=(combo_points=4&dot.revealing_strike.remains<7.2&(target.time_to_die>dot.revealing_strike.remains+7.2)|(target.time_to_die<dot.revealing_strike.remains+7.2&ticks_remain<2))|!ticking
	if ComboPoints() == 4 and target.DebuffRemaining(revealing_strike_debuff) < 7.2 and target.TimeToDie() > target.DebuffRemaining(revealing_strike_debuff) + 7.2 or target.TimeToDie() < target.DebuffRemaining(revealing_strike_debuff) + 7.2 and target.TicksRemaining(revealing_strike_debuff) < 2 or not target.DebuffPresent(revealing_strike_debuff) Spell(revealing_strike)
	#sinister_strike,if=dot.revealing_strike.ticking
	if target.DebuffPresent(revealing_strike_debuff) Spell(sinister_strike)
}

# ActionList: CombatPrecombatActions --> main, shortcd, cd

AddFunction CombatPrecombatActions
{
	#flask,type=greater_draenic_agility_flask
	#food,type=frosty_stew
	#apply_poison,lethal=deadly
	if BuffRemaining(lethal_poison_buff) < 1200 Spell(deadly_poison)
	#snapshot_stats
	#stealth
	if BuffExpires(stealthed_buff any=1) Spell(stealth)
	#slice_and_dice,if=talent.marked_for_death.enabled
	if Talent(marked_for_death_talent) and BuffRemaining(slice_and_dice_buff) < BaseDuration(slice_and_dice_buff) Spell(slice_and_dice)
}

AddFunction CombatPrecombatShortCdActions
{
	unless BuffRemaining(lethal_poison_buff) < 1200 and Spell(deadly_poison)
		or BuffExpires(stealthed_buff any=1) and Spell(stealth)
	{
		#marked_for_death
		Spell(marked_for_death)
	}
}

AddFunction CombatPrecombatCdActions
{
	unless BuffRemaining(lethal_poison_buff) < 1200 and Spell(deadly_poison)
	{
		#potion,name=draenic_agility
		UsePotionAgility()
	}
}

### Combat icons.
AddCheckBox(opt_rogue_combat_aoe L(AOE) specialization=combat default)

AddIcon specialization=combat help=shortcd enemies=1 checkbox=!opt_rogue_combat_aoe
{
	if InCombat(no) CombatPrecombatShortCdActions()
	CombatDefaultShortCdActions()
}

AddIcon specialization=combat help=shortcd checkbox=opt_rogue_combat_aoe
{
	if InCombat(no) CombatPrecombatShortCdActions()
	CombatDefaultShortCdActions()
}

AddIcon specialization=combat help=main enemies=1
{
	if InCombat(no) CombatPrecombatActions()
	CombatDefaultActions()
}

AddIcon specialization=combat help=aoe checkbox=opt_rogue_combat_aoe
{
	if InCombat(no) CombatPrecombatActions()
	CombatDefaultActions()
}

AddIcon specialization=combat help=cd enemies=1 checkbox=!opt_rogue_combat_aoe
{
	if InCombat(no) CombatPrecombatCdActions()
	CombatDefaultCdActions()
}

AddIcon specialization=combat help=cd checkbox=opt_rogue_combat_aoe
{
	if InCombat(no) CombatPrecombatCdActions()
	CombatDefaultCdActions()
}
]]
	OvaleScripts:RegisterScript("ROGUE", name, desc, code, "script")
end
