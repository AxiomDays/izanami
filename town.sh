declare -a townarr=("Palace" "Church" "Smithy" "Apothecary" "Demonitorium" "Dungeon" "Talk" "Status")
declare -a talkarr=("Kobaneko" "Exit")
declare -A demon=(
["Exit"]=0
["Goblin"]=15
["Oni"]=10
)
town(){
townstate=1
echo "Where do you want to go"
while [[ "$townstate" = 1 ]]
do
ninjaTools["Shuriken"]=3
ninjaTools["PaperBomb"]=3
ninjaTools["FumaShuriken"]=3
save
select place in ${townarr[@]}
do
	PS3="Pick a Number: "
	case $place in
		Status)
			select choice in Stats Equipment Magic Save Exit
			do
				case $choice in
					Stats)
						whom
						sleep 1
						status_stats
						status_equip
						sleep 1
						echo "You're at level ${resources[LVL]} and have $((resources[NEXP]-resources[EXP])) experience left till next level."
						echo "You currently have ${resources[GOLD]} yen."
						break 2;;
					Equipment)
						equipmenu=1
						while [[ "$equipmenu" = 1 ]]
						do
						select equipe in ${equipmentNo[@]} Exit
						do
							case $equipe in
								Exit)
									equipmenu=0
									break 4;;
								*)
									equip ${equipe}
									break;;
							esac
						done
						done;;
					Save)
						save
						break 2;;
					Exit)
						break 2;;
				esac
			done;;			
		Church)
			shop church
			break;;
		Palace)
			break;;
		Smithy)
			shop smith
			break;;
		Apothecary)
			shop apothecary
			break;;
		Demonitorium)
			shop demon
			break;;
		Talk)
			select person in "${talkarr[@]}"
			do
				case $person in
					Kobaneko)
						Kobaneko
						break;;
					White)
						White
						break;;
					Exit)
						break;;
				esac
			done
			break;;
		Dungeon)
			echo "You are travelling to Dungeon Level ${dungLevel}"
			travel 25
			case $dungLevel in
				1)
					dunj ${dungeon1[@]}
					;;
				2)
					dunj ${dungeon2[@]}
					;;
				3)
					dunj ${dungeon3[@]}
					;;
				4)
					dunj ${dungeon4[@]}
					battle "${gigas[@]}"
					;;
				5)
					dunj ${dungeon5[@]}
					FinalFloor
					;;
				*)
					dunj ${dungeon5[@]}
					;;
			esac
			travel 25
			break;;
	esac
done
done
}

shop(){
shopstate=1
if [[ "$1" = smith ]]; then
echo "A wave of heat rolls over you as soon as you step in."
char "Old Smithy" "What would yer like to purchase, adventurer!"
PS3="Pick a Number: "
while [[ "$shopstate" = 1 ]]
do
select smit in ${!smithy[@]}
       do
	PS3="Pick a Number: "
	case $smit in
		Exit)
			shopstate=0
			break;;
		*)
			echo "That will be ${smithy[$smit]} yen"
			read -p "[y/n]: " reply
			if [[ "$reply" = y || "$reply" = Y ]]; then
				if [[ "${resources[GOLD]}" -ge "${smithy[$smit]}" ]]; then
					add_equipment ${smit}
					resources[GOLD]=$((resources[GOLD]-smithy[$smit]))
					read -p "Would you like to equip this now? [y/n] " reply2
					if [[ "$reply2" == y || "$reply2" == Y ]]; then
						equip ${smit}
						break
					fi	
					break
				else
					echo "You don't have enough Yen"
					break
				fi
			else
				continue
			fi;;
	esac
done
done
elif [[ "$1" = "church" ]]; then
	echo "The soft scent of incense attacks you. There's a quiet hymn everberating from unknown places."
	char "Sister Amaka" "Come my child, be healed"
	char "Sister Amaka" "That will be $((resources[LVL]*25)) yen"
        read -p "[y/n]: " reply
	while [[ "$shopstate" = 1 ]]
	do
		if [[ "$reply" = y || "$reply" = Y ]]; then
	               	if [[ "${resources[GOLD]}" -ge "$((resources[LVL]*25))" ]]; then
				PS3="Choose: "
				select opt in Healing Purge Blessing Exit	
				do
					case $opt in
						Healing)
							derived[HP]=${derived[MaxHP]}
							derived[STA]=${derived[MaxSTA]}
							 char "Sister Amaka" "You have been healed. Go now and sin no more"
							break;;
						Purge)
							statusfx[sealed]=0
			                                statusfx[EnExhaust]=0
			                                statusfx[toxin]=0
							 char "Sister Amaka" "You have been delivered from ailment. Go now and be free."
							break;;
						Blessing)
							 char "Sister Amaka" "Our lord has granted you a boon"
							break;;
						Exit)
							shopstate=0
							break;;
					esac
				done
			else
				echo "You don't have enough Yen"
				break
			fi
		else
			break
		fi
	done
	elif [[ "$1" = "apothecary" ]]; then
		echo "An indescribable miasma rises out as you open the door, the smell of ginseng, rabbit foot and other unknowable reagents"
		char "Lenarr, the Alchemist" "What would you like to purchase, adventurer!"
		PS3="Pick a Number: "
		while [[ "$shopstate" = 1 ]]
		do
		select smit in ${!apothy[@]}
        	do
                	PS3="Pick a Number: "
			case $smit in
				Exit)
					shopstate=0
					break;;
				*)
					char "Lenarr, the Alchemist" "That will be ${apothy[$smit]} yen"
					read -p "[y/n]: " reply
					if [[ "$reply" = y || "$reply" = Y ]]; then
						if [[ "${resources[GOLD]}" -ge "${apothy[$smit]}" ]]; then
							add_item ${smit}
							resources[GOLD]=$((resources[GOLD]-apothy[$smit]))
							break
						else
							echo "You don't have enough Yen"
							break
						fi
					else
						continue
					fi;;
			esac
	        done
		done
	elif [[ "$1" = "demon" ]]; then
                echo "Unholy sigils paint the walls and howling creatures cackle from cages hanging precariously overhead"
                char "Crowley" "Test your skills, adventurer... Anything you carve out is yours."
                PS3="Pick a Number: "
                while [[ "$shopstate" = 1 ]]
                do
		echo "Whatever you want, I got it."
		select opt in "Buy Mag"	"See Demons" "Talk to Crowley"
		do
			case $opt in
				"Buy Mag")
					read -p "How much do you want to buy: [number] " number
					while [[ ! "$number" =~ ^[0-9]+$ ]];
					do    
						read -p "Reenter the number: " number
					done
					cost=$((10*number))
					read -p "That will be ${cost} yen. [y/n]" resp
					if [[ ${resp} = y ]]; then
						 if [[ "${resources[GOLD]}" -ge "${cost}" ]]; then
							 resources[GOLD]=$((resources[GOLD]-cost))
							 resources[MAG]=$((resources[MAG]+number))
						 else
							 echo "You don't have enough Yen"
							 continue
						 fi
					else
						echo "What else would you like to purchase"
						break
					fi
					shopstate=0
					break;;
				"See Demons")
					break;;
				"Talk to Crowley")
					Crowley
					shopstate=0
					break;;
			esac
		done
                select smit in ${!demon[@]}
                do
                        PS3="Pick a Number: "
                        case $smit in
                                Exit)
                                        shopstate=0
                                        break;;
                                Goblin)
                                        echo "That will be ${demon[$smit]} yen"
                                        read -p "[y/n]: " reply
                                        if [[ "$reply" = y || "$reply" = Y ]]; then
                                                if [[ "${resources[GOLD]}" -ge "${demon[$smit]}" ]]; then
							battle "${goblin[@]}"
                                                        resources[GOLD]=$((resources[GOLD]-demon[$smit]))
                                                        break
                                                else
                                                        echo "Broke ass"
                                                        break
                                                fi
                                        else
                                                continue
                                        fi;;
				Oni)
                                        echo "That will be ${demon[$smit]} yen"
                                        read -p "[y/n]: " reply
                                        if [[ "$reply" = y || "$reply" = Y ]]; then
                                                if [[ "${resources[GOLD]}" -ge "${demon[$smit]}" ]]; then
                                                        battle "${oni[@]}"
                                                        resources[GOLD]=$((resources[GOLD]-demon[$smit]))
                                                        break
                                                else
                                                        echo "Broke ass"
                                                        break
                                                fi
                                        else
                                                continue
                                        fi;;
                        esac
                done
                done

	fi
}

equip(){
	local tempequip="$1"
		case $tempequip in
			*)
				for eq in "${equipListHead[@]}"
				do
					if [[ "$tempequip" = ${eq} ]]; then
						equip[HEAD]=${tempequip}
					fi
				done
				 for eq in "${equipListBody[@]}"
				 do
                                        if [[ "$tempequip" = ${eq} ]]; then
                                                equip[BODY]=${tempequip}
                                        fi
				done
				 for eq in "${equipListWeapon[@]}"
				 do
                                        if [[ "$tempequip" = ${eq} ]]; then
                                                equip[WEAPON]=${tempequip}
                                        fi
				done
				echo "about to equip check"
				status_equip
				equip_check;;
		esac
}

add_equipment(){
	for eqa in "${equipmentNo[@]}"
        do
                if [[ "$1" = "${eqa}" ]]; then
                        eqfound=1
                        break
                fi
        done
        if [[ "${eqfound}" = 1 ]]; then
                equipment[$eqa]=$((equipment[$eqa]+1))
                echo "Obtained ${eqa}"
                eqfound=0
        else
                equipment+=([$1]=1)
                equipmentNo+=($1)
                echo "Obtained $1"
        fi
	echo "--------------------------------------"
        for eqa in "${equipmentNo[@]}"
        do
                echo "$eqa : ${equipment[$eqa]}"
        done
	echo "--------------------------------------"
}

add_item(){
	for eqi in "${inventoryNo[@]}"
	do
		if [[ "$1" = "$eqi" ]]; then
			invfound=1
			break
		fi
	done
	if [[ "${invfound}" = 1 ]]; then	
		inventory[$eqi]=$((inventory[$eqi]+1))
                echo "Obtained ${eqi}"
		invfound=0
	else
		inventory+=([$1]=1)
		inventoryNo+=($1)
		echo "Obtained $1"
	fi
	echo "--------------------------------------"
	for eqi in "${inventoryNo[@]}"
        do
		echo "$eqi : ${inventory[$eqi]}"
        done
	echo "--------------------------------------"
}
