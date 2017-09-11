state("ShovelKnight")
{
	// Start/Reset
	// This variable may be tentative
	bool gameStarted : 0x7C263C;

	// Player stats
	bool characterID : 0x7BD408;
	float playerHP : 0x76D9FC, 0xA8, 0x5DC, 0x18, 0x2C;

	// Boss stats
	float bossHP : 0x76D9FC, 0xA8, 0x5E4, 0x18, 0x2C;

	// Misc stats
	byte stageID : 0x7C363C;
}

startup
{
	// SETTINGS
	// Header settings
	settings.Add("splits", true, "Splits");
	settings.Add("splitsKill", true, "Stage Splits (on boss kill)", "splits");

	// On Kill Splits
	settings.Add("plainsKill", true, "Black Knight 1 (The Plains)", "splitsKill");
	settings.Add("pridemoorKeepKill", true, "King Knight (Pridemoor Keep)", "splitsKill");
	settings.Add("lichYardKill", true, "Specter Knight (Lich Yard)", "splitsKill");
	settings.Add("explodatoriumKill", true, "Plague Knight (Explodatorium)", "splitsKill");
	settings.Add("ironWhaleKill", true, "Treasure Knight (Iron Whale)", "splitsKill");
	settings.Add("lostCityKill", true, "Mole Knight (Lost City)", "splitsKill");
	settings.Add("clockTowerKill", true, "Tinker Knight (Clock Tower)", "splitsKill");
	settings.Add("strandedShipKill", true, "Polar Knight (Stranded Ship)", "splitsKill");
	settings.Add("flyingMachineKill", true, "Propeller Knight (Flying Machine)", "splitsKill");
	settings.Add("tofEntranceKill", true, "Black Knight 3 (Tower of Fate: Entrance)", "splitsKill");
	settings.Add("blackKnight2Kill", true, "Black Knight 2 (PK Only)", "splitsKill");
	settings.Add("tofAscentKill", true, "Boss Rush (Tower of Fate: Ascent)", "splitsKill");
	settings.Add("tofEnchantress1Kill", true, "Enchantress 1 (Tower of Fate: ????????)", "splitsKill");
	settings.Add("tofEnchantress2Kill", true, "Enchantress 2 (Tower of Fate: ????????)", "splitsKill");
	settings.Add("tofEnchantress3Kill", true, "Enchantress 3 (Tower of Fate: ????????) (PK Only)", "splitsKill");
}

init 
{
	// used for holding any splits that might be hit twice by runners
	vars.splits = new HashSet<string>();

	vars.stageIDs = new Dictionary<int, string>
	{
		{11, "plains"},
		{12, "pridemoorKeep"},
		{13, "lichYard"},
		{14, "explodatorium"},
		{15, "ironWhale"},
		{16, "lostCity"},
		{17, "clockTower"},
		{18, "strandedShip"},
		{19, "flyingMachine"},
		{20, "tofEntrance"},
		{21, "tofAscent"},
		{22, "tofEnchantress"},
		{41, "blackKnight2"},
	};

	vars.characterIDs = new Dictionary<int, string>
	{
		{0, "shovelKnight"},
		{1, "plagueKnight"},
		{2, "specterKnight"},
		{3, "kingKnight"}
	};

	vars.bossKillCounter = 0;
}

update 
{
	if (current.playerHP == 0)
	{
		vars.bossKillCounter = 0;
	}
}

start { return current.gameStarted && !old.gameStarted; }

reset
{
	if (!current.gameStarted && old.gameStarted)
	{
		vars.splits.Clear();
		return true;
	}	
}

split
{
	// On Kill splits
	if (current.bossHP == 0 && old.bossHP != 0 && current.playerHP != 0 && old.playerHP != 0) 
	{	
		// Tinker
		if (vars.stageIDs[current.stageID] == "clockTower" && vars.bossKillCounter != 2 - 1) 
		{ 
			++vars.bossKillCounter;
			return false; 
		}

		// Boss Rush
		if (vars.stageIDs[current.stageID] == "tofAscent" && vars.bossKillCounter != 9 - 1) 
		{ 
			++vars.bossKillCounter; 
			return false;
		}

		// Enchantress Splits
		if (vars.stageIDs[current.stageID] == "tofEnchantress")
		{	
			++vars.bossKillCounter;
			return settings["tofEnchantress" + vars.bossKillCounter.ToString() + "Kill"];
		}

		// Black Knight 2
		if (vars.stageIDs[current.stageID] == "blackKnight2") { return settings["blackKnight2Kill"] && vars.characterIDs[current.characterID] == "plagueKnight"; }

		// Everything else
		if (!vars.stageIDs.ContainsKey(current.stageID)) { return false; }

		return settings[vars.stageIDs[current.stageID] + "Kill"];
	}
}