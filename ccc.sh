#!/bin/bash
source funcs.txt

declare -A inventory=(
["Medicine"]=5
["StaminaPill"]=5
["GreenHerbs"]=0
["SenchaTea"]=5
)

declare -a goblin=(
[0]=35
[1]=15
[2]=5
[3]=15
[4]=100
[5]="Fire"
[6]="The Goblin slashes at you with its claws and you take"
[7]="Goblin"
)

declare -a oni=(
[0]=125
[1]=25
[2]=3
[3]=15
[4]=100
[5]="Wind"
[6]="The Oni slams into your chest with a massive club and you take"
[7]="Oni"
)


battle (){
turncount=0
time=0
local enemy=("$@")
for eq in "${!enemy[@]}"
do
        echo "$eq : ${enemy[$eq]}"
done
 echo "Fight Started"
while [[ "${enemy[0]}" > 0 ]];
do
	turncount=$((turncount+1))
	PS3="Pick a number: "
	select option in Fight Defend Run Heal Technique NinjaTools
	do
		case $option in
			Fight)
				#add a miss chance
				DEF=3
				echo "${enemy[0]}"
				ranny=$((RANDOM % 3 + 1))
				POW=$(((stats[STR]+eqstats[STR])*ranny))
				enemy[HP]=$(((enemy[0]-(POW))))
				if [[ "$ranny" = 3 ]]; then
					POWfact="Decisive"
				elif [[ "$ranny" = 2 ]]; then
					POWfact="Solid"
				else
					POWfact="Weak"
				fi
				echo "Enemy took a ${POWfact} hit and lost ${POW} HP"
				echo "${enemy[0]}"
				break;;
			Defend)
				DEF=5
				break;;
			Run)
				DEF=3
				runfactor=$((RANDOM % 6 + 1))
				break;;
			Heal)
				echo "entered heal"
				DEF=3
				ranny=$((RANDOM % 2 + 1))
				ranny2=$((RANDOM % 15 + (stats[WIS]+eqstats[WIS])))
				DocHeal=$(((stats[WIS]+eqstats[WIS]*ranny) + ranny2))
				if [[ "$class" = Doctor ]]; then
					if [[ "${inventory[GreenHerbs]}" < 1 ]]; then
						echo "You're out of herbs!"
						continue
					fi
					stats[HP]=$((stats[HP]+DocHeal))
					if [[ ${stats[HP]} -gt ${stats[MaxHP]} ]]; then
						stats[HP]=${stats[MaxHP]}
					fi
					echo "You spend Green Herbs recover ${DocHeal} HP with your expert healing technique"
					inventory[GreenHerbs]=$((inventory[GreenHerbs]-1))
					whom
					break
				else
					if [[ "${inventory[Medicine]}" < 1 ]]; then
                                                echo "You're out of Medicine!"
                                                continue
                                        fi
					stats[HP]=$((stats[HP]+50))
                                        if [[ ${stats[HP]} -gt ${stats[MaxHP]} ]]; then
                                                stats[HP]=${stats[MaxHP]}
                                        fi
                                        echo "You spend Medicine and give yourself amateur firstaid. You gain 50 HP"
                                        inventory[Medicine]=$((inventory[Medicine]-1))
                                        whom
					break
				fi;;
			Technique)
				PS3="Pick a number: "
				if [[ "$class" = Ronin ]]; then
					select attack in StrongStrike-15- Ichimonji-24- MoonSwallow-10- GambolShroud-35- 
                                	do
                                        	case $attack in
							StrongStrike-15-)
								if [[ "${stats[STA]}" -lt 0 ]]; then
                                                                        echo "You're too out of breath to use this technique"
                                                                        break 1
                                                                fi
                                                                stats[STA]=$((stats[STA]-15))
								DEF=3
								ranny=$((RANDOM % (stats[STR]+eqstats[STR]) + stats[STR]))
								POW=$(((stats[STR]+eqstats[STR])*2))
								POWOW=$((POW+ranny))
								enemy[HP]=$(((enemy[0]-(POWOW))))
								echo "You spend your pent up energy and swing with gusto, dealing ${POW} damage"
								echo "${enemy[0]}"
								break;;
							Ichimonji-24-)
								if [[ "${stats[STA]}" -lt 0 ]]; then
                                                                        echo "You're too out of breath to use this technique"
                                                                        break 1
                                                                fi
                                                                stats[STA]=$((stats[STA]-24))
								DEF=1
                                                                ranny=$((RANDOM % (stats[STR]+eqstats[STR]) + stats[STR]))
                                                                POW=$(((stats[STR]+eqstats[STR])*3))
                                                                POWOW=$((POW+ranny))
                                                                enemy[HP]=$(((enemy[0]-(POWOW))))
                                                                echo "Letting go of your guard, ignorant of all defense, you put yor very soul into one devastating swing, dealing ${POW} damage"
                                                                echo "${enemy[0]}"
                                                                break;;
							MoonSwallow-10-)
								if [[ "${stats[STA]}" -lt 0 ]]; then
                                                                        echo "You're too out of breath to use this technique"
                                                                        break 1
                                                                fi
                                                                stats[STA]=$((stats[STA]-10))
								DEF=3
								dazzleranny=$((RANDOM % 4 + 1))
								if [[ "$dazzleranny" = 4 ]]; then
									dazzle=1
								fi
                                                                ranny=$((RANDOM % (stats[STR]+eqstats[STR]) + stats[STR]))
                                                                POW=$(((stats[STR]+eqstats[STR])+ranny))
                                                                enemy[HP]=$(((enemy[0]-(POW))))
                                                                echo "Channeling the power of the moon you perform a dazzling strike, dealing ${POW} damage"
                                                                echo "${enemy[0]}"
                                                                break;;
							GambolShroud-35-)
								if [[ "${stats[STA]}" -lt 0 ]]; then
                                                                        echo "You're too out of breath to use this technique"
                                                                        break 1
								else
                                                                	stats[STA]=$((stats[STA]-35))
									#
									#add detriments to being out of breath
									#
									DEF=2
									killranny=$((RANDOM % 16 + 1))
									if [[ "${killranny}" = 16 ]]; then
                                                                		echo "You strike at your opponents very soul, felling them in one strike"
										enemy[HP]=0
									else
										echo "You're final technique misses, leaving you wide open"
									fi
                                                                	echo "${enemy[0]}"
                                                                	break
								fi;;
                                        	esac
                                	done
				elif [[ "$class" = Shinobi ]]; then
					select attack in StrongStrike Acupunct Tekkai Rankyaku Soru
					do
						case $attack in
							StrongStrike\[6\])
								if [[ "${stats[STA]}" -lt 6 ]]; then
									echo "You're too out of breath to use this technique"
									continue
								fi
								stats[STA]=$((stats[STA]-6))
								DEF=3
                                                                ranny=$((RANDOM % (stats[STR]+eqstats[STR]) + stats[STR]))
                                                                POW=$(((stats[STR]+eqstats[STR])*2))
                                                                POWOW=$((POW+ranny))
                                                                enemy[HP]=$(((enemy[0]-(POWOW))))
                                                                echo "You spend your pent up energy and swing with gusto, dealing ${POW} damage"
                                                                echo "${enemy[0]}"
								break;;
							Acupunct\[4\])
								if [[ "${stats[STA]}" -lt 4 ]]; then
                                                                        echo "You're too out of breath to use this technique"
                                                                        continue
                                                                fi
								stats[STA]=$((stats[STA]-4))
								DEF=3
                                                                ranny=$((RANDOM % 15 + 8))
                                                                POW=$(((stats[STR]+eqstats[STR])*1))
                                                                POWOW=$((POW+ranny))
                                                                enemy[HP]=$(((enemy[0]-(POWOW))))
								acuranny=$((RANDOM % 6 + 1))
                                                                if [[ "$acuranny" = 6 ]]; then
                                                                        echo "You strike at your targets pressure points, leaving them paralyzed"
									acu=1
								else
									echo "You strike at your targets pressure points, but fail to paralyze them"
                                                                fi
                                                                echo "${enemy[0]}"
								break;;
							Tekkai\[7\])
								if [[ "${stats[STA]}" -lt 7 ]]; then
                                                                        echo "You're too out of breath to use this technique"
                                                                        continue
                                                                fi
								stats[STA]=$((stats[STA]-7))
								DEF=5
                                                                POW=$(((stats[AGI]+eqstats[AGI])*1))
                                                                enemy[HP]=$(((enemy[0]-(POW))))
                                                                echo "You harden the breath in your lungs, dealing a palm strike while holding your guard up"
                                                                echo "${enemy[0]}"
								break;;
							Rankyaku\[8\])
								if [[ "${stats[STA]}" -lt 8 ]]; then
                                                                        echo "You're too out of breath to use this technique"
                                                                        continue
                                                                fi
								stats[STA]=$((stats[STA]-8))
								DEF=3
                                                                ranny=$((RANDOM % 15 + 8))
                                                                POW=$(((stats[AGI]+eqstats[AGI])*1))
                                                                POWOW=$((POW+ranny))
								if [[ "${enemy[5]}" = Wind ]]; then
									enemy[HP]=$(((enemy[0]-(POWOW*2))))
									echo "You deliver a powerful kick, kicking up a gust of wind weakness"
								else
									enemy[HP]=$(((enemy[0]-(POWOW))))
									echo "No weakness"
								fi
                                                                echo "${enemy[0]}"
                                                                break;;
							Soru\[6\])
								if [[ "${stats[STA]}" -lt 6 ]]; then
                                                                        echo "You're too out of breath to use this technique"
                                                                        continue
                                                                fi
								stats[STA]=$((stats[STA]-6))
								runfactor=6
								echo "You vanish before your opponents eyes"
								break;;
						esac
					done
				else 
					select attack in StrongStrike Scope
                                	do
                                        	case $attack in
                                                	#work on these next, decide if you want to do class based or stat based
                                        	esac
                                	done
				fi
				break;;
			NinjaTools)
				break;;
		esac
	done
	if [[ ${enemy[HP]} -lt 1 ]]; then
		echo "${enemy[7]} has been defeated."
		sleep 1
		echo "You gained ${enemy[3]} yen and ${enemy[4]} experience."
		break
	elif [[ "${runfactor}" = 6 ]]; then
		echo "You ran away"
		runfactor=0
		break
	elif [[ "${runfactor}" -gt 0 ]]; then
		echo "You failed to run away!"
		runfactor=0
	elif [[ "${acu}" = 1 ]]; then
		time=$((time+1))
		echo "The enemy is paralyzed!"
		if [[ "${time}" -gt 1 ]]; then
			if [[ $((RANDOM % 2 + 1)) = 2 ]]; then
				acu=0
				time=0
				echo "The enemy has regained composure"
			fi
		fi
		continue
	elif [[ "${dazzle}" = 1 ]]; then
		echo "The enemy was dazzled!"
		dazzle=0
		continue
	fi
	sleep 0.5
	ranny=$((RANDOM % 3 + 1))
	enemyPOW=$(((enemy[1]*ranny)/DEF))
	if [[ "$DEF" -lt 4 ]]; then
		echo "${enemy[6]} $(((enemy[1]*ranny)/DEF)) damage"
	else
		echo "You glance off the attack and take ${enemyPOW} damage"
	fi
	stats[HP]=$((stats[HP]-enemyPOW))
	stats[STA]=$((stats[STA]+(stats[AGI]/2)))
	if [[ "${stats[STA]}" -gt "${stats[MaxSTA]}" ]]; then
		stats[STA]=${stats[MaxSTA]}
	fi
	whom
done
}
level_up(){
	echo "You've ascended to level ${resources[LVL]}!"
	for stat in "${!stats[@]}"
	do
        	echo "$stat : ${stats[$stat]} + ${eqstats[$stat]}"
	done
	for stat in "${!stats[@]}"
	do
		stat=$((stat+1))
	done
	for stat in "${!stats[@]}"
	do
        	echo "$stat : ${stats[$stat]} + ${eqstats[$stat]}"
	done
}

give_exp(){
	echo "give exp entered $1"
	sleep 1
	exp=("$1")
	resources[EXP]=$((resources[EXP]+exp))
	if [[ "${resouces[EXP]}" -gt "${resouces[NEXP]}" ]]; then
		resources[EXP]=$((resources[EXP]-resources[NEXP]))
		resources[NEXP]=$((resources[NEXP]*2))
		resources[LVL]=$((resources[LVL]+1))
		level_up
	fi

}

declare -A stats=(
["STR"]=5
["INT"]=5
["WIS"]=5
["END"]=5
["GUI"]=5
["AGI"]=5
["MaxHP"]=1
["HP"]=${stats[MaxHP]}
["MaxSTA"]=1
["STA"]=${stats[MaxSTA]}
)

declare -A resources=(
["LVL"]=1
["EXP"]=0
["NEXP"]=100
["GOLD"]=0
)

declare -A flags=(
["menuState"]=0
["battleState"]=0
["saveflag"]=0
["loadflag"]=0
)

declare -A eqstats=(
["STR"]=0
["INT"]=0
["END"]=0
["AGI"]=0
["WIS"]=0
)

declare -A equip=(
["HEAD"]=
["BODY"]=
["WEAPON"]=
)

if [[ -f "save.conf" ]]; then
	source "save.conf"
	echo "source??"
fi
	
if [[ "${flags[loadflag]}" < 1 ]]; then
echo "$1"
echo "The hunt for the nameless blade is upon us."
sleep 1 
echo "Like a star fallen from the sky, hundreds of the greatest warriors, tacticians and world-shapers the province has ever seen are after this legendary weapon that seemed to have been sent by the gods themselves."
sleep 1
echo "Hidden deep in the center of Izanami's Forest, do you have the strength to obtain the greatest treasure? Or will you fall like the others that came before?"
sleep 1
read -p "What do they call you: " name
read -p "How long have you been on this earth: " age
if [[ "$age" > 40 ]]; then
	echo "With great years comes great wisdom, you will be blessed with guile but inferior in strength"
	stats[INT]=$((stats[INT]+5))
	stats[WIS]=$((stats[WIS]+5))
	agech1="Royal"
	agech2="Born to unimaginable wealth yet no throne to show for it, your bloodgiven seat forever filled by the oafish lot that is your king. You seek retribution, you seek your birthright, all that lies within. And you have the resources to get it."
	sleep 2
else
	echo "With youth comes great vigor, you are foolhardy but your power can only keep growing"
	stats[STR]=$((stats[STR]+5))
	stats[END]=$((stats[END]+5))
	agech1="Scion"
	agech2="Born to unimaginable wealth and unbearable responsiblity, the royal tutors made sure you grew up well learned in arts of hand and war but you still lack much in foresight."
	sleep 2
fi
echo "Before finding yourself wound up in such an untenable quest, what work did your hands find themselves in"
PS3="Pick a number: "
select character in Farmer ${agech1} Destitute Doctor Ronin Shinobi
do
	class=${character}
	case $character in 
		Farmer)
			echo "A man of the earth who finds himself in depths far beyond him, you are strong from years of backbreaking labour and have always been known for your wit"
			read -p "confirm [y/n]: " resp1
			if [[ "$resp1" == y || "$resp1" == Y ]]; then
				stats[STR]=$((stats[STR]+2))
				stats[WIS]=$((stats[WIS]+2))
				stats[INT]=$((stats[INT]+2))
				stats[GUI]=$((stats[GUI]+2))
                                stats[AGI]=$((stats[AGI]+2))
                                stats[END]=$((stats[END]+2))
				equip[HEAD]=WoolCap
				break
			else
				continue
			fi;;
		${agech1})
			echo "${agech2}"
			read -p "confirm [y/n]: " resp1
                        if [[ "$resp1" == y || "$resp1" == Y ]]; then
				stats[STR]=$((stats[STR]+5))
				stats[END]=$((stats[END]+5))
				stats[GUI]=$((stats[GUI]+5))
                                break
                        else
                                continue
                        fi;;
		Destitute)
			echo "Born into poverty, not even the scraps on your back belong to you. Your birth was insignificant and your life a meaningless struggle, but alas you may yet find your worth in the pit."
			read -p "confirm [y/n]: " resp1
                        if [[ "$resp1" == y || "$resp1" == Y ]]; then
				stats[STR]=$((stats[STR]-1))
                                stats[WIS]=$((stats[WIS]-1))
                                stats[INT]=$((stats[INT]-1))
                                stats[GUI]=$((stats[GUI]-1))
                                stats[AGI]=$((stats[AGI]-1))
                                stats[END]=$((stats[END]-1))
                                break
                        else
                                continue
                        fi;;
		Doctor)
			echo "A healer of men, a combat medic, a learned medicine man. Though you've spent your whole life giving life those who may not even deserve, you seek a weapon that can only take. Your skill with people and bodies will serve you well"
			read -p "confirm [y/n]: " resp1
                        if [[ "$resp1" == y || "$resp1" == Y ]]; then
				stats[WIS]=$((stats[WIS]+6))
                                stats[INT]=$((stats[INT]+4))
                                stats[GUI]=$((stats[GUI]+2))
                                break
                        else
                                continue
                        fi;;
		Ronin)
			echo "A former samurai who has performed a slight against his lord, whether intentionally or not, whether righteously or not"
			read -p "confirm [y/n]: " resp1
                        if [[ "$resp1" == y || "$resp1" == Y ]]; then
				stats[STR]=$((stats[STR]+6))
                                stats[END]=$((stats[END]+2))
                                stats[AGI]=$((stats[AGI]+4))
                                break
                        else
                                continue
                        fi;;
		Shinobi)
			echo "The shinobi are warriors whose existence is myth. They dance in shadow and attack only when moonlight strikes their targets eyes."
			read -p "confirm [y/n]: " resp1
                        if [[ "$resp1" == y || "$resp1" == Y ]]; then
				stats[AGI]=$((stats[AGI]+8))
                                stats[INT]=$((stats[INT]+4))
                                break
                        else
                                continue
                        fi;;
	esac
done
sleep 2
equip_check
SUM_HP1=$((stats[END]+eqstats[END]))
SUM_HP2=$((stats[WIS]+eqstats[WIS]))
stats[MaxHP]=$(((SUM_HP1*10)+(SUM_HP2*3)))
stats[HP]=${stats[MaxHP]}
stats[MaxSTA]=$(((stats[AGI]+stats[END]+eqstats[AGI]+eqstats[END])*3))
stats[STA]=${stats[MaxSTA]}

echo "These are your parameters"
for stat in "${!stats[@]}"
do
	echo "$stat : ${stats[$stat]} + ${eqstats[$stat]}"
done
sleep 1
echo "Your name is ${name}. You are a ${age}-year old ${class} with ${stats[MaxHP]} HP and ${stats[MaxSTA]} Stamina. "
for eq in "${!equip[@]}"
do
	echo "$eq : ${equip[$eq]}"
done
flags[saveflag]=1
flags[loadflag]=1
save
fi
status_stats
status_equip
whom
echo "This is the beginning"
battle "${oni[@]}"

