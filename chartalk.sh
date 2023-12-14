source save.conf
declare -a kobanekoActiveList=( [0]="I need to find it… I need to find the sword…" 
				[1]="I want to grow stronger-" 
				[2]="Uhh… Tourism?" 
				[3]="Why… do you talk like that…" 
				[4]="Are you guys humans…? Or?")
declare -a crowleyActiveList=("I was told to ask you about the sword by Kobaneko" "I’m looking for info on the unnamed sword" "What’s a Demonitorium?" "You look just like a regular person!" "Do you have any tips for me in combat, sir?" "Bye")
declare -a whiteActiveList=("About You" "About Crowley" "About Kobaneko" "About Demon King" "Holy Judgement?" "About Nameless Katana")
declare -a izanagiActiveList=("Who are you" "What do you want" "What happened to White")
declare -A dialogueChecks=(
["dungLevelCrowleycheck"]=0
["dungLevelKobancheck"]=0
["kobanBreak"]=0
["kobamaoucheck"]=0
["kobaguidecheck"]=0
["kobasubjcheck"]=0
["endCrowCheck"]=0
["endKobanCheck"]=0
["endWhiteCheck"]=0
)

char(){
	char=("$1")
	yap=("$2")
	RED='\033[0;31m'
	NC='\033[0m' # No Color

	echo -e "${RED}${char}:${NC} ${yap}"
	read -p ""
}

White(){
	talkstate=1
        while [[ $talkstate=1 ]];
        do
	select rep in ${whiteActiveList[@]}
	do
		case $rep in
			"About You")
				char White "I’m merely a shadow of a time past. My Identity is of no meaning."
				break;;
			"About Crowley")
				char White "A weak man hiding behind a dead ideal. He’d rather his lackeys do his dirty work than ever sully his hands. If I were you I’d be wary of his machinations."
                                break;;
			"About Kobaneko")
				char White "A uniquely ambitious demon. I can see the zeal in her eyes, she seeks something far greater than most of her kin, and she intends to use you to obtain it."
                                break;;
			"About Demon King")
				char White "[he laughs out loud]"
				char White "Daimaou Kagutsuchi. An unbelievably powerful demon."
				char White "It’s said in his final clash, so loud were his roars and so heavy were his swings that volcanoes began to cry in anguish overhead. Such stupendous power, brought down by holy judgement."
                                break;;
			"Holy Judgement?")
				char White "Minamoto no Raiko was given a divine mandate, and tasked with the destruction of the leader of the demon realm."
                                break;;
			"About Nameless Katana")
				char White "A tombstone almost, a pure fragment of the goddess used by her partner to seal her corpse at the very bottom of hell. Who knows what taking it would do."
				char White "Of course, a warrior like yourself is beyond such technicalities."
                                break;;
			
		esac
	done
	done
}

Minamoto(){
	read -p "The cold darkness ensnares you. Your body falls still and numbness overtakes you."
	read -p "You can feel it, your very soul being washed away by the churning tides of time."
	read -p "But deep in the back of your mind’s eye, you see something. An impossibly bright light."
	read -p "So incandescent that merely observing it seems to blow back the darkness out of reach."
	select rep in "Reach Out" "Give Up"
                do
                        case $rep in
				"Reach Out")
					read -p "As you reach closer and closer into the light, a figure manifests."
					char ??? "Ah, you can see me, can you."
					char ??? "It has been a long time since I’ve seen a soul so pathetically cling onto life."
					char ??? "Tell me, what exactly is awaiting you in the land of the living. To what purpose do you grasp so desperately at the threads of your fate?"
					char ??? "Do you want to fight?"
					char ??? "Do you want to win?"
					char ??? "Or do you just want to live…"
					break;;
				"Give Up")
					die;;
			esac
		done
	select rep in "I want to Fight!" "I want to Win!" "I want to Live!"
                do
                        case $rep in
				"I want to Fight!")
					char ??? "..."
					char ??? "Just fighting for its own sake is meaningless."
					char ??? "Tell me, how are you different from the demons that tore your stomach open and strew your intestines about. The warmongers who burn and pillage in the name of lord and country."
					char ??? "A thug at best, your soul is worthless. Goodbye."
					die;;
				"I want to Win!")
					read -p "[the light erupts around you, so brightly that you feel you might go blind.]"
					char ??? "[A booming laughter circles around you from every direction. The freezing darkness you once felt was now replaced by an almost unbearable painful heat.]"
					char ??? "You're precisely correct! Winning is the only possible outcome, isn’t it!"
					char ??? "I can see within you, your soul burns with an unquenchable flame."
					char ??? "Continue to struggle!"
					char ??? "Continue to fight!"
					char ??? "Continue to attain strength!  Until none can bear to stand before you, until you are unparalleled."
					char ??? "You may call me 'White'"
					char White "You have my permission to rise once again."
					${dialogueChecks[endWhiteCheck]}=1
					crowleyActiveList+=("I met a person name White")
					break;;
				"I want to Live!")
					char ??? "..."
					char ??? "Mere survival is the purpose of the most base of creatures."
					char ??? "Tell me, how are you different from a wild beast on the hunt for its next meal, who turns tail at the sight of the hunter."
					char ??? "Your soul is like that of a mealworm, the belly of the demon world suits you. Begone."
					die;;
			esac
		done
}

Crowley(){
	if [[ $dungLevel -gt 1 && ${dialogueChecks[dungLevelCrowleycheck]} == 0 ]]; then
		 dialogueChecks[dungLevelCrowleycheck]=1
		 crowleyActiveList+=("I’ve cleared the first level of the dungeon")
	fi
	if [[ $dungLevel -gt 3 && ${dialogueChecks[dungLevelCrowleycheck]} == 1 ]]; then
                 dialogueChecks[dungLevelCrowleycheck]=2
                 crowleyActiveList+=("I’ve cleared the third floor")
        fi
	if [[ $dungLevel -gt 4 && ${dialogueChecks[dungLevelCrowleycheck]} == 2 ]]; then
                 dialogueChecks[dungLevelCrowleycheck]=3
                 crowleyActiveList+=("I’ve cleared the fourth floor")
        fi
        talkstate=1
        while [[ $talkstate=1 ]];
        do
                select rep in "${crowleyActiveList[@]}"
                do
                        case $rep in
				"I was told to ask you about the sword by Kobaneko")
					char Crowley "Why yes of course you were."
					char Crowley "Every sorry lord or lost champion tumbles down this hole in search of the <power to rule the world below and above>"
					char Crowley "But do you even know what the blade is? What it can do?"
					break;;
				"I’m looking for info on the unnamed sword")
					char Crowley "[he leers at you analytically, then makes a flippant hand gesture] Get to the second floor of the dungeon, then I’ll talk to you."
					break;;
				"What’s a Demonitorium?")
					char Crowley "We sell demons and we sell Magic Element, my child. If you need fuel for your magic, or you need to cut something down to size, I’m the man to meet."
					break;;
				"You look just like a regular person!")
					char Crowley "Hmmm? Oh I have a charm against the poisons of the demonic world. I wouldn’t dare breath the filth of these creatures"
					break;;
				"Do you have any tips for me in combat, sir?")
					char Crowley "If they hit you, hit them back."
				       	char Crowley "Don’t run out of stamina."
				       	char Crowley "If the enemy looks like it’s about to swing something nasty, defend yourself. The rest you’ll learn on the field."
					char Crowley "Ah, and if you run into the Great Devourer out there run like your life depends on it."
					break;;
				"I met a person name White")
					char Crowley "Hmm. You came back from the brink of death? Are you sure you weren’t hallucinating from pain?"
					char Crowley "A person named White? Pure light? Doesn’t sound like any demonic phenotypes I know. This is purely conjecture but it’s likely what you met was a Phantom."
					char Crowley "An apparition that is born when a particularly stubborn soul clings onto nearby Seithr."
					char Crowley "It’s said only those on the brink of death have the ability to even see one, so perhaps there is merit to your story. [he laughs a bit]"
					char Crowley "Keep me updated on this ‘White’ if you can."
					break;;
				"Kobaneko mentioned a demon king?")
					char Crowley "Ahh. Daimaou Kagutsuchi."
					char Crowley "A ruthless, terrible demon. His reign knew no bound and he burned all that he found unsightly."
					char Crowley "Yet the savage demons absolutely adored him. He and his most powerful kin would make their way to the human world and wage war on the shogunate."
					char Crowley "His presence was always marked with dark skies and liquid fire, and all land he passed over was blackened for 10 generations."
					char Crowley "It is said he was eventually felled by Lord Minamoto-no-Raiko."
					break;;
				"I’ve cleared the first level of the dungeon")
					char Crowley "I’m impressed. Sure, I’ll tell you. The goddess slumbers deep within the earth, and the blade sleeps even deeper within her undying corpse. You must crawl and fight to the lowest level to obtain it."
					char Crowley "Many have come before you and many have fallen. But I see a glint in your eye. See, some benefactors and I have strong vested interest in that blade, and we’re looking for associates to help us attain it. Get through the next two layers and come back to me."
					char Crowley "I'm sure that mangy grimalkin has told you a lot as well. Do what you wish but be wary of vesting trust in a demon."
					if [[ ${dialogueChecks[kobaguidecheck]} != 1 ]]; then
					kobanekoActiveList+=("Crowley gave me some guidance.")
	                                ${dialogueChecks[kobaguidecheck]}=1
                                	fi
					unset crowleyActiveList[1]
					break;;
				"I’ve cleared the third floor")
					char Crowley "You show unprecedented promise, my child. I think we are of a kind." 
					char Crowley "You are privy to the existence of the Society of the Deep Blue, I’m sure? You may know us as librarians. Keepers of the occult and esoteric. In some sense that is our task in modernity. But this is merely a holdover from our true task for the past 500 years." 
					char Crowley "Even as states and bloodlines dissolved, and power shifted from one to another. We remained the same, our irrefutable duty never changed. To protect mankind from the torment of demonkind."
					char Crowley "As fellow humans, we share the same goals, and I continue to pray earnestly for your wellbeing. Like I mentioned, I wantyou to help us achieve our goals, don’t worry about the details for now. Just focus on getting through the next floor safely. It is guarded by an incredibly powerful demon from the last era. Take this charm and stay safe."
					break;;
				"I’ve cleared the fourth floor")
					char Crowley "You are simply incredible, my child. I haven’t seen this much potential since Lord Minamoto. I must have mentioned this to you already, but there used to be a King. A King of Hell. Daimaou, the demons called it. A Demon Lord."
					char Crowley "Its will was absolute and even the most cantankerous and bloodthirsty among them would grovel beneath it. It was not a king by nature of its birth mind you, nor by common vote. [he chuckles mildly, as if to imply it was a laughable concept]. No, it ruled with sheer force. Only by its inarguable might did other demons bow."
					char Crowley "So there then begs the question, could it mean that in all the infinite millenia that demons have crawled and struggled and consumed and lied and fought for power, that this creature was their ultimate evolution? That there could exist none other, that no demon was ever successful in having its head? Of course not."
					char Crowley "As it is in the nature of those beasts to struggle and grow ever more, eventually something emerges from the pits of hell so powerful that the dynamic is upset. These two impossible forces clash, and thus would demons spill forth from every chasm and every unholy place, bringing death and disease, chaos and famine."
					char Crowley "In the end, when the dust settles and the corpses return to the earth, a new Daimaou sits atop its throne. Of course this must all sound outlandish to you, but these were the times our forefathers survived in. You may take pride in your strength, but against an unrelenting flood of demons mankind could do nothing but cower and hide."
					char Crowley "Our research indicates that through the unnamed sword's power to manipulate seithr, it as well has the power to absolutely control the hearts of demons, given that the proper ritual is performed."
					char Crowley "With this in our grasp, the entirety of the demon realm will become but a stepping stone for mankind's future. Our future."
					char Crowley "Come, we must arrive at the last floor without delay. I fear external actors are acting against us."
					${dialogueChecks[endCrowCheck]}=1
					break;;
				"Bye")
					talkstate=0
					break 2;;
                        esac
                done
        done
}

Kobaneko(){
	if [[ $dungLevel -gt 1 && ${dialogueChecks[dungLevelKobancheck]} == 0 ]]; then
                 dialogueChecks[dungLevelKobancheck]=1
                 kobanekoActiveList+=("I’ve been to the dungeon")
        fi
        if [[ $dungLevel -gt 3 && ${dialogueChecks[dungLevelKobancheck]} == 1 ]]; then
                 dialogueChecks[dungLevelKobancheck]=2
        fi
	talkstate=1
	while [[ $talkstate=1 ]];
        do
	if [[ ${dialogueChecks[kobanBreak]} == 1 ]]; then
                read -p "We have nothing else to discuss. Leave."
                break
        fi
	select rep in "${kobanekoActiveList[@]}"
        do
		case $rep in
			"I need to find it… I need to find the sword…")
				char Kobaneko "[she leans in awfully close] You humans are so deliciously unpurrrr-dictable. You wish to throw away all the comforts of the world above and dig your way into hell for some flimsy sword?"
				char Kobaneko "If the unnamed katana is what you seek then you must fall even deeper than you already have. Into a place so steeped in darkness that no man returns unchanged…"
				char Kobaneko "[her expression reverts back to normal] Nya-sk Dr.Crowley at the Demonitorium for more info!"
                                kobanekoActiveList+=("Be seeing you")
				unset kobanekoActiveList[0]
				break;;
			"I want to grow stronger-")
				char Kobaneko "Nya! If strength is what you seek then go over to the demonitorium and slaughter to your hearts content. Nyihihi!"
				break;;
			"Uhh… Tourism?")
				char Kobaneko "Ohh. Ichor is a wonderful place!"
				char Kobaneko "If you’re hurt you can go to the church!" 
				char Kobaneko "If you need herbs or tools you can visit the apothecary!" 
				char Kobaneko "And if you want to test your skills against demons, head over to the demonitorium!"
				break;;
			"Why… do you talk like that…")
				char Kobaneko "Talk like how? This is just the tongue of Nya’s people!"
				break;;
			"Are you guys humans…? Or?")
				char Kobaneko "We’re everything inbetween! When a human is exposed to a lot of seithr at once, overtime they start to gain traits, and these are passed down to their children! And their childrens children!"
				char Kobaneko "Ah the cycle of life is so beautiful!"
				char Kobaneko "Of course, some of us are half-demons! We even allow regular demons if they agree to behave."
				char Kobaneko "Ichor is welcoming to all who are willing to abide by its absolute NO VIOLENCE clause!"
				kobanekoActiveList+=("Seithr? What’s that")
				kobanekoActiveList+=("No Violence clause?")
				unset kobanekoActiveList[4]				
				break;;
			"Seithr? What’s that")
				char Kobaneko "It’s all around nya’s world! It’s the wonderful clay of creation!"
				char Kobaneko "However, it's most concentrated in the demon world, and any human that stays here for too long starts to change."
				break;;
			"No Violence clause?")
				char Kobaneko "Yes! Nya can rip and tear all you want in the dungeons or the demonitorium but absolutely NO fighting is allowed between citizens"
				break;;
			"I’ve been to the dungeon")
				char Kobaneko "Oh? Really, you talked to Crowley too?"
				char Kobaneko "So how was it? Enjoyed your first taste of demon blood?"
				char Kobaneko "Oh don’t be coy, out there it’s kill or be killed. It’s in the nature of this world for us to tear ourselves apart."
				char Kobaneko "Well, truth be told, It didn't always use to be like that."
				if [[ ${dialogueChecks[kobamaoucheck]} != 1 ]]; then
                                kobanekoActiveList+=("How was it before.")
				crowleyActiveList+=("Kobaneko mentioned a demon king?")
				${dialogueChecks[kobamaoucheck]}=1
                                fi
				break;;
			"How was it before.")
				char Kobaneko "When I was still just a kitten, and when the Demon Lord was still alive… Weak demons were protected and stronger demons were given purpose…"
				char Kobaneko "It wasn’t absolute chaos. He ruled by strength as all demons should— he gave us safe territories and showed no mercy to those who broke them."
				break;;
			"Crowley gave me some guidance.")
				char Kobaneko "That old coot sure seems to have taken a liking to you. But yes, everything he said was true. The blade is a crystallization of the goddess’s power."
				char Kobaneko "One who wields it has the power to shape the demon world, but the depths are far too dangerous, and at the end of the 4th floor stands a demon from an era long gone. Said to be so powerful that none could ever manage to stand up to him."
				break;;
			"Crowley wants me to use the Sword to subjugate demons")
				if [[ ${dialogueChecks[kobasubjcheck]} != 1 ]]; then
				char Kobaneko "I figured as much, that man always had such a catty~ attitude about him." 
				char Kobaneko "Well, he says that’s what you’re meant to do, right? Because you’re human. Right? Surely, you must share his goals."
				char Kobaneko "Although, the fact you came all the way to tell me this begs to differ. So then, I ask you, my dear human. Is this truly your heart's desire? Do you earnestly with all your heart seek the eradication of free will within all demonkind?"
				select ans in "Yes" "I'm unsure" "No"
				do
					case $ans in
						"Yes")
							char Kobaneko "[she seems somewhat disappointed]"
							char Kobaneko "Then we have nothing else to discuss…"
							dialogueChecks[kobanBreak]=1
							break 2;;
						"I'm unsure")
							char Kobaneko "You seek the blade for yourself, don’t you? You came here seeking power and you’re at the cusp of it."
							char Kobaneko "Do what you humans do best and keep moving forward. The rest will fall into place eventually."
							${dialogueChecks[endKobanCheck]}=1
							break;;
						"No")
							char Kobaneko "Even knowing our nature you still seek to protect us. You’re a curious one, ${name}."
							char Kobaneko "To have defeated the Gigas, your strength is without question. Many demons are watching you already. Ever since you came out of the 3rd floor unscathed, innumerable eyes have been placed on you. Watching your evergrowing power."
							char Kobaneko "Allow me to let you in on a secret so steeped in hell and wrapped in the secrets of demon-tongue, that not even those of the Blue know this."
							char Kobaneko "‘The Goddess is alive’." 
							char Kobaneko "Not an undying corpse, or in some deep sleep, but Alive. Shocking, I know, but we can feel it. All demons can, she is our mother, after all. We feel the soft thumping under the earth with every beat of her heart. She is awake, but quiet."
							${dialogueChecks[endKobanCheck]}=1
							break;;
					esac
				done
				char Kobaneko "The former Daimaou was slain by a man called Minamoto no Raiko. He tore through the demon realm with naught but sword and lightning stolen from the heavens."
				char Kobaneko "He was an unseen flash of pure white and rumbling thunder, and even though he was undoubtedly human, he moved with a viciousness unseen even among demonkind. In their grand ensuing battle, they slew each other."
				char Kobaneko "This ‘sword’ was born soon after. It is unknown what was so special about their bout that caused this to happen, or if both events are even related, but we know for a fact that whoever wields it has the power to become a new Daimaou."
				char Kobaneko "Whether protecting mankind is your wish, or obtaining absolute power is your wish, the only path to either is to take up this unholy mantle."
				${dialogueChecks[kobasubjcheck]}=1
				fi
				char Kobaneko "I'll wait for you on the final floor."
				break;;
			"Be seeing you")
				char Kobaneko "Bye-bye!"
				talkstate=0
				break 2
		esac
	done
done
}

OneHornedLady(){
	local qasked=0
	while [[ $talkstate=1 ]];
	do
		select rep in "Who are you?" "Where am I" "My name is ${name}"
	do
		case $rep in
			"Who are you?")
				char "Angry Woman" "*glares* I’m your guide, I’m to register you. Name."
				qasked=1
				break;;
			"Where am I")
				char "Angry Woman" "This is the town of Ichor, where the dregs of mankind wind up when the above world is done with them. Name."
				qasked=1
				break;;
			"My name is ${name}")
				char "Angry Woman" "Good."
				if [[ "${qasked}" == 1 ]]; then 
					char "Angry Woman" "Talk to Koban if you want to ask anymore stupid questions." 
				else
					char "Angry Woman" "Go talk to Koban next."
				fi

				break 2;;
		esac
	done
	done
}

FinalFloor(){
	read -p "You take extreme care as you step lower and lower into the abyss, a dull thudding sound seems to move through the entire structure. Beneath your feet lay colorful rolls of fabric with myriad patterns, the density increasing as you pierced lower and lower."
	read -p "By the point you had reached the bottom of the staircase, there were so many of them that they covered up the entire floor, and as you lift your gaze up you see the decorated corpse of the goddess. A macabre carcass, its chest cavity spread open like a blooming flower, as streams of cloth flowed out of it like a gushing wound. Its arms lay splayed at the sides and its head nailed to the wall. It looked almost ritualistic."
	read -p "And inside, deep within all that, a rigid beam of pure light shot out where her heart would be. Your eyes had trouble focusing on it, it shone with an excruciating incandescence, but you were sure somehow, there wasn’t even an inkling of doubt in your heart, that this was the sword of myth."
	read -p "It stirs."
	read -p "The grey rotten corpse lurches forward, ripping off its own affixed head and leaving it dangling behind. A headless lanky creature hunched over you at least thrice your height, all the while fabric continued to pour out of its chest. Only one word it muttered, even though where once stood its head now was a mere stump, you were sure beyond doubt that this was being made by it."
	echo ""
	read -p "'Avenge'"
	echo ""
	battle "${goblin[@]}"
	if [[ ${dialogueChecks[endKobanCheck]} == 1 || ${dialogueChecks[endKobanCheck]} == 1 ]]; then
		read -p "You are successful in dispatching the goddess. Crowley steps in just behind you."
		char Crowley "That was no goddess, merely the lingering embers of one. More akin to a demon than anything."
		char Crowley "But your work is splendid nonetheless. All you need do now is simply reach out for it, and all the power is yours."
		read -p "Kobaneko, who neither of you seems to have noticed slink in, is standing to your right. The look of revulsion on Crowley's face is evident and immediate. She stood with the head of the corpse in her arms, holding it like it were a child."
		char Kobaneko "Dearest mother. Forgive these humans who so brazenly desecrate your grave…"
		char Kobaneko "Do you believe he has your best wishes at heart? I know what the society of Blue does, and what they are. You’re less than a tool to them."
	        char Kobaneko "What do you think will become of your beloved human world when one party wields the entire force of the demonic realm."
		char Kobaneko "The answer is hell on earth, more guided and precise than anything a demonic incursion could ever cause."
		char Kobaneko "I’m not saying that you should trust only me. I am a demon after all. But there is a reason why new demon kings are created time and time again. The balance between man’s destiny and ours rests on an impossibly thin knife edge."
		char Kobaneko "If you want to subjugate demons then do it with your own strength. If you want to save humanity, then do it of your own will."

		char Crowley "Utter drivel!"
		char Crowley "The poisonous words of a demon. Demons kill and take as they please, yet we can do naught but mewl and rebuild. Even merely to step foot in their domain causes us to become filthy facsimiles of their kind."
		char Crowley "It brings up such unknowable disgust within me to admit, yet I am neither foolish nor blind to the truth before my eyes. They outnumber us and are far more powerful."
		char Crowley "Do you understand what this means? Each Daimaou is inevitably more powerful than the last,and mankind cannot keep them at bay til eternity. One day, the dam will break and we will fall under the might of a Demon King powerful enough to tear the bridge between our worlds open."
		char Crowley "So you see, this is why we must obtain the sword. For the sake of mankind, for the absolute subjugation of the enemy, you… we must ascend."
	fi

	declare -a endarr=("Take the Sword in your own Name")
	if [[ ${dialogueChecks[endKobanCheck]} == 1 ]]; then
		endarr+=("Become the King of Hell")
	fi
	if [[ ${dialogueChecks[endCrowCheck]} == 1 ]]; then
                endarr+=("Enslave demonkind in the name of Humanity")
        fi

	read -p "[you hear a voice]"
	char ??? "Reach for the blade and your true heart’s desire will be crystallized."
	select choice in "${endarr[@]}"
	do
		case $choice in
			"Take the Sword in your own Name")
				echo "redeemed"
				local ending="redeemed"
				break;;
			"Become the King of Hell")
				echo "ascend"
				local ending="ascend"
				break;;
			"Enslave demonkind in the name of Humanity")
				echo "subjugate"
				local ending="subjugate"
				break;;
		esac
	done

	case $ending in
		"redeemed")
			read -p "Light swirls around your body and you draw a blade of gold and silver."
			read -p "It seems less majestic than you expected."
			read -p "Almost... inconsequential."
			;;
		"ascend")
			read -p "You reach out and draw the beam of light, its form begins to coalesce immediately."
			char Crowley "Impossible! You drew the blade of the former demon king!?"
			char Kobaneko "'Hi-no-Kagutsuchi'"
			read -p "[the look on his face is almost indecipherable, but his eyes were locked solely on you]"
			char Crowley "Why would a human want to mingle with subhuman filth… Above his own kind. It defies all logic. No, it goes against nature itself."
			char Crowley "An aberration like you- with all the knowledge I’ve given you. Becoming Demon King? I cannot suffer you leave this place alive"
			battle "${goblin[@]}"
			;;
		"subjugate")
			read -p "You reach out and draw the beam of light, its form begins to coalesce immediately."
			char Kobaneko "Ah, the blade of Emperor Sutoku. So this is the path you have chosen, dear Human."
			char Kobaneko "Maybe I did rely on you far too much. Either way, I can’t very well let you leave this place knowing what you plan to do with that."
			read -p "[the ribbons around you seem to coalesce, bundling and knotting together into a terrifying figure]"
			char Kobaneko "If you truly believe yourself to be worthy of subjugating all demonkin, then a simple thing as defeating a Daimaou should be an afterthought"
			battle "${goblin[@]}"
			;;
	esac
	if [[ ${dialogueChecks[endWhiteCheck]} == 1 ]]; then
		read -p "A figure manifests before you in a flash of white. The same one who saved you from the brink of death. He stood with his arms folded, and a look of pride on his face."
		char White "You are incredible."
		read -p "Without a second word, he is upon you."
		battle "${goblin[@]}"
		char White "Your strength is unparalleled. You are-..."
		read -p "His last few words were muffled, as the room began to unfold and warp. Above you, which should’ve been the upper floors of the depth, now bore open the crimson skies of the demon realm."
		Izanagi
	fi
	Ending ${ending}
}

Izanagi(){
	read -p "Amidst the red, a ray of swirling light falls down before you, and from it emerges a man."
	char ??? "You wield untenable power, mortal. You may witness me."
	talkstate=1
	while [[ $talkstate = 1 ]]
	do
	select rep in "${izanagiActiveList[@]}"
	do
		case $rep in
			"Who are you")
				char Izanagi-no-Mikoto "My name is Izanagi no Mikoto. Your ancestors one hundred generations ahead of your father would build shrines in my name."
				unset izanagiActiveList[0]
				break;;
			"What happens if she resurrects?")
				char Izanagi-no-Mikoto "If she is able to break the cloths that bind her and make her way to the human realm, she will bring with her death of an unimaginable scale"
				break;;
			"What do you want")
				char Izanagi-no-Mikoto "That power you wield in your hand is a weapon of my crafting. A spear of light meant to keep my wife from being resurrected."
				izanagiActiveList+=("What happens if she resurrects?")
				unset izanagiActiveList[1]
				break;;
			"What happened to White")
				char Izanagi-no-Mikoto "You refer to the boy you bested in combat? He was an aid that has served its purpose. A role that has been opened anew"
				unset izanagiActiveList[2]
				izanagiActiveList+=("Purpose?")
				break;;
			"Purpose?")
				char Izanagi-no-Mikoto "Yes. The only way for her to be free is for a powerful enough Daimaou to break the seals I placed on her almost a millennia ago."
				char Izanagi-no-Mikoto "His former purpose, and your new one, is to take the head of any demon king who attempts such an act. That sword you wield was merely a stopgap until a new ‘Messenger’ could be found."
				char Izanagi-no-Mikoto "So fierce warrior, do you pledge loyalty to me?"
				select resp in Yes No
                		do
                		       case $resp in
					       Yes)
						       ending="whitewar"
						       talkstate=0
						       break 2;;
					       No)
						       char Izanagi-no-Mikoto "..."
						       char Izanagi-no-Mikoto "You deny a god? I hope then for your sake that whatever you have obtained is worth the heavenly ire you have drawn."
						       read -p "The so called god vanishes as abruptly as it manifested."
						       talkstate=0
						       break 2;;
				       esac
			       done
			       break;;
		esac
	done
done
}

Ending(){
	ending=("$1") 
	case $ending in
		"redeemed")
			echo "Ended Redeemed";;
		"ascend")
			echo "Ended Ascend";;
		"subjugate")
			echo "Ended Subjugate";;
		"whitewar")
			echo "Ended WhiteWar";;
	esac
	Credits
}

Credits(){
	echo "developed in vi by AxiomDays" | sed  -e :a -e "s/^.\{1,$(tput cols)\}$/ & /;ta" | tr -d '\n' | head -c $(tput cols)
	echo ""
	echo "written by AxiomDays" | sed  -e :a -e "s/^.\{1,$(tput cols)\}$/ & /;ta" | tr -d '\n' | head -c $(tput cols)
	echo ""
	echo "ascii-art from ''" | sed  -e :a -e "s/^.\{1,$(tput cols)\}$/ & /;ta" | tr -d '\n' | head -c $(tput cols)
	echo ""
	echo "Thanks for Playing!" | sed  -e :a -e "s/^.\{1,$(tput cols)\}$/ & /;ta" | tr -d '\n' | head -c $(tput cols)
	exit
}
