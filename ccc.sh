#!/bin/bash
source funcs.txt

declare -a goblin=(
[0]=100
[1]=5
[2]=5
[3]=15
[4]=100
)


battle (){
local enemy=("$@")
for eq in "${!enemy[@]}"
do
        echo "$eq : ${enemy[$eq]}"
done
 echo "Fight Started"
while [[ "${enemy[0]}" > 0 ]];
do
	PS3="Pick a number: "
	select option in Fight Defend Run Heal Technique NinjaTools
	do
		case $option in
			Fight)
				DEF=1
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
				DEF=2
				break;;
			Run)
				DEF=1
				break;;
			Heal)
				echo "entered heal"
				DEF=1
				ranny=$((RANDOM % 2 + 1))
				ranny2=$((RANDOM % 15 + (stats[WIS]+eqstats[WIS])))
				DocHeal=$(((stats[WIS]+eqstats[WIS]*ranny) + ranny2))
				if [[ "$class" = Doctor ]]; then
					stats[HP]=$((stats[HP]+DocHeal))
					if [[ ${stats[HP]} -gt ${stats[MaxHP]} ]]; then
						stats[HP]=${stats[MaxHP]}
					fi
					echo "You recover ${DocHeal} HP with your expert healing technique"
					whom
					break
				else
					echo "You must be a \'Doctor\' to use this skill"
					continue
				fi;;
			Technique)
				break;;
			NinjaTools)
				break;;
		esac
	done
	sleep 0.5
	ranny=$((RANDOM % 3 + 1))
	enemyPOW=$(((enemy[1]*ranny)/DEF))
	if [[ "$DEF" = 1 ]]; then
		echo "The enemy retaliates and you take $(((enemy[1]*ranny)/DEF)) damage"
	else
		echo "You glance off the attack and take ${enemyPOW} damage"
	fi
	stats[HP]=$((stats[HP]-enemyPOW))
	whom
done
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
["STA"]=1
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
	stats[STR]=$((stats[STR]+5))
	stats[WIS]=$((stats[WIS]+10))
	agech1="Royal"
	agech2="Born to unimaginable wealth yet no throne to show for it, your bloodgiven seat forever filled by the oafish lot that is your king. You seek retribution, you seek your birthright, all that lies within. And you have the resources to get it."
	sleep 2
else
	echo "With youth comes great vigor, you are foolhardy but your power can only keep growing"
	stats[STR]=$((stats[STR]+10))
	stats[WIS]=$((stats[WIS]+5))
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
stats[STA]=$(((stats[AGI]+stats[END]+eqstats[AGI]+eqstats[END])*2))

echo "These are your parameters"
for stat in "${!stats[@]}"
do
	echo "$stat : ${stats[$stat]} + ${eqstats[$stat]}"
done
sleep 1
echo "Your name is ${name}. You are a ${age}-year old ${class} with ${stats[MaxHP]} HP and ${stats[STA]} Stamina. "
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
battle "${goblin[@]}"
