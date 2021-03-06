local OVALE, Ovale = ...
local OvaleScripts = Ovale.OvaleScripts

-- THE REST OF THIS FILE IS AUTOMATICALLY GENERATED.
-- ANY CHANGES MADE BELOW THIS POINT WILL BE LOST.

do
	local name = "simulationcraft_rogue_assassination_t18m"
	local desc = "[7.0] SimulationCraft: Rogue_Assassination_T18M"
	local code = [[
# Based on SimulationCraft profile "Rogue_Assassination_T18M".
#	class=rogue
#	spec=assassination
#	talents=3110131

Include(ovale_common)
Include(ovale_trinkets_mop)
Include(ovale_trinkets_wod)
Include(ovale_rogue_spells)

AddCheckBox(opt_melee_range L(not_in_melee_range) specialization=assassination)
AddCheckBox(opt_potion_agility ItemName(draenic_agility_potion) default specialization=assassination)
AddCheckBox(opt_legendary_ring_agility ItemName(legendary_ring_agility) default specialization=assassination)
AddCheckBox(opt_vanish SpellName(vanish) default specialization=assassination)

AddFunction AssassinationUsePotionAgility
{
	if CheckBoxOn(opt_potion_agility) and target.Classification(worldboss) Item(draenic_agility_potion usable=1)
}

### actions.default

AddFunction AssassinationDefaultMainActions
{
	#rupture,if=combo_points>=2&!ticking&time<10&!artifact.urge_to_kill.enabled
	if ComboPoints() >= 2 and not target.DebuffPresent(rupture_debuff) and TimeInCombat() < 10 and not BuffPresent(urge_to_kill_buff) Spell(rupture)
	#rupture,if=combo_points>=4&!ticking
	if ComboPoints() >= 4 and not target.DebuffPresent(rupture_debuff) Spell(rupture)
	#kingsbane,if=buff.vendetta.up|cooldown.vendetta.remains>30
	if DebuffPresent(vendetta_debuff) or SpellCooldown(vendetta) > 30 Spell(kingsbane)
	#run_action_list,name=exsang_combo,if=cooldown.exsanguinate.up&(buff.maalus.up|cooldown.vanish.remains>35)
	if not SpellCooldown(exsanguinate) > 0 and { BuffPresent(maalus_buff) or SpellCooldown(vanish) > 35 } AssassinationExsangComboMainActions()
	#call_action_list,name=garrote
	AssassinationGarroteMainActions()
	#rupture,if=combo_points>=5&cooldown.exsanguinate.remains<8&dot.rupture.remains<14
	if ComboPoints() >= 5 and SpellCooldown(exsanguinate) < 8 and target.DebuffRemaining(rupture_debuff) < 14 Spell(rupture)
	#call_action_list,name=exsang,if=dot.rupture.exsanguinated&spell_targets.fan_of_knives<=1
	if target.DebuffRemaining(rupture_debuff_exsanguinated) and Enemies() <= 1 AssassinationExsangMainActions()
	#call_action_list,name=finish
	AssassinationFinishMainActions()
	#call_action_list,name=build
	AssassinationBuildMainActions()
}

AddFunction AssassinationDefaultShortCdActions
{
	#call_action_list,name=cds
	AssassinationCdsShortCdActions()

	unless ComboPoints() >= 2 and not target.DebuffPresent(rupture_debuff) and TimeInCombat() < 10 and not BuffPresent(urge_to_kill_buff) and Spell(rupture) or ComboPoints() >= 4 and not target.DebuffPresent(rupture_debuff) and Spell(rupture) or { DebuffPresent(vendetta_debuff) or SpellCooldown(vendetta) > 30 } and Spell(kingsbane)
	{
		#run_action_list,name=exsang_combo,if=cooldown.exsanguinate.up&(buff.maalus.up|cooldown.vanish.remains>35)
		if not SpellCooldown(exsanguinate) > 0 and { BuffPresent(maalus_buff) or SpellCooldown(vanish) > 35 } AssassinationExsangComboShortCdActions()
	}
}

AddFunction AssassinationDefaultCdActions
{
	#potion,name=draenic_agility,if=buff.bloodlust.react|target.time_to_die<=25|debuff.vendetta.up
	if BuffPresent(burst_haste_buff any=1) or target.TimeToDie() <= 25 or target.DebuffPresent(vendetta_debuff) AssassinationUsePotionAgility()
	#use_item,slot=finger1
	if CheckBoxOn(opt_legendary_ring_agility) Item(legendary_ring_agility usable=1)
	#blood_fury,if=debuff.vendetta.up
	if target.DebuffPresent(vendetta_debuff) Spell(blood_fury_ap)
	#berserking,if=debuff.vendetta.up
	if target.DebuffPresent(vendetta_debuff) Spell(berserking)
	#arcane_torrent,if=debuff.vendetta.up&energy.deficit>50&!dot.rupture.exsanguinated&(cooldown.exsanguinate.remains>3|!artifact.urge_to_kill.enabled)
	if target.DebuffPresent(vendetta_debuff) and EnergyDeficit() > 50 and not target.DebuffRemaining(rupture_debuff_exsanguinated) and { SpellCooldown(exsanguinate) > 3 or not BuffPresent(urge_to_kill_buff) } Spell(arcane_torrent_energy)
	#call_action_list,name=cds
	AssassinationCdsCdActions()
}

### actions.build

AddFunction AssassinationBuildMainActions
{
	#mutilate,target_if=min:dot.deadly_poison_dot.remains,if=combo_points.deficit>=2&dot.rupture.exsanguinated&spell_targets.fan_of_knives>1
	if ComboPointsDeficit() >= 2 and target.DebuffRemaining(rupture_debuff_exsanguinated) and Enemies() > 1 Spell(mutilate)
	#mutilate,target_if=max:bleeds,if=combo_points.deficit>=2&spell_targets.fan_of_knives=2&dot.deadly_poison_dot.refreshable&debuff.agonizing_poison.remains<=0.3*debuff.agonizing_poison.duration
	if ComboPointsDeficit() >= 2 and Enemies() == 2 and target.DebuffPresent(deadly_poison_dot_debuff) and target.DebuffRemaining(agonizing_poison_debuff) <= 0.3 * BaseDuration(agonizing_poison_debuff) Spell(mutilate)
	#hemorrhage,target_if=max:target.time_to_die,if=combo_points.deficit>=1&!ticking&dot.rupture.remains>6&spell_targets.fan_of_knives>1
	if ComboPointsDeficit() >= 1 and not target.DebuffPresent(hemorrhage_debuff) and target.DebuffRemaining(rupture_debuff) > 6 and Enemies() > 1 Spell(hemorrhage)
	#fan_of_knives,if=combo_points.deficit>=1&(spell_targets>3|(poisoned_enemies<3&spell_targets>2))&spell_targets.fan_of_knives>1
	if ComboPointsDeficit() >= 1 and { Enemies() > 3 or 0 < 3 and Enemies() > 2 } and Enemies() > 1 Spell(fan_of_knives)
	#hemorrhage,if=(combo_points.deficit>=1&refreshable)|(combo_points.deficit=1&dot.rupture.refreshable)
	if ComboPointsDeficit() >= 1 and target.Refreshable(hemorrhage_debuff) or ComboPointsDeficit() == 1 and target.DebuffPresent(rupture_debuff) Spell(hemorrhage)
	#hemorrhage,if=combo_points.deficit=2&set_bonus.tier18_2pc&target.health.pct<=35
	if ComboPointsDeficit() == 2 and ArmorSetBonus(T18 2) and target.HealthPercent() <= 35 Spell(hemorrhage)
	#mutilate,if=cooldown.garrote.remains>2&(combo_points.deficit>=3|(combo_points.deficit>=2&!(set_bonus.tier18_2pc&target.health.pct<=35)))
	if SpellCooldown(garrote) > 2 and { ComboPointsDeficit() >= 3 or ComboPointsDeficit() >= 2 and not { ArmorSetBonus(T18 2) and target.HealthPercent() <= 35 } } Spell(mutilate)
}

### actions.cds

AddFunction AssassinationCdsShortCdActions
{
	#marked_for_death,cycle_targets=1,target_if=min:target.time_to_die,if=combo_points.deficit>=5
	if ComboPointsDeficit() >= 5 Spell(marked_for_death)
	#vanish,if=talent.subterfuge.enabled&combo_points<=2&!dot.rupture.exsanguinated
	if Talent(subterfuge_talent) and ComboPoints() <= 2 and not target.DebuffRemaining(rupture_debuff_exsanguinated) and CheckBoxOn(opt_vanish) Spell(vanish)
	#vanish,if=talent.shadow_focus.enabled&!dot.rupture.exsanguinated&combo_points.deficit>=2
	if Talent(shadow_focus_talent) and not target.DebuffRemaining(rupture_debuff_exsanguinated) and ComboPointsDeficit() >= 2 and CheckBoxOn(opt_vanish) Spell(vanish)
}

AddFunction AssassinationCdsCdActions
{
	#vendetta,if=target.time_to_die<20|buff.maalus.react
	if target.TimeToDie() < 20 or BuffPresent(maalus_buff) Spell(vendetta)
}

### actions.exsang

AddFunction AssassinationExsangMainActions
{
	#rupture,if=combo_points>=cp_max_spend&ticks_remain<2
	if ComboPoints() >= MaxComboPoints() and target.TicksRemaining(rupture_debuff) < 2 Spell(rupture)
	#death_from_above,if=combo_points>=cp_max_spend-1&dot.rupture.remains>3
	if ComboPoints() >= MaxComboPoints() - 1 and target.DebuffRemaining(rupture_debuff) > 3 Spell(death_from_above)
	#envenom,if=combo_points>=cp_max_spend-1&dot.rupture.remains>3
	if ComboPoints() >= MaxComboPoints() - 1 and target.DebuffRemaining(rupture_debuff) > 3 Spell(envenom)
	#hemorrhage,if=combo_points.deficit<=1
	if ComboPointsDeficit() <= 1 Spell(hemorrhage)
	#hemorrhage,if=combo_points.deficit>=1&debuff.hemorrhage.remains<1
	if ComboPointsDeficit() >= 1 and target.DebuffRemaining(hemorrhage_debuff) < 1 Spell(hemorrhage)
	#pool_resource,for_next=1
	#mutilate,if=combo_points.deficit>=2
	if ComboPointsDeficit() >= 2 Spell(mutilate)
}

### actions.exsang_combo

AddFunction AssassinationExsangComboMainActions
{
	#rupture,if=combo_points>=cp_max_spend&(buff.vanish.up|cooldown.vanish.remains>15)&cooldown.exsanguinate.remains<1
	if ComboPoints() >= MaxComboPoints() and { BuffPresent(vanish_buff) or SpellCooldown(vanish) > 15 } and SpellCooldown(exsanguinate) < 1 Spell(rupture)
	#call_action_list,name=garrote
	AssassinationGarroteMainActions()
	#hemorrhage,if=combo_points.deficit=1
	if ComboPointsDeficit() == 1 Spell(hemorrhage)
	#mutilate,if=combo_points.deficit<=1
	if ComboPointsDeficit() <= 1 Spell(mutilate)
	#call_action_list,name=build
	AssassinationBuildMainActions()
}

AddFunction AssassinationExsangComboShortCdActions
{
	#vanish,if=talent.nightstalker.enabled&combo_points>=cp_max_spend&cooldown.exsanguinate.remains<1&gcd.remains=0&energy>=25
	if Talent(nightstalker_talent) and ComboPoints() >= MaxComboPoints() and SpellCooldown(exsanguinate) < 1 and not GCDRemaining() > 0 and Energy() >= 25 and CheckBoxOn(opt_vanish) Spell(vanish)

	unless ComboPoints() >= MaxComboPoints() and { BuffPresent(vanish_buff) or SpellCooldown(vanish) > 15 } and SpellCooldown(exsanguinate) < 1 and Spell(rupture)
	{
		#exsanguinate,if=prev_gcd.rupture&dot.rupture.remains>25+4*talent.deeper_stratagem.enabled&cooldown.vanish.remains>10
		if PreviousGCDSpell(rupture) and target.DebuffRemaining(rupture_debuff) > 25 + 4 * TalentPoints(deeper_stratagem_talent) and SpellCooldown(vanish) > 10 Spell(exsanguinate)
	}
}

### actions.finish

AddFunction AssassinationFinishMainActions
{
	#rupture,target_if=max:target.time_to_die,if=!ticking&combo_points>=5&spell_targets.fan_of_knives>1
	if not target.DebuffPresent(rupture_debuff) and ComboPoints() >= 5 and Enemies() > 1 Spell(rupture)
	#rupture,if=combo_points>=cp_max_spend&refreshable&!exsanguinated
	if ComboPoints() >= MaxComboPoints() and target.Refreshable(rupture_debuff) and not target.DebuffPresent(exsanguinated) Spell(rupture)
	#death_from_above,if=combo_points>=cp_max_spend-1
	if ComboPoints() >= MaxComboPoints() - 1 Spell(death_from_above)
	#envenom,if=combo_points>=cp_max_spend-1&!dot.rupture.refreshable&buff.elaborate_planning.remains<2&energy.deficit<40
	if ComboPoints() >= MaxComboPoints() - 1 and not target.DebuffPresent(rupture_debuff) and BuffRemaining(elaborate_planning_buff) < 2 and EnergyDeficit() < 40 Spell(envenom)
	#envenom,if=combo_points>=cp_max_spend&!dot.rupture.refreshable&buff.elaborate_planning.remains<2&cooldown.garrote.remains<1
	if ComboPoints() >= MaxComboPoints() and not target.DebuffPresent(rupture_debuff) and BuffRemaining(elaborate_planning_buff) < 2 and SpellCooldown(garrote) < 1 Spell(envenom)
}

### actions.garrote

AddFunction AssassinationGarroteMainActions
{
	#pool_resource,for_next=1
	#garrote,cycle_targets=1,target_if=max:target.time_to_die,if=talent.subterfuge.enabled&!ticking&combo_points.deficit>=1
	if Talent(subterfuge_talent) and not target.DebuffPresent(garrote_debuff) and ComboPointsDeficit() >= 1 Spell(garrote)
	unless Talent(subterfuge_talent) and not target.DebuffPresent(garrote_debuff) and ComboPointsDeficit() >= 1 and SpellUsable(garrote) and SpellCooldown(garrote) < TimeToEnergyFor(garrote)
	{
		#pool_resource,for_next=1
		#garrote,if=combo_points.deficit>=1&!exsanguinated
		if ComboPointsDeficit() >= 1 and not target.DebuffPresent(exsanguinated) Spell(garrote)
	}
}

### actions.precombat

AddFunction AssassinationPrecombatMainActions
{
	#flask,type=greater_draenic_agility_flask
	#augmentation,type=hyper
	Spell(augmentation)
	#food,type=jumbo_sea_dog
	#snapshot_stats
	#apply_poison,lethal=deadly
	if BuffRemaining(lethal_poison_buff) < 1200 Spell(deadly_poison)
	#stealth
	Spell(stealth)
}

AddFunction AssassinationPrecombatShortCdActions
{
	unless Spell(augmentation) or BuffRemaining(lethal_poison_buff) < 1200 and Spell(deadly_poison) or Spell(stealth)
	{
		#marked_for_death
		Spell(marked_for_death)
	}
}

AddFunction AssassinationPrecombatShortCdPostConditions
{
	Spell(augmentation) or BuffRemaining(lethal_poison_buff) < 1200 and Spell(deadly_poison) or Spell(stealth)
}

AddFunction AssassinationPrecombatCdActions
{
	unless Spell(augmentation) or BuffRemaining(lethal_poison_buff) < 1200 and Spell(deadly_poison) or Spell(stealth)
	{
		#potion,name=draenic_agility
		AssassinationUsePotionAgility()
	}
}

AddFunction AssassinationPrecombatCdPostConditions
{
	Spell(augmentation) or BuffRemaining(lethal_poison_buff) < 1200 and Spell(deadly_poison) or Spell(stealth)
}

### Assassination icons.

AddCheckBox(opt_rogue_assassination_aoe L(AOE) default specialization=assassination)

AddIcon checkbox=!opt_rogue_assassination_aoe enemies=1 help=shortcd specialization=assassination
{
	if not InCombat() AssassinationPrecombatShortCdActions()
	unless not InCombat() and AssassinationPrecombatShortCdPostConditions()
	{
		AssassinationDefaultShortCdActions()
	}
}

AddIcon checkbox=opt_rogue_assassination_aoe help=shortcd specialization=assassination
{
	if not InCombat() AssassinationPrecombatShortCdActions()
	unless not InCombat() and AssassinationPrecombatShortCdPostConditions()
	{
		AssassinationDefaultShortCdActions()
	}
}

AddIcon enemies=1 help=main specialization=assassination
{
	if not InCombat() AssassinationPrecombatMainActions()
	AssassinationDefaultMainActions()
}

AddIcon checkbox=opt_rogue_assassination_aoe help=aoe specialization=assassination
{
	if not InCombat() AssassinationPrecombatMainActions()
	AssassinationDefaultMainActions()
}

AddIcon checkbox=!opt_rogue_assassination_aoe enemies=1 help=cd specialization=assassination
{
	if not InCombat() AssassinationPrecombatCdActions()
	unless not InCombat() and AssassinationPrecombatCdPostConditions()
	{
		AssassinationDefaultCdActions()
	}
}

AddIcon checkbox=opt_rogue_assassination_aoe help=cd specialization=assassination
{
	if not InCombat() AssassinationPrecombatCdActions()
	unless not InCombat() and AssassinationPrecombatCdPostConditions()
	{
		AssassinationDefaultCdActions()
	}
}

### Required symbols
# agonizing_poison_debuff
# arcane_torrent_energy
# augmentation
# berserking
# blood_fury_ap
# deadly_poison
# deadly_poison_dot_debuff
# death_from_above
# deeper_stratagem_talent
# draenic_agility_potion
# elaborate_planning_buff
# envenom
# exsanguinate
# fan_of_knives
# garrote
# garrote_debuff
# hemorrhage
# hemorrhage_debuff
# kick
# kingsbane
# legendary_ring_agility
# lethal_poison_buff
# maalus_buff
# marked_for_death
# mutilate
# nightstalker_talent
# rupture
# rupture_debuff
# shadow_focus_talent
# shadowstep
# stealth
# subterfuge_talent
# urge_to_kill
# vanish
# vanish_buff
# vendetta
# vendetta_debuff
]]
	OvaleScripts:RegisterScript("ROGUE", "assassination", name, desc, code, "script")
end

do
	local name = "simulationcraft_rogue_outlaw_t18m"
	local desc = "[7.0] SimulationCraft: Rogue_Outlaw_T18M"
	local code = [[
# Based on SimulationCraft profile "Rogue_Outlaw_T18M".
#	class=rogue
#	spec=outlaw
#	talents=3010022

Include(ovale_common)
Include(ovale_trinkets_mop)
Include(ovale_trinkets_wod)
Include(ovale_rogue_spells)

AddCheckBox(opt_melee_range L(not_in_melee_range) specialization=outlaw)
AddCheckBox(opt_potion_agility ItemName(draenic_agility_potion) default specialization=outlaw)
AddCheckBox(opt_legendary_ring_agility ItemName(legendary_ring_agility) default specialization=outlaw)

AddFunction OutlawUsePotionAgility
{
	if CheckBoxOn(opt_potion_agility) and target.Classification(worldboss) Item(draenic_agility_potion usable=1)
}

### actions.default

AddFunction OutlawDefaultMainActions
{
	#pool_resource,for_next=1
	#ambush
	Spell(ambush)
	unless SpellUsable(ambush) and SpellCooldown(ambush) < TimeToEnergyFor(ambush)
	{
		#pool_resource,for_next=1,extra_amount=60
		#vanish,if=combo_points.deficit>=2&energy>60
		unless ComboPointsDeficit() >= 2 and Energy() > 60 and SpellUsable(vanish) and SpellCooldown(vanish) < TimeToEnergy(60)
		{
			#pool_resource,for_next=1,extra_amount=60
			#shadowmeld,if=combo_points.deficit>=2&energy>60
			unless ComboPointsDeficit() >= 2 and Energy() > 60 and SpellUsable(shadowmeld) and SpellCooldown(shadowmeld) < TimeToEnergy(60)
			{
				#slice_and_dice,if=combo_points>=5&buff.slice_and_dice.remains<target.time_to_die&buff.slice_and_dice.remains<6
				if ComboPoints() >= 5 and BuffRemaining(slice_and_dice_buff) < target.TimeToDie() and BuffRemaining(slice_and_dice_buff) < 6 Spell(slice_and_dice)
				#roll_the_bones,if=combo_points>=5&buff.roll_the_bones.remains<target.time_to_die&(buff.roll_the_bones.remains<3|buff.roll_the_bones.remains<duration*0.3%rtb_buffs|(!buff.shark_infested_waters.up&rtb_buffs<2))
				if ComboPoints() >= 5 and BuffRemaining(roll_the_bones_buff) < target.TimeToDie() and { BuffRemaining(roll_the_bones_buff) < 3 or BuffRemaining(roll_the_bones_buff) < BaseDuration(roll_the_bones_buff) * 0.3 / BuffCount(roll_the_bones_buff) or not BuffPresent(shark_infested_waters_buff) and BuffCount(roll_the_bones_buff) < 2 } Spell(roll_the_bones)
				#call_action_list,name=finisher,if=combo_points>=5+talent.deeper_stratagem.enabled
				if ComboPoints() >= 5 + TalentPoints(deeper_stratagem_talent) OutlawFinisherMainActions()
				#call_action_list,name=generator,if=combo_points<5+talent.deeper_stratagem.enabled
				if ComboPoints() < 5 + TalentPoints(deeper_stratagem_talent) OutlawGeneratorMainActions()
			}
		}
	}
}

AddFunction OutlawDefaultShortCdActions
{
	#blade_flurry,if=(spell_targets.blade_flurry>=2&!buff.blade_flurry.up)|(spell_targets.blade_flurry<2&buff.blade_flurry.up)
	if Enemies() >= 2 and not BuffPresent(blade_flurry_buff) or Enemies() < 2 and BuffPresent(blade_flurry_buff) Spell(blade_flurry)
	#pool_resource,for_next=1
	#ambush
	unless SpellUsable(ambush) and SpellCooldown(ambush) < TimeToEnergyFor(ambush)
	{
		#pool_resource,for_next=1,extra_amount=60
		#vanish,if=combo_points.deficit>=2&energy>60
		if ComboPointsDeficit() >= 2 and Energy() > 60 Spell(vanish)
		unless ComboPointsDeficit() >= 2 and Energy() > 60 and SpellUsable(vanish) and SpellCooldown(vanish) < TimeToEnergy(60)
		{
			#pool_resource,for_next=1,extra_amount=60
			#shadowmeld,if=combo_points.deficit>=2&energy>60
			unless ComboPointsDeficit() >= 2 and Energy() > 60 and SpellUsable(shadowmeld) and SpellCooldown(shadowmeld) < TimeToEnergy(60)
			{
				unless ComboPoints() >= 5 and BuffRemaining(slice_and_dice_buff) < target.TimeToDie() and BuffRemaining(slice_and_dice_buff) < 6 and Spell(slice_and_dice) or ComboPoints() >= 5 and BuffRemaining(roll_the_bones_buff) < target.TimeToDie() and { BuffRemaining(roll_the_bones_buff) < 3 or BuffRemaining(roll_the_bones_buff) < BaseDuration(roll_the_bones_buff) * 0.3 / BuffCount(roll_the_bones_buff) or not BuffPresent(shark_infested_waters_buff) and BuffCount(roll_the_bones_buff) < 2 } and Spell(roll_the_bones)
				{
					#cannonball_barrage,if=spell_targets.cannonball_barrage>=1
					if Enemies() >= 1 Spell(cannonball_barrage)
					#curse_of_the_dreadblades,if=combo_points.deficit>=4
					if ComboPointsDeficit() >= 4 Spell(curse_of_the_dreadblades)
					#marked_for_death,cycle_targets=1,target_if=min:target.time_to_die,if=combo_points.deficit>=4+talent.deeper_stratagem.enabled
					if ComboPointsDeficit() >= 4 + TalentPoints(deeper_stratagem_talent) Spell(marked_for_death)
				}
			}
		}
	}
}

AddFunction OutlawDefaultCdActions
{
	#potion,name=draenic_agility,if=buff.bloodlust.react|target.time_to_die<=25|buff.adrenaline_rush.up
	if BuffPresent(burst_haste_buff any=1) or target.TimeToDie() <= 25 or BuffPresent(adrenaline_rush_buff) OutlawUsePotionAgility()
	#use_item,slot=finger1
	if CheckBoxOn(opt_legendary_ring_agility) Item(legendary_ring_agility usable=1)
	#blood_fury
	Spell(blood_fury_ap)
	#berserking
	Spell(berserking)
	#arcane_torrent,if=energy.deficit>40
	if EnergyDeficit() > 40 Spell(arcane_torrent_energy)
	#adrenaline_rush,if=!buff.adrenaline_rush.up
	if not BuffPresent(adrenaline_rush_buff) Spell(adrenaline_rush)
	#pool_resource,for_next=1
	#ambush
	unless SpellUsable(ambush) and SpellCooldown(ambush) < TimeToEnergyFor(ambush)
	{
		#pool_resource,for_next=1,extra_amount=60
		#vanish,if=combo_points.deficit>=2&energy>60
		unless ComboPointsDeficit() >= 2 and Energy() > 60 and SpellUsable(vanish) and SpellCooldown(vanish) < TimeToEnergy(60)
		{
			#pool_resource,for_next=1,extra_amount=60
			#shadowmeld,if=combo_points.deficit>=2&energy>60
			if ComboPointsDeficit() >= 2 and Energy() > 60 Spell(shadowmeld)
			unless ComboPointsDeficit() >= 2 and Energy() > 60 and SpellUsable(shadowmeld) and SpellCooldown(shadowmeld) < TimeToEnergy(60)
			{
				unless ComboPoints() >= 5 and BuffRemaining(slice_and_dice_buff) < target.TimeToDie() and BuffRemaining(slice_and_dice_buff) < 6 and Spell(slice_and_dice) or ComboPoints() >= 5 and BuffRemaining(roll_the_bones_buff) < target.TimeToDie() and { BuffRemaining(roll_the_bones_buff) < 3 or BuffRemaining(roll_the_bones_buff) < BaseDuration(roll_the_bones_buff) * 0.3 / BuffCount(roll_the_bones_buff) or not BuffPresent(shark_infested_waters_buff) and BuffCount(roll_the_bones_buff) < 2 } and Spell(roll_the_bones)
				{
					#killing_spree,if=energy.time_to_max>5|energy<15
					if TimeToMaxEnergy() > 5 or Energy() < 15 Spell(killing_spree)
				}
			}
		}
	}
}

### actions.finisher

AddFunction OutlawFinisherMainActions
{
	#death_from_above
	Spell(death_from_above)
	#run_through
	Spell(run_through)
}

### actions.generator

AddFunction OutlawGeneratorMainActions
{
	#ghostly_strike,if=talent.ghostly_strike.enabled&debuff.ghostly_strike.remains<duration*0.3
	if Talent(ghostly_strike_talent) and target.DebuffRemaining(ghostly_strike_debuff) < BaseDuration(ghostly_strike_debuff) * 0.3 Spell(ghostly_strike)
	#pistol_shot,if=buff.opportunity.up&energy<60
	if BuffPresent(opportunity_buff) and Energy() < 60 Spell(pistol_shot)
	#saber_slash
	Spell(saber_slash)
}

### actions.precombat

AddFunction OutlawPrecombatMainActions
{
	#flask,type=greater_draenic_agility_flask
	#augmentation,type=hyper
	Spell(augmentation)
	#food,type=jumbo_sea_dog
	#snapshot_stats
	#stealth
	Spell(stealth)
}

AddFunction OutlawPrecombatShortCdActions
{
	unless Spell(augmentation) or Spell(stealth)
	{
		#marked_for_death
		Spell(marked_for_death)
	}
}

AddFunction OutlawPrecombatShortCdPostConditions
{
	Spell(augmentation) or Spell(stealth)
}

AddFunction OutlawPrecombatCdActions
{
	unless Spell(augmentation) or Spell(stealth)
	{
		#potion,name=draenic_agility
		OutlawUsePotionAgility()
	}
}

AddFunction OutlawPrecombatCdPostConditions
{
	Spell(augmentation) or Spell(stealth)
}

### Outlaw icons.

AddCheckBox(opt_rogue_outlaw_aoe L(AOE) default specialization=outlaw)

AddIcon checkbox=!opt_rogue_outlaw_aoe enemies=1 help=shortcd specialization=outlaw
{
	if not InCombat() OutlawPrecombatShortCdActions()
	unless not InCombat() and OutlawPrecombatShortCdPostConditions()
	{
		OutlawDefaultShortCdActions()
	}
}

AddIcon checkbox=opt_rogue_outlaw_aoe help=shortcd specialization=outlaw
{
	if not InCombat() OutlawPrecombatShortCdActions()
	unless not InCombat() and OutlawPrecombatShortCdPostConditions()
	{
		OutlawDefaultShortCdActions()
	}
}

AddIcon enemies=1 help=main specialization=outlaw
{
	if not InCombat() OutlawPrecombatMainActions()
	OutlawDefaultMainActions()
}

AddIcon checkbox=opt_rogue_outlaw_aoe help=aoe specialization=outlaw
{
	if not InCombat() OutlawPrecombatMainActions()
	OutlawDefaultMainActions()
}

AddIcon checkbox=!opt_rogue_outlaw_aoe enemies=1 help=cd specialization=outlaw
{
	if not InCombat() OutlawPrecombatCdActions()
	unless not InCombat() and OutlawPrecombatCdPostConditions()
	{
		OutlawDefaultCdActions()
	}
}

AddIcon checkbox=opt_rogue_outlaw_aoe help=cd specialization=outlaw
{
	if not InCombat() OutlawPrecombatCdActions()
	unless not InCombat() and OutlawPrecombatCdPostConditions()
	{
		OutlawDefaultCdActions()
	}
}

### Required symbols
# adrenaline_rush
# adrenaline_rush_buff
# ambush
# arcane_torrent_energy
# augmentation
# berserking
# blade_flurry
# blade_flurry_buff
# blood_fury_ap
# cannonball_barrage
# curse_of_the_dreadblades
# death_from_above
# deeper_stratagem_talent
# draenic_agility_potion
# ghostly_strike
# ghostly_strike_debuff
# ghostly_strike_talent
# kick
# killing_spree
# legendary_ring_agility
# marked_for_death
# opportunity_buff
# pistol_shot
# roll_the_bones
# roll_the_bones_buff
# run_through
# saber_slash
# shadowmeld
# shadowstep
# shark_infested_waters_buff
# slice_and_dice
# slice_and_dice_buff
# stealth
# vanish
]]
	OvaleScripts:RegisterScript("ROGUE", "outlaw", name, desc, code, "script")
end

do
	local name = "simulationcraft_rogue_subtlety_t18m"
	local desc = "[7.0] SimulationCraft: Rogue_Subtlety_T18M"
	local code = [[
# Based on SimulationCraft profile "Rogue_Subtlety_T18M".
#	class=rogue
#	spec=subtlety
#	talents=1230011

Include(ovale_common)
Include(ovale_trinkets_mop)
Include(ovale_trinkets_wod)
Include(ovale_rogue_spells)

AddCheckBox(opt_melee_range L(not_in_melee_range) specialization=subtlety)
AddCheckBox(opt_potion_agility ItemName(draenic_agility_potion) default specialization=subtlety)
AddCheckBox(opt_legendary_ring_agility ItemName(legendary_ring_agility) default specialization=subtlety)

AddFunction SubtletyUsePotionAgility
{
	if CheckBoxOn(opt_potion_agility) and target.Classification(worldboss) Item(draenic_agility_potion usable=1)
}

### actions.default

AddFunction SubtletyDefaultMainActions
{
	#symbols_of_death,if=buff.symbols_of_death.remains<target.time_to_die-4&buff.symbols_of_death.remains<=10.5&buff.shadowmeld.down
	if BuffRemaining(symbols_of_death_buff) < target.TimeToDie() - 4 and BuffRemaining(symbols_of_death_buff) <= 10.5 and BuffExpires(shadowmeld_buff) Spell(symbols_of_death)
	#shuriken_storm,if=buff.stealth.up&talent.premeditation.enabled&combo_points.max-combo_points>=3&spell_targets.shuriken_storm>=7
	if BuffPresent(stealthed_buff any=1) and Talent(premeditation_talent) and MaxComboPoints() - ComboPoints() >= 3 and Enemies() >= 7 Spell(shuriken_storm)
	#shuriken_storm,if=buff.stealth.up&!buff.death.up&combo_points.max-combo_points>=2&((!talent.premeditation.enabled&spell_targets.shuriken_storm>=4)|spell_targets.shuriken_storm>=8)
	if BuffPresent(stealthed_buff any=1) and not BuffPresent(death_buff) and MaxComboPoints() - ComboPoints() >= 2 and { not Talent(premeditation_talent) and Enemies() >= 4 or Enemies() >= 8 } Spell(shuriken_storm)
	#shadowstrike,if=combo_points.max-combo_points>=2
	if MaxComboPoints() - ComboPoints() >= 2 Spell(shadowstrike)
	#pool_resource,for_next=1,extra_amount=energy.max-talent.master_of_shadows.enabled*30
	#vanish,if=(energy.deficit<talent.master_of_shadows.enabled*30&combo_points.max-combo_points>=3&cooldown.shadow_dance.charges<2)|target.time_to_die<8
	unless { EnergyDeficit() < TalentPoints(master_of_shadows_talent) * 30 and MaxComboPoints() - ComboPoints() >= 3 and SpellChargeCooldown(shadow_dance) < 2 or target.TimeToDie() < 8 } and SpellUsable(vanish) and SpellCooldown(vanish) < TimeToEnergyFor(vanish)
	{
		#pool_resource,for_next=1,extra_amount=energy.max-talent.master_of_shadows.enabled*30
		#shadow_dance,if=combo_points.max-combo_points>=2&((cooldown.vanish.remains&buff.symbols_of_death.remains<=10.5&energy.deficit<talent.master_of_shadows.enabled*30)|cooldown.shadow_dance.charges>=2|target.time_to_die<25)
		unless MaxComboPoints() - ComboPoints() >= 2 and { SpellCooldown(vanish) > 0 and BuffRemaining(symbols_of_death_buff) <= 10.5 and EnergyDeficit() < TalentPoints(master_of_shadows_talent) * 30 or SpellChargeCooldown(shadow_dance) >= 2 or target.TimeToDie() < 25 } and SpellUsable(shadow_dance) and SpellCooldown(shadow_dance) < TimeToEnergyFor(shadow_dance)
		{
			#enveloping_shadows,if=buff.enveloping_shadows.remains<target.time_to_die&((buff.enveloping_shadows.remains<=10.8+talent.deeper_stratagem.enabled*1.8&combo_points>=5+talent.deeper_stratagem.enabled)|buff.enveloping_shadows.remains<=6)
			if BuffRemaining(enveloping_shadows_buff) < target.TimeToDie() and { BuffRemaining(enveloping_shadows_buff) <= 10.8 + TalentPoints(deeper_stratagem_talent) * 1.8 and ComboPoints() >= 5 + TalentPoints(deeper_stratagem_talent) or BuffRemaining(enveloping_shadows_buff) <= 6 } Spell(enveloping_shadows)
			#run_action_list,name=finisher,if=combo_points>=5
			if ComboPoints() >= 5 SubtletyFinisherMainActions()
			#run_action_list,name=generator,if=combo_points<5
			if ComboPoints() < 5 SubtletyGeneratorMainActions()
		}
	}
}

AddFunction SubtletyDefaultShortCdActions
{
	#goremaws_bite,if=(combo_points.max-combo_points>=2&energy.deficit>55&time<10)|(combo_points.max-combo_points>=4&energy.deficit>45)|target.time_to_die<8
	if MaxComboPoints() - ComboPoints() >= 2 and EnergyDeficit() > 55 and TimeInCombat() < 10 or MaxComboPoints() - ComboPoints() >= 4 and EnergyDeficit() > 45 or target.TimeToDie() < 8 Spell(goremaws_bite)

	unless BuffRemaining(symbols_of_death_buff) < target.TimeToDie() - 4 and BuffRemaining(symbols_of_death_buff) <= 10.5 and BuffExpires(shadowmeld_buff) and Spell(symbols_of_death) or BuffPresent(stealthed_buff any=1) and Talent(premeditation_talent) and MaxComboPoints() - ComboPoints() >= 3 and Enemies() >= 7 and Spell(shuriken_storm) or BuffPresent(stealthed_buff any=1) and not BuffPresent(death_buff) and MaxComboPoints() - ComboPoints() >= 2 and { not Talent(premeditation_talent) and Enemies() >= 4 or Enemies() >= 8 } and Spell(shuriken_storm) or MaxComboPoints() - ComboPoints() >= 2 and Spell(shadowstrike)
	{
		#pool_resource,for_next=1,extra_amount=energy.max-talent.master_of_shadows.enabled*30
		#vanish,if=(energy.deficit<talent.master_of_shadows.enabled*30&combo_points.max-combo_points>=3&cooldown.shadow_dance.charges<2)|target.time_to_die<8
		if EnergyDeficit() < TalentPoints(master_of_shadows_talent) * 30 and MaxComboPoints() - ComboPoints() >= 3 and SpellChargeCooldown(shadow_dance) < 2 or target.TimeToDie() < 8 Spell(vanish)
		unless { EnergyDeficit() < TalentPoints(master_of_shadows_talent) * 30 and MaxComboPoints() - ComboPoints() >= 3 and SpellChargeCooldown(shadow_dance) < 2 or target.TimeToDie() < 8 } and SpellUsable(vanish) and SpellCooldown(vanish) < TimeToEnergyFor(vanish)
		{
			#pool_resource,for_next=1,extra_amount=energy.max-talent.master_of_shadows.enabled*30
			#shadow_dance,if=combo_points.max-combo_points>=2&((cooldown.vanish.remains&buff.symbols_of_death.remains<=10.5&energy.deficit<talent.master_of_shadows.enabled*30)|cooldown.shadow_dance.charges>=2|target.time_to_die<25)
			if MaxComboPoints() - ComboPoints() >= 2 and { SpellCooldown(vanish) > 0 and BuffRemaining(symbols_of_death_buff) <= 10.5 and EnergyDeficit() < TalentPoints(master_of_shadows_talent) * 30 or SpellChargeCooldown(shadow_dance) >= 2 or target.TimeToDie() < 25 } Spell(shadow_dance)
			unless MaxComboPoints() - ComboPoints() >= 2 and { SpellCooldown(vanish) > 0 and BuffRemaining(symbols_of_death_buff) <= 10.5 and EnergyDeficit() < TalentPoints(master_of_shadows_talent) * 30 or SpellChargeCooldown(shadow_dance) >= 2 or target.TimeToDie() < 25 } and SpellUsable(shadow_dance) and SpellCooldown(shadow_dance) < TimeToEnergyFor(shadow_dance)
			{
				unless BuffRemaining(enveloping_shadows_buff) < target.TimeToDie() and { BuffRemaining(enveloping_shadows_buff) <= 10.8 + TalentPoints(deeper_stratagem_talent) * 1.8 and ComboPoints() >= 5 + TalentPoints(deeper_stratagem_talent) or BuffRemaining(enveloping_shadows_buff) <= 6 } and Spell(enveloping_shadows)
				{
					#marked_for_death,cycle_targets=1,target_if=min:target.time_to_die,if=combo_points.deficit>=4+talent.deeper_stratagem.enabled
					if ComboPointsDeficit() >= 4 + TalentPoints(deeper_stratagem_talent) Spell(marked_for_death)
				}
			}
		}
	}
}

AddFunction SubtletyDefaultCdActions
{
	#potion,name=draenic_agility,if=buff.bloodlust.react|target.time_to_die<=25|buff.shadow_blades.up
	if BuffPresent(burst_haste_buff any=1) or target.TimeToDie() <= 25 or BuffPresent(shadow_blades_buff) SubtletyUsePotionAgility()
	#use_item,slot=finger1
	if CheckBoxOn(opt_legendary_ring_agility) Item(legendary_ring_agility usable=1)
	#blood_fury,if=buff.shadow_dance.up|buff.vanish.up|buff.stealth.up
	if BuffPresent(shadow_dance_buff) or BuffPresent(vanish_buff) or BuffPresent(stealthed_buff any=1) Spell(blood_fury_ap)
	#berserking,if=buff.shadow_dance.up|buff.vanish.up|buff.stealth.up
	if BuffPresent(shadow_dance_buff) or BuffPresent(vanish_buff) or BuffPresent(stealthed_buff any=1) Spell(berserking)
	#arcane_torrent,if=energy.deficit>70&(buff.shadow_dance.up|buff.vanish.up|buff.stealth.up)
	if EnergyDeficit() > 70 and { BuffPresent(shadow_dance_buff) or BuffPresent(vanish_buff) or BuffPresent(stealthed_buff any=1) } Spell(arcane_torrent_energy)
	#shadow_blades,if=!buff.shadow_blades.up&energy.deficit<20&(buff.shadow_dance.up|buff.vanish.up|buff.stealth.up)
	if not BuffPresent(shadow_blades_buff) and EnergyDeficit() < 20 and { BuffPresent(shadow_dance_buff) or BuffPresent(vanish_buff) or BuffPresent(stealthed_buff any=1) } Spell(shadow_blades)

	unless { MaxComboPoints() - ComboPoints() >= 2 and EnergyDeficit() > 55 and TimeInCombat() < 10 or MaxComboPoints() - ComboPoints() >= 4 and EnergyDeficit() > 45 or target.TimeToDie() < 8 } and Spell(goremaws_bite) or BuffRemaining(symbols_of_death_buff) < target.TimeToDie() - 4 and BuffRemaining(symbols_of_death_buff) <= 10.5 and BuffExpires(shadowmeld_buff) and Spell(symbols_of_death) or BuffPresent(stealthed_buff any=1) and Talent(premeditation_talent) and MaxComboPoints() - ComboPoints() >= 3 and Enemies() >= 7 and Spell(shuriken_storm) or BuffPresent(stealthed_buff any=1) and not BuffPresent(death_buff) and MaxComboPoints() - ComboPoints() >= 2 and { not Talent(premeditation_talent) and Enemies() >= 4 or Enemies() >= 8 } and Spell(shuriken_storm) or MaxComboPoints() - ComboPoints() >= 2 and Spell(shadowstrike)
	{
		#pool_resource,for_next=1,extra_amount=energy.max-talent.master_of_shadows.enabled*30
		#vanish,if=(energy.deficit<talent.master_of_shadows.enabled*30&combo_points.max-combo_points>=3&cooldown.shadow_dance.charges<2)|target.time_to_die<8
		unless { EnergyDeficit() < TalentPoints(master_of_shadows_talent) * 30 and MaxComboPoints() - ComboPoints() >= 3 and SpellChargeCooldown(shadow_dance) < 2 or target.TimeToDie() < 8 } and SpellUsable(vanish) and SpellCooldown(vanish) < TimeToEnergyFor(vanish)
		{
			#pool_resource,for_next=1,extra_amount=energy.max-talent.master_of_shadows.enabled*30
			#shadow_dance,if=combo_points.max-combo_points>=2&((cooldown.vanish.remains&buff.symbols_of_death.remains<=10.5&energy.deficit<talent.master_of_shadows.enabled*30)|cooldown.shadow_dance.charges>=2|target.time_to_die<25)
			unless MaxComboPoints() - ComboPoints() >= 2 and { SpellCooldown(vanish) > 0 and BuffRemaining(symbols_of_death_buff) <= 10.5 and EnergyDeficit() < TalentPoints(master_of_shadows_talent) * 30 or SpellChargeCooldown(shadow_dance) >= 2 or target.TimeToDie() < 25 } and SpellUsable(shadow_dance) and SpellCooldown(shadow_dance) < TimeToEnergyFor(shadow_dance)
			{
				#shadowmeld,if=energy>40&combo_points.max-combo_points>=3&!(buff.shadow_dance.up|buff.vanish.up|buff.stealth.up)
				if Energy() > 40 and MaxComboPoints() - ComboPoints() >= 3 and not { BuffPresent(shadow_dance_buff) or BuffPresent(vanish_buff) or BuffPresent(stealthed_buff any=1) } Spell(shadowmeld)
			}
		}
	}
}

### actions.finisher

AddFunction SubtletyFinisherMainActions
{
	#death_from_above,if=spell_targets.death_from_above>=10
	if Enemies() >= 10 Spell(death_from_above)
	#nightblade,if=!dot.nightblade.ticking|dot.nightblade.remains<duration*0.3
	if not target.DebuffPresent(nightblade_debuff) or target.DebuffRemaining(nightblade_debuff) < BaseDuration(nightblade_debuff) * 0.3 Spell(nightblade)
	#nightblade,cycle_targets=1,target_if=max:target.time_to_die,if=active_dot.nightblade<6&target.time_to_die>6&(!dot.nightblade.ticking|dot.nightblade.remains<duration*0.3)
	if DebuffCountOnAny(nightblade_debuff) < 6 and target.TimeToDie() > 6 and { not target.DebuffPresent(nightblade_debuff) or target.DebuffRemaining(nightblade_debuff) < BaseDuration(nightblade_debuff) * 0.3 } Spell(nightblade)
	#death_from_above
	Spell(death_from_above)
	#eviscerate
	Spell(eviscerate)
}

### actions.generator

AddFunction SubtletyGeneratorMainActions
{
	#shuriken_storm,if=spell_targets.shuriken_storm>=2
	if Enemies() >= 2 Spell(shuriken_storm)
	#gloomblade,if=energy.time_to_max<2.5
	if TimeToMaxEnergy() < 2.5 Spell(gloomblade)
	#backstab,if=energy.time_to_max<2.5
	if TimeToMaxEnergy() < 2.5 Spell(backstab)
}

### actions.precombat

AddFunction SubtletyPrecombatMainActions
{
	#flask,type=greater_draenic_agility_flask
	#augmentation,type=hyper
	Spell(augmentation)
	#food,type=jumbo_sea_dog
	#snapshot_stats
	#stealth
	Spell(stealth)
	#symbols_of_death
	Spell(symbols_of_death)
}

AddFunction SubtletyPrecombatShortCdActions
{
	unless Spell(augmentation) or Spell(stealth)
	{
		#marked_for_death
		Spell(marked_for_death)
	}
}

AddFunction SubtletyPrecombatShortCdPostConditions
{
	Spell(augmentation) or Spell(stealth) or Spell(symbols_of_death)
}

AddFunction SubtletyPrecombatCdActions
{
	unless Spell(augmentation) or Spell(stealth)
	{
		#potion,name=draenic_agility
		SubtletyUsePotionAgility()
	}
}

AddFunction SubtletyPrecombatCdPostConditions
{
	Spell(augmentation) or Spell(stealth) or Spell(symbols_of_death)
}

### Subtlety icons.

AddCheckBox(opt_rogue_subtlety_aoe L(AOE) default specialization=subtlety)

AddIcon checkbox=!opt_rogue_subtlety_aoe enemies=1 help=shortcd specialization=subtlety
{
	if not InCombat() SubtletyPrecombatShortCdActions()
	unless not InCombat() and SubtletyPrecombatShortCdPostConditions()
	{
		SubtletyDefaultShortCdActions()
	}
}

AddIcon checkbox=opt_rogue_subtlety_aoe help=shortcd specialization=subtlety
{
	if not InCombat() SubtletyPrecombatShortCdActions()
	unless not InCombat() and SubtletyPrecombatShortCdPostConditions()
	{
		SubtletyDefaultShortCdActions()
	}
}

AddIcon enemies=1 help=main specialization=subtlety
{
	if not InCombat() SubtletyPrecombatMainActions()
	SubtletyDefaultMainActions()
}

AddIcon checkbox=opt_rogue_subtlety_aoe help=aoe specialization=subtlety
{
	if not InCombat() SubtletyPrecombatMainActions()
	SubtletyDefaultMainActions()
}

AddIcon checkbox=!opt_rogue_subtlety_aoe enemies=1 help=cd specialization=subtlety
{
	if not InCombat() SubtletyPrecombatCdActions()
	unless not InCombat() and SubtletyPrecombatCdPostConditions()
	{
		SubtletyDefaultCdActions()
	}
}

AddIcon checkbox=opt_rogue_subtlety_aoe help=cd specialization=subtlety
{
	if not InCombat() SubtletyPrecombatCdActions()
	unless not InCombat() and SubtletyPrecombatCdPostConditions()
	{
		SubtletyDefaultCdActions()
	}
}

### Required symbols
# arcane_torrent_energy
# augmentation
# backstab
# berserking
# blood_fury_ap
# death_buff
# death_from_above
# deeper_stratagem_talent
# draenic_agility_potion
# enveloping_shadows
# enveloping_shadows_buff
# eviscerate
# gloomblade
# goremaws_bite
# kick
# legendary_ring_agility
# marked_for_death
# master_of_shadows_talent
# nightblade
# nightblade_debuff
# premeditation_talent
# shadow_blades
# shadow_blades_buff
# shadow_dance
# shadow_dance_buff
# shadowmeld
# shadowmeld_buff
# shadowstep
# shadowstrike
# shuriken_storm
# stealth
# symbols_of_death
# symbols_of_death_buff
# vanish
# vanish_buff
]]
	OvaleScripts:RegisterScript("ROGUE", "subtlety", name, desc, code, "script")
end
