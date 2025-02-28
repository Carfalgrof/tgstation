/mob/living/simple_animal/hostile/asteroid/hivelord
	name = "hivelord"
	desc = "A truly alien creature, it is a mass of unknown organic material, constantly fluctuating. When attacking, pieces of it split off and attack in tandem with the original."
	icon = 'icons/mob/simple/lavaland/lavaland_monsters.dmi'
	icon_state = "Hivelord"
	icon_living = "Hivelord"
	icon_aggro = "Hivelord_alert"
	icon_dead = "Hivelord_dead"
	icon_gib = "syndicate_gib"
	mob_biotypes = MOB_ORGANIC
	move_to_delay = 14
	ranged = 1
	vision_range = 5
	aggro_vision_range = 9
	speed = 3
	maxHealth = 75
	health = 75
	harm_intent_damage = 5
	melee_damage_lower = 0
	melee_damage_upper = 0
	attack_verb_continuous = "lashes out at"
	attack_verb_simple = "lash out at"
	speak_emote = list("telepathically cries")
	attack_sound = 'sound/weapons/pierce.ogg'
	throw_message = "falls right through the strange body of the"
	ranged_cooldown = 0
	ranged_cooldown_time = 20
	obj_damage = 0
	environment_smash = ENVIRONMENT_SMASH_NONE
	retreat_distance = 3
	minimum_distance = 3
	pass_flags = PASSTABLE
	loot = list(/obj/item/organ/internal/monster_core/regenerative_core)
	var/brood_type = /mob/living/simple_animal/hostile/asteroid/hivelordbrood
	var/has_clickbox = TRUE

/mob/living/simple_animal/hostile/asteroid/hivelord/Initialize(mapload)
	. = ..()
	if(has_clickbox)
		AddComponent(/datum/component/clickbox, icon_state = "hivelord", max_scale = INFINITY, dead_state = "hivelord_dead") //they writhe so much.

/mob/living/simple_animal/hostile/asteroid/hivelord/OpenFire(the_target)
	if(world.time >= ranged_cooldown)
		var/mob/living/simple_animal/hostile/asteroid/hivelordbrood/A = new brood_type(src.loc)

		A.flags_1 |= (flags_1 & ADMIN_SPAWNED_1)
		A.GiveTarget(target)
		A.friends = friends
		A.faction = faction.Copy()
		ranged_cooldown = world.time + ranged_cooldown_time

/mob/living/simple_animal/hostile/asteroid/hivelord/AttackingTarget()
	OpenFire()
	return TRUE

/mob/living/simple_animal/hostile/asteroid/hivelord/death(gibbed)
	mouse_opacity = MOUSE_OPACITY_ICON
	..(gibbed)

//A fragile but rapidly produced creature
/mob/living/simple_animal/hostile/asteroid/hivelordbrood
	name = "hivelord brood"
	desc = "A fragment of the original Hivelord, rallying behind its original. One isn't much of a threat, but..."
	icon = 'icons/mob/simple/lavaland/lavaland_monsters.dmi'
	icon_state = "Hivelordbrood"
	icon_living = "Hivelordbrood"
	icon_aggro = "Hivelordbrood"
	icon_dead = "Hivelordbrood"
	icon_gib = "syndicate_gib"
	move_to_delay = 1
	friendly_verb_continuous = "buzzes near"
	friendly_verb_simple = "buzz near"
	vision_range = 10
	speed = 3
	maxHealth = 1
	health = 1
	harm_intent_damage = 5
	melee_damage_lower = 2
	melee_damage_upper = 2
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	speak_emote = list("telepathically cries")
	attack_sound = 'sound/weapons/pierce.ogg'
	attack_vis_effect = ATTACK_EFFECT_SLASH
	throw_message = "falls right through the strange body of the"
	obj_damage = 0
	environment_smash = ENVIRONMENT_SMASH_NONE
	pass_flags = PASSTABLE | PASSMOB
	density = FALSE
	del_on_death = 1
	var/clickbox_state = "hivelord"
	var/clickbox_max_scale = INFINITY

/mob/living/simple_animal/hostile/asteroid/hivelordbrood/Initialize(mapload)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(death)), 100)
	AddElement(/datum/element/simple_flying)
	AddComponent(/datum/component/swarming)
	AddComponent(/datum/component/clickbox, icon_state = clickbox_state, max_scale = clickbox_max_scale)

//Legion
/mob/living/simple_animal/hostile/asteroid/hivelord/legion
	name = "legion"
	desc = "You can still see what was once a human under the shifting mass of corruption."
	icon = 'icons/mob/simple/lavaland/lavaland_monsters.dmi'
	icon_state = "legion"
	icon_living = "legion"
	icon_aggro = "legion"
	icon_dead = "legion"
	icon_gib = "syndicate_gib"
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	mouse_opacity = MOUSE_OPACITY_ICON
	obj_damage = 60
	melee_damage_lower = 15
	melee_damage_upper = 15
	attack_verb_continuous = "lashes out at"
	attack_verb_simple = "lash out at"
	speak_emote = list("echoes")
	attack_sound = 'sound/weapons/pierce.ogg'
	throw_message = "bounces harmlessly off of"
	crusher_loot = /obj/item/crusher_trophy/legion_skull
	loot = list(/obj/item/organ/internal/monster_core/regenerative_core/legion)
	brood_type = /mob/living/simple_animal/hostile/asteroid/hivelordbrood/legion
	del_on_death = 1
	stat_attack = HARD_CRIT
	robust_searching = 1
	has_clickbox = FALSE
	var/dwarf_mob = FALSE
	var/snow_legion = FALSE
	var/mob/living/carbon/human/stored_mob

/mob/living/simple_animal/hostile/asteroid/hivelord/legion/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/content_barfer)

/mob/living/simple_animal/hostile/asteroid/hivelord/legion/dwarf
	name = "dwarf legion"
	desc = "You can still see what was once a rather small human under the shifting mass of corruption."
	icon_state = "dwarf_legion"
	icon_living = "dwarf_legion"
	icon_aggro = "dwarf_legion"
	icon_dead = "dwarf_legion"
	maxHealth = 60
	health = 60
	speed = 2 //faster!
	crusher_drop_mod = 20
	dwarf_mob = TRUE

/mob/living/simple_animal/hostile/asteroid/hivelord/legion/death(gibbed)
	visible_message(span_warning("The skulls on [src] wail in anger as they flee from their dying host!"))
	if (!isnull(stored_mob))
		stored_mob = null
		return ..()

	// We didn't contain a real body so spawn a random one
	var/turf/our_turf = get_turf(src)
	if(our_turf)
		if(from_spawner)
			new /obj/effect/mob_spawn/corpse/human/charredskeleton(our_turf)
		else if(dwarf_mob)
			new /obj/effect/mob_spawn/corpse/human/legioninfested/dwarf(our_turf)
		else if(snow_legion)
			new /obj/effect/mob_spawn/corpse/human/legioninfested/snow(our_turf)

			new /obj/effect/mob_spawn/corpse/human/legioninfested/dwarf(our_turf)
		else
			new /obj/effect/mob_spawn/corpse/human/legioninfested(our_turf)
	return ..()

/mob/living/simple_animal/hostile/asteroid/hivelord/legion/tendril
	from_spawner = TRUE

//Legion skull
/mob/living/simple_animal/hostile/asteroid/hivelordbrood/legion
	name = "legion"
	desc = "One of many."
	icon = 'icons/mob/simple/lavaland/lavaland_monsters.dmi'
	icon_state = "legion_head"
	icon_living = "legion_head"
	icon_aggro = "legion_head"
	icon_dead = "legion_head"
	icon_gib = "syndicate_gib"
	friendly_verb_continuous = "buzzes near"
	friendly_verb_simple = "buzz near"
	vision_range = 10
	maxHealth = 1
	health = 5
	harm_intent_damage = 5
	melee_damage_lower = 12
	melee_damage_upper = 12
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	attack_vis_effect = ATTACK_EFFECT_BITE
	speak_emote = list("echoes")
	attack_sound = 'sound/weapons/pierce.ogg'
	throw_message = "is shrugged off by"
	del_on_death = TRUE
	stat_attack = HARD_CRIT
	robust_searching = 1
	clickbox_state = "sphere"
	clickbox_max_scale = 2
	var/can_infest_dead = FALSE

/mob/living/simple_animal/hostile/asteroid/hivelordbrood/legion/Life(seconds_per_tick = SSMOBS_DT, times_fired)
	. = ..()
	if(stat == DEAD || !isturf(loc))
		return
	for(var/mob/living/carbon/human/victim in range(src, 1)) //Only for corpse right next to/on same tile
		switch(victim.stat)
			if(UNCONSCIOUS, HARD_CRIT)
				infest(victim)
				return //This will qdelete the legion.
			if(DEAD)
				if(can_infest_dead)
					infest(victim)
					return //This will qdelete the legion.

///Create a legion at the location of a corpse. Exists so that legion subtypes can override it with their own type of legion.
/mob/living/simple_animal/hostile/asteroid/hivelordbrood/legion/proc/make_legion(mob/living/carbon/human/H)
	if(HAS_TRAIT(H, TRAIT_DWARF)) //dwarf legions aren't just fluff!
		return new /mob/living/simple_animal/hostile/asteroid/hivelord/legion/dwarf(H.loc)
	else
		return new /mob/living/simple_animal/hostile/asteroid/hivelord/legion(H.loc)

///Create a new legion using the supplied human H
/mob/living/simple_animal/hostile/asteroid/hivelordbrood/legion/proc/infest(mob/living/carbon/human/H)
	visible_message(span_warning("[name] burrows into the flesh of [H]!"))
	var/mob/living/simple_animal/hostile/asteroid/hivelord/legion/L = make_legion(H)
	visible_message(span_warning("[L] staggers to [L.p_their()] feet!"))
	H.investigate_log("has been killed by hivelord infestation.", INVESTIGATE_DEATHS)
	H.death()
	H.adjustBruteLoss(1000)
	L.stored_mob = H
	H.forceMove(L)
	qdel(src)

//Advanced Legion is slightly tougher to kill and can raise corpses (revive other legions)
/mob/living/simple_animal/hostile/asteroid/hivelord/legion/advanced
	stat_attack = DEAD
	maxHealth = 120
	health = 120
	brood_type = /mob/living/simple_animal/hostile/asteroid/hivelordbrood/legion/advanced
	icon_state = "dwarf_legion"
	icon_living = "dwarf_legion"
	icon_aggro = "dwarf_legion"
	icon_dead = "dwarf_legion"

/mob/living/simple_animal/hostile/asteroid/hivelordbrood/legion/advanced
	stat_attack = DEAD
	can_infest_dead = TRUE

//Legion that spawns Legions
/mob/living/simple_animal/hostile/big_legion
	name = "legion"
	desc = "One of many."
	icon = 'icons/mob/simple/lavaland/64x64megafauna.dmi'
	icon_state = "legion"
	icon_living = "legion"
	icon_dead = "legion"
	health_doll_icon = "legion"
	health = 450
	maxHealth = 450
	melee_damage_lower = 20
	melee_damage_upper = 20
	anchored = FALSE
	AIStatus = AI_ON
	stop_automated_movement = FALSE
	wander = TRUE
	maxbodytemp = INFINITY
	layer = MOB_LAYER
	del_on_death = TRUE
	sentience_type = SENTIENCE_BOSS
	loot = list(/obj/item/organ/internal/monster_core/regenerative_core/legion = 3, /obj/effect/mob_spawn/corpse/human/legioninfested = 5)
	move_to_delay = 14
	vision_range = 5
	aggro_vision_range = 9
	speed = 3
	faction = list(FACTION_MINING)
	weather_immunities = list(TRAIT_LAVA_IMMUNE, TRAIT_ASHSTORM_IMMUNE)
	obj_damage = 30
	environment_smash = ENVIRONMENT_SMASH_STRUCTURES
	// Purple, but bright cause we're gonna need to spot mobs on lavaland
	lighting_cutoff_red = 35
	lighting_cutoff_green = 20
	lighting_cutoff_blue = 45


/mob/living/simple_animal/hostile/big_legion/Initialize(mapload)
	.=..()
	AddComponent(\
		/datum/component/spawner,\
		spawn_types = list(/mob/living/simple_animal/hostile/asteroid/hivelord/legion),\
		spawn_time = 20 SECONDS,\
		max_spawned = 3,\
		spawn_text = "peels itself off from",\
		faction = faction,\
	)

// Snow Legion
/mob/living/simple_animal/hostile/asteroid/hivelord/legion/snow
	name = "snow legion"
	desc = "You can still see what was once a human under the shifting snowy mass, clearly decorated by a clown."
	icon = 'icons/mob/simple/icemoon/icemoon_monsters.dmi'
	icon_state = "snowlegion"
	icon_living = "snowlegion"
	icon_aggro = "snowlegion_alive"
	icon_dead = "snowlegion"
	crusher_loot = /obj/item/crusher_trophy/legion_skull
	loot = list(/obj/item/organ/internal/monster_core/regenerative_core/legion)
	brood_type = /mob/living/simple_animal/hostile/asteroid/hivelordbrood/legion/snow
	weather_immunities = list(TRAIT_SNOWSTORM_IMMUNE)
	snow_legion = TRUE

/mob/living/simple_animal/hostile/asteroid/hivelordbrood/legion/snow/make_legion(mob/living/carbon/human/H)
	return new /mob/living/simple_animal/hostile/asteroid/hivelord/legion/snow(H.loc)

/mob/living/simple_animal/hostile/asteroid/hivelord/legion/snow/portal
	from_spawner = TRUE

// Snow Legion skull
/mob/living/simple_animal/hostile/asteroid/hivelordbrood/legion/snow
	name = "snow legion"
	desc = "One of many."
	icon = 'icons/mob/simple/icemoon/icemoon_monsters.dmi'
	icon_state = "snowlegion_head"
	icon_living = "snowlegion_head"
	icon_aggro = "snowlegion_head"
	icon_dead = "snowlegion_head"
	weather_immunities = list(TRAIT_SNOWSTORM_IMMUNE)
