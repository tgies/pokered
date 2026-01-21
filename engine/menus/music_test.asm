SECTION "Music Test", ROMX

DisplayMusicTestMenu::
	call ClearScreen
	call RunDefaultPaletteCommand
	call LoadTextBoxTilePatterns
	call LoadFontTilePatterns
	hlcoord 0, 0
	ld b, 7
	ld c, 18
	call TextBoxBorder
	hlcoord 1, 1
	ld de, MusicTestTitleText
	call PlaceString
	hlcoord 1, 2
	ld de, MusicTestSelectText
	call PlaceString
	hlcoord 1, 3
	ld de, MusicTestPlayText
	call PlaceString
	hlcoord 1, 4
	ld de, MusicTestStopText
	call PlaceString
	hlcoord 1, 5
	ld de, MusicTestExitText
	call PlaceString
	hlcoord 0, 6
	ld b, 5
	ld c, 18
	call TextBoxBorder
	hlcoord 1, 7
	ld de, MusicTestTrackLabelText
	call PlaceString
	call UpdateSprites
	xor a
	ld [wMusicTestSelection], a
	call MusicTest_DrawSelection

.inputLoop
	xor a
	ldh [hJoyPressed], a
	ldh [hJoyReleased], a
	ldh [hJoyHeld], a
	call Joypad
	ldh a, [hJoyPressed]
	bit B_PAD_B, a
	jr nz, .exit
	bit B_PAD_START, a
	jr nz, .stop
	bit B_PAD_A, a
	jr nz, .play
	bit B_PAD_DOWN, a
	jr nz, .next
	bit B_PAD_RIGHT, a
	jr nz, .next
	bit B_PAD_UP, a
	jr nz, .prev
	bit B_PAD_LEFT, a
	jr nz, .prev
	jr .inputLoop

.next
	call MusicTest_NextTrack
	call MusicTest_DrawSelection
	jr .inputLoop

.prev
	call MusicTest_PrevTrack
	call MusicTest_DrawSelection
	jr .inputLoop

.play
	call MusicTest_PlayCurrent
	jr .inputLoop

.stop
	ld a, SFX_STOP_ALL_MUSIC
	call PlaySound
	jr .inputLoop

.exit
	ld a, SFX_STOP_ALL_MUSIC
	call PlaySound
	ret

MusicTest_DrawSelection:
	hlcoord 1, 8
	lb bc, 1, 16
	call ClearScreenArea
	call MusicTest_GetEntryPointer
	ld a, [hli]
	ld a, [hli]
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	push de
	ld a, [wMusicTestSelection]
	inc a
	ld [wMusicTestTrackNumber], a
	hlcoord 7, 7
	ld de, wMusicTestTrackNumber
	lb bc, LEADING_ZEROES | 1, 2
	call PrintNumber
	ld [hl], "/"
	inc hl
	ld de, MusicTestTotalCountValue
	lb bc, 1, 2
	call PrintNumber
	pop de
	hlcoord 1, 8
	call PlaceString
	ret

MusicTest_GetEntryPointer:
	ld a, [wMusicTestSelection]
	ld e, a
	ld d, 0
	ld hl, MusicTestTrackTable
	add hl, de
	add hl, de
	add hl, de
	add hl, de
	ret

MusicTest_NextTrack:
	ld a, [wMusicTestSelection]
	inc a
	ld hl, MusicTestTotalCountValue
	cp [hl]
	jr c, .store
	xor a
.store
	ld [wMusicTestSelection], a
	ret

MusicTest_PrevTrack:
	ld a, [wMusicTestSelection]
	and a
	jr nz, .decrement
	ld hl, MusicTestTotalCountValue
	ld a, [hl]
	dec a
	jr .store
.decrement
	dec a
.store
	ld [wMusicTestSelection], a
	ret

MusicTest_PlayCurrent:
	call MusicTest_GetEntryPointer
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	ld a, b
	call PlayMusic
	ret

MusicTestTitleText:
	db "MUSIC TEST@"

MusicTestSelectText:
	db "UP/DOWN: SELECT@"

MusicTestPlayText:
	db "A:PLAY@"

MusicTestStopText:
	db "START:STOP@"

MusicTestExitText:
	db "B:EXIT@"

MusicTestTrackLabelText:
	db "TRACK @"

DEF MUSIC_TEST_ENTRY_LENGTH EQU 4

MACRO music_test_entry
	db \1
	db BANK(\2)
	dw \3
ENDM

MusicTestTrackTable:
	music_test_entry MUSIC_PALLET_TOWN,         Music_PalletTown,        MusicTestTrackName_PalletTown
	music_test_entry MUSIC_POKECENTER,          Music_Pokecenter,        MusicTestTrackName_Pokecenter
	music_test_entry MUSIC_GYM,                 Music_Gym,               MusicTestTrackName_Gym
	music_test_entry MUSIC_CITIES1,             Music_Cities1,           MusicTestTrackName_Cities1
	music_test_entry MUSIC_CITIES2,             Music_Cities2,           MusicTestTrackName_Cities2
	music_test_entry MUSIC_CELADON,             Music_Celadon,           MusicTestTrackName_Celadon
	music_test_entry MUSIC_CINNABAR,            Music_Cinnabar,          MusicTestTrackName_Cinnabar
	music_test_entry MUSIC_VERMILION,           Music_Vermilion,         MusicTestTrackName_Vermilion
	music_test_entry MUSIC_LAVENDER,            Music_Lavender,          MusicTestTrackName_Lavender
	music_test_entry MUSIC_SS_ANNE,             Music_SSAnne,            MusicTestTrackName_SSAnne
	music_test_entry MUSIC_MEET_PROF_OAK,       Music_MeetProfOak,       MusicTestTrackName_MeetProfOak
	music_test_entry MUSIC_MEET_RIVAL,          Music_MeetRival,         MusicTestTrackName_MeetRival
	music_test_entry MUSIC_MUSEUM_GUY,          Music_MuseumGuy,         MusicTestTrackName_MuseumGuy
	music_test_entry MUSIC_SAFARI_ZONE,         Music_SafariZone,        MusicTestTrackName_SafariZone
	music_test_entry MUSIC_PKMN_HEALED,         Music_PkmnHealed,        MusicTestTrackName_PkmnHealed
	music_test_entry MUSIC_ROUTES1,             Music_Routes1,           MusicTestTrackName_Routes1
	music_test_entry MUSIC_ROUTES2,             Music_Routes2,           MusicTestTrackName_Routes2
	music_test_entry MUSIC_ROUTES3,             Music_Routes3,           MusicTestTrackName_Routes3
	music_test_entry MUSIC_ROUTES4,             Music_Routes4,           MusicTestTrackName_Routes4
	music_test_entry MUSIC_INDIGO_PLATEAU,      Music_IndigoPlateau,     MusicTestTrackName_IndigoPlateau
	music_test_entry MUSIC_GYM_LEADER_BATTLE,   Music_GymLeaderBattle,   MusicTestTrackName_GymLeaderBattle
	music_test_entry MUSIC_TRAINER_BATTLE,      Music_TrainerBattle,     MusicTestTrackName_TrainerBattle
	music_test_entry MUSIC_WILD_BATTLE,         Music_WildBattle,        MusicTestTrackName_WildBattle
	music_test_entry MUSIC_FINAL_BATTLE,        Music_FinalBattle,       MusicTestTrackName_FinalBattle
	music_test_entry MUSIC_DEFEATED_TRAINER,    Music_DefeatedTrainer,   MusicTestTrackName_DefeatedTrainer
	music_test_entry MUSIC_DEFEATED_WILD_MON,   Music_DefeatedWildMon,   MusicTestTrackName_DefeatedWild
	music_test_entry MUSIC_DEFEATED_GYM_LEADER, Music_DefeatedGymLeader, MusicTestTrackName_DefeatedLeader
	music_test_entry MUSIC_TITLE_SCREEN,        Music_TitleScreen,       MusicTestTrackName_TitleScreen
	music_test_entry MUSIC_CREDITS,             Music_Credits,           MusicTestTrackName_Credits
	music_test_entry MUSIC_HALL_OF_FAME,        Music_HallOfFame,        MusicTestTrackName_HallOfFame
	music_test_entry MUSIC_OAKS_LAB,            Music_OaksLab,           MusicTestTrackName_OaksLab
	music_test_entry MUSIC_JIGGLYPUFF_SONG,     Music_JigglypuffSong,    MusicTestTrackName_Jigglypuff
	music_test_entry MUSIC_BIKE_RIDING,         Music_BikeRiding,        MusicTestTrackName_BikeRiding
	music_test_entry MUSIC_SURFING,             Music_Surfing,           MusicTestTrackName_Surfing
	music_test_entry MUSIC_GAME_CORNER,         Music_GameCorner,        MusicTestTrackName_GameCorner
	music_test_entry MUSIC_INTRO_BATTLE,        Music_IntroBattle,       MusicTestTrackName_IntroBattle
	music_test_entry MUSIC_DUNGEON1,            Music_Dungeon1,          MusicTestTrackName_Dungeon1
	music_test_entry MUSIC_DUNGEON2,            Music_Dungeon2,          MusicTestTrackName_Dungeon2
	music_test_entry MUSIC_DUNGEON3,            Music_Dungeon3,          MusicTestTrackName_Dungeon3
	music_test_entry MUSIC_CINNABAR_MANSION,    Music_CinnabarMansion,   MusicTestTrackName_CinnabarMansion
	music_test_entry MUSIC_POKEMON_TOWER,       Music_PokemonTower,      MusicTestTrackName_PokemonTower
	music_test_entry MUSIC_SILPH_CO,            Music_SilphCo,           MusicTestTrackName_SilphCo
	music_test_entry MUSIC_MEET_EVIL_TRAINER,   Music_MeetEvilTrainer,   MusicTestTrackName_MeetEvilTrainer
	music_test_entry MUSIC_MEET_FEMALE_TRAINER, Music_MeetFemaleTrainer, MusicTestTrackName_MeetFemaleTrainer
	music_test_entry MUSIC_MEET_MALE_TRAINER,   Music_MeetMaleTrainer,   MusicTestTrackName_MeetMaleTrainer
MusicTestTrackTableEnd:

MusicTestTotalCountValue:
	db (MusicTestTrackTableEnd - MusicTestTrackTable) / MUSIC_TEST_ENTRY_LENGTH

MusicTestTrackName_PalletTown:
	db "PALLET@"
MusicTestTrackName_Pokecenter:
	db "POKE CTR@"
MusicTestTrackName_Gym:
	db "GYM@"
MusicTestTrackName_Cities1:
	db "CITY 1@"
MusicTestTrackName_Cities2:
	db "CITY 2@"
MusicTestTrackName_Celadon:
	db "CELADON@"
MusicTestTrackName_Cinnabar:
	db "CINNABAR@"
MusicTestTrackName_Vermilion:
	db "VERMILION@"
MusicTestTrackName_Lavender:
	db "LAVENDER@"
MusicTestTrackName_SSAnne:
	db "SS ANNE@"
MusicTestTrackName_MeetProfOak:
	db "PROF OAK@"
MusicTestTrackName_MeetRival:
	db "RIVAL@"
MusicTestTrackName_MuseumGuy:
	db "MUSEUM@"
MusicTestTrackName_SafariZone:
	db "SAFARI@"
MusicTestTrackName_PkmnHealed:
	db "HEAL@"
MusicTestTrackName_Routes1:
	db "ROUTE 1@"
MusicTestTrackName_Routes2:
	db "ROUTE 2@"
MusicTestTrackName_Routes3:
	db "ROUTE 3@"
MusicTestTrackName_Routes4:
	db "ROUTE 4@"
MusicTestTrackName_IndigoPlateau:
	db "INDIGO@"
MusicTestTrackName_GymLeaderBattle:
	db "GYM BTL@"
MusicTestTrackName_TrainerBattle:
	db "TRAINER@"
MusicTestTrackName_WildBattle:
	db "WILD@"
MusicTestTrackName_FinalBattle:
	db "FINAL@"
MusicTestTrackName_DefeatedTrainer:
	db "WIN TRNR@"
MusicTestTrackName_DefeatedWild:
	db "WIN WILD@"
MusicTestTrackName_DefeatedLeader:
	db "WIN LEAD@"
MusicTestTrackName_TitleScreen:
	db "TITLE@"
MusicTestTrackName_Credits:
	db "CREDITS@"
MusicTestTrackName_HallOfFame:
	db "HALL@"
MusicTestTrackName_OaksLab:
	db "OAK LAB@"
MusicTestTrackName_Jigglypuff:
	db "JIGGLY@"
MusicTestTrackName_BikeRiding:
	db "BIKE@"
MusicTestTrackName_Surfing:
	db "SURF@"
MusicTestTrackName_GameCorner:
	db "GAME@"
MusicTestTrackName_IntroBattle:
	db "INTRO@"
MusicTestTrackName_Dungeon1:
	db "DGN 1@"
MusicTestTrackName_Dungeon2:
	db "DGN 2@"
MusicTestTrackName_Dungeon3:
	db "DGN 3@"
MusicTestTrackName_CinnabarMansion:
	db "MANSION@"
MusicTestTrackName_PokemonTower:
	db "TOWER@"
MusicTestTrackName_SilphCo:
	db "SILPH@"
MusicTestTrackName_MeetEvilTrainer:
	db "EVIL TR@"
MusicTestTrackName_MeetFemaleTrainer:
	db "FEMALE@"
MusicTestTrackName_MeetMaleTrainer:
	db "MALE@"
