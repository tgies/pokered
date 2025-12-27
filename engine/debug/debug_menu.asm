DebugMenu:
IF DEF(_DEBUG)
	call ClearScreen

	; These debug names are used for TestBattle.
	; StartNewGameDebug uses the debug names from PrepareOakSpeech.
	ld hl, DebugBattlePlayerName
	ld de, wPlayerName
	ld bc, NAME_LENGTH
	call CopyData

	ld hl, DebugBattleRivalName
	ld de, wRivalName
	ld bc, NAME_LENGTH
	call CopyData

	call LoadFontTilePatterns
	call LoadHpBarAndStatusTilePatterns
	call ClearSprites
	call RunDefaultPaletteCommand

	hlcoord 5, 6
	ld b, 3
	ld c, 9
	call TextBoxBorder

	hlcoord 7, 7
	ld de, DebugMenuOptions
	call PlaceString

	ld a, TEXT_DELAY_MEDIUM
	ld [wOptions], a

	ld a, PAD_A | PAD_B | PAD_START
	ld [wMenuWatchedKeys], a
	xor a
	ld [wMenuJoypadPollCount], a
	inc a
	ld [wMaxMenuItem], a
	ld a, 7
	ld [wTopMenuItemY], a
	dec a
	ld [wTopMenuItemX], a
	xor a
	ld [wCurrentMenuItem], a
	ld [wLastMenuItem], a
	ld [wMenuWatchMovingOutOfBounds], a

	call HandleMenuInput
	bit B_PAD_B, a
	jp nz, DisplayTitleScreen

	ld a, [wCurrentMenuItem]
	and a ; FIGHT?
	jp z, TestBattle

	; DEBUG
	ld hl, wStatusFlags6
	set BIT_DEBUG_MODE, [hl]
	jp StartNewGameDebug

DebugBattlePlayerName:
	db "Tom@"

DebugBattleRivalName:
	db "Juerry@"

DebugMenuOptions:
	db   "FIGHT"
	next "DEBUG@"
ELSE
	ret
ENDC

; TestBattle - ALWAYS AVAILABLE
; This is the AI Battle mode entry point
; Moved outside of DEF(_DEBUG) so it's always compiled
TestBattle::
	; Initialize graphics that would normally be set up by DebugMenu
	call ClearScreen
	call LoadFontTilePatterns
	call LoadHpBarAndStatusTilePatterns
	call ClearSprites
	call RunDefaultPaletteCommand

	; Set up default player/rival names for the battle
	ld hl, .AIBattlePlayerName
	ld de, wPlayerName
	ld bc, NAME_LENGTH
	call CopyData

	ld hl, .AIBattleRivalName
	ld de, wRivalName
	ld bc, NAME_LENGTH
	call CopyData

.loop
	call GBPalNormal

	; Don't mess around with obedience.
	ld a, 1 << BIT_EARTHBADGE
	ld [wObtainedBadges], a

	; Do NOT set BIT_TEST_BATTLE, as it forces the battle engine to use a debug move (POUND)
	; instead of the player's selected move.
	; ld hl, wStatusFlags7
	; set BIT_TEST_BATTLE, [hl]

	; Reset the party.
	ld hl, wPartyCount
	xor a
	ld [hli], a
	dec a
	ld [hl], a

	; Give the player a level 50 Pikachu (for AI battles).
	; wMonDataLocation = 0 means: player party + show nickname prompt
	; User will need to press A/B to skip it, but data is correct
	ld a, PIKACHU
	ld [wCurPartySpecies], a
	ld a, 50
	ld [wCurEnemyLevel], a
	xor a
	ld [wMonDataLocation], a
	ld [wCurMap], a
	call AddPartyMon

	; Fight against a level 10 Mew (will be replaced by AI-generated Pokemon).
	ld a, MEW
	ld [wCurOpponent], a

	predef InitOpponent

	; When the battle ends, do it all again.
	ld a, 1
	ld [wUpdateSpritesEnabled], a
	ldh [hAutoBGTransferEnabled], a
	jr .loop

.AIBattlePlayerName:
	db "RED@"

.AIBattleRivalName:
	db "BLUE@"
