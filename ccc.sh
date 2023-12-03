#!/bin/bash
source funcs.txt
source inv.txt
source town.sh
source stats.txt
source battle.txt
source dunj.txt
source deimos.txt

declare -A stats=(
["STR"]=5
["INT"]=5
["WIS"]=5
["END"]=5
["GUI"]=5
["AGI"]=5
)

declare -A derived=(
["MaxHP"]=1
["HP"]=1
["MaxSTA"]=1
["STA"]=1
)

declare -A resources=(
["LVL"]=1
["EXP"]=0
["NEXP"]=100
["GOLD"]=100
["MAG"]=50
)

declare -A statusfx=(
["EnExhaust"]=0
["sealed"]=0
["toxin"]=0
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
echo "The hunt for the nameless blade is upon us."
sleep 1 
echo "Like a star fallen from the sky, hundreds of the greatest warriors, tacticians and world-shapers the province has ever seen are after this legendary weapon that seemed to have been sent by the gods themselves."
sleep 1
echo "Hidden deep in the center of Izanami's Forest, do you have the strength to obtain the greatest treasure? Or will you fall like the others that came before?"
sleep 1
echo "What do they call you: "
read -a name
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
derived[MaxHP]=$(((SUM_HP1*10)+(SUM_HP2*3)+(LVL*15)))
derived[HP]=${derived[MaxHP]}
derived[MaxSTA]=$(((stats[AGI]+stats[END]+eqstats[AGI]+eqstats[END])*3))
derived[STA]=${derived[MaxSTA]}

echo "These are your parameters"
for stat in "${!stats[@]}"
do
	echo "$stat : ${stats[$stat]} + ${eqstats[$stat]}"
done
sleep 1
echo "Your name is ${name[@]}. You are a ${age}-year old ${class} with ${derived[MaxHP]} HP and ${derived[MaxSTA]} Stamina. "
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
add_item Elixir
add_equipment BloodiedDagger
sleep 1
town 
battle "${oni[@]}"

