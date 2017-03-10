	/*

	Note from the author:

	Hi, as of writing this I'll be occupied with a full-time software engineering educational activity for about 12 weeks, in 1 week.

	If this script breaks on Specter, which unfortunately despite my efforts it may do, this script should be fixable with a few minutes in Cheat Engine nonetheless.
	Simply declare a new state block with your updated values -- use memory.MainModuleSize or whatever it's called to determine the version.

	Then all that needs to be done is to replace these variables in the update and split blocks -- you can ignore the scanning logic and all that.
	(replace vars.playerGold.Current with current.PlayerGold, for example)

	Notes on the variables:

	SaveSlot:
	This one is pretty stable -- it is used in the reset and start blocks for autostart and autoreset.
	It should work across versions. If it breaks, however, it is a static byte which matches (saveslotselected - 1), and is 9 in the title.

	PlayerGold:
	Also a static value which matches your current gold.

	HPPlayerDisplay:
	This value is a dynamic value which changes addresses when changing stages, and has no pointers on the map screen.
	This value is a float.
	This is what is shown at the top of the HUD when in a stage.
	This is not the actual player HP.

	HPBossDisplay:
	This value is a dynamic value which changes addresses when changing stages, and has no pointers on the map screen.
	This value is a float.
	This is what is shown at the top of the HUD when in a stage.
	This is not the actual boss HP.

	PlagueKnight:
	Currently used as a boolean value, but will probably have a third state (2) when Specter comes out (?)
	Static value and is used for some stage split checks

	StageID:
	Stage identifying the current stage the player is on
	Doesn't seem to exist in 1.1 (?)

	In most games, pointer offsets do not tend to change when they are updated -- however, this seems different in SK's case.
	A big thanks to Shane for offering to put searchable patterns in memory -- this may actually help a lot with static values, but unfortunately it poses a few problems for dynamic memory and other values.

	If you have any questions, feel free to PM me on Discord

	Cheers,
	Souzooka

	P.S. I'll probably be implementing position-based splits for transitions into bossrooms as well, so SK's position values may have to be updated worst case as well.

	*/

	/*
	
	Known issues: LS can return a "Cannot perform runtime binding on a null reference" error occasionally, and this may cause logic errors.

	*/




	/* List of stage IDs:
	8: The Plains (Black Knight) (✓)
	9: Pridemoor Keep (King Knight) (✓)
	10: The Lich Yard (Specter Knight) (✓)
	11: The Explodatorium (Plague Knight) (✓)
	12: Iron Whale (Treasure Knight) (✓)
	13: Lost City (Mole Knight) (✓)
	14: Clockwork Tower (Tinker Knight) (✓)
	15: Stranded Ship (Polar Knight) (✓)
	16: Flying Machine (Propeller Knight) (✓)
	17: Tower of Fate: Entrance (Black Knight EX) (✓)
	18: Tower of Fate: Ascent (Boss Rush) (✓)
	19: Tower of Fate: ???????? (Enchantress) (✓)
	38: Black Knight 2 (✓)
	*/

	/*
	SaveSlot (✓)
	PlayerGold (in progress)
	HPPlayerDisplay (Ｘ)
	HPBossDisplay (Ｘ)
	PlagueKnight (Ｘ)
	StageID (Ｘ)
	*/

state("ShovelKnight")
{
	// Player stats
/*	bool PlagueKnight : 0x4CEB04; // false for Shovel Knight, true for Plague Knight*/
/*	uint PlayerGold : 0x4CEB14; // S*/
/*	float HPPlayerDisplay : 0x4CC0EC, 0x94, 0x420, 0x18, 0x2C; // Display for player life at top of screen*/

	// Misc Stats
/*	byte StageID : 0x4CF994;*/
/*	byte SaveSlot : 0x4CEDE8; // 9 in title, becomes (saveslot - 1) when "yes" is pressed -- this is 0-based*/

/*	// Boss HPs
	float HPBossDisplay : 0x4CC0EC, 0x94, 0x424, 0x18, 0x2C; // Display for boss life at top of screen -- if this is anything but 0 or null we're in a boss fight.
	*/
}

startup
{
	// SETTINGS START
	// Header settings
	settings.Add("splits", true, "Splits");
	settings.Add("splitsStage", false, "Stage Splits (on boss activation)", "splits");
	settings.Add("splitsBossRoom", false, "Stage Splits (on entering boss room)", "splits");
	settings.Add("splitsGold", true, "Boss Splits (on gold)", "splits");
	settings.Add("splitsKill", true, "Boss Splits (on kill)", "splits");
	settings.Add("splitsFadeOut", false, "Boss Splits (on fadeout)", "splits");
	settings.Add("splitsDreams", false, "Dream Splits", "splits");

	// On Stage Splits
	settings.Add("plainsStage", true, "The Plains", "splitsStage");
	settings.Add("pridemoorKeepStage", true, "Pridemoor Keep", "splitsStage");
	settings.Add("lichYardStage", true, "Lich Yard", "splitsStage");
	settings.Add("explodatoriumStage", true, "Explodatorium", "splitsStage");
	settings.Add("ironWhaleStage", true, "Iron Whale", "splitsStage");
	settings.Add("lostCityStage", true, "Lost City", "splitsStage");
	settings.Add("clockTowerStage", true, "Clock Tower", "splitsStage");
	settings.Add("strandedShipStage", true, "Stranded Ship", "splitsStage");
	settings.Add("flyingMachineStage", true, "Flying Machine", "splitsStage");
	settings.Add("toFEntranceStage", true, "Tower of Fate: Entrance", "splitsStage");
	settings.Add("toFBossRushStage", true, "Tower of Fate: Ascent", "splitsStage");
	settings.Add("toFEnchantressStage", true, "Tower of Fate: ????????", "splitsStage");

	// On Bossroom Splits
	settings.Add("plainsBossRoom", false, "The Plains", "splitsBossRoom");
	settings.Add("pridemoorKeepBossRoom", true, "Pridemoor Keep", "splitsBossRoom");
	settings.Add("lichYardBossRoom", true, "Lich Yard", "splitsBossRoom");
	settings.Add("explodatoriumBossRoom", true, "Explodatorium", "splitsBossRoom");
	settings.Add("ironWhaleBossRoom", true, "Iron Whale", "splitsBossRoom");
	settings.Add("lostCityBossRoom", true, "Lost City", "splitsBossRoom");
	settings.Add("clockTowerBossRoom", true, "Clock Tower", "splitsBossRoom");
	settings.Add("strandedShipBossRoom", true, "Stranded Ship", "splitsBossRoom");
	settings.Add("flyingMachineBossRoom", true, "Flying Machine", "splitsBossRoom");
	settings.Add("toFEntranceBossRoom", true, "Tower of Fate: Entrance", "splitsBossRoom");
	settings.Add("toFBossRushBossRoom", true, "Tower of Fate: Ascent", "splitsBossRoom");
	settings.Add("toFEnchantressBossRoom", true, "Tower of Fate: ????????", "splitsBossRoom");

	// On Gold Boss Splits
	settings.Add("plainsGold", true, "Black Knight 1 (The Plains)", "splitsGold");
	settings.Add("pridemoorKeepGold", true, "King Knight (Pridemoor Keep)", "splitsGold");
	settings.Add("lichYardGold", true, "Specter Knight (Lich Yard)", "splitsGold");
	settings.Add("explodatoriumGold", true, "Plague Knight (Explodatorium)", "splitsGold");
	settings.Add("ironWhaleGold", true, "Treasure Knight (Iron Whale)", "splitsGold");
	settings.Add("lostCityGold", true, "Mole Knight (Lost City)", "splitsGold");
	settings.Add("clockTowerGold", true, "Tinker Knight (Clock Tower)", "splitsGold");
	settings.Add("strandedShipGold", true, "Polar Knight (Stranded Ship)", "splitsGold");
	settings.Add("flyingMachineGold", true, "Propeller Knight (Flying Machine)", "splitsGold");
	settings.Add("toFEntranceGold", true, "Black Knight 3 (Tower of Fate: Entrance)", "splitsGold");
	settings.Add("blackKnight2Gold", true, "Black Knight 2 (PK Only)", "splitsGold");

	// On Kill Splits
	settings.Add("plainsKill", false, "Black Knight 1 (The Plains)", "splitsKill");
	settings.Add("pridemoorKeepKill", false, "King Knight (Pridemoor Keep)", "splitsKill");
	settings.Add("lichYardKill", false, "Specter Knight (Lich Yard)", "splitsKill");
	settings.Add("explodatoriumKill", false, "Plague Knight (Explodatorium)", "splitsKill");
	settings.Add("ironWhaleKill", false, "Treasure Knight (Iron Whale)", "splitsKill");
	settings.Add("lostCityKill", false, "Mole Knight (Lost City)", "splitsKill");
	settings.Add("clockTowerKill", false, "Tinker Knight (Clock Tower)", "splitsKill");
	settings.Add("strandedShipKill", false, "Polar Knight (Stranded Ship)", "splitsKill");
	settings.Add("flyingMachineKill", false, "Propeller Knight (Flying Machine)", "splitsKill");
	settings.Add("toFEntranceKill", false, "Black Knight 3 (Tower of Fate: Entrance)", "splitsKill");
	settings.Add("blackKnight2Kill", false, "Black Knight 2 (PK Only)", "splitsKill");
	settings.Add("toFBossRushKill", true, "Boss Rush (Tower of Fate: Ascent)", "splitsKill");
	settings.Add("toFEnchantress1Kill", true, "Enchantress 1 (Tower of Fate: ????????)", "splitsKill");
	settings.Add("toFEnchantress2Kill", true, "Enchantress 2 (Tower of Fate: ????????)", "splitsKill");

	// On Fade Out Boss Splits
	settings.Add("plainsFadeOut", true, "The Plains", "splitsFadeOut");
	settings.Add("pridemoorKeepFadeOut", true, "Pridemoor Keep", "splitsFadeOut");
	settings.Add("lichYardFadeOut", true, "Lich Yard", "splitsFadeOut");
	settings.Add("explodatoriumFadeOut", true, "Explodatorium", "splitsFadeOut");
	settings.Add("ironWhaleFadeOut", true, "Iron Whale", "splitsFadeOut");
	settings.Add("lostCityFadeOut", true, "Lost City", "splitsFadeOut");
	settings.Add("clockTowerFadeOut", true, "Clock Tower", "splitsFadeOut");
	settings.Add("strandedShipFadeOut", true, "Stranded Ship", "splitsFadeOut");
	settings.Add("flyingMachineFadeOut", true, "Flying Machine", "splitsFadeOut");
	settings.Add("toFEntranceFadeOut", true, "Tower of Fate: Entrance", "splitsFadeOut");
	settings.Add("toFBossRushFadeOut", true, "Tower of Fate: Ascent", "splitsFadeOut");
	settings.Add("blackKnight2FadeOut", true, "Black Knight 2 (PK Only)", "splitsFadeOut");

	// Dream Splits
	settings.Add("dream1", true, "Dream 1", "splitsDreams");
	settings.Add("dream2", true, "Dream 2", "splitsDreams");
	settings.Add("dream3", true, "Dream 3", "splitsDreams");

	// SETTINGS END
}

init 
{

	// CUSTOM/PLACEHOLDER VARIABLES START
	// These two variables should be accessible inside the whole init block
	var module = modules.First();
	var scanner = new SignatureScanner(game, module.BaseAddress, module.ModuleMemorySize);

	vars.bossRecentlyDefeated = false;
	vars.bossKillCounter = 0;

	vars.versionFound = false;
	vars.version = "";
	vars.versionNumber = 2.4;
	vars.specterOfTorment = false;

	vars.rescanStaticStopwatch = new Stopwatch();
	vars.rescanHPDisplayStopwatch = new Stopwatch();
	vars.rescanVersionStopwatch = new Stopwatch();
	vars.recentlyDeadStopwatch = new Stopwatch();

	vars.watchers = new MemoryWatcherList();

	vars.plagueKnight = new MemoryWatcher<bool>(IntPtr.Zero);
	vars.playerGold = new MemoryWatcher<uint>(IntPtr.Zero);
	vars.stageID = new MemoryWatcher<byte>(IntPtr.Zero);
	vars.saveSlot = new MemoryWatcher<byte>(IntPtr.Zero);
	vars.hpPlayerDisplay = new MemoryWatcher<float>(IntPtr.Zero);
	vars.hpBossDisplay = new MemoryWatcher<float>(IntPtr.Zero);
	vars.playerPosX = new MemoryWatcher<float>(IntPtr.Zero);
	vars.playerPosY = new MemoryWatcher<float>(IntPtr.Zero);

	vars.hpPlayerDisplayCodeAddr = IntPtr.Zero;
	vars.versionCodeAddr = IntPtr.Zero;
	vars.saveSlotCodeAddr = IntPtr.Zero;
	vars.saveSlotSpecterCodeAddr = IntPtr.Zero;

	vars.plagueKnightAddr = IntPtr.Zero;
	vars.playerGoldAddr = IntPtr.Zero;
	vars.stageIDAddr = IntPtr.Zero;
	vars.saveSlotAddr = IntPtr.Zero;
	vars.hpPlayerDisplayAddr = (IntPtr)0x2C;
	vars.hpBossDisplayAddr = (IntPtr)0x2C;
	vars.playerPosXAddr = (IntPtr)0xC;

	vars.plainsStage = false;
	vars.pridemoorKeepStage = false;
	vars.lichYardStage = false;
	vars.explodatoriumStage = false;
	vars.ironWhaleStage = false;
	vars.lostCityStage = false;
	vars.clockTowerStage = false;
	vars.strandedShipStage = false;
	vars.flyingMachineStage = false;
	vars.toFEntranceStage = false;
	vars.toFBossRushStage = false;
	vars.toFEnchantressStage = false;
	vars.plainsBossRoom = false;
	vars.pridemoorKeepBossRoom = false;
	vars.lichYardBossRoom = false;
	vars.explodatoriumBossRoom = false;
	vars.ironWhaleBossRoom = false;
	vars.lostCityBossRoom = false;
	vars.clockTowerBossRoom = false;
	vars.strandedShipBossRoom = false;
	vars.flyingMachineBossRoom = false;
	vars.toFEntranceBossRoom = false;
	vars.toFBossRushBossRoom = false;
	vars.toFEnchantressBossRoom = false;
	vars.toFEnchantress1Kill = false;
	vars.toFEntranceFadeOut = false;
	vars.toFBossRushFadeOut = false;
	vars.blackKnight2FadeOut = false;
	vars.stagesCount = 0;
	vars.dream1 = false;
	vars.dream2 = false;
	vars.dream3 = false;

	// REMINDER: The base address is always the same in each instance of the same version. You only need to scan for it in init when the game is loaded, and never again!
	// REMINDER: The only things which may need readjusting are the pointer values.

	// PlagueKnight offsets: Static
	vars.plagueKnightTarget = new SigScanTarget(1,
		"A1 ?? ?? ?? ??",		// Target Address
		"83 F8 01",
		"75 13",
		"83 3D ?? ?? ?? ?? 0B",
		"74 14",
		"8B 7D F8");

	// PlayerGold offsets: Static
	// PlayerGold base address scan (if game updates):
	vars.playerGoldTarget = new SigScanTarget(23,
		"C6 83 ?? ?? ?? ?? 01",
		"83 BB ?? ?? ?? ?? 00",
		"75 0B",
		"8B 83 ?? ?? ?? ??",
		"A3 ?? ?? ?? ??", 		// Target Address
		"5F");

	// StageID offsets: Static
	vars.stageIDTarget = new SigScanTarget(1,
		"A3 ?? ?? ?? ??",
		"C6 05 ?? ?? ?? ?? 00",
		"89 8E ?? ?? ?? ??",
		"C6 86 ?? ?? ?? ?? 01");

	// SaveSlot offsets: Static
	vars.saveSlotTarget = new SigScanTarget(2,
		"C6 05 ?? ?? ?? ?? 09"	// Target Address
		);

	// Tentative, saveSlot might be 10 when in title for Specter
	vars.saveSlotSpecterTarget = new SigScanTarget(2,
		"C6 05 ?? ?? ?? ?? 0A"	// Target Address
		);

	// Version String offsets: 0x14, 0x34, 0x60
	vars.versionTarget = new SigScanTarget(2,
		"8B 35 ?? ?? ?? ??",
		"3B F3",
		"74 16",
		"90",
		"8B 4E 04",
		"8B 11",
		"8B 52 04",
		"8D 45 08",
		"50");

	// Note: Rescan pointers when stage ID changes

	// HPPlayerDisplay offsets: 0x94, 0x420, 0x18, 0x2C
	// HPBossDisplay offsets: 0x94, 0x424, 0x18, 0x2C
	// HPPlayerDisplay base address scan (if game updates):
	vars.hpPlayerDisplayTarget = new SigScanTarget(1,
		"A1 ?? ?? ?? ??", 		// Target Address
		"80 78 24 00",
		"?? ?? ?? ?? ?? ??",
		"56",
		"57",
		"8D 71 1D"
		);

	// CUSTOM/PLACEHOLDER VARIABLES END

	// SCANNING ACTIONS START 
	Action<string> RescanStatic = (text) => {

		vars.playerGoldCodeAddr = scanner.Scan(vars.playerGoldTarget);
		vars.playerGoldAddr = memory.ReadValue<int>((IntPtr)vars.playerGoldCodeAddr);
		vars.playerGold = new MemoryWatcher<uint>((IntPtr)vars.playerGoldAddr);

		vars.plagueKnightCodeAddr = scanner.Scan(vars.plagueKnightTarget);
		vars.plagueKnightAddr = memory.ReadValue<int>((IntPtr)vars.plagueKnightCodeAddr);
		vars.plagueKnight = new MemoryWatcher<bool>((IntPtr)vars.plagueKnightAddr);

		vars.stageIDCodeAddr = scanner.Scan(vars.stageIDTarget);
		vars.stageIDAddr = memory.ReadValue<int>((IntPtr)vars.stageIDCodeAddr);
		vars.stageID = new MemoryWatcher<byte>((IntPtr)vars.stageIDAddr);

		vars.saveSlotCodeAddr = scanner.Scan(vars.saveSlotTarget);
		vars.saveSlotSpecterCodeAddr = scanner.Scan(vars.saveSlotSpecterTarget);

		if (vars.saveSlotCodeAddr == IntPtr.Zero && vars.saveSlotSpecterCodeAddr != IntPtr.Zero) {
			vars.specterOfTorment = true;
			vars.saveSlotCodeAddr = vars.saveSlotSpecterCodeAddr;
		}

		vars.saveSlotAddr = memory.ReadValue<int>((IntPtr)vars.saveSlotCodeAddr);
		vars.saveSlot = new MemoryWatcher<byte>((IntPtr)vars.saveSlotAddr);

		vars.watchers.AddRange(new MemoryWatcher[]
		{
			vars.playerGold,
			vars.plagueKnight,
			vars.stageID,
			vars.saveSlot
		});

	};

	Action<string> RescanHPDisplay = (text) => {

		// Base address won't change, so check to prevent unnecessary scans
		if ((IntPtr)vars.hpPlayerDisplayCodeAddr == IntPtr.Zero) {
			vars.hpPlayerDisplayCodeAddr = scanner.Scan(vars.hpPlayerDisplayTarget);

			vars.hpPlayerDisplayBaseAddr = memory.ReadValue<int>((IntPtr)vars.hpPlayerDisplayCodeAddr);
			vars.hpBossDisplayBaseAddr = vars.hpPlayerDisplayBaseAddr;
		}

		vars.hpPlayerDisplayPointerLevel1 = memory.ReadValue<int>((IntPtr)vars.hpPlayerDisplayBaseAddr) + 0x94;
		vars.hpBossDisplayPointerLevel1 = vars.hpPlayerDisplayPointerLevel1;

		vars.hpPlayerDisplayPointerLevel2 = memory.ReadValue<int>((IntPtr)vars.hpPlayerDisplayPointerLevel1) + 0x420;
		vars.hpBossDisplayPointerLevel2 = memory.ReadValue<int>((IntPtr)vars.hpBossDisplayPointerLevel1) + 0x424;

		vars.hpPlayerDisplayPointerLevel3 = memory.ReadValue<int>((IntPtr)vars.hpPlayerDisplayPointerLevel2) + 0x18;
		vars.hpBossDisplayPointerLevel3 = memory.ReadValue<int>((IntPtr)vars.hpBossDisplayPointerLevel2) + 0x18;

		vars.hpPlayerDisplayAddrOld = vars.hpPlayerDisplayAddr;

		vars.hpPlayerDisplayAddr = memory.ReadValue<int>((IntPtr)vars.hpPlayerDisplayPointerLevel3) + 0x2C;
		vars.hpBossDisplayAddr = memory.ReadValue<int>((IntPtr)vars.hpBossDisplayPointerLevel3) + 0x2C;

		if ((IntPtr)vars.hpPlayerDisplayAddrOld == (IntPtr)0x2C && (IntPtr)vars.hpPlayerDisplayAddr != (IntPtr)0x2C) {

			vars.hpPlayerDisplay = new MemoryWatcher<float>((IntPtr)vars.hpPlayerDisplayAddr);
			vars.hpBossDisplay = new MemoryWatcher<float>((IntPtr)vars.hpBossDisplayAddr);

			vars.watchers.AddRange(new MemoryWatcher[]
			{
				vars.hpPlayerDisplay,
				vars.hpBossDisplay
			});
		}

		vars.playerPosPointerLevel1 = memory.ReadValue<int>((IntPtr)vars.hpPlayerDisplayBaseAddr) + 0x84;
		vars.playerPosPointerLevel2 = memory.ReadValue<int>((IntPtr)vars.playerPosPointerLevel1) + 0xB40;
		vars.playerPosPointerLevel3 = memory.ReadValue<int>((IntPtr)vars.playerPosPointerLevel2) + 0x20;

		vars.playerPosXAddrOld = vars.playerPosXAddr;

		vars.playerPosXAddr = memory.ReadValue<int>((IntPtr)vars.playerPosPointerLevel3) + 0xC;
		vars.playerPosYAddr = memory.ReadValue<int>((IntPtr)vars.playerPosPointerLevel3) + 0x10;

		if ((IntPtr)vars.playerPosXAddrOld == (IntPtr)0xC && (IntPtr)vars.playerPosXAddr != (IntPtr)0xC) {

			vars.playerPosX = new MemoryWatcher<float>((IntPtr)vars.playerPosXAddr);
			vars.playerPosY = new MemoryWatcher<float>((IntPtr)vars.playerPosYAddr);

			vars.watchers.AddRange(new MemoryWatcher[]
			{
				vars.playerPosX,
				vars.playerPosY
			});
		}

	};

	Action<string> RescanVersion = (text) => {
		if ((IntPtr)vars.versionCodeAddr == IntPtr.Zero) {
			vars.versionCodeAddr = scanner.Scan(vars.versionTarget);
			vars.versionBaseAddr = memory.ReadValue<int>((IntPtr)vars.versionCodeAddr);
		}

		vars.versionPointerLevel1 = memory.ReadValue<int>((IntPtr)vars.versionBaseAddr) + 0x14;

		vars.versionPointerLevel2 = memory.ReadValue<int>((IntPtr)vars.versionPointerLevel1) + 0x34;

		vars.versionAddr = memory.ReadValue<int>((IntPtr)vars.versionPointerLevel2) + 0x60;

		vars.version = memory.ReadString((IntPtr)vars.versionAddr, 256);

		if (vars.version.Length > 7 && vars.version.Substring(0, 7) == "version") {
			vars.versionFound = true;
			version = vars.version;
			vars.versionNumber = Convert.ToSingle(vars.version.Substring(8, 3));
		}
	};

	vars.RescanStatic = RescanStatic;
	vars.RescanHPDisplay = RescanHPDisplay;
	vars.RescanVersion = RescanVersion;

	vars.testAddr = scanner.Scan(vars.playerGoldLastOffsetTarget);
	vars.test = memory.ReadValue<int>((IntPtr)vars.testAddr); 

	// SCANNING ACTIONS END
}

update
{

	vars.watchers.UpdateAll(game);
	// Note: "ShovelKnight.exe"+0x0 isn't a null area of memory 
	// Rescan Static logic start (This shouldn't have to be used more than once!)
	if ((IntPtr)vars.playerGoldAddr == IntPtr.Zero && !vars.rescanStaticStopwatch.IsRunning) {
	    vars.rescanStaticStopwatch.Start();
	}

	if (vars.rescanStaticStopwatch.ElapsedMilliseconds >= 1000) {
		vars.rescanStaticStopwatch.Reset();
		vars.RescanStatic("");
	}
	// Rescan Static logic end

	// Rescan HP Display logic start
	if (!vars.rescanHPDisplayStopwatch.IsRunning) {
		vars.rescanHPDisplayStopwatch.Start();
	}

	// Rescan Pointer paths every 0.1 second -- this logic shouldn't cause any problems
	if (vars.rescanHPDisplayStopwatch.ElapsedMilliseconds >= 100) {
		vars.rescanHPDisplayStopwatch.Reset();
		vars.RescanHPDisplay("");
	}
	// Rescan HP Display logic end

	// Rescan Version logic start
	// ONLY WORKS IF THE SCRIPT IS RUNNING BEFORE A SAVE IS SELECTED!
	// There is no *real* way to automatically detect the version from what I've found.
	// We want to know what the version is so in case the Specter Knight patch just renders the game into pieces, we might still be able to use one script for all executables.
	if (!vars.versionFound && !vars.rescanVersionStopwatch.IsRunning) {
		vars.rescanVersionStopwatch.Start();
	}

	if (vars.rescanVersionStopwatch.ElapsedMilliseconds >= 500) {
		vars.rescanVersionStopwatch.Reset();
		vars.RescanVersion("");
	}
	// Rescan Version logic end

	// current.HPPlayerDisplay does not become null when respawning
	if (vars.hpBossDisplay.Current == 0 && vars.hpPlayerDisplay.Current > 0 && vars.hpBossDisplay.Old != 0) {
		vars.bossRecentlyDefeated = true;
		vars.bossKillCounter++;
	}

	// if we're dead, or the pointer isn't being used (last offset is 0x2C, so it'll point to 0x0000002C in memory) (in map, title, etc.), reset these variables
	if (vars.hpPlayerDisplay.Current == 0 || (IntPtr)vars.hpPlayerDisplayAddr == (IntPtr)0x2C) {
		vars.recentlyDeadStopwatch.Restart();
		vars.bossRecentlyDefeated = false;
		vars.bossKillCounter = 0;
	}

	// the Player HP can possibly be shown as boss HP for a frame after spawning, so add a check
	if (vars.recentlyDeadStopwatch.ElapsedMilliseconds >= 100) {
		vars.recentlyDeadStopwatch.Reset();
	}

	if (timer.CurrentPhase == TimerPhase.NotRunning) {
		vars.plainsStage = false;
		vars.pridemoorKeepStage = false;
		vars.lichYardStage = false;
		vars.explodatoriumStage = false;
		vars.ironWhaleStage = false;
		vars.lostCityStage = false;
		vars.clockTowerStage = false;
		vars.strandedShipStage = false;
		vars.flyingMachineStage = false;
		vars.toFEntranceStage = false;
		vars.toFBossRushStage = false;
		vars.toFEnchantressStage = false;
		vars.plainsBossRoom = false;
		vars.pridemoorKeepBossRoom = false;
		vars.lichYardBossRoom = false;
		vars.explodatoriumBossRoom = false;
		vars.ironWhaleBossRoom = false;
		vars.lostCityBossRoom = false;
		vars.clockTowerBossRoom = false;
		vars.strandedShipBossRoom = false;
		vars.flyingMachineBossRoom = false;
		vars.toFEntranceBossRoom = false;
		vars.toFBossRushBossRoom = false;
		vars.toFEnchantressBossRoom = false;
		vars.toFEnchantress1Kill = false;
		vars.toFEntranceFadeOut = false;
		vars.toFBossRushFadeOut = false;
		vars.blackKnight2FadeOut = false;
		vars.stagesCount = 0;
		vars.dream1 = false;
		vars.dream2 = false;
		vars.dream3 = false;
	}

	
}

start
{
	// Start when a save slot is selected
	if (!vars.specterOfTorment) {
		return vars.saveSlot.Current < 9 && vars.saveSlot.Old == 9;
	}
	else if (vars.specterOfTorment) {
		return vars.saveSlot.Current < 10 && vars.saveSlot.Old == 10;
	}
}

reset
{
	// Reset when save slot is deselected (which happens when going to title)
	if (!vars.specterOfTorment) {
		return vars.saveSlot.Current == 9 && vars.saveSlot.Old != 9;
	}
	else if (vars.specterOfTorment) {
		return vars.saveSlot.Current == 10 && vars.saveSlot.Old != 10;
	}
}

split
{
	// Stage splits
	if (vars.hpBossDisplay.Old == 0 && vars.hpBossDisplay.Current > 0 && !vars.recentlyDeadStopwatch.IsRunning) {
		switch((byte)vars.stageID.Current) {
			case 8:
				// The Plains
				if (!vars.plainsStage && vars.hpBossDisplay.Current != 8) {
					vars.plainsStage = true;
					return settings["plainsStage"];
				}
				break;
			case 9:
				// Pridemoor Keep
				if (!vars.pridemoorKeepStage) {
					vars.pridemoorKeepStage = true;
					return settings["pridemoorKeepStage"];
				}
				break;
			case 10:
				// The Lich Yard
				if (!vars.lichYardStage) {
					vars.lichYardStage = true;
					return settings["lichYardStage"];
				}
				break;
			case 11:
				// The Explodatorium
				if (!vars.explodatoriumStage) {
					vars.explodatoriumStage = true;
					return settings["explodatoriumStage"];
				}
				break;
			case 12:
				// Iron Whale
				if (!vars.ironWhaleStage) {
					vars.ironWhaleStage = true;
					return settings["ironWhaleStage"];
				}
				break;
			case 13:
				// Lost City
				if (!vars.lostCityStage) {
					vars.lostCityStage = true;
					return settings["lostCityStage"];
				}
				break;
			case 14:
				// Clock Tower
				if (!vars.clockTowerStage) {
					vars.clockTowerStage = true;
					return settings["clockTowerStage"];
				}
				break;
			case 15:
				// Stranded Ship
				if (!vars.strandedShipStage) {
					vars.strandedShipStage = true;
					return settings["strandedShipStage"];
				}
				break;
			case 16:
				// Flying Machine
				if (!vars.flyingMachineStage) {
					vars.flyingMachineStage = true;
					return settings["flyingMachineStage"];
				}
				break;
			case 17:
				// Tower of Fate: Entrance
				if (!vars.toFEntranceStage) {
					vars.toFEntranceStage = true;
					return settings["toFEntranceStage"];
				}
				break;
			case 18:
				// Tower of Fate: Ascent
				if (!vars.toFBossRushStage) {
					vars.toFBossRushStage = true;
					return settings["toFBossRushStage"];
				}
				break;
			case 19:
				// Tower of Fate: ????????
				if (!vars.toFEnchantressStage) {
					vars.toFEnchantressStage = true;
					return settings["toFEnchantressStage"];
				}
				break;
			default:
				return false;
		}
	}

	// Bossroom transition splits
	switch((byte)vars.stageID.Current) {
		case 8:
			if (!vars.plainsBossRoom && 
					(vars.playerPosX.Current >= 718 && vars.playerPosX.Current <= 750) &&
					(vars.playerPosY.Current >= -407 && vars.playerPosY.Current <= -370)) {
				vars.plainsBossRoom = true;
				return settings["plainsBossRoom"];
			}
			break;
		case 9:
			if (!vars.pridemoorKeepBossRoom && 
					(vars.playerPosX.Current >= 757.7 && vars.playerPosX.Current <= 800) &&
					(vars.playerPosY.Current >= -200 && vars.playerPosY.Current <= -188)) {
				vars.pridemoorKeepBossRoom = true;
				return settings["pridemoorKeepBossRoom"];
			}
			break;
		case 10:
			if (!vars.lichYardBossRoom && 
					(vars.playerPosX.Current >= 931.2 && vars.playerPosX.Current <= 970.5) &&
					(vars.playerPosY.Current >= -122 && vars.playerPosY.Current <= -100)) {
				vars.lichYardBossRoom = true;
				return settings["lichYardBossRoom"];
			}
			break;
		case 11:
			if (!vars.explodatoriumBossRoom && 
					(vars.playerPosX.Current >= 958 && vars.playerPosX.Current <= 1000) &&
					(vars.playerPosY.Current >= -230 && vars.playerPosY.Current <= -207)) {
				vars.explodatoriumBossRoom = true;
				return settings["explodatoriumBossRoom"];
			}
			break;
		case 12:
			if (!vars.ironWhaleBossRoom && 
					(vars.playerPosX.Current >= 836.7 && vars.playerPosX.Current <= 875) &&
					(vars.playerPosY.Current >= -213 && vars.playerPosY.Current <= -195)) {
				vars.ironWhaleBossRoom = true;
				return settings["ironWhaleBossRoom"];
			}
			break;
		case 13:
			if (!vars.lostCityBossRoom && 
					(vars.playerPosX.Current >= 878.4 && vars.playerPosX.Current <= 916) &&
					(vars.playerPosY.Current >= -258 && vars.playerPosY.Current <= -240)) {
				vars.lostCityBossRoom = true;
				return settings["lostCityBossRoom"];
			}
			break;
		case 14:
			if (!vars.clockTowerBossRoom && 
					(vars.playerPosX.Current >= 635.2 && vars.playerPosX.Current <= 673) &&
					(vars.playerPosY.Current >= -255 && vars.playerPosY.Current <= -220)) {
				vars.clockTowerBossRoom = true;
				return settings["clockTowerBossRoom"];
			}
			break;
		case 15:
			if (!vars.strandedShipBossRoom && 
					(vars.playerPosX.Current >= 902.4 && vars.playerPosX.Current <= 942) &&
					(vars.playerPosY.Current >= -100 && vars.playerPosY.Current <= -50)) {
				vars.strandedShipBossRoom = true;
				return settings["strandedShipBossRoom"];
			}
			break;
		case 16:
			if (!vars.flyingMachineBossRoom && 
					(vars.playerPosX.Current >= 926.4 && vars.playerPosX.Current <= 970) &&
					(vars.playerPosY.Current >= -80 && vars.playerPosY.Current <= -30)) {
				vars.flyingMachineBossRoom = true;
				return settings["flyingMachineBossRoom"];
			}
			break;
		case 17:
			if (!vars.toFEntranceBossRoom && 
					(vars.playerPosX.Current >= 1036.8 && vars.playerPosX.Current <= 1070) &&
					(vars.playerPosY.Current >= -120 && vars.playerPosY.Current <= -30)) {
				vars.toFEntranceBossRoom = true;
				return settings["toFEntranceBossRoom"];
			}
			break;
		case 18:
			if (!vars.toFBossRushBossRoom && 
					(vars.playerPosX.Current >= 663 && vars.playerPosX.Current <= 700) &&
					(vars.playerPosY.Current >= -190 && vars.playerPosY.Current <= -169.4)) {
				vars.toFBossRushBossRoom = true;
				return settings["toFBossRushBossRoom"];
			}
			break;
		case 19:
			if (!vars.toFEnchantressBossRoom && 
					(vars.playerPosX.Current >= 433.6 && vars.playerPosX.Current <= 480) &&
					(vars.playerPosY.Current >= -210 && vars.playerPosY.Current <= -169.4)) {
				vars.toFEnchantressBossRoom = true;
				return settings["toFEnchantressBossRoom"];
			}
			break;
		default:
			break;
	}

	// split on getting gold after every required boss
	// we do not want vars.bossRecentlyDefeated and vars.bossKillCounter to get reset in undefined stages
	if (vars.bossRecentlyDefeated && vars.playerGold.Current > vars.playerGold.Old) {
		switch((byte)vars.stageID.Current) {
			case 8:
				// The Plains
				return settings["plainsGold"];
			case 9:
				// Pridemoor Keep
				return settings["pridemoorKeepGold"];
			case 10:
				// The Lich Yard
				return settings["lichYardGold"];
			case 11:
				// The Explodatorium
				return settings["explodatoriumGold"];
			case 12:
				// Iron Whale
				return settings["ironWhaleGold"];
			case 13:
				// Lost City
				return settings["lostCityGold"];
			case 14:
				// Clock Tower
				if (vars.plagueKnight.Current) {
					return settings["clockTowerGold"] && vars.bossKillCounter == 3;
				}
				else if (!vars.plagueKnight.Current) {
					return settings["clockTowerGold"] && vars.bossKillCounter == 2;
				}
				break;
			case 15:
				// Stranded Ship
				return settings["strandedShipGold"];
			case 16:
				// Flying Machine
				return settings["flyingMachineGold"];
			case 17:
				// Tower of Fate: Entrance
				return settings["toFEntranceGold"];
			case 38:
				// Black Knight 2
				return settings["blackKnight2Gold"] && vars.plagueKnight.Current;
			default:
				return false;
		}
	}

	// On Kill splits
	if (vars.hpBossDisplay.Current == 0 && vars.hpBossDisplay.Old != 0 && vars.hpPlayerDisplay.Current > 0) {
		switch((byte)vars.stageID.Current) {
			case 8:
				// The Plains
				return settings["plainsKill"];
			case 9:
				// Pridemoor Keep
				return settings["pridemoorKeepKill"];
			case 10:
				// The Lich Yard
				return settings["lichYardKill"];
			case 11:
				// The Explodatorium
				return settings["explodatoriumKill"];
			case 12:
				// Iron Whale
				return settings["ironWhaleKill"];
			case 13:
				// Lost City
				return settings["lostCityKill"];
			case 14:
				// Clock Tower
				if (vars.plagueKnight.Current) {
					return settings["clockTowerKill"] && vars.bossKillCounter == 3;
				}
				else if (!vars.plagueKnight.Current) {
					return settings["clockTowerKill"] && vars.bossKillCounter == 2;
				}
				break;
			case 15:
				// Stranded Ship
				return settings["strandedShipKill"];
			case 16:
				// Flying Machine
				return settings["flyingMachineKill"];
			case 17:
				// Tower of Fate: Entrance
				return settings["toFEntranceKill"];
			case 18:
				// Tower of Fate: Ascent
				return settings["toFBossRushKill"] && vars.bossKillCounter == 9;
			case 19:
				// Tower of Fate: ????????
				if (!vars.toFEnchantress1Kill && vars.bossKillCounter == 1) {
					vars.toFEnchantress1Kill = true;
					return settings["toFEnchantress1Kill"];
				}
				else if (vars.bossKillCounter == 2) {
					return settings["toFEnchantress2Kill"];
				}
				break;
			case 38:
				// Black Knight 2
				return settings["blackKnight2Kill"] && vars.plagueKnight.Current;
			default:
				return false;
		}
	}

	// Stage Fadeout Splits
	if (vars.stageID.Current == 24 || vars.stageID.Current == 126 && vars.stageID.Old != 24) {
		switch ((byte)vars.stageID.Old) {
			case 8:
				// The Plains
				vars.stagesCount++;
				return settings["plainsFadeOut"] && vars.stageID.Current == 24;
			case 9:
				// Pridemoor Keep
				vars.stagesCount++;
				return settings["pridemoorKeepFadeOut"] && vars.stageID.Current == 24;
			case 10:
				// The Lich Yard
				vars.stagesCount++;
				return settings["lichYardFadeOut"] && vars.stageID.Current == 24;
			case 11:
				// The Explodatorium
				vars.stagesCount++;
				return settings["explodatoriumFadeOut"] && vars.stageID.Current == 24;
			case 12:
				// Iron Whale
				vars.stagesCount++;
				return settings["ironWhaleFadeOut"] && vars.stageID.Current == 24;
			case 13:
				// Lost City
				vars.stagesCount++;
				return settings["lostCityFadeOut"] && vars.stageID.Current == 24;
			case 14:
				// Clock Tower
				vars.stagesCount++;
				return settings["clockTowerFadeOut"] && vars.stageID.Current == 24;
			case 15:
				// Stranded Ship
				vars.stagesCount++;
				return settings["strandedShipFadeOut"] && vars.stageID.Current == 24;
			case 16:
				// Flying Machine
				vars.stagesCount++;
				return settings["flyingMachineFadeOut"] && vars.stageID.Current == 24;
			case 17:
				// Tower of Fate: Entrance
				if (!vars.toFEntranceFadeOut && vars.stageID.Current == 126 && vars.toFEntranceBossRoom) {
					vars.stagesCount = 0;
					vars.toFEntranceFadeOut = true;
					return settings["toFEntranceFadeOut"] && vars.stageID.Current == 126;
				}
				break;
			case 18:
				// Tower of Fate: Ascent
				if (!vars.toFBossRushFadeOut && vars.stageID.Current == 126 && vars.toFBossRushBossRoom) {
					vars.toFBossRushFadeOut = true;
					return settings["toFBossRushFadeOut"] && vars.stageID.Current == 126;
				}
				break;
			case 38:
				// Black Knight 2
				if (!vars.blackKnight2FadeOut) {
					vars.blackKnight2FadeOut = true;
					return settings["blackKnight2FadeOut"] && vars.stageID.Current == 126 && vars.plagueKnight.Current;
				}
				break;
			default:
				break;
		}
	}


	// Dream Splits
	if (vars.stageID.Current == 126 && vars.stagesCount % 3 == 0) {
		switch ((byte)vars.stagesCount) {
			case 3:
				if (!vars.dream1) {
					vars.dream1 = true;
					return settings["dream1"];
				}
				break;
			case 6:
				if (!vars.dream2) {
					vars.dream2 = true;
					return settings["dream2"];
				}
				break;
			case 9:
				if (!vars.dream3) {
					vars.dream3 = true;
					return settings["dream3"];
				}
				break;
			default:
				break;
		}
	}
}
