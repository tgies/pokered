MusicTest_CopyTrackName::
        ld hl, wMusicTestNamePointer
        ld e, [hl]
        inc hl
        ld d, [hl]
        call CopyToStringBuffer
        ret

MusicTestName_PalletTown::
        db "PALLET@"

MusicTestName_Pokecenter::
        db "CENTER@"

MusicTestName_Gym::
        db "GYM@"

MusicTestName_Cities1::
        db "CITIES1@"

MusicTestName_Cities2::
        db "CITIES2@"

MusicTestName_Celadon::
        db "CELADON@"

MusicTestName_Cinnabar::
        db "CINNABAR@"

MusicTestName_Vermilion::
        db "VERMILION@"

MusicTestName_Lavender::
        db "LAVENDER@"

MusicTestName_SSAnne::
        db "SS ANNE@"

MusicTestName_MeetProfOak::
        db "PROF. OAK@"

MusicTestName_MeetRival::
        db "RIVAL@"

MusicTestName_MuseumGuy::
        db "MUSEUM@"

MusicTestName_SafariZone::
        db "SAFARI@"

MusicTestName_PkmnHealed::
        db "HEAL@"

MusicTestName_Routes1::
        db "RT 1@"

MusicTestName_Routes2::
        db "RT 2@"

MusicTestName_Routes3::
        db "RT 3@"

MusicTestName_Routes4::
        db "RT 4@"

MusicTestName_IndigoPlateau::
        db "PLATEAU@"

MusicTestName_GymLeaderBattle::
        db "GYM BTL@"

MusicTestName_TrainerBattle::
        db "TRNR BTL@"

MusicTestName_WildBattle::
        db "WILD BTL@"

MusicTestName_FinalBattle::
        db "FINAL BTL@"

MusicTestName_DefeatedTrainer::
        db "DEFEAT TR@"

MusicTestName_DefeatedWildMon::
        db "DEFEAT WILD@"

MusicTestName_DefeatedGymLeader::
        db "DEFEAT GYM@"

MusicTestName_TitleScreen::
        db "TITLE@"

MusicTestName_Credits::
        db "CREDITS@"

MusicTestName_HallOfFame::
        db "HOF@"

MusicTestName_OaksLab::
        db "LAB@"

MusicTestName_JigglypuffSong::
        db "JIGGLY@"

MusicTestName_BikeRiding::
        db "BIKE@"

MusicTestName_Surfing::
        db "SURF@"

MusicTestName_GameCorner::
        db "CORNER@"

MusicTestName_IntroBattle::
        db "INTRO@"

MusicTestName_Dungeon1::
        db "DUNG 1@"

MusicTestName_Dungeon2::
        db "DUNG 2@"

MusicTestName_Dungeon3::
        db "DUNG 3@"

MusicTestName_CinnabarMansion::
        db "MANSION@"

MusicTestName_PokemonTower::
        db "TOWER@"

MusicTestName_SilphCo::
        db "SILPH@"

MusicTestName_MeetEvilTrainer::
        db "EVIL TR@"

MusicTestName_MeetFemaleTrainer::
        db "FEMALE TR@"

MusicTestName_MeetMaleTrainer::
        db "MALE TR@"
