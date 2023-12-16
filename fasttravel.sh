#!/bin/bash
declare -a encountTable=(Monster Monster Monster Monster Monster BadFall TerribleFall TerribleFall TerribleFall Treasure Treasure SmallGold SmallGold SmallGold BigGold BigGold SmallMag SmallMag Statue DryBones LaughingDemons LaughingDemons ClassReminder GreatDevourer StrDemon StrDemon DemonChat DemonChat DemonChat DemonChat Puzzle Puzzle Human Human Human HostileHuman HostileHuman ClassReminder2 BlueBird BlueBird)
declare -a ItemTreasureTable=(Medicine StaminaPill SenchaTea FiveFingerSeal Antidote EnergyCandy Panacea)
declare -a EqTreasureTable=(GoldCrown BloodSword WitchHat TurtleShell GigantEdge NinjaArmor)
travel(){
	declare route=()
	local playerPos=0
        local end=$1
	for ((i=0;i<$1;i++))
	do
		route+=(.)
	done
	printroute(){
		route[$playerPos]="X"
		echo ""
		tput cuu1;tput el
		echo -en "${route[@]}"
		tput cuu1;tput el
		echo ""
	}
	randomEncounter(){
		local rand=$((RANDOM % 100 + 1))
		local secrand=$((RANDOM % 39 + 0))
		if [[ $rand -ge 85 ]]; then
			encounter=${encountTable[$secrand]}
			echo ""
			case $encounter in
				BlueBird)
					local goldget=$((RANDOM % 10 + 1))
                                        read -p "A small bird-like creature flows into your hand and leaves behind a small bag. You gain $((goldget*resources[LVL])) MAG!"
					read -p "It seems like Dr. Crowley is trying to help out- In his own way"
                                        resources[MAG]=$((resources[MAG]+(goldget*resources[LVL])));;
				Monster)
					read -p "You ran into a hostile demon!"
					local demchance=$((RANDOM % 7 + 1))
					case $demchance in
						1)
							battle "${goblin[@]}";;
						2)
                                                        battle "${imp[@]}";;
						3)
                                                        battle "${goblin[@]}";;
						4)
                                                        battle "${imp[@]}";;
						5)
                                                        battle "${goblin[@]}";;
						6)
                                                        battle "${goblin[@]}";;
						7)
							read -p "and this one is out for your guts!"
                                                        battle "${hobgoblin[@]}";;
					esac;;
				BadFall)
					read -p "You trip and scrape your knee. It doesn't slow you down but it's still kind of annoying";;
				TerribleFall)
					local goldget=$((RANDOM % 10 + 1))
					read -p "You weren't paying attention and you slip off a steep cliff!"
                                        SkillCheck AGI 8
                                        if [[ $SKR = 1 ]]; then
                                                read -p "However you're deft enough to stick your landing!"
                                                give_exp $((20*resources[LVL]))
                                        else
						read -p "You land badly and take $((goldget)) damage. How unfortunate."
                                        fi;;
				Treasure)

					read -p "Treasure Get!"
					treasureDrop;;
				StrDemon)
					local goldget=$((RANDOM % 40 + 20))
					read -p "You run into a powerful gang of demons, but rather than attack, they force you into a wrestling contest!"
                                        SkillCheck STR 12
                                        if [[ $SKR = 1 ]]; then
                                                read -p "However with your superior strength you manage to beat your demonic opponent!"
                                                read -p "They give you some MAG as prize!"
                                                resources[MAG]=$((${resources[MAG]}+(goldget*resources[LVL])))
						give_exp $((40*resources[LVL]))
                                        else
                                                read -p "Unfortunately, your demonic opponent mercilessly slams you into the ground."
						read -p "They give you some Yen as a consolation..."
                                                resources[GOLD]=$((${resources[GOLD]}+(goldget*resources[LVL])))
                                        fi;;
				DemonChat)
					local goldget=$((RANDOM % 10 + 1))
					read -p "You run into a group of demons, they eye you warily."
					SkillCheck GUI 8
					if [[ $SKR = 1 ]]; then
						read -p "However you manage to talk them out of an altercation!"
						read -p "They give you some MAG as a parting gift"
						resources[MAG]=$((${resources[MAG]}+(goldget*resources[LVL])))
					else
						read -p "All of a sudden they attack!"
						case $dungLevel in
							1)
								battle "${goblin[@]}";;
							2)
								battle "${goblin[@]}";;
							3)
								battle "${imp[@]}";;
							4)
                                                                battle "${imp[@]}";;
							5)
								battle "${hobgoblin[@]}"
						esac
					fi;;
				Puzzle)
					local goldget=$((RANDOM % 10 + 1))
					read -p "You run into a terribly curious demon, it asks you a befuddling question."
                                        SkillCheck INT 10
                                        if [[ $SKR = 1 ]]; then
                                                read -p "However with your superior intellect, you're able to answer correctly!"
                                                read -p "They give you some MAG as a parting gift"
                                                resources[MAG]=$((${resources[MAG]}+(goldget*resources[LVL])))
						give_exp $((70*resources[LVL]))
                                        else
                                                read -p "You answer incorrectly... "
                                                battle "${sphinx[@]}"
                                        fi;;
				Human)
					read -p "You encounter another human on your way. They seem to be in search of the sword as well."
					SkillCheck GUI 10
					if [[ $SKR = 1 ]]; then
                                                read -p "You exchange some information, and your knowledge of the demon world increases"
						give_exp $((50*resources[LVL]))
                                        else
                                                read -p "They seem wary of you, so your conversation is short"
                                        fi;;
				HostileHuman)
					read -p "You encounter another human on your way. They seem dangerous..."
                                        SkillCheck GUI 12
                                        if [[ $SKR = 1 ]]; then
                                                read -p "You exchange some information, and your knowledge of the demon world increases"
                                                give_exp $((70*resources[LVL]))
                                        else
                                                read -p "Without warning they attack you!"
                                                battle "${human[@]}"
                                        fi;;
				SmallGold)
					local goldget=$((RANDOM % 40 + 1))
					read -p "You found a small coiffer with some gold. You gain $((goldget*resources[LVL])) gold. How fortunate."
					read -p "You feel somehow that this is Kobaneko's doing"
					resources[GOLD]=$((resources[GOLD]+(goldget*resources[LVL])));;
				BigGold)
					local goldget=$((RANDOM % 100 + 1))
                                        read -p "You wind upon a large purse filled with gold. You gain $((goldget*resources[LVL])) gold!"
					read -p "You feel somehow that this is Kobaneko's doing."
                                        resources[GOLD]=$((resources[GOLD]+(goldget*resources[LVL])));;
				SmallMag)
					local goldget=$((RANDOM % 10 + 1))
                                        read -p "You find yourself in a deep underground cavern. Above you a silver liquid drips ever so slowly to the ground. You gain $((goldget*resources[LVL])) MAG!"
                                        resources[MAG]=$((resources[MAG]+(goldget*resources[LVL])));;
				Statue)
					read -p "You come upon a gigantic marble statue. It seemed to be of a powerful demon with 6 arms and 10 eyes."
					read -p "Its lustre was only matched by the incredible detail."
					read -p "At the Podium, it read, 'The Venerable Daimaou Kagutsuchi'";;
				DryBones)
					read -p "You come across a pile of... oddly human bones. Best to keep moving.";;
				LaughingDemons)
					read -p "You suddenly feel as though your being watched... The sky above seems to twist and bend... "
					read -p "You hear the laughter of innumerable demons..."
					if [[ $((RANDOM % 2 + 1)) == 2 ]]; then
						case $dungLevel in
							1)
								battle "${ghost[@]}";;
							2)
								battle "${ghost[@]}";;
							3)
								battle "${orias[@]}";;
							4)
								battle "${sphinx[@]}";;
							5)
								battle "${belial[@]}";;
						esac
					else
						read -p "The feeling passes."
					fi;;
				ClassReminder)
					read -p "You think back on your life as a ${class}. It was without note. Otherwise, you wouldn't have found yourself here.";;
				ClassReminder2)
					case $class in
						Farmer)
							read -p "You utilize your ability to quickly survey a land to figure out the quickest and safest route"
							give_exp $((50*resources[LVL]))
							;;
						${agech1})
							read -p "You think back to when your tutor taught you the royal art of hoofing long distances. It helps a bit."
							give_exp $((50*resources[LVL]))
							;;
						Destitute)
							read -p "You're used to living outdoors, so this expedition doesn't phase you much"
							give_exp $((50*resources[LVL]))
							;;
						Doctor)
							read -p "Your medical studies have taught you to make sure to prioritize proper hydration and breathing to maximize stamina."
							give_exp $((50*resources[LVL]))
							;;
						Ronin)
							read -p "You're a wanderer at heart, these lands are no worse than the ones you've wandered in the past"
							give_exp $((50*resources[LVL]))
							;;
						Shinobi)
							read -p "This land doesn't even approach the worst of your shinobi training. You continue to trudge."
							give_exp $((50*resources[LVL]))
							;;
					esac;;
				GreatDevourer)
					read -p "The ground groans and churns. The heavens split in twain. Tremble! The Great Devourer has come to swallow reality itself!"
					battle "${devourer[@]}";;
			esac
		fi
	}
	printroute
	for ((;$playerPos<$end;))
	do
		sleep 0.5
		playerPos=$((playerPos+1))
		route[$((playerPos-1))]="."
		printroute
		randomEncounter
	done
	echo ""
}

SkillCheck(){
	local stat=$1
	local difficulty=$2
	local modifier=$(((stats[$stat]/2)-3))
	local dice=$((RANDOM % 18 + 1))
	echo "stats: $stats[$stat] = ${stats[$stat]}, modifier: $modifier , diceroll: $dice"
	if [[ $((dice + modifier)) -ge $difficulty ]]; then
		#skill check result
		SKR=1
	else
		SKR=0
	fi
}

treasureDrop(){
	overanny=$((RANDOM % 10 + 1))
	if [[ $overanny -gt 8 ]]; then
		eqranny=$((RANDOM % 5 + 0 ))
		add_equipment "${EqTreasureTable[eqranny]}"
	elif [[ $overanny -gt 3 ]]; then
		itranny=$((RANDOM % 6 + 0 ))
		add_item "${ItemTreasureTable[itranny]}"
	else
		goldranny=$((RANDOM % 2 + 1 ))
		if [[ $goldranny == 1 ]]; then
			resources[gold]=$((resources[gold]+(50*resources[LVL])))
			echo "You found $((50*resources[LVL])) MAG"
		else
			resources[MAG]=$((resources[gold]+(10*resources[LVL])))
			echo "You found $((10*resources[LVL])) MAG"
		fi
	fi
}
