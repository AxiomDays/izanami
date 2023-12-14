#!/bin/bash
declare -a encountTable=(Monster Monster Monster Monster Monster BadFall Treasure Treasure SmallGold SmallGold SmallGold BigGold SmallMag SmallMag Statue DryBones LaughingDemons LaughingDemons ClassReminder GreatDevourer)
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
		local secrand=$((RANDOM % 20 + 1))
		if [[ $rand -ge 95 ]]; then
			encounter=${encountTable[$secrand]}
			echo ""
			case $encounter in
				Monster)
					read -p "You ran into a hostile demon!"
					battle "${goblin[@]}";;
				BadFall)
					read -p "You trip and scrape your knee. It doesn't slow you down but it's still kind of annoying";;
				Treasure)
					read -p "treasure get";;
				SmallGold)
					local goldget=$((RANDOM % 40 + 1))
					read -p "You found a small coiffer with some gold. You gain $((goldget*resources[LVL])) gold. How fortunate."
					resources[gold]=$((resources[gold]+(goldget*resources[LVL])));;
				BigGold)
					local goldget=$((RANDOM % 100 + 1))
                                        read -p "You wind upon a large purse filled with gold. You gain $((goldget*resources[LVL])) gold!"
                                        resources[gold]=$((resources[gold]+(goldget*resources[LVL])));;
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
						battle "${ghost[@]}"
					else
						read -p "The feeling passes."
					fi;;
				ClassReminder)
					read -p "You think back on your life as a ${class}. It was without note. Otherwise, you wouldn't have found yourself here.";;
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
