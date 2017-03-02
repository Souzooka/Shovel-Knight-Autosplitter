state("ShovelKnight", "Version 2.4A")
{
	// Player stats
	bool CharacterSelected : 0x4CEB04; // false for Shovel Knight, true for Plague Knight
	uint PlayerGold : 0x4CEB14; // S
	float HPPlayerDisplay : 0x4CC0EC, 0x94, 0x420 /*blazeit*/, 0x18, 0x2C; // Display for player life at top of screen

	// Misc Stats
/*	uint Kills : 0x4CF818;
	uint BossKills : 0x4D0AA8; // not sure if this is boss kills, per se -- gets set to 1 after color screen effect at end of stage, reset to 0 on map.*/
	uint StageID : 0x4CF994;
	byte SaveSlot : 0x4CEDE8; // 9 in title, becomes (saveslot - 1) when "yes" is pressed -- this is 0-based

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
	*/

	// Boss HPs
	float HPBossDisplay : 0x4CC0EC, 0x94, 0x424, /*notsoblazeit*/ 0x18, 0x2C; // Display for boss life at top of screen -- if this is anything but 0 or null we're in a boss fight.
	
}

startup
{
	// SETTINGS START
	// Header settings
	settings.Add("Splits", true, "Splits");
	settings.Add("SplitsGold", true, "Boss Splits (on gold)", "Splits");
	settings.Add("SplitsFadeOut", false, "Boss Splits (on fadeout)", "Splits");
	// SETTINGS END
}

init 
{
	// CUSTOM/PLACEHOLDER VARIABLES START
	vars.BossRecentlyDefeated = false;
	vars.BossKillCounter = 0;

	// REMINDER: The base address is always the same in each instance of the same version. You only need to scan for it in init when the game is loaded, and never again!
	// REMINDER: The only things which may need readjusting are the pointer values.

	// PlayerGold offsets: Static
	// PlayerGold base address scan (if game updates):
	/* 	vars.PlayerGoldTarget = new SigScanTarget(26,
		"C6 83 ?? ?? ?? ?? 01",
		"83 BB ?? ?? ?? ?? 00",
		"75 0B",
		"8B 83 ?? ?? ?? ??",
		"A3 ?? ?? ?? ??",
		"5F")

	// Note: Rescan pointers when stage ID changes

	// HPPlayerDisplay offsets: 0x94, 0x420, 0x18, 0x2C
	// HPBossDisplay offsets: 0x94, 0x424, 0x18, 0x2C
	// HPPlayerDisplay base address scan (if game updates):
	/*	vars.HPPlayerDisplay = new SigScanTarget(1,
		"A1 ?? ?? ??",
		"80 78 24 00",
		"?? ?? ?? ?? ?? ??",
		"56",
		"57",
		"8D 71 1D"
		);	*/

	// CUSTOM/PLACEHOLDER VARIABLES END
}

update
{
	// this logic looks like it should fire when respawning, but it doesn't
	// if there's a problem add "&& old.HPBossDisplay != null", but we should be good
	if (current.HPBossDisplay == 0 && old.HPBossDisplay != 0 && current.HPPlayerDisplay > 0) {
		vars.BossRecentlyDefeated = true;
		vars.BossKillCounter++;
	}

	// if the HP display isn't shown (as result of going to map, dying, or going to title), reset counter vars
	if (current.HPPlayerDisplay == null || current.HPPlayerDisplay == 0) {
		vars.BossRecentlyDefeated = false;
		vars.BossKillCounter = 0;
	}

}

start
{
	// Start when a save slot is selected
	return current.SaveSlot < 9 && old.SaveSlot == 9;
}

reset
{
	// Reset when save slot is deselected (which happens when going to title)
	return current.SaveSlot == 9 && old.SaveSlot != 9;
}

split
{
	// split on getting gold after every required boss
	// returns are placeholders for settings
	// we do not want vars.BossRecentlyDefeated and vars.BossKillCounter to get reset in undefined stages
	if (vars.BossRecentlyDefeated && current.PlayerGold > old.PlayerGold) {
		switch((uint)current.StageID) {
			case 8:
				// The Plains
				vars.BossRecentlyDefeated = false;
				vars.BossKillCounter = 0;
				return true;
			case 9:
				// Pridemoor Keep
				vars.BossRecentlyDefeated = false;
				vars.BossKillCounter = 0;
				return true;
			case 10:
				// The Lich Yard
				vars.BossRecentlyDefeated = false;
				vars.BossKillCounter = 0;
				return true;
			case 11:
				// The Explodatorium
				vars.BossRecentlyDefeated = false;
				vars.BossKillCounter = 0;
				return true;
			case 12:
				// Iron Whale
				vars.BossRecentlyDefeated = false;
				vars.BossKillCounter = 0;
				return true;
			case 13:
				// Lost City
				vars.BossRecentlyDefeated = false;
				vars.BossKillCounter = 0;
				return true;
			case 15:
				// Stranded Ship
				vars.BossRecentlyDefeated = false;
				vars.BossKillCounter = 0;
				return true;
			case 16:
				// Flying Machine
				vars.BossRecentlyDefeated = false;
				vars.BossKillCounter = 0;
				return true;
			case 17:
				// Tower of Fate: Entrance
				vars.BossRecentlyDefeated = false;
				vars.BossKillCounter = 0;
				return true;
			case 38:
				vars.BossRecentlyDefeated = false;
				vars.BossKillCounter = 0;
				return current.CharacterSelected == 1;
			default:
				return false;
		}
	}

	// split after Tinker
	// if we're in the Clockwork Tower and we've gone through 2 phases as SK, or 3 as PK
	if (current.StageID == 14 && current.PlayerGold > old.PlayerGold &&
	((vars.BossKillCounter == 2 && !current.CharacterSelected) || 
	(vars.BossKillCounter == 3 && current.CharacterSelected))) {
		vars.BossRecentlyDefeated = false;
		vars.BossKillCounter = 0;
		return true;
	}

	// split after boss rush
	if (vars.BossKillCounter == 9 && current.StageID == 18) {
		vars.BossRecentlyDefeated = false;
		vars.BossKillCounter = 0;
		return true;
	}

	// Enchantress Split
	if (current.StageID == 19 && vars.BossKillCounter == 2) {
		vars.BossRecentlyDefeated = false;
		vars.BossKillCounter = 0;
		return true;
	}

}
