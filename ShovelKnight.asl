	/*

	Note from the author:

	Hi, as of writing this I'll be occupied with a full-time software engineering educational activity for about 12 weeks, in 1 week.

	If this script breaks on Specter, which unfortunately despite my efforts it may do, this script should be fixable with a few minutes in Cheat Engine nonetheless.
	Simply declare a new state block with your updated values -- use memory.MainModuleSize or whatever it's called to determine the version.

	Then all that needs to be done is to replace these variables in the update and split blocks -- you can ignore the scanning logic and all that.
	(replace vars.PlayerGold.Current with current.PlayerGold, for example)

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
	settings.Add("Splits", true, "Splits");
	settings.Add("SplitsStage", false, "Stage Splits (on boss activation)", "Splits");
	settings.Add("SplitsBossRoom", false, "Stage Splits (on entering boss room)", "Splits");
	settings.Add("SplitsGold", true, "Boss Splits (on gold)", "Splits");
	settings.Add("SplitsKill", true, "Boss Splits (on kill)", "Splits");
	settings.Add("SplitsFadeOut", false, "Boss Splits (on fadeout)", "Splits");
	settings.Add("SplitsDreams", false, "Dream Splits", "Splits");

	// On Stage Splits
	settings.Add("PlainsStage", true, "The Plains", "SplitsStage");
	settings.Add("PridemoorKeepStage", true, "Pridemoor Keep", "SplitsStage");
	settings.Add("LichYardStage", true, "Lich Yard", "SplitsStage");
	settings.Add("ExplodatoriumStage", true, "Explodatorium", "SplitsStage");
	settings.Add("IronWhaleStage", true, "Iron Whale", "SplitsStage");
	settings.Add("LostCityStage", true, "Lost City", "SplitsStage");
	settings.Add("ClockTowerStage", true, "Clock Tower", "SplitsStage");
	settings.Add("StrandedShipStage", true, "Stranded Ship", "SplitsStage");
	settings.Add("FlyingMachineStage", true, "Flying Machine", "SplitsStage");
	settings.Add("ToFEntranceStage", true, "Tower of Fate: Entrance", "SplitsStage");
	settings.Add("ToFBossRushStage", true, "Tower of Fate: Ascent", "SplitsStage");
	settings.Add("ToFEnchantressStage", true, "Tower of Fate: ????????", "SplitsStage");

	// On Bossroom Splits
	settings.Add("PlainsBossRoom", false, "The Plains", "SplitsBossRoom");
	settings.Add("PridemoorKeepBossRoom", true, "Pridemoor Keep", "SplitsBossRoom");
	settings.Add("LichYardBossRoom", true, "Lich Yard", "SplitsBossRoom");
	settings.Add("ExplodatoriumBossRoom", true, "Explodatorium", "SplitsBossRoom");
	settings.Add("IronWhaleBossRoom", true, "Iron Whale", "SplitsBossRoom");
	settings.Add("LostCityBossRoom", true, "Lost City", "SplitsBossRoom");
	settings.Add("ClockTowerBossRoom", true, "Clock Tower", "SplitsBossRoom");
	settings.Add("StrandedShipBossRoom", true, "Stranded Ship", "SplitsBossRoom");
	settings.Add("FlyingMachineBossRoom", true, "Flying Machine", "SplitsBossRoom");
	settings.Add("ToFEntranceBossRoom", true, "Tower of Fate: Entrance", "SplitsBossRoom");
	settings.Add("ToFBossRushBossRoom", true, "Tower of Fate: Ascent", "SplitsBossRoom");
	settings.Add("ToFEnchantressBossRoom", true, "Tower of Fate: ????????", "SplitsBossRoom");

	// On Gold Boss Splits
	settings.Add("PlainsGold", true, "Black Knight 1 (The Plains)", "SplitsGold");
	settings.Add("PridemoorKeepGold", true, "King Knight (Pridemoor Keep)", "SplitsGold");
	settings.Add("LichYardGold", true, "Specter Knight (Lich Yard)", "SplitsGold");
	settings.Add("ExplodatoriumGold", true, "Plague Knight (Explodatorium)", "SplitsGold");
	settings.Add("IronWhaleGold", true, "Treasure Knight (Iron Whale)", "SplitsGold");
	settings.Add("LostCityGold", true, "Mole Knight (Lost City)", "SplitsGold");
	settings.Add("ClockTowerGold", true, "Tinker Knight (Clock Tower)", "SplitsGold");
	settings.Add("StrandedShipGold", true, "Polar Knight (Stranded Ship)", "SplitsGold");
	settings.Add("FlyingMachineGold", true, "Propeller Knight (Flying Machine)", "SplitsGold");
	settings.Add("ToFEntranceGold", true, "Black Knight 3 (Tower of Fate: Entrance)", "SplitsGold");
	settings.Add("BlackKnight2Gold", true, "Black Knight 2 (PK Only)", "SplitsGold");

	// On Kill Splits
	settings.Add("PlainsKill", false, "Black Knight 1 (The Plains)", "SplitsKill");
	settings.Add("PridemoorKeepKill", false, "King Knight (Pridemoor Keep)", "SplitsKill");
	settings.Add("LichYardKill", false, "Specter Knight (Lich Yard)", "SplitsKill");
	settings.Add("ExplodatoriumKill", false, "Plague Knight (Explodatorium)", "SplitsKill");
	settings.Add("IronWhaleKill", false, "Treasure Knight (Iron Whale)", "SplitsKill");
	settings.Add("LostCityKill", false, "Mole Knight (Lost City)", "SplitsKill");
	settings.Add("ClockTowerKill", false, "Tinker Knight (Clock Tower)", "SplitsKill");
	settings.Add("StrandedShipKill", false, "Polar Knight (Stranded Ship)", "SplitsKill");
	settings.Add("FlyingMachineKill", false, "Propeller Knight (Flying Machine)", "SplitsKill");
	settings.Add("ToFEntranceKill", false, "Black Knight 3 (Tower of Fate: Entrance)", "SplitsKill");
	settings.Add("BlackKnight2Kill", false, "Black Knight 2 (PK Only)", "SplitsKill");
	settings.Add("ToFBossRushKill", true, "Boss Rush (Tower of Fate: Ascent)", "SplitsKill");
	settings.Add("ToFEnchantress1Kill", true, "Enchantress 1 (Tower of Fate: ????????)", "SplitsKill");
	settings.Add("ToFEnchantress2Kill", true, "Enchantress 2 (Tower of Fate: ????????)", "SplitsKill");

	// On Fade Out Boss Splits
	settings.Add("PlainsFadeOut", true, "The Plains", "SplitsFadeOut");
	settings.Add("PridemoorKeepFadeOut", true, "Pridemoor Keep", "SplitsFadeOut");
	settings.Add("LichYardFadeOut", true, "Lich Yard", "SplitsFadeOut");
	settings.Add("ExplodatoriumFadeOut", true, "Explodatorium", "SplitsFadeOut");
	settings.Add("IronWhaleFadeOut", true, "Iron Whale", "SplitsFadeOut");
	settings.Add("LostCityFadeOut", true, "Lost City", "SplitsFadeOut");
	settings.Add("ClockTowerFadeOut", true, "Clock Tower", "SplitsFadeOut");
	settings.Add("StrandedShipFadeOut", true, "Stranded Ship", "SplitsFadeOut");
	settings.Add("FlyingMachineFadeOut", true, "Flying Machine", "SplitsFadeOut");
	settings.Add("ToFEntranceFadeOut", true, "Tower of Fate: Entrance", "SplitsFadeOut");
	settings.Add("BlackKnight2FadeOut", true, "Black Knight 2 (PK Only)", "SplitsFadeOut");

	// Dream Splits
	settings.Add("Dream1", true, "Dream 1", "SplitsDreams");
	settings.Add("Dream2", true, "Dream 2", "SplitsDreams");
	settings.Add("Dream3", true, "Dream 3", "SplitsDreams");

	// SETTINGS END
}

init 
{

	// CUSTOM/PLACEHOLDER VARIABLES START
	// These two variables should be accessible inside the whole init block
	var module = modules.First();
	var scanner = new SignatureScanner(game, module.BaseAddress, module.ModuleMemorySize);

	vars.BossRecentlyDefeated = false;
	vars.BossKillCounter = 0;

	vars.VersionFound = false;
	vars.Version = "";
	vars.VersionNumber = 2.4;

	vars.RescanStaticStopwatch = new Stopwatch();
	vars.RescanHPDisplayStopwatch = new Stopwatch();
	vars.RescanVersionStopwatch = new Stopwatch();
	vars.RecentlyDeadStopwatch = new Stopwatch();

	vars.watchers = new MemoryWatcherList();

	vars.PlagueKnight = new MemoryWatcher<bool>(IntPtr.Zero);
	vars.PlayerGold = new MemoryWatcher<uint>(IntPtr.Zero);
	vars.StageID = new MemoryWatcher<byte>(IntPtr.Zero);
	vars.SaveSlot = new MemoryWatcher<byte>(IntPtr.Zero);
	vars.HPPlayerDisplay = new MemoryWatcher<float>(IntPtr.Zero);
	vars.HPBossDisplay = new MemoryWatcher<float>(IntPtr.Zero);
	vars.PlayerPosX = new MemoryWatcher<float>(IntPtr.Zero);
	vars.PlayerPosY = new MemoryWatcher<float>(IntPtr.Zero);

	vars.HPPlayerDisplayCodeAddr = IntPtr.Zero;
	vars.VersionCodeAddr = IntPtr.Zero;

	vars.PlagueKnightAddr = IntPtr.Zero;
	vars.PlayerGoldAddr = IntPtr.Zero;
	vars.StageIDAddr = IntPtr.Zero;
	vars.SaveSlotAddr = IntPtr.Zero;
	vars.HPPlayerDisplayAddr = (IntPtr)0x2C;
	vars.HPBossDisplayAddr = (IntPtr)0x2C;
	vars.PlayerPosXAddr = (IntPtr)0xC;

	vars.PlainsStage = false;
	vars.PridemoorKeepStage = false;
	vars.LichYardStage = false;
	vars.ExplodatoriumStage = false;
	vars.IronWhaleStage = false;
	vars.LostCityStage = false;
	vars.ClockTowerStage = false;
	vars.StrandedShipStage = false;
	vars.FlyingMachineStage = false;
	vars.ToFEntranceStage = false;
	vars.ToFBossRushStage = false;
	vars.ToFEnchantressStage = false;
	vars.PlainsBossRoom = false;
	vars.PridemoorKeepBossRoom = false;
	vars.LichYardBossRoom = false;
	vars.ExplodatoriumBossRoom = false;
	vars.IronWhaleBossRoom = false;
	vars.LostCityBossRoom = false;
	vars.ClockTowerBossRoom = false;
	vars.StrandedShipBossRoom = false;
	vars.FlyingMachineBossRoom = false;
	vars.ToFEntranceBossRoom = false;
	vars.ToFBossRushBossRoom = false;
	vars.ToFEnchantressBossRoom = false;
	vars.ToFEnchantress1Kill = false;
	vars.ToFEntranceFadeOut = false;
	vars.ToFBossRushFadeOut = false;
	vars.BlackKnight2FadeOut = false;
	vars.StagesCount = 0;
	vars.Dream1 = false;
	vars.Dream2 = false;
	vars.Dream3 = false;

	// REMINDER: The base address is always the same in each instance of the same version. You only need to scan for it in init when the game is loaded, and never again!
	// REMINDER: The only things which may need readjusting are the pointer values.

	// PlagueKnight offsets: Static
	vars.PlagueKnightTarget = new SigScanTarget(1,
		"A1 ?? ?? ?? ??",		// Target Address
		"83 F8 01",
		"75 13",
		"83 3D ?? ?? ?? ?? 0B",
		"74 14",
		"8B 7D F8");

	// PlayerGold offsets: Static
	// PlayerGold base address scan (if game updates):
	vars.PlayerGoldTarget = new SigScanTarget(23,
		"C6 83 ?? ?? ?? ?? 01",
		"83 BB ?? ?? ?? ?? 00",
		"75 0B",
		"8B 83 ?? ?? ?? ??",
		"A3 ?? ?? ?? ??", 		// Target Address
		"5F");


	// variables seem to change pointer paths between updates, so be a crazy person and scan for every single offset
	// for 2.4A: 0x490B10, 0x360, 0x14, 0xCB4
	vars.PlayerGoldLastOffsetTarget = new SigScanTarget(2,
		"89 8B ?? ?? ?? ??",
		"EB 06",
		"89 93 ?? ?? ?? ??",
		"8B 83 ?? ?? ?? ??",
		"3D ?? ?? ?? ??",
		"72 05");

	// 0x10?
	vars.PlayerGold2ndLastOffsetTarget = new SigScanTarget(2,
		"8B 77 ??",
		"89 3D ?? ?? ?? ??",
		"85 F6",
		"74 11",
		"8B 4E 04",
		"FF D2");

	// StageID offsets: Static
	vars.StageIDTarget = new SigScanTarget(1,
		"A3 ?? ?? ?? ??",
		"C6 05 ?? ?? ?? ?? 00",
		"89 8E ?? ?? ?? ??",
		"C6 86 ?? ?? ?? ?? 01");

	// SaveSlot offsets: Static
	vars.SaveSlotTarget = new SigScanTarget(2,
		"C6 05 ?? ?? ?? ?? 09"	// Target Address
		);

	// Version String offsets: 0x14, 0x34, 0x60
	vars.VersionTarget = new SigScanTarget(2,
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
	vars.HPPlayerDisplayTarget = new SigScanTarget(1,
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

		vars.PlayerGoldCodeAddr = scanner.Scan(vars.PlayerGoldTarget);
		vars.PlayerGoldAddr = memory.ReadValue<int>((IntPtr)vars.PlayerGoldCodeAddr);
		vars.PlayerGold = new MemoryWatcher<uint>((IntPtr)vars.PlayerGoldAddr);

		vars.PlagueKnightCodeAddr = scanner.Scan(vars.PlagueKnightTarget);
		vars.PlagueKnightAddr = memory.ReadValue<int>((IntPtr)vars.PlagueKnightCodeAddr);
		vars.PlagueKnight = new MemoryWatcher<bool>((IntPtr)vars.PlagueKnightAddr);

		vars.StageIDCodeAddr = scanner.Scan(vars.StageIDTarget);
		vars.StageIDAddr = memory.ReadValue<int>((IntPtr)vars.StageIDCodeAddr);
		vars.StageID = new MemoryWatcher<byte>((IntPtr)vars.StageIDAddr);

		vars.SaveSlotCodeAddr = scanner.Scan(vars.SaveSlotTarget);
		vars.SaveSlotAddr = memory.ReadValue<int>((IntPtr)vars.SaveSlotCodeAddr);
		vars.SaveSlot = new MemoryWatcher<byte>((IntPtr)vars.SaveSlotAddr);

		vars.watchers.AddRange(new MemoryWatcher[]
		{
			vars.PlayerGold,
			vars.PlagueKnight,
			vars.StageID,
			vars.SaveSlot
		});

	};

	Action<string> RescanHPDisplay = (text) => {

		// Base address won't change, so check to prevent unnecessary scans
		if ((IntPtr)vars.HPPlayerDisplayCodeAddr == IntPtr.Zero) {
			vars.HPPlayerDisplayCodeAddr = scanner.Scan(vars.HPPlayerDisplayTarget);

			vars.HPPlayerDisplayBaseAddr = memory.ReadValue<int>((IntPtr)vars.HPPlayerDisplayCodeAddr);
			vars.HPBossDisplayBaseAddr = vars.HPPlayerDisplayBaseAddr;
		}

		vars.HPPlayerDisplayPointerLevel1 = memory.ReadValue<int>((IntPtr)vars.HPPlayerDisplayBaseAddr) + 0x94;
		vars.HPBossDisplayPointerLevel1 = vars.HPPlayerDisplayPointerLevel1;

		vars.HPPlayerDisplayPointerLevel2 = memory.ReadValue<int>((IntPtr)vars.HPPlayerDisplayPointerLevel1) + 0x420;
		vars.HPBossDisplayPointerLevel2 = memory.ReadValue<int>((IntPtr)vars.HPBossDisplayPointerLevel1) + 0x424;

		vars.HPPlayerDisplayPointerLevel3 = memory.ReadValue<int>((IntPtr)vars.HPPlayerDisplayPointerLevel2) + 0x18;
		vars.HPBossDisplayPointerLevel3 = memory.ReadValue<int>((IntPtr)vars.HPBossDisplayPointerLevel2) + 0x18;

		vars.HPPlayerDisplayAddrOld = vars.HPPlayerDisplayAddr;

		vars.HPPlayerDisplayAddr = memory.ReadValue<int>((IntPtr)vars.HPPlayerDisplayPointerLevel3) + 0x2C;
		vars.HPBossDisplayAddr = memory.ReadValue<int>((IntPtr)vars.HPBossDisplayPointerLevel3) + 0x2C;

		if ((IntPtr)vars.HPPlayerDisplayAddrOld == (IntPtr)0x2C && (IntPtr)vars.HPPlayerDisplayAddr != (IntPtr)0x2C) {

			vars.HPPlayerDisplay = new MemoryWatcher<float>((IntPtr)vars.HPPlayerDisplayAddr);
			vars.HPBossDisplay = new MemoryWatcher<float>((IntPtr)vars.HPBossDisplayAddr);

			vars.watchers.AddRange(new MemoryWatcher[]
			{
				vars.HPPlayerDisplay,
				vars.HPBossDisplay
			});
		}

		vars.PlayerPosPointerLevel1 = memory.ReadValue<int>((IntPtr)vars.HPPlayerDisplayBaseAddr) + 0x84;
		vars.PlayerPosPointerLevel2 = memory.ReadValue<int>((IntPtr)vars.PlayerPosPointerLevel1) + 0xB40;
		vars.PlayerPosPointerLevel3 = memory.ReadValue<int>((IntPtr)vars.PlayerPosPointerLevel2) + 0x20;

		vars.PlayerPosXAddrOld = vars.PlayerPosXAddr;

		vars.PlayerPosXAddr = memory.ReadValue<int>((IntPtr)vars.PlayerPosPointerLevel3) + 0xC;
		vars.PlayerPosYAddr = memory.ReadValue<int>((IntPtr)vars.PlayerPosPointerLevel3) + 0x10;

		if ((IntPtr)vars.PlayerPosXAddrOld == (IntPtr)0xC && (IntPtr)vars.PlayerPosXAddr != (IntPtr)0xC) {

			vars.PlayerPosX = new MemoryWatcher<float>((IntPtr)vars.PlayerPosXAddr);
			vars.PlayerPosY = new MemoryWatcher<float>((IntPtr)vars.PlayerPosYAddr);

			vars.watchers.AddRange(new MemoryWatcher[]
			{
				vars.PlayerPosX,
				vars.PlayerPosY
			});
		}

	};

	Action<string> RescanVersion = (text) => {
		if ((IntPtr)vars.VersionCodeAddr == IntPtr.Zero) {
			vars.VersionCodeAddr = scanner.Scan(vars.VersionTarget);
			vars.VersionBaseAddr = memory.ReadValue<int>((IntPtr)vars.VersionCodeAddr);
		}

		vars.VersionPointerLevel1 = memory.ReadValue<int>((IntPtr)vars.VersionBaseAddr) + 0x14;

		vars.VersionPointerLevel2 = memory.ReadValue<int>((IntPtr)vars.VersionPointerLevel1) + 0x34;

		vars.VersionAddr = memory.ReadValue<int>((IntPtr)vars.VersionPointerLevel2) + 0x60;

		vars.Version = memory.ReadString((IntPtr)vars.VersionAddr, 256);

		if (vars.Version.Length > 7 && vars.Version.Substring(0, 7) == "version") {
			vars.VersionFound = true;
			version = vars.Version;
			vars.VersionNumber = Convert.ToSingle(vars.Version.Substring(8, 3));
		}
	};

	vars.RescanStatic = RescanStatic;
	vars.RescanHPDisplay = RescanHPDisplay;
	vars.RescanVersion = RescanVersion;

	vars.testAddr = scanner.Scan(vars.PlayerGoldLastOffsetTarget);
	vars.test = memory.ReadValue<int>((IntPtr)vars.testAddr); 

	// SCANNING ACTIONS END
}

update
{

	vars.watchers.UpdateAll(game);
	// Note: "ShovelKnight.exe"+0x0 isn't a null area of memory 
	// Rescan Static logic start (This shouldn't have to be used more than once!)
	if ((IntPtr)vars.PlayerGoldAddr == IntPtr.Zero && !vars.RescanStaticStopwatch.IsRunning) {
	    vars.RescanStaticStopwatch.Start();
	}

	if (vars.RescanStaticStopwatch.ElapsedMilliseconds >= 1000) {
		vars.RescanStaticStopwatch.Reset();
		vars.RescanStatic("");
	}
	// Rescan Static logic end

	// Rescan HP Display logic start
	if (!vars.RescanHPDisplayStopwatch.IsRunning) {
		vars.RescanHPDisplayStopwatch.Start();
	}

	// Rescan Pointer paths every 0.1 second -- this logic shouldn't cause any problems
	if (vars.RescanHPDisplayStopwatch.ElapsedMilliseconds >= 100) {
		vars.RescanHPDisplayStopwatch.Reset();
		vars.RescanHPDisplay("");
	}
	// Rescan HP Display logic end

	// Rescan Version logic start
	// ONLY WORKS IF THE SCRIPT IS RUNNING BEFORE A SAVE IS SELECTED!
	// There is no *real* way to automatically detect the version from what I've found.
	// We want to know what the version is so in case the Specter Knight patch just renders the game into pieces, we might still be able to use one script for all executables.
	if (!vars.VersionFound && !vars.RescanVersionStopwatch.IsRunning) {
		vars.RescanVersionStopwatch.Start();
	}

	if (vars.RescanVersionStopwatch.ElapsedMilliseconds >= 500) {
		vars.RescanVersionStopwatch.Reset();
		vars.RescanVersion("");
	}
	// Rescan Version logic end

	// current.HPPlayerDisplay does not become null when respawning
	if (vars.HPBossDisplay.Current == 0 && vars.HPPlayerDisplay.Current > 0 && vars.HPBossDisplay.Old != 0) {
		vars.BossRecentlyDefeated = true;
		vars.BossKillCounter++;
	}

	// if we're dead, or the pointer isn't being used (last offset is 0x2C, so it'll point to 0x0000002C in memory) (in map, title, etc.), reset these variables
	if (vars.HPPlayerDisplay.Current == 0 || (IntPtr)vars.HPPlayerDisplayAddr == (IntPtr)0x2C) {
		vars.RecentlyDeadStopwatch.Restart();
		vars.BossRecentlyDefeated = false;
		vars.BossKillCounter = 0;
	}

	// the Player HP can possibly be shown as boss HP for a frame after spawning, so add a check
	if (vars.RecentlyDeadStopwatch.ElapsedMilliseconds >= 100) {
		vars.RecentlyDeadStopwatch.Reset();
	}

	if (timer.CurrentPhase == TimerPhase.NotRunning) {
		vars.PlainsStage = false;
		vars.PridemoorKeepStage = false;
		vars.LichYardStage = false;
		vars.ExplodatoriumStage = false;
		vars.IronWhaleStage = false;
		vars.LostCityStage = false;
		vars.ClockTowerStage = false;
		vars.StrandedShipStage = false;
		vars.FlyingMachineStage = false;
		vars.ToFEntranceStage = false;
		vars.ToFBossRushStage = false;
		vars.ToFEnchantressStage = false;
		vars.PlainsBossRoom = false;
		vars.PridemoorKeepBossRoom = false;
		vars.LichYardBossRoom = false;
		vars.ExplodatoriumBossRoom = false;
		vars.IronWhaleBossRoom = false;
		vars.LostCityBossRoom = false;
		vars.ClockTowerBossRoom = false;
		vars.StrandedShipBossRoom = false;
		vars.FlyingMachineBossRoom = false;
		vars.ToFEntranceBossRoom = false;
		vars.ToFBossRushBossRoom = false;
		vars.ToFEnchantressBossRoom = false;
		vars.ToFEnchantress1Kill = false;
		vars.ToFEntranceFadeOut = false;
		vars.ToFBossRushFadeOut = false;
		vars.BlackKnight2FadeOut = false;
		vars.StagesCount = 0;
		vars.Dream1 = false;
		vars.Dream2 = false;
		vars.Dream3 = false;
	}

	
}

start
{
	// Start when a save slot is selected
	return vars.SaveSlot.Current < 9 && vars.SaveSlot.Old == 9;
}

reset
{
	// Reset when save slot is deselected (which happens when going to title)
	return vars.SaveSlot.Current == 9 && vars.SaveSlot.Old != 9;
}

split
{
	// Stage splits
	if (vars.HPBossDisplay.Old == 0 && vars.HPBossDisplay.Current > 0 && !vars.RecentlyDeadStopwatch.IsRunning) {
		switch((byte)vars.StageID.Current) {
			case 8:
				// The Plains
				if (!vars.PlainsStage && vars.HPBossDisplay.Current != 8) {
					vars.PlainsStage = true;
					return settings["PlainsStage"];
				}
				break;
			case 9:
				// Pridemoor Keep
				if (!vars.PridemoorKeepStage) {
					vars.PridemoorKeepStage = true;
					return settings["PridemoorKeepStage"];
				}
				break;
			case 10:
				// The Lich Yard
				if (!vars.LichYardStage) {
					vars.LichYardStage = true;
					return settings["LichYardStage"];
				}
				break;
			case 11:
				// The Explodatorium
				if (!vars.ExplodatoriumStage) {
					vars.ExplodatoriumStage = true;
					return settings["ExplodatoriumStage"];
				}
				break;
			case 12:
				// Iron Whale
				if (!vars.IronWhaleStage) {
					vars.IronWhaleStage = true;
					return settings["IronWhaleStage"];
				}
				break;
			case 13:
				// Lost City
				if (!vars.LostCityStage) {
					vars.LostCityStage = true;
					return settings["LostCityStage"];
				}
				break;
			case 14:
				// Clock Tower
				if (!vars.ClockTowerStage) {
					vars.ClockTowerStage = true;
					return settings["ClockTowerStage"];
				}
				break;
			case 15:
				// Stranded Ship
				if (!vars.StrandedShipStage) {
					vars.StrandedShipStage = true;
					return settings["StrandedShipStage"];
				}
				break;
			case 16:
				// Flying Machine
				if (!vars.FlyingMachineStage) {
					vars.FlyingMachineStage = true;
					return settings["FlyingMachineStage"];
				}
				break;
			case 17:
				// Tower of Fate: Entrance
				if (!vars.ToFEntranceStage) {
					vars.ToFEntranceStage = true;
					return settings["ToFEntranceStage"];
				}
				break;
			case 18:
				// Tower of Fate: Ascent
				if (!vars.ToFBossRushStage) {
					vars.ToFBossRushStage = true;
					return settings["ToFBossRushStage"];
				}
				break;
			case 19:
				// Tower of Fate: ????????
				if (!vars.ToFEnchantressStage) {
					vars.ToFEnchantressStage = true;
					return settings["ToFEnchantressStage"];
				}
				break;
			default:
				return false;
		}
	}

	// Bossroom transition splits
	switch((byte)vars.StageID.Current) {
		case 8:
			if (!vars.PlainsBossRoom && 
					(vars.PlayerPosX.Current >= 718 && vars.PlayerPosX.Current <= 750) &&
					(vars.PlayerPosY.Current >= -407 && vars.PlayerPosY.Current <= -370)) {
				vars.PlainsBossRoom = true;
				return settings["PlainsBossRoom"];
			}
			break;
		case 9:
			if (!vars.PridemoorKeepBossRoom && 
					(vars.PlayerPosX.Current >= 757.7 && vars.PlayerPosX.Current <= 800) &&
					(vars.PlayerPosY.Current >= -200 && vars.PlayerPosY.Current <= -188)) {
				vars.PridemoorKeepBossRoom = true;
				return settings["PridemoorKeepBossRoom"];
			}
			break;
		case 10:
			if (!vars.LichYardBossRoom && 
					(vars.PlayerPosX.Current >= 931.2 && vars.PlayerPosX.Current <= 970.5) &&
					(vars.PlayerPosY.Current >= -122 && vars.PlayerPosY.Current <= -100)) {
				vars.LichYardBossRoom = true;
				return settings["LichYardBossRoom"];
			}
			break;
		case 11:
			if (!vars.ExplodatoriumBossRoom && 
					(vars.PlayerPosX.Current >= 958 && vars.PlayerPosX.Current <= 1000) &&
					(vars.PlayerPosY.Current >= -230 && vars.PlayerPosY.Current <= -207)) {
				vars.ExplodatoriumBossRoom = true;
				return settings["ExplodatoriumBossRoom"];
			}
			break;
		case 12:
			if (!vars.IronWhaleBossRoom && 
					(vars.PlayerPosX.Current >= 836.7 && vars.PlayerPosX.Current <= 875) &&
					(vars.PlayerPosY.Current >= -213 && vars.PlayerPosY.Current <= -195)) {
				vars.IronWhaleBossRoom = true;
				return settings["IronWhaleBossRoom"];
			}
			break;
		case 13:
			if (!vars.LostCityBossRoom && 
					(vars.PlayerPosX.Current >= 878.4 && vars.PlayerPosX.Current <= 916) &&
					(vars.PlayerPosY.Current >= -258 && vars.PlayerPosY.Current <= -240)) {
				vars.LostCityBossRoom = true;
				return settings["LostCityBossRoom"];
			}
			break;
		case 14:
			if (!vars.ClockTowerBossRoom && 
					(vars.PlayerPosX.Current >= 635.2 && vars.PlayerPosX.Current <= 673) &&
					(vars.PlayerPosY.Current >= -255 && vars.PlayerPosY.Current <= -220)) {
				vars.ClockTowerBossRoom = true;
				return settings["ClockTowerBossRoom"];
			}
			break;
		case 15:
			if (!vars.StrandedShipBossRoom && 
					(vars.PlayerPosX.Current >= 902.4 && vars.PlayerPosX.Current <= 942) &&
					(vars.PlayerPosY.Current >= -100 && vars.PlayerPosY.Current <= -50)) {
				vars.StrandedShipBossRoom = true;
				return settings["StrandedShipBossRoom"];
			}
			break;
		case 16:
			if (!vars.FlyingMachineBossRoom && 
					(vars.PlayerPosX.Current >= 926.4 && vars.PlayerPosX.Current <= 970) &&
					(vars.PlayerPosY.Current >= -80 && vars.PlayerPosY.Current <= -30)) {
				vars.FlyingMachineBossRoom = true;
				return settings["FlyingMachineBossRoom"];
			}
			break;
		case 17:
			if (!vars.ToFEntranceBossRoom && 
					(vars.PlayerPosX.Current >= 1036.8 && vars.PlayerPosX.Current <= 1070) &&
					(vars.PlayerPosY.Current >= -120 && vars.PlayerPosY.Current <= -30)) {
				vars.ToFEntranceBossRoom = true;
				return settings["ToFEntranceBossRoom"];
			}
			break;
		case 18:
			if (!vars.ToFBossRushBossRoom && 
					(vars.PlayerPosX.Current >= 663 && vars.PlayerPosX.Current <= 700) &&
					(vars.PlayerPosY.Current >= -190 && vars.PlayerPosY.Current <= -169.4)) {
				vars.ToFBossRushBossRoom = true;
				return settings["ToFBossRushBossRoom"];
			}
			break;
		case 19:
			if (!vars.ToFEnchantressBossRoom && 
					(vars.PlayerPosX.Current >= 433.6 && vars.PlayerPosX.Current <= 480) &&
					(vars.PlayerPosY.Current >= -210 && vars.PlayerPosY.Current <= -169.4)) {
				vars.ToFEnchantressBossRoom = true;
				return settings["ToFEnchantressBossRoom"];
			}
			break;
		default:
			break;
	}

	// split on getting gold after every required boss
	// we do not want vars.BossRecentlyDefeated and vars.BossKillCounter to get reset in undefined stages
	if (vars.BossRecentlyDefeated && vars.PlayerGold.Current > vars.PlayerGold.Old) {
		switch((byte)vars.StageID.Current) {
			case 8:
				// The Plains
				return settings["PlainsGold"];
			case 9:
				// Pridemoor Keep
				return settings["PridemoorKeepGold"];
			case 10:
				// The Lich Yard
				return settings["LichYardGold"];
			case 11:
				// The Explodatorium
				return settings["ExplodatoriumGold"];
			case 12:
				// Iron Whale
				return settings["IronWhaleGold"];
			case 13:
				// Lost City
				return settings["LostCityGold"];
			case 14:
				// Clock Tower
				if (vars.PlagueKnight.Current) {
					return settings["ClockTowerGold"] && vars.BossKillCounter == 3;
				}
				else if (!vars.PlagueKnight.Current) {
					return settings["ClockTowerGold"] && vars.BossKillCounter == 2;
				}
				break;
			case 15:
				// Stranded Ship
				return settings["StrandedShipGold"];
			case 16:
				// Flying Machine
				return settings["FlyingMachineGold"];
			case 17:
				// Tower of Fate: Entrance
				return settings["ToFEntranceGold"];
			case 38:
				// Black Knight 2
				return settings["BlackKnight2Gold"] && vars.PlagueKnight.Current;
			default:
				return false;
		}
	}

	// On Kill splits
	if (vars.HPBossDisplay.Current == 0 && vars.HPBossDisplay.Old != 0 && vars.HPPlayerDisplay.Current > 0) {
		switch((byte)vars.StageID.Current) {
			case 8:
				// The Plains
				return settings["PlainsKill"];
			case 9:
				// Pridemoor Keep
				return settings["PridemoorKeepKill"];
			case 10:
				// The Lich Yard
				return settings["LichYardKill"];
			case 11:
				// The Explodatorium
				return settings["ExplodatoriumKill"];
			case 12:
				// Iron Whale
				return settings["IronWhaleKill"];
			case 13:
				// Lost City
				return settings["LostCityKill"];
			case 14:
				// Clock Tower
				if (vars.PlagueKnight.Current) {
					return settings["ClockTowerKill"] && vars.BossKillCounter == 3;
				}
				else if (!vars.PlagueKnight.Current) {
					return settings["ClockTowerKill"] && vars.BossKillCounter == 2;
				}
				break;
			case 15:
				// Stranded Ship
				return settings["StrandedShipKill"];
			case 16:
				// Flying Machine
				return settings["FlyingMachineKill"];
			case 17:
				// Tower of Fate: Entrance
				return settings["ToFEntranceKill"];
			case 18:
				// Tower of Fate: Ascent
				return settings["ToFBossRushKill"] && vars.BossKillCounter == 9;
			case 19:
				// Tower of Fate: ????????
				if (!vars.ToFEnchantress1Kill && vars.BossKillCounter == 1) {
					vars.ToFEnchantress1Kill = true;
					return settings["ToFEnchantress1Kill"];
				}
				else if (vars.BossKillCounter == 2) {
					return settings["ToFEnchantress2Kill"];
				}
				break;
			case 38:
				// Black Knight 2
				return settings["BlackKnight2Kill"] && vars.PlagueKnight.Current;
			default:
				return false;
		}
	}

	// Stage Fadeout Splits
	if (vars.StageID.Current == 24 || vars.StageID.Current == 126 && vars.StageID.Old != 24) {
		switch ((byte)vars.StageID.Old) {
			case 8:
				// The Plains
				vars.StagesCount++;
				return settings["PlainsFadeOut"] && vars.StageID.Current == 24;
			case 9:
				// Pridemoor Keep
				vars.StagesCount++;
				return settings["PridemoorKeepFadeOut"] && vars.StageID.Current == 24;
			case 10:
				// The Lich Yard
				vars.StagesCount++;
				return settings["LichYardFadeOut"] && vars.StageID.Current == 24;
			case 11:
				// The Explodatorium
				vars.StagesCount++;
				return settings["ExplodatoriumFadeOut"] && vars.StageID.Current == 24;
			case 12:
				// Iron Whale
				vars.StagesCount++;
				return settings["IronWhaleFadeOut"] && vars.StageID.Current == 24;
			case 13:
				// Lost City
				vars.StagesCount++;
				return settings["LostCityFadeOut"] && vars.StageID.Current == 24;
			case 14:
				// Clock Tower
				vars.StagesCount++;
				return settings["ClockTowerFadeOut"] && vars.StageID.Current == 24;
			case 15:
				// Stranded Ship
				vars.StagesCount++;
				return settings["StrandedShipFadeOut"] && vars.StageID.Current == 24;
			case 16:
				// Flying Machine
				vars.StagesCount++;
				return settings["FlyingMachineFadeOut"] && vars.StageID.Current == 24;
			case 17:
				// Tower of Fate: Entrance
				if (!vars.ToFEntranceFadeOut && vars.StageID.Current == 126 && vars.ToFEntranceBossRoom) {
					vars.StagesCount = 0;
					vars.ToFEntranceFadeOut = true;
					return settings["ToFEntranceFadeOut"] && vars.StageID.Current == 126;
				}
				break;
			case 18:
				// Tower of Fate: Ascent
				if (!vars.ToFBossRushFadeOut && vars.StageID.Current == 126 && vars.ToFBossRushBossRoom) {
					vars.ToFBossRushFadeOut = true;
					return settings["ToFBossRushFadeOut"] && vars.StageID.Current == 126;
				}
				break;
			case 38:
				// Black Knight 2
				if (!vars.BlackKnight2FadeOut) {
					vars.BlackKnight2FadeOut = true;
					return settings["BlackKnight2FadeOut"] && vars.StageID.Current == 126 && vars.PlagueKnight.Current;
				}
				break;
			default:
				break;
		}
	}


	// Dream Splits
	if (vars.StageID.Current == 126 && vars.StagesCount % 3 == 0) {
		switch ((byte)vars.StagesCount) {
			case 3:
				if (!vars.Dream1) {
					vars.Dream1 = true;
					return settings["Dream1"];
				}
				break;
			case 6:
				if (!vars.Dream2) {
					vars.Dream2 = true;
					return settings["Dream2"];
				}
				break;
			case 9:
				if (!vars.Dream3) {
					vars.Dream3 = true;
					return settings["Dream3"];
				}
				break;
			default:
				break;
		}
	}
}
