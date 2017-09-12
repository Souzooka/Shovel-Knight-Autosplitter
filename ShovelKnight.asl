state("ShovelKnight")
{
	// Note: HP values use the HUD display values, not the actual value.

	// Start/Reset
	// This variable may be tentative
	bool gameStarted : 0x7C263C;

	// Player stats
	byte characterID : 0x7BD408;
	int playerGold : 0x7C266C;
	float playerHP : 0x76D9FC, 0xA8, 0x5DC, 0x18, 0x2C;

	// Boss stats
	float bossHP : 0x76D9FC, 0xA8, 0x5E4, 0x18, 0x2C;

	// Misc stats
	byte stageID : 0x7C673C;
}

startup
{
	// SETTINGS
	// Header settings
	settings.Add("splits", true, "Splits");
	settings.Add("splitsGold", false, "Stage Splits (on boss gold)", "splits");
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
	settings.Add("tofEnchantress2Kill", true, "Enchantress 2 / Dark Reize (Specter) (Tower of Fate: ????????)", "splitsKill");
	settings.Add("tofEnchantress3Kill", true, "Enchantress 3 (Tower of Fate: ????????) (PK Only)", "splitsKill");
	settings.Add("darkReizeKill", true, "Dark Reize (Specter Knight)", "splitsKill");
	settings.Add("shieldKnightKill", true, "Shield Knight (Specter Knight)", "splitsKill");

	// On Gold Splits
	settings.Add("plainsGold", true, "Black Knight 1 (The Plains)", "splitsGold");
	settings.Add("pridemoorKeepGold", true, "King Knight (Pridemoor Keep)", "splitsGold");
	settings.Add("lichYardGold", true, "Specter Knight (Lich Yard)", "splitsGold");
	settings.Add("explodatoriumGold", true, "Plague Knight (Explodatorium)", "splitsGold");
	settings.Add("ironWhaleGold", true, "Treasure Knight (Iron Whale)", "splitsGold");
	settings.Add("lostCityGold", true, "Mole Knight (Lost City)", "splitsGold");
	settings.Add("clockTowerGold", true, "Tinker Knight (Clock Tower)", "splitsGold");
	settings.Add("strandedShipGold", true, "Polar Knight (Stranded Ship)", "splitsGold");
	settings.Add("flyingMachineGold", true, "Propeller Knight (Flying Machine)", "splitsGold");
	settings.Add("tofEntranceGold", true, "Black Knight 3 (Tower of Fate: Entrance)", "splitsGold");
	settings.Add("blackKnight2Gold", true, "Black Knight 2 (PK Only)", "splitsGold");
	settings.Add("darkReizeGold", true, "Dark Reize (Specter Knight)", "splitsGold");
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
		{24, "darkReize"},
		{38, "shieldKnight"},
		{41, "blackKnight2"},
	};

	vars.characterIDs = new Dictionary<int, string>
	{
		{0, "shovelKnight"},
		{1, "plagueKnight"},
		{2, "specterKnight"},
		{3, "kingKnight"}
	};

	// Counts how many boss stages the player has defeated without dying or going back to the map
	// Used for multi-stage bosses
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
		++vars.bossKillCounter;
		if (!vars.stageIDs.ContainsKey(current.stageID)) { return false; }

		// Tinker
		if (vars.stageIDs[current.stageID] == "clockTower" && vars.bossKillCounter != 2) 
		{ 
			return false; 
		}

		// Boss Rush
		if (vars.stageIDs[current.stageID] == "tofAscent" && vars.bossKillCounter != 9) 
		{ 
			return false;
		}

		// Enchantress Splits
		if (vars.stageIDs[current.stageID] == "tofEnchantress")
		{	
			return settings["tofEnchantress" + vars.bossKillCounter.ToString() + "Kill"];
		}

		// Black Knight 2
		if (vars.stageIDs[current.stageID] == "blackKnight2") 
		{ 
			return settings["blackKnight2Kill"] && vars.characterIDs[current.characterID] == "plagueKnight"; 
		}

		// Reize
		if (vars.stageIDs[current.stageID] == "darkReize")
		{
			return settings["darkReizeKill"] && vars.characterIDs[current.characterID] == "specterKnight"; 
		}

		// Shield Knight
		if (vars.stageIDs[current.stageID] == "shieldKnight")
		{
			return settings["shieldKnightKill"] && vars.characterIDs[current.characterID] == "specterKnight"; 
		}

		// Everything else

		// Settings has no "ContainsKey"-like method, so we have to try/catch instead
		try
		{
			return settings[vars.stageIDs[current.stageID] + "Kill"];
		}
		catch
		{
			return false;
		}
	}

	// On Gold splits
	if (vars.bossKillCounter > 0 && current.playerGold > old.playerGold)
	{
		if (!vars.stageIDs.ContainsKey(current.stageID)) { return false; }

		// Tinker
		if (vars.stageIDs[current.stageID] == "clockTower" && vars.bossKillCounter != 2) 
		{ 
			return false; 
		}

		// Black Knight 2
		if (vars.stageIDs[current.stageID] == "blackKnight2") 
		{ 
			return settings["blackKnight2Gold"] && vars.characterIDs[current.characterID] == "plagueKnight"; 
		}

		// Reize
		if (vars.stageIDs[current.stageID] == "darkReize")
		{
			return settings["darkReizeGold"] && vars.characterIDs[current.characterID] == "specterKnight"; 
		}

		// Everything else

		try
		{
			return settings[vars.stageIDs[current.stageID] + "Gold"];
		}
		catch
		{
			return false;
		}
	}
}