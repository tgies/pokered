; Music test menu that allows playing any track from the game.

DEF MUSIC_TEST_ENTRY_LENGTH EQU 4
DEF NUM_MUSIC_TEST_TRACKS EQU 45
DEF MUSIC_TEST_STRINGS_BANK EQU BANK(MusicTest_CopyTrackName)

DisplayMusicTestMenu::
        call MusicTest_InitScreen
        call MusicTest_EnsureSelectionInRange
        call MusicTest_DrawSelection
.loop
        call JoypadLowSensitivity
        ldh a, [hJoy5]
        and a
        jr z, .loop
        ld b, a
        bit B_PAD_B, b
        jr nz, .exit
        bit B_PAD_START, b
        jr nz, .stop
        bit B_PAD_SELECT, b
        jr nz, .stop
        bit B_PAD_A, b
        jr nz, .play
        bit B_PAD_LEFT, b
        jr nz, .previous
        bit B_PAD_UP, b
        jr nz, .previous
        bit B_PAD_RIGHT, b
        jr nz, .next
        bit B_PAD_DOWN, b
        jr nz, .next
        jr .loop
.play
        call MusicTest_PlayCurrent
        jr .loop
.stop
        call MusicTest_Stop
        jr .loop
.previous
        call MusicTest_MovePrevious
        jr .loop
.next
        call MusicTest_MoveNext
        jr .loop
.exit
        call MusicTest_Stop
        ld a, SFX_PRESS_AB
        call PlaySound
        ret

MusicTest_InitScreen:
        call ClearScreen
        call RunDefaultPaletteCommand
        call LoadTextBoxTilePatterns
        call LoadFontTilePatterns
        call UpdateSprites
        hlcoord 0, 0
        ld b, 12
        ld c, 18
        call TextBoxBorder
        hlcoord 2, 1
        ld de, MusicTestTitleText
        call PlaceString
        hlcoord 2, 2
        ld de, MusicTestPromptText
        call PlaceString
        hlcoord 2, 9
        ld de, MusicTestControlsLine1
        call PlaceString
        hlcoord 2, 10
        ld de, MusicTestControlsLine2
        call PlaceString
        hlcoord 2, 11
        ld de, MusicTestControlsLine3
        call PlaceString
        ld a, $01
        ldh [hAutoBGTransferEnabled], a
        call Delay3
        ret

MusicTest_EnsureSelectionInRange:
        ld a, [wMusicTestSelection]
        cp NUM_MUSIC_TEST_TRACKS
        ret c
        xor a
        ld [wMusicTestSelection], a
        ret

MusicTest_MoveNext:
        ld a, [wMusicTestSelection]
        inc a
        cp NUM_MUSIC_TEST_TRACKS
        jr c, .store
        xor a
.store
        ld [wMusicTestSelection], a
        jp MusicTest_OnSelectionChanged

MusicTest_MovePrevious:
        ld a, [wMusicTestSelection]
        and a
        jr nz, .decrement
        ld a, NUM_MUSIC_TEST_TRACKS
.decrement
        dec a
        ld [wMusicTestSelection], a
        jp MusicTest_OnSelectionChanged

MusicTest_OnSelectionChanged:
        ld a, SFX_SWITCH
        call PlaySound
        jp MusicTest_DrawSelection

MusicTest_DrawSelection:
        hlcoord 1, 3
        lb bc, 4, 18
        call ClearScreenArea
        hlcoord 2, 3
        ld de, MusicTestTrackLabel
        call PlaceString
        ld a, [wMusicTestSelection]
        inc a
        ld [wMusicTestCurrentNumber], a
        hlcoord 8, 3
        ld de, wMusicTestCurrentNumber
        lb bc, LEADING_ZEROES | 1, 2
        call PrintNumber
        hlcoord 10, 3
        ld de, MusicTestTrackSeparator
        call PlaceString
        hlcoord 11, 3
        ld de, MusicTestTrackCount
        lb bc, LEADING_ZEROES | 1, 2
        call PrintNumber
        call MusicTest_GetEntryPointer
        ld a, [hli]
        ld a, [hli]
        ld a, [hl]
        ld [wMusicTestNamePointer], a
        inc hl
        ld a, [hl]
        ld [wMusicTestNamePointer + 1], a
        ld b, MUSIC_TEST_STRINGS_BANK
        ld hl, MusicTest_CopyTrackName
        call Bankswitch
        ld de, wStringBuffer
        hlcoord 2, 4
        call PlaceString
        ret

MusicTest_GetEntryPointer:
        ld a, [wMusicTestSelection]
        ld hl, MusicTestTracks
        ld bc, MUSIC_TEST_ENTRY_LENGTH
        call AddNTimes
        ret

MusicTest_PlayCurrent:
        call MusicTest_GetEntryPointer
        ld a, [hli]
        ld b, a
        ld a, [hli]
        ld c, a
        ld a, b
        jp PlayMusic

MusicTest_Stop:
        ld a, SFX_STOP_ALL_MUSIC
        jp PlaySound

MusicTestTitleText:
        db "MUSIC TEST@"
MusicTestPromptText:
        db "SELECT A TRACK@"
MusicTestControlsLine1:
        db "A: PLAY   B: EXIT@"
MusicTestControlsLine2:
        db "START: STOP TUNE@"
MusicTestControlsLine3:
        db "UP/DOWN OR L/R@"
MusicTestTrackLabel:
        db "TRACK@"
MusicTestTrackSeparator:
        db "/@"
MusicTestTrackCount:
        db NUM_MUSIC_TEST_TRACKS

MusicTestTracks:
        table_width MUSIC_TEST_ENTRY_LENGTH
        db MUSIC_PALLET_TOWN
        db BANK(Music_PalletTown)
        dw MusicTestName_PalletTown
        db MUSIC_POKECENTER
        db BANK(Music_Pokecenter)
        dw MusicTestName_Pokecenter
        db MUSIC_GYM
        db BANK(Music_Gym)
        dw MusicTestName_Gym
        db MUSIC_CITIES1
        db BANK(Music_Cities1)
        dw MusicTestName_Cities1
        db MUSIC_CITIES2
        db BANK(Music_Cities2)
        dw MusicTestName_Cities2
        db MUSIC_CELADON
        db BANK(Music_Celadon)
        dw MusicTestName_Celadon
        db MUSIC_CINNABAR
        db BANK(Music_Cinnabar)
        dw MusicTestName_Cinnabar
        db MUSIC_VERMILION
        db BANK(Music_Vermilion)
        dw MusicTestName_Vermilion
        db MUSIC_LAVENDER
        db BANK(Music_Lavender)
        dw MusicTestName_Lavender
        db MUSIC_SS_ANNE
        db BANK(Music_SSAnne)
        dw MusicTestName_SSAnne
        db MUSIC_MEET_PROF_OAK
        db BANK(Music_MeetProfOak)
        dw MusicTestName_MeetProfOak
        db MUSIC_MEET_RIVAL
        db BANK(Music_MeetRival)
        dw MusicTestName_MeetRival
        db MUSIC_MUSEUM_GUY
        db BANK(Music_MuseumGuy)
        dw MusicTestName_MuseumGuy
        db MUSIC_SAFARI_ZONE
        db BANK(Music_SafariZone)
        dw MusicTestName_SafariZone
        db MUSIC_PKMN_HEALED
        db BANK(Music_PkmnHealed)
        dw MusicTestName_PkmnHealed
        db MUSIC_ROUTES1
        db BANK(Music_Routes1)
        dw MusicTestName_Routes1
        db MUSIC_ROUTES2
        db BANK(Music_Routes2)
        dw MusicTestName_Routes2
        db MUSIC_ROUTES3
        db BANK(Music_Routes3)
        dw MusicTestName_Routes3
        db MUSIC_ROUTES4
        db BANK(Music_Routes4)
        dw MusicTestName_Routes4
        db MUSIC_INDIGO_PLATEAU
        db BANK(Music_IndigoPlateau)
        dw MusicTestName_IndigoPlateau
        db MUSIC_GYM_LEADER_BATTLE
        db BANK(Music_GymLeaderBattle)
        dw MusicTestName_GymLeaderBattle
        db MUSIC_TRAINER_BATTLE
        db BANK(Music_TrainerBattle)
        dw MusicTestName_TrainerBattle
        db MUSIC_WILD_BATTLE
        db BANK(Music_WildBattle)
        dw MusicTestName_WildBattle
        db MUSIC_FINAL_BATTLE
        db BANK(Music_FinalBattle)
        dw MusicTestName_FinalBattle
        db MUSIC_DEFEATED_TRAINER
        db BANK(Music_DefeatedTrainer)
        dw MusicTestName_DefeatedTrainer
        db MUSIC_DEFEATED_WILD_MON
        db BANK(Music_DefeatedWildMon)
        dw MusicTestName_DefeatedWildMon
        db MUSIC_DEFEATED_GYM_LEADER
        db BANK(Music_DefeatedGymLeader)
        dw MusicTestName_DefeatedGymLeader
        db MUSIC_TITLE_SCREEN
        db BANK(Music_TitleScreen)
        dw MusicTestName_TitleScreen
        db MUSIC_CREDITS
        db BANK(Music_Credits)
        dw MusicTestName_Credits
        db MUSIC_HALL_OF_FAME
        db BANK(Music_HallOfFame)
        dw MusicTestName_HallOfFame
        db MUSIC_OAKS_LAB
        db BANK(Music_OaksLab)
        dw MusicTestName_OaksLab
        db MUSIC_JIGGLYPUFF_SONG
        db BANK(Music_JigglypuffSong)
        dw MusicTestName_JigglypuffSong
        db MUSIC_BIKE_RIDING
        db BANK(Music_BikeRiding)
        dw MusicTestName_BikeRiding
        db MUSIC_SURFING
        db BANK(Music_Surfing)
        dw MusicTestName_Surfing
        db MUSIC_GAME_CORNER
        db BANK(Music_GameCorner)
        dw MusicTestName_GameCorner
        db MUSIC_INTRO_BATTLE
        db BANK(Music_IntroBattle)
        dw MusicTestName_IntroBattle
        db MUSIC_DUNGEON1
        db BANK(Music_Dungeon1)
        dw MusicTestName_Dungeon1
        db MUSIC_DUNGEON2
        db BANK(Music_Dungeon2)
        dw MusicTestName_Dungeon2
        db MUSIC_DUNGEON3
        db BANK(Music_Dungeon3)
        dw MusicTestName_Dungeon3
        db MUSIC_CINNABAR_MANSION
        db BANK(Music_CinnabarMansion)
        dw MusicTestName_CinnabarMansion
        db MUSIC_POKEMON_TOWER
        db BANK(Music_PokemonTower)
        dw MusicTestName_PokemonTower
        db MUSIC_SILPH_CO
        db BANK(Music_SilphCo)
        dw MusicTestName_SilphCo
        db MUSIC_MEET_EVIL_TRAINER
        db BANK(Music_MeetEvilTrainer)
        dw MusicTestName_MeetEvilTrainer
        db MUSIC_MEET_FEMALE_TRAINER
        db BANK(Music_MeetFemaleTrainer)
        dw MusicTestName_MeetFemaleTrainer
        db MUSIC_MEET_MALE_TRAINER
        db BANK(Music_MeetMaleTrainer)
        dw MusicTestName_MeetMaleTrainer
        assert_table_length NUM_MUSIC_TEST_TRACKS

; Track name strings are stored in text/music_test.asm.
