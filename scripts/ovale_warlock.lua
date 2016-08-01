local OVALE, Ovale = ...
local OvaleScripts = Ovale.OvaleScripts

-- THE REST OF THIS FILE IS AUTOMATICALLY GENERATED.
-- ANY CHANGES MADE BELOW THIS POINT WILL BE LOST.

do
	local name = "simulationcraft_warlock_affliction_t18m"
	local desc = "[7.0] SimulationCraft: Warlock_Affliction_T18M"
	local code = [[
# Based on SimulationCraft profile "Warlock_Affliction_T18M".
#	class=warlock
#	spec=affliction
#	talents=2203011
#	pet=felhunter

Include(ovale_common)
Include(ovale_trinkets_mop)
Include(ovale_trinkets_wod)
Include(ovale_warlock_spells)

AddCheckBox(opt_potion_intellect ItemName(draenic_intellect_potion) default specialization=affliction)
AddCheckBox(opt_legendary_ring_intellect ItemName(legendary_ring_intellect) default specialization=affliction)

AddFunction AfflictionUsePotionIntellect
{
	if CheckBoxOn(opt_potion_intellect) and target.Classification(worldboss) Item(draenic_intellect_potion usable=1)
}

### actions.default

AddFunction AfflictionDefaultMainActions
{
	#soul_effigy,if=!pet.soul_effigy.active
	if not pet.Present() Spell(soul_effigy)
	#agony,if=remains<=tick_time+gcd
	if target.DebuffRemaining(agony_debuff) <= target.TickTime(agony_debuff) + GCD() Spell(agony)
	#agony,target=soul_effigy,if=remains<=tick_time+gcd
	if target.DebuffRemaining(agony_debuff) <= target.TickTime(agony_debuff) + GCD() Spell(agony text=soul_effigy)
	#corruption,if=remains<=tick_time+gcd
	if target.DebuffRemaining(corruption_debuff) <= target.TickTime(corruption_debuff) + GCD() Spell(corruption)
	#siphon_life,if=remains<=tick_time+gcd
	if target.DebuffRemaining(siphon_life_debuff) <= target.TickTime(siphon_life_debuff) + GCD() Spell(siphon_life)
	#corruption,target=soul_effigy,if=remains<=tick_time+gcd
	if target.DebuffRemaining(corruption_debuff) <= target.TickTime(corruption_debuff) + GCD() Spell(corruption text=soul_effigy)
	#siphon_life,target=soul_effigy,if=remains<=tick_time+gcd
	if target.DebuffRemaining(siphon_life_debuff) <= target.TickTime(siphon_life_debuff) + GCD() Spell(siphon_life text=soul_effigy)
	#mana_tap,if=buff.mana_tap.remains<=buff.mana_tap.duration*0.3&target.time_to_die>buff.mana_tap.duration*0.3
	if BuffRemaining(mana_tap_buff) <= BaseDuration(mana_tap_buff) * 0.3 and target.TimeToDie() > BaseDuration(mana_tap_buff) * 0.3 Spell(mana_tap)
	#unstable_affliction,if=(soul_shard>=4|buff.shard_instability.remains|buff.instability.remains|buff.soul_harvest.remains|buff.nithramus.remains)
	if SoulShards() >= 4 or BuffPresent(shard_instability_buff) or BuffPresent(instability_buff) or BuffPresent(soul_harvest_buff) or BuffPresent(nithramus_buff) Spell(unstable_affliction)
	#agony,if=remains<=duration*0.3
	if target.DebuffRemaining(agony_debuff) <= BaseDuration(agony_debuff) * 0.3 Spell(agony)
	#agony,target=soul_effigy,if=remains<=duration*0.3
	if target.DebuffRemaining(agony_debuff) <= BaseDuration(agony_debuff) * 0.3 Spell(agony text=soul_effigy)
	#corruption,if=remains<=duration*0.3
	if target.DebuffRemaining(corruption_debuff) <= BaseDuration(corruption_debuff) * 0.3 Spell(corruption)
	#haunt
	Spell(haunt)
	#siphon_life,if=remains<=duration*0.3
	if target.DebuffRemaining(siphon_life_debuff) <= BaseDuration(siphon_life_debuff) * 0.3 Spell(siphon_life)
	#corruption,target=soul_effigy,if=remains<=duration*0.3
	if target.DebuffRemaining(corruption_debuff) <= BaseDuration(corruption_debuff) * 0.3 Spell(corruption text=soul_effigy)
	#siphon_life,target=soul_effigy,if=remains<=duration*0.3
	if target.DebuffRemaining(siphon_life_debuff) <= BaseDuration(siphon_life_debuff) * 0.3 Spell(siphon_life text=soul_effigy)
	#life_tap,if=mana.pct<=10
	if ManaPercent() <= 10 Spell(life_tap)
	#drain_soul,chain=1,interrupt=1
	Spell(drain_soul)
	#drain_life,chain=1,interrupt=1
	Spell(drain_life)
	#life_tap
	Spell(life_tap)
}

AddFunction AfflictionDefaultShortCdActions
{
	unless not pet.Present() and Spell(soul_effigy) or target.DebuffRemaining(agony_debuff) <= target.TickTime(agony_debuff) + GCD() and Spell(agony) or target.DebuffRemaining(agony_debuff) <= target.TickTime(agony_debuff) + GCD() and Spell(agony text=soul_effigy)
	{
		#service_pet
		Spell(service_felhunter)

		unless target.DebuffRemaining(corruption_debuff) <= target.TickTime(corruption_debuff) + GCD() and Spell(corruption) or target.DebuffRemaining(siphon_life_debuff) <= target.TickTime(siphon_life_debuff) + GCD() and Spell(siphon_life) or target.DebuffRemaining(corruption_debuff) <= target.TickTime(corruption_debuff) + GCD() and Spell(corruption text=soul_effigy) or target.DebuffRemaining(siphon_life_debuff) <= target.TickTime(siphon_life_debuff) + GCD() and Spell(siphon_life text=soul_effigy) or BuffRemaining(mana_tap_buff) <= BaseDuration(mana_tap_buff) * 0.3 and target.TimeToDie() > BaseDuration(mana_tap_buff) * 0.3 and Spell(mana_tap)
		{
			#phantom_singularity
			Spell(phantom_singularity)
		}
	}
}

AddFunction AfflictionDefaultCdActions
{
	#use_item,name=nithramus_the_allseer
	if CheckBoxOn(opt_legendary_ring_intellect) Item(legendary_ring_intellect usable=1)

	unless not pet.Present() and Spell(soul_effigy) or target.DebuffRemaining(agony_debuff) <= target.TickTime(agony_debuff) + GCD() and Spell(agony) or target.DebuffRemaining(agony_debuff) <= target.TickTime(agony_debuff) + GCD() and Spell(agony text=soul_effigy) or Spell(service_felhunter)
	{
		#summon_doomguard,if=!talent.grimoire_of_supremacy.enabled&spell_targets.infernal_awakening<3
		if not Talent(grimoire_of_supremacy_talent) and Enemies() < 3 Spell(summon_doomguard)
		#summon_infernal,if=!talent.grimoire_of_supremacy.enabled&spell_targets.infernal_awakening>=3
		if not Talent(grimoire_of_supremacy_talent) and Enemies() >= 3 Spell(summon_infernal)
		#berserking
		Spell(berserking)
		#blood_fury
		Spell(blood_fury_sp)
		#arcane_torrent
		Spell(arcane_torrent_mana)
		#potion,name=draenic_intellect,if=buff.nithramus.remains
		if BuffPresent(nithramus_buff) AfflictionUsePotionIntellect()
		#soul_harvest
		Spell(soul_harvest)
	}
}

### actions.precombat

AddFunction AfflictionPrecombatMainActions
{
	#snapshot_stats
	#grimoire_of_sacrifice,if=talent.grimoire_of_sacrifice.enabled
	if Talent(grimoire_of_sacrifice_talent) and pet.Present() Spell(grimoire_of_sacrifice)
	#mana_tap,if=talent.mana_tap.enabled&!buff.mana_tap.remains
	if Talent(mana_tap_talent) and not BuffPresent(mana_tap_buff) Spell(mana_tap)
}

AddFunction AfflictionPrecombatShortCdActions
{
	#flask,type=greater_draenic_intellect_flask
	#food,type=felmouth_frenzy
	#summon_pet,if=!talent.grimoire_of_supremacy.enabled&(!talent.grimoire_of_sacrifice.enabled|buff.demonic_power.down)
	if not Talent(grimoire_of_supremacy_talent) and { not Talent(grimoire_of_sacrifice_talent) or BuffExpires(demonic_power_buff) } and not pet.Present() Spell(summon_felhunter)
}

AddFunction AfflictionPrecombatShortCdPostConditions
{
	Talent(mana_tap_talent) and not BuffPresent(mana_tap_buff) and Spell(mana_tap)
}

AddFunction AfflictionPrecombatCdActions
{
	unless not Talent(grimoire_of_supremacy_talent) and { not Talent(grimoire_of_sacrifice_talent) or BuffExpires(demonic_power_buff) } and not pet.Present() and Spell(summon_felhunter)
	{
		#summon_doomguard,if=talent.grimoire_of_supremacy.enabled&active_enemies<3
		if Talent(grimoire_of_supremacy_talent) and Enemies() < 3 Spell(summon_doomguard)
		#summon_infernal,if=talent.grimoire_of_supremacy.enabled&active_enemies>=3
		if Talent(grimoire_of_supremacy_talent) and Enemies() >= 3 Spell(summon_infernal)
		#potion,name=draenic_intellect
		AfflictionUsePotionIntellect()
	}
}

AddFunction AfflictionPrecombatCdPostConditions
{
	not Talent(grimoire_of_supremacy_talent) and { not Talent(grimoire_of_sacrifice_talent) or BuffExpires(demonic_power_buff) } and not pet.Present() and Spell(summon_felhunter) or Talent(mana_tap_talent) and not BuffPresent(mana_tap_buff) and Spell(mana_tap)
}

### Affliction icons.

AddCheckBox(opt_warlock_affliction_aoe L(AOE) default specialization=affliction)

AddIcon checkbox=!opt_warlock_affliction_aoe enemies=1 help=shortcd specialization=affliction
{
	if not InCombat() AfflictionPrecombatShortCdActions()
	unless not InCombat() and AfflictionPrecombatShortCdPostConditions()
	{
		AfflictionDefaultShortCdActions()
	}
}

AddIcon checkbox=opt_warlock_affliction_aoe help=shortcd specialization=affliction
{
	if not InCombat() AfflictionPrecombatShortCdActions()
	unless not InCombat() and AfflictionPrecombatShortCdPostConditions()
	{
		AfflictionDefaultShortCdActions()
	}
}

AddIcon enemies=1 help=main specialization=affliction
{
	if not InCombat() AfflictionPrecombatMainActions()
	AfflictionDefaultMainActions()
}

AddIcon checkbox=opt_warlock_affliction_aoe help=aoe specialization=affliction
{
	if not InCombat() AfflictionPrecombatMainActions()
	AfflictionDefaultMainActions()
}

AddIcon checkbox=!opt_warlock_affliction_aoe enemies=1 help=cd specialization=affliction
{
	if not InCombat() AfflictionPrecombatCdActions()
	unless not InCombat() and AfflictionPrecombatCdPostConditions()
	{
		AfflictionDefaultCdActions()
	}
}

AddIcon checkbox=opt_warlock_affliction_aoe help=cd specialization=affliction
{
	if not InCombat() AfflictionPrecombatCdActions()
	unless not InCombat() and AfflictionPrecombatCdPostConditions()
	{
		AfflictionDefaultCdActions()
	}
}

### Required symbols
# agony
# agony_debuff
# arcane_torrent_mana
# berserking
# blood_fury_sp
# corruption
# corruption_debuff
# demonic_power_buff
# draenic_intellect_potion
# drain_life
# drain_soul
# grimoire_of_sacrifice
# grimoire_of_sacrifice_talent
# grimoire_of_supremacy_talent
# haunt
# instability_buff
# legendary_ring_intellect
# life_tap
# mana_tap
# mana_tap_buff
# mana_tap_talent
# nithramus_buff
# phantom_singularity
# service_felhunter
# shard_instability_buff
# siphon_life
# siphon_life_debuff
# soul_effigy
# soul_harvest
# soul_harvest_buff
# summon_doomguard
# summon_felhunter
# summon_infernal
# unstable_affliction
]]
	OvaleScripts:RegisterScript("WARLOCK", "affliction", name, desc, code, "script")
end

do
	local name = "simulationcraft_warlock_demonology_t18m"
	local desc = "[7.0] SimulationCraft: Warlock_Demonology_T18M"
	local code = [[
# Based on SimulationCraft profile "Warlock_Demonology_T18M".
#	class=warlock
#	spec=demonology
#	talents=1102013
#	pet=felguard

Include(ovale_common)
Include(ovale_trinkets_mop)
Include(ovale_trinkets_wod)
Include(ovale_warlock_spells)

AddCheckBox(opt_potion_intellect ItemName(draenic_intellect_potion) default specialization=demonology)
AddCheckBox(opt_legendary_ring_intellect ItemName(legendary_ring_intellect) default specialization=demonology)

AddFunction DemonologyUsePotionIntellect
{
	if CheckBoxOn(opt_potion_intellect) and target.Classification(worldboss) Item(draenic_intellect_potion usable=1)
}

### actions.default

AddFunction DemonologyDefaultMainActions
{
	#doom,if=talent.soul_harvest.enabled&!cooldown.soul_harvest.remains&!remains
	if Talent(soul_harvest_talent) and not SpellCooldown(soul_harvest) > 0 and not target.DebuffRemaining(doom_debuff) Spell(doom)
	#doom,if=talent.impending_doom.enabled&remains<=action.hand_of_guldan.cast_time
	if Talent(impending_doom_talent) and target.DebuffRemaining(doom_debuff) <= CastTime(hand_of_guldan) Spell(doom)
	#hand_of_guldan,if=soul_shard>=1
	if SoulShards() >= 1 Spell(hand_of_guldan)
	#demonic_empowerment,if=wild_imp_no_de>=5
	if 0 >= 5 Spell(demonic_empowerment)
	#doom,if=talent.impending_doom.enabled&remains<=duration*0.3
	if Talent(impending_doom_talent) and target.DebuffRemaining(doom_debuff) <= BaseDuration(doom_debuff) * 0.3 Spell(doom)
	#demonbolt
	Spell(demonbolt)
	#shadow_bolt
	Spell(shadow_bolt)
	#life_tap
	Spell(life_tap)
}

AddFunction DemonologyDefaultShortCdActions
{
	#service_pet
	Spell(service_felguard)
}

AddFunction DemonologyDefaultCdActions
{
	#use_item,name=nithramus_the_allseer
	if CheckBoxOn(opt_legendary_ring_intellect) Item(legendary_ring_intellect usable=1)
	#berserking
	Spell(berserking)
	#blood_fury
	Spell(blood_fury_sp)
	#arcane_torrent
	Spell(arcane_torrent_mana)
	#potion,name=draenic_intellect,if=buff.nithramus.remains
	if BuffPresent(nithramus_buff) DemonologyUsePotionIntellect()

	unless Spell(service_felguard)
	{
		#summon_doomguard,if=!talent.grimoire_of_supremacy.enabled&spell_targets.infernal_awakening<3
		if not Talent(grimoire_of_supremacy_talent) and Enemies() < 3 Spell(summon_doomguard)
		#summon_infernal,if=!talent.grimoire_of_supremacy.enabled&spell_targets.infernal_awakening>=3
		if not Talent(grimoire_of_supremacy_talent) and Enemies() >= 3 Spell(summon_infernal)
		#soul_harvest,if=dot.doom.remains
		if target.DebuffRemaining(doom_debuff) Spell(soul_harvest)
	}
}

### actions.precombat

AddFunction DemonologyPrecombatMainActions
{
	#demonic_empowerment
	Spell(demonic_empowerment)
}

AddFunction DemonologyPrecombatShortCdActions
{
	#flask,type=greater_draenic_intellect_flask
	#food,type=frosty_stew
	#summon_pet,if=!talent.grimoire_of_supremacy.enabled&(!talent.grimoire_of_sacrifice.enabled|buff.demonic_power.down)
	if not Talent(grimoire_of_supremacy_talent) and { not Talent(grimoire_of_sacrifice_talent) or BuffExpires(demonic_power_buff) } and not pet.Present() Spell(summon_felguard)
}

AddFunction DemonologyPrecombatShortCdPostConditions
{
	Spell(demonic_empowerment)
}

AddFunction DemonologyPrecombatCdActions
{
	unless not Talent(grimoire_of_supremacy_talent) and { not Talent(grimoire_of_sacrifice_talent) or BuffExpires(demonic_power_buff) } and not pet.Present() and Spell(summon_felguard)
	{
		#summon_doomguard,if=talent.grimoire_of_supremacy.enabled&active_enemies<3
		if Talent(grimoire_of_supremacy_talent) and Enemies() < 3 Spell(summon_doomguard)
		#summon_infernal,if=talent.grimoire_of_supremacy.enabled&active_enemies>=3
		if Talent(grimoire_of_supremacy_talent) and Enemies() >= 3 Spell(summon_infernal)
		#snapshot_stats
		#potion,name=draenic_intellect
		DemonologyUsePotionIntellect()
	}
}

AddFunction DemonologyPrecombatCdPostConditions
{
	not Talent(grimoire_of_supremacy_talent) and { not Talent(grimoire_of_sacrifice_talent) or BuffExpires(demonic_power_buff) } and not pet.Present() and Spell(summon_felguard) or Spell(demonic_empowerment)
}

### Demonology icons.

AddCheckBox(opt_warlock_demonology_aoe L(AOE) default specialization=demonology)

AddIcon checkbox=!opt_warlock_demonology_aoe enemies=1 help=shortcd specialization=demonology
{
	if not InCombat() DemonologyPrecombatShortCdActions()
	unless not InCombat() and DemonologyPrecombatShortCdPostConditions()
	{
		DemonologyDefaultShortCdActions()
	}
}

AddIcon checkbox=opt_warlock_demonology_aoe help=shortcd specialization=demonology
{
	if not InCombat() DemonologyPrecombatShortCdActions()
	unless not InCombat() and DemonologyPrecombatShortCdPostConditions()
	{
		DemonologyDefaultShortCdActions()
	}
}

AddIcon enemies=1 help=main specialization=demonology
{
	if not InCombat() DemonologyPrecombatMainActions()
	DemonologyDefaultMainActions()
}

AddIcon checkbox=opt_warlock_demonology_aoe help=aoe specialization=demonology
{
	if not InCombat() DemonologyPrecombatMainActions()
	DemonologyDefaultMainActions()
}

AddIcon checkbox=!opt_warlock_demonology_aoe enemies=1 help=cd specialization=demonology
{
	if not InCombat() DemonologyPrecombatCdActions()
	unless not InCombat() and DemonologyPrecombatCdPostConditions()
	{
		DemonologyDefaultCdActions()
	}
}

AddIcon checkbox=opt_warlock_demonology_aoe help=cd specialization=demonology
{
	if not InCombat() DemonologyPrecombatCdActions()
	unless not InCombat() and DemonologyPrecombatCdPostConditions()
	{
		DemonologyDefaultCdActions()
	}
}

### Required symbols
# arcane_torrent_mana
# berserking
# blood_fury_sp
# demonbolt
# demonic_empowerment
# demonic_power_buff
# doom
# doom_debuff
# draenic_intellect_potion
# grimoire_of_sacrifice_talent
# grimoire_of_supremacy_talent
# hand_of_guldan
# impending_doom_talent
# legendary_ring_intellect
# life_tap
# nithramus_buff
# service_felguard
# shadow_bolt
# soul_harvest
# soul_harvest_talent
# summon_doomguard
# summon_felguard
# summon_infernal
]]
	OvaleScripts:RegisterScript("WARLOCK", "demonology", name, desc, code, "script")
end

do
	local name = "simulationcraft_warlock_destruction_t18m"
	local desc = "[7.0] SimulationCraft: Warlock_Destruction_T18M"
	local code = [[
# Based on SimulationCraft profile "Warlock_Destruction_T18M".
#	class=warlock
#	spec=destruction
#	talents=2301033
#	pet=imp

Include(ovale_common)
Include(ovale_trinkets_mop)
Include(ovale_trinkets_wod)
Include(ovale_warlock_spells)

AddCheckBox(opt_potion_intellect ItemName(draenic_intellect_potion) default specialization=destruction)
AddCheckBox(opt_legendary_ring_intellect ItemName(legendary_ring_intellect) default specialization=destruction)

AddFunction DestructionUsePotionIntellect
{
	if CheckBoxOn(opt_potion_intellect) and target.Classification(worldboss) Item(draenic_intellect_potion usable=1)
}

### actions.default

AddFunction DestructionDefaultMainActions
{
	#immolate,if=remains<=tick_time
	if target.DebuffRemaining(immolate_debuff) <= target.TickTime(immolate_debuff) Spell(immolate)
	#immolate,if=talent.roaring_blaze.enabled&remains<=duration&!debuff.roaring_blaze.remains&(action.conflagrate.charges=2|(action.conflagrate.charges>=1&action.conflagrate.recharge_time<cast_time+gcd))
	if Talent(roaring_blaze_talent) and target.DebuffRemaining(immolate_debuff) <= BaseDuration(immolate_debuff) and not target.DebuffPresent(roaring_blaze_debuff) and { Charges(conflagrate) == 2 or Charges(conflagrate) >= 1 and SpellChargeCooldown(conflagrate) < CastTime(immolate) + GCD() } Spell(immolate)
	#conflagrate,if=talent.roaring_blaze.enabled&(charges=2|(action.conflagrate.charges>=1&action.conflagrate.recharge_time<gcd))
	if Talent(roaring_blaze_talent) and { Charges(conflagrate) == 2 or Charges(conflagrate) >= 1 and SpellChargeCooldown(conflagrate) < GCD() } Spell(conflagrate)
	#conflagrate,if=talent.roaring_blaze.enabled&prev_gcd.conflagrate
	if Talent(roaring_blaze_talent) and PreviousGCDSpell(conflagrate) Spell(conflagrate)
	#conflagrate,if=talent.roaring_blaze.enabled&debuff.roaring_blaze.stack=2
	if Talent(roaring_blaze_talent) and target.DebuffStacks(roaring_blaze_debuff) == 2 Spell(conflagrate)
	#conflagrate,if=talent.roaring_blaze.enabled&debuff.roaring_blaze.stack=3&buff.bloodlust.remains
	if Talent(roaring_blaze_talent) and target.DebuffStacks(roaring_blaze_debuff) == 3 and BuffPresent(burst_haste_buff any=1) Spell(conflagrate)
	#conflagrate,if=!talent.roaring_blaze.enabled&buff.conflagration_of_chaos.remains<=action.chaos_bolt.cast_time
	if not Talent(roaring_blaze_talent) and BuffRemaining(conflagration_of_chaos_buff) <= CastTime(chaos_bolt) Spell(conflagrate)
	#conflagrate,if=!talent.roaring_blaze.enabled&(charges=1&recharge_time<action.chaos_bolt.cast_time|charges=2)&soul_shard<5
	if not Talent(roaring_blaze_talent) and { Charges(conflagrate) == 1 and SpellChargeCooldown(conflagrate) < CastTime(chaos_bolt) or Charges(conflagrate) == 2 } and SoulShards() < 5 Spell(conflagrate)
	#channel_demonfire,if=dot.immolate.remains>cast_time
	if target.DebuffRemaining(immolate_debuff) > CastTime(channel_demonfire) Spell(channel_demonfire)
	#chaos_bolt,if=soul_shard>3
	if SoulShards() > 3 Spell(chaos_bolt)
	#mana_tap,if=buff.mana_tap.remains<=buff.mana_tap.duration*0.3&target.time_to_die>buff.mana_tap.duration*0.3
	if BuffRemaining(mana_tap_buff) <= BaseDuration(mana_tap_buff) * 0.3 and target.TimeToDie() > BaseDuration(mana_tap_buff) * 0.3 Spell(mana_tap)
	#chaos_bolt
	Spell(chaos_bolt)
	#conflagrate,if=!talent.roaring_blaze.enabled
	if not Talent(roaring_blaze_talent) Spell(conflagrate)
	#immolate,if=!talent.roaring_blaze.enabled&remains<=duration*0.3
	if not Talent(roaring_blaze_talent) and target.DebuffRemaining(immolate_debuff) <= BaseDuration(immolate_debuff) * 0.3 Spell(immolate)
	#life_tap,if=talent.mana_tap.enabled&mana.pct<=10
	if Talent(mana_tap_talent) and ManaPercent() <= 10 Spell(life_tap)
	#incinerate
	Spell(incinerate)
	#life_tap
	Spell(life_tap)
}

AddFunction DestructionDefaultShortCdActions
{
	unless target.DebuffRemaining(immolate_debuff) <= target.TickTime(immolate_debuff) and Spell(immolate) or Talent(roaring_blaze_talent) and target.DebuffRemaining(immolate_debuff) <= BaseDuration(immolate_debuff) and not target.DebuffPresent(roaring_blaze_debuff) and { Charges(conflagrate) == 2 or Charges(conflagrate) >= 1 and SpellChargeCooldown(conflagrate) < CastTime(immolate) + GCD() } and Spell(immolate) or Talent(roaring_blaze_talent) and { Charges(conflagrate) == 2 or Charges(conflagrate) >= 1 and SpellChargeCooldown(conflagrate) < GCD() } and Spell(conflagrate) or Talent(roaring_blaze_talent) and PreviousGCDSpell(conflagrate) and Spell(conflagrate) or Talent(roaring_blaze_talent) and target.DebuffStacks(roaring_blaze_debuff) == 2 and Spell(conflagrate) or Talent(roaring_blaze_talent) and target.DebuffStacks(roaring_blaze_debuff) == 3 and BuffPresent(burst_haste_buff any=1) and Spell(conflagrate) or not Talent(roaring_blaze_talent) and BuffRemaining(conflagration_of_chaos_buff) <= CastTime(chaos_bolt) and Spell(conflagrate) or not Talent(roaring_blaze_talent) and { Charges(conflagrate) == 1 and SpellChargeCooldown(conflagrate) < CastTime(chaos_bolt) or Charges(conflagrate) == 2 } and SoulShards() < 5 and Spell(conflagrate)
	{
		#service_pet
		Spell(service_imp)

		unless target.DebuffRemaining(immolate_debuff) > CastTime(channel_demonfire) and Spell(channel_demonfire) or SoulShards() > 3 and Spell(chaos_bolt)
		{
			#dimensional_rift
			Spell(dimensional_rift)

			unless BuffRemaining(mana_tap_buff) <= BaseDuration(mana_tap_buff) * 0.3 and target.TimeToDie() > BaseDuration(mana_tap_buff) * 0.3 and Spell(mana_tap) or Spell(chaos_bolt)
			{
				#cataclysm
				Spell(cataclysm)
			}
		}
	}
}

AddFunction DestructionDefaultCdActions
{
	#use_item,name=nithramus_the_allseer
	if CheckBoxOn(opt_legendary_ring_intellect) Item(legendary_ring_intellect usable=1)

	unless target.DebuffRemaining(immolate_debuff) <= target.TickTime(immolate_debuff) and Spell(immolate) or Talent(roaring_blaze_talent) and target.DebuffRemaining(immolate_debuff) <= BaseDuration(immolate_debuff) and not target.DebuffPresent(roaring_blaze_debuff) and { Charges(conflagrate) == 2 or Charges(conflagrate) >= 1 and SpellChargeCooldown(conflagrate) < CastTime(immolate) + GCD() } and Spell(immolate)
	{
		#berserking
		Spell(berserking)
		#blood_fury
		Spell(blood_fury_sp)
		#arcane_torrent
		Spell(arcane_torrent_mana)
		#potion,name=draenic_intellect,if=buff.nithramus.remains
		if BuffPresent(nithramus_buff) DestructionUsePotionIntellect()

		unless Talent(roaring_blaze_talent) and { Charges(conflagrate) == 2 or Charges(conflagrate) >= 1 and SpellChargeCooldown(conflagrate) < GCD() } and Spell(conflagrate) or Talent(roaring_blaze_talent) and PreviousGCDSpell(conflagrate) and Spell(conflagrate) or Talent(roaring_blaze_talent) and target.DebuffStacks(roaring_blaze_debuff) == 2 and Spell(conflagrate) or Talent(roaring_blaze_talent) and target.DebuffStacks(roaring_blaze_debuff) == 3 and BuffPresent(burst_haste_buff any=1) and Spell(conflagrate) or not Talent(roaring_blaze_talent) and BuffRemaining(conflagration_of_chaos_buff) <= CastTime(chaos_bolt) and Spell(conflagrate) or not Talent(roaring_blaze_talent) and { Charges(conflagrate) == 1 and SpellChargeCooldown(conflagrate) < CastTime(chaos_bolt) or Charges(conflagrate) == 2 } and SoulShards() < 5 and Spell(conflagrate) or Spell(service_imp)
		{
			#summon_infernal,if=artifact.lord_of_flames.rank>0&!buff.lord_of_flames.remains
			if 0 > 0 and not BuffPresent(lord_of_flames_buff) Spell(summon_infernal)
			#summon_doomguard,if=!talent.grimoire_of_supremacy.enabled&spell_targets.infernal_awakening<3
			if not Talent(grimoire_of_supremacy_talent) and Enemies() < 3 Spell(summon_doomguard)
			#summon_infernal,if=!talent.grimoire_of_supremacy.enabled&spell_targets.infernal_awakening>=3
			if not Talent(grimoire_of_supremacy_talent) and Enemies() >= 3 Spell(summon_infernal)
			#soul_harvest
			Spell(soul_harvest)
		}
	}
}

### actions.precombat

AddFunction DestructionPrecombatMainActions
{
	#snapshot_stats
	#grimoire_of_sacrifice,if=talent.grimoire_of_sacrifice.enabled
	if Talent(grimoire_of_sacrifice_talent) and pet.Present() Spell(grimoire_of_sacrifice)
	#mana_tap,if=talent.mana_tap.enabled&!buff.mana_tap.remains
	if Talent(mana_tap_talent) and not BuffPresent(mana_tap_buff) Spell(mana_tap)
	#incinerate
	Spell(incinerate)
}

AddFunction DestructionPrecombatShortCdActions
{
	#flask,type=greater_draenic_intellect_flask
	#food,type=frosty_stew
	#summon_pet,if=!talent.grimoire_of_supremacy.enabled&(!talent.grimoire_of_sacrifice.enabled|buff.demonic_power.down)
	if not Talent(grimoire_of_supremacy_talent) and { not Talent(grimoire_of_sacrifice_talent) or BuffExpires(demonic_power_buff) } and not pet.Present() Spell(summon_imp)
}

AddFunction DestructionPrecombatShortCdPostConditions
{
	Talent(mana_tap_talent) and not BuffPresent(mana_tap_buff) and Spell(mana_tap) or Spell(incinerate)
}

AddFunction DestructionPrecombatCdActions
{
	unless not Talent(grimoire_of_supremacy_talent) and { not Talent(grimoire_of_sacrifice_talent) or BuffExpires(demonic_power_buff) } and not pet.Present() and Spell(summon_imp)
	{
		#summon_doomguard,if=talent.grimoire_of_supremacy.enabled&active_enemies<3
		if Talent(grimoire_of_supremacy_talent) and Enemies() < 3 Spell(summon_doomguard)
		#summon_infernal,if=talent.grimoire_of_supremacy.enabled&active_enemies>=3
		if Talent(grimoire_of_supremacy_talent) and Enemies() >= 3 Spell(summon_infernal)
		#potion,name=draenic_intellect
		DestructionUsePotionIntellect()
	}
}

AddFunction DestructionPrecombatCdPostConditions
{
	not Talent(grimoire_of_supremacy_talent) and { not Talent(grimoire_of_sacrifice_talent) or BuffExpires(demonic_power_buff) } and not pet.Present() and Spell(summon_imp) or Talent(mana_tap_talent) and not BuffPresent(mana_tap_buff) and Spell(mana_tap) or Spell(incinerate)
}

### Destruction icons.

AddCheckBox(opt_warlock_destruction_aoe L(AOE) default specialization=destruction)

AddIcon checkbox=!opt_warlock_destruction_aoe enemies=1 help=shortcd specialization=destruction
{
	if not InCombat() DestructionPrecombatShortCdActions()
	unless not InCombat() and DestructionPrecombatShortCdPostConditions()
	{
		DestructionDefaultShortCdActions()
	}
}

AddIcon checkbox=opt_warlock_destruction_aoe help=shortcd specialization=destruction
{
	if not InCombat() DestructionPrecombatShortCdActions()
	unless not InCombat() and DestructionPrecombatShortCdPostConditions()
	{
		DestructionDefaultShortCdActions()
	}
}

AddIcon enemies=1 help=main specialization=destruction
{
	if not InCombat() DestructionPrecombatMainActions()
	DestructionDefaultMainActions()
}

AddIcon checkbox=opt_warlock_destruction_aoe help=aoe specialization=destruction
{
	if not InCombat() DestructionPrecombatMainActions()
	DestructionDefaultMainActions()
}

AddIcon checkbox=!opt_warlock_destruction_aoe enemies=1 help=cd specialization=destruction
{
	if not InCombat() DestructionPrecombatCdActions()
	unless not InCombat() and DestructionPrecombatCdPostConditions()
	{
		DestructionDefaultCdActions()
	}
}

AddIcon checkbox=opt_warlock_destruction_aoe help=cd specialization=destruction
{
	if not InCombat() DestructionPrecombatCdActions()
	unless not InCombat() and DestructionPrecombatCdPostConditions()
	{
		DestructionDefaultCdActions()
	}
}

### Required symbols
# arcane_torrent_mana
# berserking
# blood_fury_sp
# cataclysm
# channel_demonfire
# chaos_bolt
# conflagrate
# conflagration_of_chaos_buff
# demonic_power_buff
# dimensional_rift
# draenic_intellect_potion
# grimoire_of_sacrifice
# grimoire_of_sacrifice_talent
# grimoire_of_supremacy_talent
# immolate
# immolate_debuff
# incinerate
# legendary_ring_intellect
# life_tap
# lord_of_flames
# lord_of_flames_buff
# mana_tap
# mana_tap_buff
# mana_tap_talent
# nithramus_buff
# roaring_blaze_debuff
# roaring_blaze_talent
# service_imp
# soul_harvest
# summon_doomguard
# summon_imp
# summon_infernal
]]
	OvaleScripts:RegisterScript("WARLOCK", "destruction", name, desc, code, "script")
end
