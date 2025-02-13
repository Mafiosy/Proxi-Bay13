/datum/event/whale_migration
	announceWhen = 5
	endWhen = 10
	var/adult_whales_per_z
	var/total_whales = list()

/datum/event/whale_migration/setup()
	endWhen = rand(300, 800)
	adult_whales_per_z = rand(8, 15)

/datum/event/whale_migration/announce()
	command_announcement.Announce("Мигрирующая стая космических китообразных была обнаружена в непосредственной близости от [location_name()]. Пожалуйста, закройте ставни иллюминаторов и соблюдайте осторожность при совершение ВКД.", "Сенсорный Массив [location_name()]", affecting_z)

/datum/event/whale_migration/start()
	spawn_whales()

/datum/event/whale_migration/proc/spawn_whales()
	for(var/station_level in affecting_z)
		for(var/count in 1 to adult_whales_per_z)
			var/dir = pick(GLOB.cardinal)
			var/turf/T
			var/turf/oppT
			while(!istype(T, /turf/space))
				T = get_random_edge_turf(dir, TRANSITIONEDGE + 5, station_level)
			oppT = get_random_edge_turf(GLOB.reverse_dir[dir], TRANSITIONEDGE + 5, station_level)
			var/mob/living/simple_animal/hostile/retaliate/space_whale/adult
			var/mob/living/simple_animal/passive/juvenile_space_whale/child
			if(prob(75))
				adult = new(T)
				child = new(get_step(T, dir))
				total_whales += list(adult, child)
				adult.throw_at(oppT, 3, 1, null, FALSE)
				child.throw_at(oppT, 3, 1, null, FALSE)
			else
				adult = new(T)
				total_whales += adult
				adult.throw_at(oppT, 3, 1, null, FALSE)

/datum/event/whale_migration/end()
	for(var/mob/whale in total_whales)
		if(!whale.stat && istype(whale.loc.loc, /area/space))
			qdel(whale)
	command_announcement.Announce("Мигрирующая стая космических китообразных продолжила движение после выхода из космического пространства [location_name()].", "Сенсорный Массив [location_name()]", affecting_z)
