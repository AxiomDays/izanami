declare -a playerMagArr=("Scathe" "Flood" "Blitz" "Hurricane" "Exit")
battle (){
turncount=0
time=0
chargevar=0
buffValue=0
activeSpellElement="None"
local enemy=("$@")
echo "__________________________________________________________________________________"
sleep 0.5
echo "You encountered ${enemy[7]}"
while [[ "${enemy[0]}" > 0 ]];
do
	derived[STA]=$((derived[STA]+(stats[AGI]/2)))
        if [[ "${derived[STA]}" -gt "${derived[MaxSTA]}" ]]; then
                derived[STA]=${derived[MaxSTA]}
        fi
	whom
	turncount=$((turncount+1))
	if [[ "${statusfx[EnExhaust]}" = 1 ]]; then
		echo "Your energy is being drained! You lose $((derived[MaxSTA]/4)) stamina."
		derived[STA]=$((derived[STA]-(derived[MaxSTA]/4)))
	fi
	if [[ "${statusfx[toxin]}" = 1 ]]; then
		echo "Toxin floods your lungs! You lose $((derived[MaxHP]/7)) HP."
                derived[HP]=$((derived[HP]-(derived[MaxHP]/7)))
        fi
	if [[ "${bloodvow}" = 1 ]]; then
		bftime=$((bftime+1))
		derived[HP]=$((derived[HP]-(derived[MaxHP]/5)))
		derived[STA]=$((derived[STA]-(derived[MaxSTA]/10)))
		if [[ "$bftime" -ge 3 ]]; then
                        bloodvow=0
                        stats[STR]=$((stats[STR]-stats[GUI]))
                fi
		 echo "Your bloodvow takes effect! You lose $((derived[MaxHP]/5)) HP and $((derived[MaxSTA]/10)) Stamina"
	fi
	PS3="Pick a number: "
	select option in Fight Magic Defend Heal Technique NinjaTools Item Run
	do
		case $option in
			Fight)
				#add a miss chance
				DEF=3
				echo "${enemy[0]}"
				ranny=$((RANDOM % 12 + 1))
				hitchance=$((RANDOM % (100/(stats[AGI]+eqstats[AGI])) + 1))
				if [[ "${hitchance}" -gt 6 ]]; then
					echo "You missed!"
					sleep 1
					break
				fi
				POW=$(((stats[STR]+eqstats[STR]+buffValue)))
				if [[ "$ranny" -gt 10 ]]; then
					POWfact="Decisive"
					fightmod=2
				elif [[ "$ranny" -ge 4 ]]; then
					POWfact="Solid"
					fightmod=1
				else
					POWfact="Weak"
					fightmod=1
				fi
				if [[ "${activeElement}" = "${enemy[5]}" ]]; then
					fightmod=$((fightmod*2))
					echo "Your weapon strikes at its weakness!"
				fi
				enemy[0]=$((enemy[0]-(POW*fightmod)))
				echo "Enemy took a ${POWfact} hit and lost $((POW*fightmod)) HP"
				echo "${enemy[0]}"
				break;;
			Magic)
				DEF=3
				select spell in ${playerMagArr[@]}
				do
					echo "${enemy[0]}"
					case $spell in
						Scathe)
							 if [[ "${resources[MAG]}" -le 5 ]]; then
                                                                        echo "You're out of MAG!"
                                                                        continue
                                                         fi
							 echo "The Hellish flames of Sage Veneer that burn eternally (MAG COST: 5)"
							 read -p "[y/n]" respmag
							 if [[ "$respmag" != y ]]; then
								 continue
							 fi
							 MagBoost
							 POW=$(($(((stats[INT]+eqstats[INT])*2)) * $((BoostVal/100))))
							 if [[ "${enemy[5]}" = "Fire" ]]; then
								 POW=$((POW*3))
								 echo "The enemy is weak!"
							 fi
                                                         enemy[0]=$((enemy[0]-POW))
							 echo "The enemy is consumed by an explosion of flames, taking $((POW)) damage!"
							 sleep 1
							 if [[ "$activeSpellElement" = "Wind" ]]; then
                                                                 enemy[0]=$((enemy[0]-POW/2))
                                                                 echo "A concurrence occurs! Your flames and wind combine to deal $((POW/2)) damage!"
								 whom
								 activeSpellElement="None"
								 break
                                                         fi
							 activeSpellElement="Fire"
                                                         whom
                                                         break;;
						Flood)
                                                         if [[ "${resources[MAG]}" -le 5 ]]; then
                                                                        echo "You're out of MAG!"
                                                                        continue
                                                         fi
                                                         echo "Channel the crushing weight of Great Serpent's Seas (MAG COST: 5)"
                                                         read -p "[y/n]" respmag
                                                         if [[ "$respmag" != y ]]; then
                                                                 continue
                                                         fi
							 MagBoost
							  POW=$(($(((stats[INT]+eqstats[INT])*2)) * $((BoostVal/100))))
							 if [[ "${enemy[5]}" = "Water" ]]; then
                                                                 POW=$((POW*3))
                                                                 echo "The enemy is weak!"
                                                         fi
                                                         enemy[0]=$((enemy[0]-POW))
                                                         echo "The enemy is swallowed by crushing waves, dealing $((POW)) dmg"
                                                         sleep 1
                                                         activeSpellElement="Water"
                                                         whom
                                                         break;;
						Blitz)
                                                         if [[ "${resources[MAG]}" -le 5 ]]; then
                                                                        echo "You're out of MAG!"
                                                                        continue
                                                         fi
                                                         echo "The Black Red Sky cracks open with the roar of the gods (MAG COST: 5)"
                                                         read -p "[y/n]" respmag
                                                         if [[ "$respmag" != y ]]; then
                                                                 continue
                                                         fi
							 MagBoost
							  POW=$(($(((stats[INT]+eqstats[INT])*2)) * $((BoostVal/100))))
                                                         if [[ "${enemy[5]}" = "Bolt" ]]; then
                                                                 POW=$((POW*3))
                                                                 echo "The enemy is weak!"
                                                         fi
                                                         enemy[0]=$((enemy[0]-POW))
                                                         echo "The enemy is violently electrocuted, dealing $((POW)) dmg"
                                                         sleep 1
							 if [[ "$activeSpellElement" = "Water" ]]; then
                                                                 enemy[0]=$((enemy[0]-POW/2))
                                                                 echo "A concurrence occurs! Your waters and thunder combine to deal $((POW/2)) damage!"
                                                                 whom
                                                                 activeSpellElement="None"
                                                                 break
                                                         fi
                                                         activeSpellElement="Bolt"
                                                         whom
                                                         break;;
						Hurricane)
                                                         if [[ "${resources[MAG]}" -le 5 ]]; then
                                                                        echo "You're out of MAG!"
                                                                        continue
                                                         fi
                                                         echo "Channel the imprgnable winds of the ancient dragons (MAG COST: 5)"
                                                         read -p "[y/n]" respmag
                                                         if [[ "$respmag" != y ]]; then
                                                                 continue
                                                         fi
							 MagBoost
							  POW=$(($(((stats[INT]+eqstats[INT])*2)) * $((BoostVal/100))))
                                                         if [[ "${enemy[5]}" = "Wind" ]]; then
                                                                 POW=$((POW*3))
                                                                 echo "The enemy is weak!"
                                                         fi
                                                         enemy[0]=$((enemy[0]-POW))
                                                         echo "The enemy is consumed in a wall of wind, dealing $((POW)) dmg"
                                                         sleep 1
                                                         activeSpellElement="Wind"
                                                         whom
                                                         break;;
						Exit)
                                                                techbreak=1
                                                                break;;	
					esac
				done
				if [[ "${techbreak}" = 1 ]]; then
                                        techbreak=0
                                        continue
                                fi
				break;;
			Defend)
				DEF=4
				derived[STA]=$((derived[STA]+(stats[AGI]/2)))
				if [[ "${derived[STA]}" -gt "${derived[MaxSTA]}" ]]; then
					derived[STA]=${derived[MaxSTA]}
				fi
				break;;
			Run)
				DEF=3
				runfactor=$((RANDOM % 6 + 1))
				break;;
			Item)
				DEF=3
				for eq in "${!inventory[@]}"
                                                do
                                                        echo "$eq : ${inventory[$eq]}"
                                                done
				PS3="Pick a Number: "
				select item in ${inventoryNo[@]}
				do
					case $item in
						Medicine)
							if [[ "${inventory[$item]}" < 1 ]]; then
                                                		echo "You're out of this item! ${inventory[$item]}"
                                                		continue
	                                        	fi
	                         	               	derived[HP]=$((derived[HP]+50))
        	                                	if [[ ${derived[HP]} -gt ${derived[MaxHP]} ]]; then
                	                                	derived[HP]=${derived[MaxHP]}
                        	                	fi
                                	        	echo "You spend Medicine and give yourself amateur firstaid. You gain 50 HP"
                                        		inventory[Medicine]=$((inventory[Medicine]-1))
							break;;
						Tonic)
                                                        if [[ "${inventory[$item]}" < 1 ]]; then
                                                                echo "You're out of this item! ${inventory[$item]}"
                                                                continue
                                                        fi
                                                        derived[HP]=$((derived[HP]+200))
                                                        if [[ ${derived[HP]} -gt ${derived[MaxHP]} ]]; then
                                                                derived[HP]=${derived[MaxHP]}
                                                        fi
                                                        echo "You spend Tonic and give yourself amateur firstaid. You gain 200 HP"
                                                        inventory[Tonic]=$((inventory[Tonic]-1))
                                                        break;;
						StaminaPill)
							if [[ "${inventory[$item]}" < 1 ]]; then
                                                		echo "You're out of this item! STAM"
                                                		continue
	                                        	fi
	                         	               	derived[STA]=$((derived[STA]+50))
        	                                	if [[ ${derived[STA]} -gt ${derived[MaxSTA]} ]]; then
                	                                	derived[STA]=${derived[MaxSTA]}
                        	                	fi
							echo "You used a StaminaPill. You restored STA"
                                        		inventory[$item]=$((inventory[$item]-1))
							break;;
						SenchaTea)
							if [[ "${inventory[$item]}" < 1 ]]; then
                                                                echo "You're out of this item! TEA"
                                                                continue
                                                        fi
                                                        derived[STA]=$((derived[STA]+50))
							derived[HP]=$((derived[HP]+50))
                                                        if [[ ${derived[STA]} -gt ${derived[MaxSTA]} ]]; then
                                                                derived[STA]=${derived[MaxSTA]}
                                                        fi
							if [[ ${derived[HP]} -gt ${derived[MaxHP]} ]]; then
                                                                derived[HP]=${derived[MaxHP]}
                                                        fi
							inventory[$item]=$((inventory[$item]-1))
                                                        echo "You used a Sencha Tea. You refilled HP and STA"
							break;;
						FiveFingerSeal)
							if [[ "${inventory[$item]}" < 1 ]]; then
                                                                echo "You're out of this item!"
                                                                continue
                                                        fi
							statusfx[sealed]=0
                                                        echo "You used a Five Finger Seal. You cured seal."
                                                        inventory[$item]=$((inventory[$item]-1))
                                                        break;;
						Antidote)
							if [[ "${inventory[$item]}" < 1 ]]; then
                                                                echo "You're out of this item!"
                                                                continue
                                                        fi
                                                        statusfx[toxin]=0
                                                        echo "You used an antidote. You cured toxin."
                                                        inventory[$item]=$((inventory[$item]-1))
                                                        break;;
						EnergyCandy)
							if [[ "${inventory[$item]}" < 1 ]]; then
                                                                echo "You're out of this item!"
                                                                continue
                                                        fi
                                                        statusfx[EnExhaust]=0
                                                        echo "You used a Energy Candy. You cured Energy Exhaust."
                                                        inventory[$item]=$((inventory[$item]-1))
                                                        break;;
						Panacea)
							if [[ "${inventory[$item]}" < 1 ]]; then
                                                                echo "You're out of this item!"
                                                                continue
                                                        fi
							statusfx[toxin]=0
							statusfx[EnExhaust]=0
                                                        statusfx[sealed]=0
                                                        echo "You used a Panacea. Whoo, all status effects gone!"
                                                        inventory[$item]=$((inventory[$item]-1))
                                                        break;;
						KobanCoin)
							if [[ "${inventory[$item]}" < 1 ]]; then
                                                                echo "You're out of this item!"
                                                                continue
                                                        fi
                                                        statusfx[toxin]=0
                                                        statusfx[EnExhaust]=0
                                                        statusfx[sealed]=0
							derived[STA]=$((derived[STA]+100))
                                                        derived[HP]=$((derived[HP]+100))
                                                        if [[ ${derived[STA]} -gt ${derived[MaxSTA]} ]]; then
                                                                derived[STA]=${derived[MaxSTA]}
                                                        fi
                                                        if [[ ${derived[HP]} -gt ${derived[MaxHP]} ]]; then
                                                                derived[HP]=${derived[MaxHP]}
                                                        fi
                                                        echo "You used Kobaneko's Coin. Your ails are gone!? You feel lucky already!"
                                                        inventory[$item]=$((inventory[$item]-1))
                                                        break;;
						CrowCharm)
							if [[ "${inventory[$item]}" < 1 ]]; then
                                                                echo "You're out of this item!"
                                                                continue
                                                        fi
							enemy[HP]=$((enemy[0]-(enemy[0]/2)))
							derived[HP]=$((derived[HP]+(enemy[0]/2)))
                                                        if [[ ${derived[HP]} -gt ${derived[MaxHP]} ]]; then
                                                                derived[HP]=${derived[MaxHP]}
                                                        fi
							echo "You used Dr Crowley's Coin. You sap half of your opponent's energy! What a malicious item..."
                                                        inventory[$item]=$((inventory[$item]-1))
                                                        break;;
						*)
							echo "This item can't be used this way..."
							continue;;
					esac
				done
				break;;
			Heal)
				echo "entered heal"
				DEF=3
				ranny2=$((RANDOM % 15 + (stats[WIS]+eqstats[WIS])*2))
				DocHeal=$(((stats[WIS]+eqstats[WIS])*3 + ranny2))
				if [[ "$class" = Doctor ]]; then
					select herb in GreenHerbs RedHerbs BlueHerbs Exit
					do
						case $herb in
							GreenHerbs)
								if [[ "${inventory[GreenHerbs]}" < 1 ]]; then
									echo "You're out of herbs!"
									continue
								fi
								derived[HP]=$((derived[HP]+DocHeal))
								if [[ ${derived[HP]} -gt ${derived[MaxHP]} ]]; then
									derived[HP]=${derived[MaxHP]}
								fi
								echo "You spend Green Herbs recover ${DocHeal} HP with your expert healing technique"
								inventory[GreenHerbs]=$((inventory[GreenHerbs]-1))
								whom
								break;;
							RedHerbs)
								if [[ "${inventory[RedHerbs]}" < 1 ]]; then
									echo "You're out of herbs!"
									continue
								fi
								derived[HP]=$((derived[HP]+DocHeal))
								buffValue=$((stats[WIS]/2))
								if [[ ${derived[HP]} -gt ${derived[MaxHP]} ]]; then
									derived[HP]=${derived[MaxHP]}
								fi
								echo "You spend Red Herbs and recover ${DocHeal} HP with your expert healing technique. You're filled with roaring strength"
								inventory[RedHerbs]=$((inventory[RedHerbs]-1))
								whom
								break;;
							BlueHerbs)	
                                                                if [[ "${inventory[BlueHerbs]}" < 1 ]]; then
                                                                        echo "You're out of herbs!"
                                                                        continue
                                                                fi
								derived[STA]=$((derived[STA]+(DocHeal/2)))
                                                                if [[ ${derived[STA]} -gt ${derived[MaxSTA]} ]]; then
                                                                        derived[STA]=${derived[MaxSTA]}
                                                                fi
								echo "You spend Blue Herbs and recover $((DocHeal/2)) STA with your expert healing technique."
								echo "Your ailments seem to be allleviated."
								statusfx[sealed]=0
								statusfx[EnExhaust]=0
								statusfx[toxin]=0
                                                                inventory[BlueHerbs]=$((inventory[BlueHerbs]-1))
                                                                whom
                                                                break;;
							Exit)
								echo "Heal Menu Exited"
								continue;;

						esac
					done
				else
				echo "You have no worthwhile medical skills..."
				continue
				fi
				break;;
			Technique)
				if [[ "${statusfx[sealed]}" = 1 ]]; then
					DEF=3
					echo "Your techniques are sealed!"
					continue
				fi
				PS3="Pick a number: "
				if [[ "$class" = Ronin ]]; then
					select attack in StrongStrike-15- Ichimonji-24- MoonSwallow-10- GambolShroud-35- 
                                	do
                                        	case $attack in
							StrongStrike-15-)
								if [[ "${derived[STA]}" -lt 0 ]]; then
                                                                        echo "You're too out of breath to use this technique"
									techbreak=1
									break
                                                                fi
                                                                derived[STA]=$((derived[STA]-15))
								DEF=3
								ranny=$((RANDOM % (stats[STR]+eqstats[STR]) + stats[STR]))
								POW=$(((stats[STR]+eqstats[STR])*2))
								POWOW=$((POW+ranny))
								enemy[HP]=$(((enemy[0]-(POWOW))))
								echo "You spend your pent up energy and swing with gusto, dealing ${POW} damage"
								echo "${enemy[0]}"
								break;;
							Ichimonji-24-)
								if [[ "${derived[STA]}" -lt 0 ]]; then
                                                                        echo "You're too out of breath to use this technique"
									techbreak=1
									break
                                                                fi
                                                                derived[STA]=$((derived[STA]-24))
								DEF=1
                                                                ranny=$((RANDOM % (stats[STR]+eqstats[STR]) + stats[STR]))
                                                                POW=$(((stats[STR]+eqstats[STR])*3))
                                                                POWOW=$((POW+ranny))
                                                                enemy[HP]=$(((enemy[0]-(POWOW))))
                                                                echo "Letting go of your guard, ignorant of all defense, you put yor very soul into one devastating swing, dealing ${POWOW} damage"
                                                                echo "${enemy[0]}"
                                                                break;;
							MoonSwallow-10-)
								if [[ "${derived[STA]}" -lt 0 ]]; then
                                                                        echo "You're too out of breath to use this technique"
									techbreak=1
									break
                                                                fi
                                                                derived[STA]=$((derived[STA]-10))
								DEF=3
								dazzleranny=$((RANDOM % 4 + 1))
								if [[ "$dazzleranny" = 4 ]]; then
									local dazzle=1
								fi
                                                                ranny=$((RANDOM % (stats[STR]+eqstats[STR]) + stats[STR]))
                                                                POW=$(((stats[STR]+eqstats[STR])+ranny))
                                                                enemy[HP]=$(((enemy[0]-(POW))))
                                                                echo "Channeling the power of the moon you perform a dazzling strike, dealing ${POW} damage"
                                                                echo "${enemy[0]}"
                                                                break;;
							GambolShroud-35-)
								if [[ "${derived[STA]}" -lt 0 ]]; then
                                                                        echo "You're too out of breath to use this technique"
									techbreak=1
									break
								else
                                                                	derived[STA]=$((derived[STA]-35))
									#
									#add detriments to being out of breath
									#add game over state
									#1 town and one dungeon with three floors
									#use select with an array for left and right turn choices
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
					select attack in StrongStrike-15- Acupunct-27- Tekkai-32- Rankyaku-22- Soru-45- Back
					do
						case $attack in
							StrongStrike-15-)
								if [[ "${derived[STA]}" -lt 0 ]]; then
									echo "You're too out of breath to use this technique"
									techbreak=1
									break
								fi
								derived[STA]=$((derived[STA]-15))
								DEF=3
                                                                ranny=$((RANDOM % (stats[STR]+eqstats[STR]) + stats[STR]))
                                                                POW=$(((stats[STR]+eqstats[STR])*2))
                                                                POWOW=$((POW+ranny))
                                                                enemy[HP]=$(((enemy[0]-(POWOW))))
                                                                echo "You spend your pent up energy and swing with gusto, dealing ${POW} damage"
                                                                echo "${enemy[0]}"
								break;;
							Acupunct-27-)
								if [[ "${derived[STA]}" -lt 0 ]]; then
                                                                        echo "You're too out of breath to use this technique"
									techbreak=1
									break
                                                                fi
								derived[STA]=$((derived[STA]-27))
								DEF=3
                                                                ranny=$((RANDOM % 15 + 8))
                                                                POW=$(((stats[STR]+eqstats[STR])*1))
                                                                POWOW=$((POW+ranny))
                                                                enemy[HP]=$(((enemy[0]-(POWOW))))
								acuranny=$((RANDOM % 6 + 1))
                                                                if [[ "$acuranny" = 6 ]]; then
                                                                        echo "You strike at your targets pressure points, leaving them paralyzed"
									local acu=1
								else
									echo "You strike at your targets pressure points, but fail to paralyze them"
                                                                fi
                                                                echo "${enemy[0]}"
								break;;
							Tekkai-32-)
								if [[ "${derived[STA]}" -lt 0 ]]; then
                                                                        echo "You're too out of breath to use this technique"
									techbreak=1
									break
                                                                fi
								derived[STA]=$((derived[STA]-32))
								DEF=5
                                                                POW=$(((stats[AGI]+eqstats[AGI])*1))
                                                                enemy[HP]=$(((enemy[0]-(POW))))
                                                                echo "You harden the breath in your lungs, dealing a palm strike while holding your guard up"
                                                                echo "${enemy[0]}"
								break;;
							Rankyaku-22-)
								if [[ "${derived[STA]}" -lt 0 ]]; then
                                                                        echo "You're too out of breath to use this technique"
									techbreak=1
									break
                                                                fi
								derived[STA]=$((derived[STA]-22))
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
							Soru-45-)
								if [[ "${derived[STA]}" -lt 45 ]]; then
                                                                        echo "You're too out of breath to use this technique"
                                                                        techbreak=1
									break
                                                                fi
								derived[STA]=$((derived[STA]-45))
								runfactor=6
								echo "You vanish before your opponents eyes"
								break;;
							Back)
								techbreak=1
								break;;
						esac
					done
				elif [[ "$class" = ${agech1} ]]; then
					select attack in StrongStrike-15- RoyalVow-25- Scope-10- BloodOath-40-
                                	do
                                        	case $attack in
                                                	StrongStrike-15-)
                                                                if [[ "${derived[STA]}" -lt 0 ]]; then
                                                                        echo "You're too out of breath to use this technique"
                                                                        techbreak=1
                                                                        break
                                                                fi
                                                                derived[STA]=$((derived[STA]-15))
                                                                DEF=3
                                                                ranny=$((RANDOM % (stats[STR]+eqstats[STR]) + stats[STR]))
                                                                POW=$(((stats[STR]+eqstats[STR])*2))
                                                                POWOW=$((POW+ranny))
                                                                enemy[HP]=$(((enemy[0]-(POWOW))))
                                                                echo "You spend your pent up energy and swing with gusto, dealing ${POW} damage"
                                                                echo "${enemy[0]}"
                                                                break;;
							RoyalVow-25-)
                                                                if [[ "${derived[STA]}" -lt 0 ]]; then
                                                                        echo "You're too out of breath to use this technique"
                                                                        techbreak=1
                                                                        break
                                                                fi
                                                                derived[STA]=$((derived[STA]-25))
                                                                DEF=5
								derived[HP]=$(((derived[HP]+(stats[GUI]*2))))
								dazzleranny=$((RANDOM % 4 + 1))
                                                                if [[ "$dazzleranny" = 4 ]]; then
                                                                        dazzle=1
                                                                fi
								echo "You make an emboldened and entrancing claim, healing $((stats[GUI]*2)) "
                                                                echo "${enemy[0]}"
                                                                break;;
							Scope-10-)
                                                                if [[ "${derived[STA]}" -lt 0 ]]; then
                                                                        echo "You're too out of breath to use this technique"
                                                                        techbreak=1
                                                                        break
                                                                fi
                                                                derived[STA]=$((derived[STA]-10))
                                                                DEF=3
                                                                echo "You analyze your opponent thoroughly"
								echo "Currently has ${enemy[0]} HP. A strength of ${enemy[1]} and a magical power of ${enemy[2]}. It is weak to ${enemy[5]} and can cast ${enemy[8]} number of spells."
                                                                echo "${enemy[0]}"
                                                                break;;
							BloodOath-40-)
                                                                if [[ "${derived[STA]}" -lt 0 ]]; then
                                                                        echo "You're too out of breath to use this technique"
                                                                        techbreak=1
                                                                        break
                                                                elif [[ "$bloodvow" = 1 ]]; then
									echo "BloodVow is already active"
									techbreak=1
									break
								fi
								bftime=0
                                                                derived[STA]=$((derived[STA]-40))
                                                                DEF=2
								stats[STR]=$((stats[STR]+stats[GUI]))
								bloodvow=1
								echo "At the cost of life and defense. Boost your physical prowess to deadly levels"
                                                                echo "${enemy[0]}"
                                                                break;;
                                        	esac
                                	done
				else
					select attack in StrongStrike-15- BloodTransfusion-25- Scope-10- 
                                	do
                                        	case $attack in
                                                	StrongStrike-15-)
                                                                if [[ "${derived[STA]}" -lt 0 ]]; then
                                                                        echo "You're too out of breath to use this technique"
                                                                        techbreak=1
                                                                        break
                                                                fi
                                                                derived[STA]=$((derived[STA]-15))
                                                                DEF=3
                                                                ranny=$((RANDOM % (stats[STR]+eqstats[STR]) + stats[STR]))
                                                                POW=$(((stats[STR]+eqstats[STR])*2))
                                                                POWOW=$((POW+ranny))
                                                                enemy[HP]=$(((enemy[0]-(POWOW))))
                                                                echo "You spend your pent up energy and swing with gusto, dealing ${POW} damage"
                                                                echo "${enemy[0]}"
                                                                break;;
							BloodTransfusion-25-)
								if [[ "${derived[STA]}" -lt 0 ]]; then
                                                                        echo "You're too out of breath to use this technique"
                                                                        techbreak=1
                                                                        break
                                                                fi
								derived[STA]=$((derived[STA]-25))
								DEF=3
								echo "The blood from your wounds coagulate into seithr!"
								echo "Spening 25 HP and 25 STA, you gain "$((stats[INT]+eqstats[INT]))" MAG"
								resources[MAG]=$((resources[MAG]+(stats[INT]+eqstats[INT])))
								break;;
							Scope-10-)
                                                                if [[ "${derived[STA]}" -lt 0 ]]; then
                                                                        echo "You're too out of breath to use this technique"
                                                                        techbreak=1
                                                                        break
                                                                fi
                                                                derived[STA]=$((derived[STA]-10))
                                                                DEF=3
                                                                echo "You analyze your opponent thoroughly"
								echo "Currently has ${enemy[0]} HP. A strength of ${enemy[1]} and a magical power of ${enemy[2]}. It is weak to ${enemy[5]} and can cast ${enemy[8]} number of spells."
                                                                echo "${enemy[0]}"
                                                                break;;
						esac
					done
						
				fi
				if [[ "${techbreak}" = 1 ]]; then
					techbreak=0
					continue	
				fi
				break;;
			NinjaTools)
				if [[ "$class" != "Shinobi" ]]; then
					echo "You must be a shinobi to use these objects"
					continue
				fi
				DEF=3
				for eq in "${!ninjaTools[@]}"
                                                do
                                                        echo "$eq : ${ninjaTools[$eq]}"
                                                done
				PS3="Pick a Number: "
				select item in ${ninjaToolsNo[@]}
				do
					case $item in
						Shuriken)
							echo "$item"
							if [[ "${ninjaTools[$item]}" < 1 ]]; then
                                                		echo "You're out of this item! ${ninjaTools[$item]}"
                                                		continue
	                                        	fi
							POW=$(((stats[AGI]+eqstats[AGI])*2))
							enemy[HP]=$((enemy[0]-POW))
							echo "You throw a ${item}, dealing $((POW)) damage."
                                        		ninjaTools[$item]=$((ninjaTools[$item]-1))
							break;;
						PaperBomb)
							echo "$item"
                                                        if [[ "${ninjaTools[$item]}" < 1 ]]; then
                                                                echo "You're out of this item! ${ninjaTools[$item]}"
                                                                continue
                                                        fi
							if [[ "${enemy[5]}" == "Fire" ]]; then
								weak=2
							else
								weak=1
							fi
							POW=$(((stats[AGI]+eqstats[AGI])*3*weak))
                                                        enemy[HP]=$((enemy[0]-POW))
							echo "You throw a ${item}, dealing $((POW)) damage."
                                                        ninjaTools[$item]=$((ninjaTools[$item]-1))
                                                        break;;
						FumaShuriken)
                                                        echo "$item"
                                                        if [[ "${ninjaTools[$item]}" < 1 ]]; then
                                                                echo "You're out of this item! ${ninjaTools[$item]}"
                                                                continue
                                                        fi
							enemy[HP]=$((enemy[0]-$(((stats[AGI]+eqstats[AGI]+stats[STR]+eqstats[STR])*2))))
                                                        echo "You throw a ${item}, dealing $(((stats[AGI]+eqstats[AGI]+stats[STR]+eqstats[STR])*2)) damage."
                                                        ninjaTools[$item]=$((ninjaTools[$item]-1))
                                                        break;;
					esac
				done
				break;;
		esac
	done
	if [[ "${derived[STA]}" -lt 0 ]]; then
                echo "You're exhausted! Your guard weakens!"
                if [[ $DEF -gt 1 ]]; then
                        DEF=1
                fi
		exhaust=1
		sleep 1
	elif [[ "${derived[STA]}" -ge 0 ]]; then
		exhaust=0
        fi

	if [[ ${enemy[HP]} -lt 1 ]]; then
		if [[ "${bloodvow}" = 1 ]]; then
			bloodvow=0
			stats[STR]=$((stats[STR]-stats[GUI]))
		fi
		echo "${enemy[7]} has been defeated."
		sleep 1
		echo "You gained ${enemy[3]} yen and ${enemy[4]} experience."
		sleep 1
		give_exp "${enemy[4]}"
		resources[GOLD]=$((${resources[GOLD]}+${enemy[3]}))
		case "${enemy[7]}" in
			"Great Devourer")
				add_equipment "DevourerChitin";;
			"Iron Gigas")
				add_equipment "Excalihuh?"
		esac
		break
	elif [[ "${runfactor}" = 6 ]]; then
		if [[ "${bloodvow}" = 1 ]]; then
                        bloodvow=0
                        stats[STR]=$((stats[STR]-stats[GUI]))
                fi
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

	sleep 1
	ranny=$((RANDOM % enemy[1] + 2))
	mranny=$((RANDOM % enemy[2] + 1))
	if [[ "$chargevar" = 1 ]]; then
		enemyPOW=$(((enemy[1]*4)/DEF))
	else
		enemyPOW=$(((enemy[1]+ranny)/DEF))
	fi
	enemyMAG=$(((enemy[2]+mranny)+ranny/2))
	if [[ "${enemy[8]}" -gt 0 && "${chargevar}" = 0 ]]; then
		magchance=$((RANDOM % 6 + 1))
		magchoice=$((RANDOM % ${enemy[8]} + 0 ))
		skillchance=$((RANDOM % 4 + 1))
		if [[ ${enemy[9]} == 2 ]]; then
			magchance=$((magchance+2))
                fi
		if [[ "$magchance" -gt 4 ]]; then
			if [[ ${enemy[9]} == 2 ]]; then
				case $magchoice in
					0)
						echo "${enemy[7]} casts ${enemyMag[$magchoice]}"
						derived[HP]=$((derived[HP]-(enemyMAG/DEF)))
						echo "You burn and take $((enemyMAG/DEF)) damage";;
					1)
                        	                echo "${enemy[7]} casts ${enemyMag[$magchoice]}"
                                	        derived[HP]=$((derived[HP]-(enemyMAG*2)))
						echo "A wave of Force slams into your chest and you take $((enemyPOW*2)) damage";;
					2)
        	                                echo "${enemy[7]} casts ${enemyMag[$magchoice]}"
                	                        enemy[1]=$((enemy[2]+5))
                        	                echo "Its magic power is growing even stronger!";;
					3)
	                                        echo "${enemy[7]} casts ${enemyMag[$magchoice]}"
        	                                enemy[0]=$((enemy[0]+enemy[2]))
                	                        echo "The enemy recovers a portion of their health";;
					4)
                                	        echo "${enemy[7]} casts ${enemyMag[$magchoice]}"
						sealranny=$((RANDOM % 3 + 1))
						if [[ "${sealranny}" = 3 ]]; then
							statusfx[sealed]=1
							echo "Your techniques have been sealed!"
						fi;;
					5)
                                        	echo "${enemy[7]} casts ${enemyMag[$magchoice]}"
						derived[HP]=$((derived[HP]-(enemyMAG*3)))
						grandranny=$((RANDOM % 4 + 1))
                	                        if [[ "${grandranny}" = 1 ]]; then
                        	                        statusfx[sealed]=1
							echo "You bear the brunt of a magical blast taking $((enemyMAG*3)) damage"
							sleep 1
							echo "Your techniques have been sealed!"
						elif [[ "${grandranny}" = 2 ]]; then
							statusfx[EnExhaust]=1
							statusfx[sealed]=1
							echo "You bear the brunt of a magical blast taking $((enemyMAG*3)) damage"
							sleep 1
							echo "You're exhausted! Your guard weakens!"
							sleep 1
							echo "Your techniques have been sealed!"
						elif [[ "${grandranny}" = 3 ]]; then
							statusfx[EnExhaust]=1
							statusfx[sealed]=1
							statusfx[toxin]=1
							echo "You bear the brunt of a magical blast taking $((enemyMAG*3)) damage"
							sleep 1
							echo "You're exhausted! Your guard weakens!"
							sleep 1
							echo "Your techniques have been sealed!"
						elif [[ "${grandranny}" = 4 ]]; then
							echo "You bear the brunt of a magical blast taking $((enemyMAG*3)) damage"
                                        	        sleep 1
                                                	derived[HP]=$((derived[HP]-(enemyMAG*2)))
							echo "You're buffetted by a second flurry of magical explosions taking $((enemyMAG*2)) damage"
						fi
				esac
			elif [[ ${enemy[9]} == 1 ]]; then
				case $magchoice in
                	                0)
                        	                echo "${enemy[7]} casts ${enemyPhy[$magchoice]}"
						local magdmg=$(((enemyMAG+enemyPOW)/DEF))
						derived[HP]=$((derived[HP]-magdmg))
	                                        echo "You burn and take $((magdmg)) damage";;
        	                        1)
                	                        echo "${enemy[7]} casts ${enemyPhy[$magchoice]}"
                        	                derived[HP]=$((derived[HP]-(enemyPOW*2)))
                                	        echo "A wave of Force slams into your chest and you take $((enemyPOW*2)) damage";;
	                                2)
        	                                echo "${enemy[7]} casts ${enemyPhy[$magchoice]}"
                	                        enemy[1]=$((enemy[1]+8))
                        	                echo "It's power is growing even stronger!";;
	                                3)
        	                                echo "${enemy[7]} casts ${enemyPhy[$magchoice]}"
						local magdmg=$(((enemyMAG+enemyPOW)/DEF))
                        	                derived[HP]=$((derived[HP]-magdmg))
						statusfx[toxin]=1
                                        	echo "The enemy strikes with a venomous point, dealing $((magdmg)) damage!";;
	                                4)
        	                                echo "${enemy[7]} casts ${enemyPhy[$magchoice]}"
                	                        godranny=$((RANDOM % 3 + 1))
						godpw=$((enemyPOW*(godranny+1)))
						derived[HP]=$((derived[HP]-(godpw)))
						sealranny=$((RANDOM % 3 + 1))
                                        	echo "An indescribably heavenly strike slams into you, dealing $((godpw)) damage"
						if [[ "${sealranny}" = 3 ]]; then
        	                                        statusfx[EnExhaust]=1
                	                                echo "You're exhausted! Your guard weakens!"
                        	                fi;;
				esac
			fi
		elif [[ $skillchance == 4 && ${enemy[10]} != "None" ]]; then
				echo ""${enemy[7]}" used its unique skill, "${enemy[10]}""
				case "${enemy[10]}" in
					"Goblin Punch")
						hitno=$((RANDOM % 4 + 1))
						for (( j=0 ; j<$hitno ; j++ ));
						do
							echo "You got hit for $((enemyPOW/2)) damage!"
							derived[HP]=$((derived[HP]-(enemyPOW/2)))
							sleep 0.5
						done
						echo "You got hit $hitno times!"
						;;
					"Devour")
						derived[HP]=$((derived[HP]-(enemyPOW+enemyMag)))
						enemy[0]=$((enemy[0]+(enemyPOW+enemyMag)/2))
						echo "A bite was taken out of you! You take $(((enemyPOW+enemyMag)/2)) damage and the enemy heals!"
						;;
					"Psychic Attack")
						psychranny=$((RANDOM % 3 + 1))
						derived[HP]=$((derived[HP]-(stats[STR]+eqstats[STR])*2))
						echo "Your body begins to move on its own! You strike yourself for $(((stats[STR]+eqstats[STR])*2)) damage!";;
					"Black Flame")
						derived[HP]=$((derived[HP]-(enemyPOW*2)))
						statusfx[EnExhaust]=1
                                                echo "Fire black as pitch surrounds you and you take $((enemyPOW*2)) damage. Your energy is being sapped.";;
					"Venom Bite")
						derived[HP]=$((derived[HP]-(enemyPOW)))
						statusfx[toxin]=1
                                                echo "You take a deadly bite and poison shoots inside of you, dealing $((enemyPOW*2)) damage.";;
					"Cataclysm")
                                                derived[HP]=$((derived[HP]-(enemyMag*2)))
                                                echo "A wave of pure Seithr slams you into the nearby wall dealing $((enemyPOW*2)) damage.";;
					"100-Layer Lacquered Sealing Pagoda")
						statusfx[sealed]=1
						echo "Your techniques have been locked out by an advanced sealing technique!";;
					"Man's Innovation")
                                                hitno=$((RANDOM % 4 + 1))
                                                for (( j=0 ; j<$hitno ; j++ ));
                                                do
                                                        echo "You got hit for $((enemyPOW)) damage!"
                                                        derived[HP]=$((derived[HP]-(enemyPOW)))
                                                        sleep 0.5
                                                done
                                                echo "Innumerable firearms crack off at once, hitting you $hitno times!"
                                                ;;
					"Shikigami Restoration")
						enemy[0]=$((enemy[0]+(enemy[2]*2)))
						echo "The enemy recovers a portion of their health. Healing for $((enemy[2]*2))";;
					"Myriad Flash")
						hitno=$((RANDOM % 3 + 1))
                                                for (( j=0 ; j<$hitno ; j++ ));
                                                do
                                                        echo "You got hit for $((enemyMag*2)) damage!"
                                                        derived[HP]=$((derived[HP]-(enemyMag*2)))
                                                        sleep 0.5
                                                done
                                                echo "The volley of light strikes you $hitno times!"
						;;

				esac
		else
			chargeranny=$((RANDOM % 6 + 1))
			if [[ "$chargeranny" = 6 && "$chargevar" = 0 ]]; then
				echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
				echo "The enemy is winding up a terrible attack..."
				echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
				chargevar=1
				continue
			elif [[ "$DEF" -lt 4 ]]; then
				echo "${enemy[6]} ${enemyPOW} damage"
			else
				echo "You glance off the attack and take ${enemyPOW} damage"
			fi
			derived[HP]=$((derived[HP]-enemyPOW))
			if [[ "${chargevar}" = 1 ]]; then
				chargevar=0
			fi
		fi
		else
			if [[ "$chargeranny" = 6 && "$chargevar" = 0 ]]; then
                        	echo "The enemy is winding up a terrible attack..."
                        	chargevar=1
				continue
			elif [[ "$DEF" -lt 4 ]]; then
                        	echo "${enemy[6]} ${enemyPOW} damage"
                	else
                        	echo "You glance off the attack and take ${enemyPOW} damage"
                	fi
                	derived[HP]=$((derived[HP]-enemyPOW))
			if [[ "${chargevar}" = 1 ]]; then
                                chargevar=0
                        fi
	fi
	if [[ "${derived[HP]}" -le 0 ]]; then
		if [[ $diedYet == 0 ]]; then
			diedYet=1
			Minamoto
		fi
		die
	fi
	 echo "${enemy[0]}"
done
}

die(){
	sleep 2
	echo "You died having achieved nothing."
	sleep 1
	echo "Your meagre grave less than a stepping stone for those that will come after."
	sleep 2
	echo "Your story muffled by the soft earth and your hollowed bones."
	sleep 1
	echo "Another lost soul cursed to haunt the pit forever."
	sleep 1
	echo "May you find your worth in the next world. "
	sleep 2
	exit 1
}

declare -a enemyMag=(
[0]="Fireball"
[1]="MagWave"
[2]="Enhancement"
[3]="Regeneration"
[4]="FourPillarSeal"
[5]="GrandMagicBurst"
)

declare -a enemyPhy=(
[0]="Flame Strike"
[1]="MagPunch"
[2]="Enhancement"
[3]="Venom Strike"
[4]="God Hand"
)

MagBoost(){
	echo "Decide how much MAG to put into this spell"
	select boost in 5 10 20 30
	do
		if [[ "${resources[MAG]}" -lt $boost ]]; then
			echo "You don't have enough MAG!"
			continue
		fi
		resources[MAG]=$((resources[MAG]-$boost))
		BoostVal=$((boost*10))
		break
	done

}
