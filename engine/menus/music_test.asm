MusicTestMenu:
	call ClearScreen
	call RunDefaultPaletteCommand
	call LoadTextBoxTilePatterns
	call LoadFontTilePatterns
	call UpdateSprites
	call MusicTest_Stop
	ld hl, wStatusFlags5
	set BIT_NO_TEXT_DELAY, [hl]
	hlcoord 4, 2
	ld de, MusicTestTitleText
	call PlaceString
	hlcoord 2, 4
	ld de, MusicTestCurrentTrackText
	call PlaceString
	hlcoord 2, 10
	ld de, MusicTestInstructionsText
	call PlaceString
	ld hl, wStatusFlags5
	res BIT_NO_TEXT_DELAY, [hl]
	xor a
	ld [wCurrentMenuItem], a
	call MusicTest_DisplayCurrent
	.loop
	call Joypad
	ldh a, [hJoyPressed]
	and a
	jr z, .noInput
	bit B_PAD_B, a
	jr nz, .exit
	bit B_PAD_A, a
	jr nz, .play
	bit B_PAD_START, a
	jr nz, .stop
	bit B_PAD_UP, a
	jr nz, .up
	bit B_PAD_LEFT, a
	jr nz, .up
	bit B_PAD_DOWN, a
	jr nz, .down
	bit B_PAD_RIGHT, a
	jr nz, .down
	jr .noInput
	.play
	call MusicTest_PlayCurrent
	jr .noInput
	.stop
	call MusicTest_Stop
	jr .noInput
	.up
	call MusicTest_Prev
	call MusicTest_DisplayCurrent
	jr .noInput
	.down
	call MusicTest_Next
	call MusicTest_DisplayCurrent
	jr .noInput
	.exit
	call MusicTest_Stop
	ld a, BANK(Music_TitleScreen)
	ld c, a
	ld a, MUSIC_TITLE_SCREEN
	call PlayMusic
	ret
	.noInput
	call DelayFrame
	jr .loop

MusicTest_DisplayCurrent:
	call MusicTest_GetEntryPointer
	inc hl
	inc hl
	ld e, [hl]
	inc hl
	ld d, [hl]
	push de
	ld hl, wStatusFlags5
	set BIT_NO_TEXT_DELAY, [hl]
	hlcoord 2, 6
	ld b, 3
	ld c, 18
	call ClearScreenArea
	pop de
	hlcoord 2, 6
	call PlaceString
	ld hl, wStatusFlags5
	res BIT_NO_TEXT_DELAY, [hl]
	ret

MusicTest_Next:
	ld a, [wCurrentMenuItem]
	inc a
	cp NUM_MUSIC_TEST_ENTRIES
	jr c, .store
	xor a
	.store
	ld [wCurrentMenuItem], a
	ret

MusicTest_Prev:
	ld a, [wCurrentMenuItem]
	and a
	jr z, .wrap
	dec a
	jr .store
	.wrap
	ld a, NUM_MUSIC_TEST_ENTRIES - 1
	.store
	ld [wCurrentMenuItem], a
	ret

MusicTest_PlayCurrent:
	call MusicTest_GetEntryPointer
	ld a, [hli]
	ld c, a
	ld a, [hl]
	call PlayMusic
	ret

MusicTest_Stop:
	ld a, SFX_STOP_ALL_MUSIC
	call PlaySound
	ret

MusicTest_GetEntryPointer:
	ld a, [wCurrentMenuItem]
	ld e, a
	ld d, 0
	ld hl, MusicTestEntries
	add hl, de
	add hl, de
	add hl, de
	add hl, de
	ret

DEF MUSIC_TEST_ENTRY_LENGTH EQU 4
DEF NUM_MUSIC_TEST_ENTRIES EQU 45

MACRO music_test_entry
	db BANK(\1)
	db \2
	dw \3
ENDM

MusicTestEntries:
	music_test_entry Music_PalletTown,        MUSIC_PALLET_TOWN,        MusicTestName_PalletTown
	music_test_entry Music_Pokecenter,        MUSIC_POKECENTER,         MusicTestName_Pokecenter
	music_test_entry Music_Gym,               MUSIC_GYM,                MusicTestName_Gym
	music_test_entry Music_Cities1,           MUSIC_CITIES1,            MusicTestName_Cities1
	music_test_entry Music_Cities2,           MUSIC_CITIES2,            MusicTestName_Cities2
	music_test_entry Music_Celadon,           MUSIC_CELADON,            MusicTestName_Celadon
	music_test_entry Music_Cinnabar,          MUSIC_CINNABAR,           MusicTestName_Cinnabar
	music_test_entry Music_Vermilion,         MUSIC_VERMILION,          MusicTestName_Vermilion
	music_test_entry Music_Lavender,          MUSIC_LAVENDER,           MusicTestName_Lavender
	music_test_entry Music_SSAnne,            MUSIC_SS_ANNE,            MusicTestName_SSAnne
	music_test_entry Music_MeetProfOak,       MUSIC_MEET_PROF_OAK,      MusicTestName_MeetProfOak
	music_test_entry Music_MeetRival,         MUSIC_MEET_RIVAL,         MusicTestName_MeetRival
	music_test_entry Music_MuseumGuy,         MUSIC_MUSEUM_GUY,         MusicTestName_MuseumGuy
	music_test_entry Music_SafariZone,        MUSIC_SAFARI_ZONE,        MusicTestName_SafariZone
	music_test_entry Music_PkmnHealed,        MUSIC_PKMN_HEALED,        MusicTestName_PkmnHealed
	music_test_entry Music_Routes1,           MUSIC_ROUTES1,            MusicTestName_Routes1
	music_test_entry Music_Routes2,           MUSIC_ROUTES2,            MusicTestName_Routes2
	music_test_entry Music_Routes3,           MUSIC_ROUTES3,            MusicTestName_Routes3
	music_test_entry Music_Routes4,           MUSIC_ROUTES4,            MusicTestName_Routes4
	music_test_entry Music_IndigoPlateau,     MUSIC_INDIGO_PLATEAU,     MusicTestName_IndigoPlateau
	music_test_entry Music_GymLeaderBattle,   MUSIC_GYM_LEADER_BATTLE,  MusicTestName_GymLeaderBattle
	music_test_entry Music_TrainerBattle,     MUSIC_TRAINER_BATTLE,     MusicTestName_TrainerBattle
	music_test_entry Music_WildBattle,        MUSIC_WILD_BATTLE,        MusicTestName_WildBattle
	music_test_entry Music_FinalBattle,       MUSIC_FINAL_BATTLE,       MusicTestName_FinalBattle
	music_test_entry Music_DefeatedTrainer,   MUSIC_DEFEATED_TRAINER,   MusicTestName_DefeatedTrainer
	music_test_entry Music_DefeatedWildMon,   MUSIC_DEFEATED_WILD_MON,  MusicTestName_DefeatedWildMon
	music_test_entry Music_DefeatedGymLeader, MUSIC_DEFEATED_GYM_LEADER, MusicTestName_DefeatedGymLeader
	music_test_entry Music_TitleScreen,       MUSIC_TITLE_SCREEN,       MusicTestName_TitleScreen
	music_test_entry Music_Credits,           MUSIC_CREDITS,            MusicTestName_Credits
	music_test_entry Music_HallOfFame,        MUSIC_HALL_OF_FAME,       MusicTestName_HallOfFame
	music_test_entry Music_OaksLab,           MUSIC_OAKS_LAB,           MusicTestName_OaksLab
	music_test_entry Music_JigglypuffSong,    MUSIC_JIGGLYPUFF_SONG,    MusicTestName_JigglypuffSong
	music_test_entry Music_BikeRiding,        MUSIC_BIKE_RIDING,        MusicTestName_BikeRiding
	music_test_entry Music_Surfing,           MUSIC_SURFING,            MusicTestName_Surfing
	music_test_entry Music_GameCorner,        MUSIC_GAME_CORNER,        MusicTestName_GameCorner
	music_test_entry Music_IntroBattle,       MUSIC_INTRO_BATTLE,       MusicTestName_IntroBattle
	music_test_entry Music_Dungeon1,          MUSIC_DUNGEON1,           MusicTestName_Dungeon1
	music_test_entry Music_Dungeon2,          MUSIC_DUNGEON2,           MusicTestName_Dungeon2
	music_test_entry Music_Dungeon3,          MUSIC_DUNGEON3,           MusicTestName_Dungeon3
	music_test_entry Music_CinnabarMansion,   MUSIC_CINNABAR_MANSION,   MusicTestName_CinnabarMansion
	music_test_entry Music_PokemonTower,      MUSIC_POKEMON_TOWER,      MusicTestName_PokemonTower
	music_test_entry Music_SilphCo,           MUSIC_SILPH_CO,           MusicTestName_SilphCo
	music_test_entry Music_MeetEvilTrainer,   MUSIC_MEET_EVIL_TRAINER,  MusicTestName_MeetEvilTrainer
	music_test_entry Music_MeetFemaleTrainer, MUSIC_MEET_FEMALE_TRAINER, MusicTestName_MeetFemaleTrainer
	music_test_entry Music_MeetMaleTrainer,   MUSIC_MEET_MALE_TRAINER,  MusicTestName_MeetMaleTrainer
MusicTestEntriesEnd:

MusicTestTitleText:
	db "MUSIC TEST@"

MusicTestCurrentTrackText:
	db "CURRENT TRACK:@"

MusicTestInstructionsText:
	db "UP/DOWN: SELECT"
	next "LEFT/RIGHT: SELECT"
	next "A: PLAY   B: EXIT"
	next "START: STOP@"

MusicTestName_PalletTown:
	db "01 PALLET TOWN@"

MusicTestName_Pokecenter:
	db "02 POKECENTER@"

MusicTestName_Gym:
	db "03 GYM@"

MusicTestName_Cities1:
	db "04 CITIES 1@"

MusicTestName_Cities2:
	db "05 CITIES 2@"

MusicTestName_Celadon:
	db "06 CELADON@"

MusicTestName_Cinnabar:
	db "07 CINNABAR@"

MusicTestName_Vermilion:
	db "08 VERMILION@"

MusicTestName_Lavender:
	db "09 LAVENDER@"

MusicTestName_SSAnne:
	db "10 S.S. ANNE@"

MusicTestName_MeetProfOak:
	db "11 MEET PROF. OAK@"

MusicTestName_MeetRival:
	db "12 MEET RIVAL@"

MusicTestName_MuseumGuy:
	db "13 MUSEUM GUY@"

MusicTestName_SafariZone:
	db "14 SAFARI ZONE@"

MusicTestName_PkmnHealed:
	db "15 PKMN HEALED@"

MusicTestName_Routes1:
	db "16 ROUTES 1@"

MusicTestName_Routes2:
	db "17 ROUTES 2@"

MusicTestName_Routes3:
	db "18 ROUTES 3@"

MusicTestName_Routes4:
	db "19 ROUTES 4@"

MusicTestName_IndigoPlateau:
	db "20 INDIGO PLATEAU@"

MusicTestName_GymLeaderBattle:
	db "21 GYM LEADER"
	next "BATTLE@"

MusicTestName_TrainerBattle:
	db "22 TRAINER BATTLE@"

MusicTestName_WildBattle:
	db "23 WILD BATTLE@"

MusicTestName_FinalBattle:
	db "24 FINAL BATTLE@"

MusicTestName_DefeatedTrainer:
	db "25 DEFEATED"
	next "TRAINER@"

MusicTestName_DefeatedWildMon:
	db "26 DEFEATED WILD"
	next "MON@"

MusicTestName_DefeatedGymLeader:
	db "27 DEFEATED GYM"
	next "LEADER@"

MusicTestName_TitleScreen:
	db "28 TITLE SCREEN@"

MusicTestName_Credits:
	db "29 CREDITS@"

MusicTestName_HallOfFame:
	db "30 HALL OF FAME@"

MusicTestName_OaksLab:
	db "31 OAK'S LAB@"

MusicTestName_JigglypuffSong:
	db "32 JIGGLYPUFF SONG@"

MusicTestName_BikeRiding:
	db "33 BIKE RIDING@"

MusicTestName_Surfing:
	db "34 SURFING@"

MusicTestName_GameCorner:
	db "35 GAME CORNER@"

MusicTestName_IntroBattle:
	db "36 INTRO BATTLE@"

MusicTestName_Dungeon1:
	db "37 DUNGEON 1@"

MusicTestName_Dungeon2:
	db "38 DUNGEON 2@"

MusicTestName_Dungeon3:
	db "39 DUNGEON 3@"

MusicTestName_CinnabarMansion:
	db "40 CINNABAR"
	next "MANSION@"

MusicTestName_PokemonTower:
	db "41 PKMN TOWER@"

MusicTestName_SilphCo:
	db "42 SILPH CO.@"

MusicTestName_MeetEvilTrainer:
	db "43 MEET EVIL"
	next "TRAINER@"

MusicTestName_MeetFemaleTrainer:
	db "44 MEET FEMALE"
	next "TRAINER@"

MusicTestName_MeetMaleTrainer:
	db "45 MEET MALE"
	next "TRAINER@"

ASSERT NUM_MUSIC_TEST_ENTRIES == (MusicTestEntriesEnd - MusicTestEntries) / MUSIC_TEST_ENTRY_LENGTH
