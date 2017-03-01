state("ShovelKnight", "Version 2.4A")
{
	// Player stats
	byte CharacterSelected : 0x4CEB04; // 0 for Shovel Knight, 1 for Plague Knight
	uint PlayerGold : 0x4CEB14; // S
	float HPPlayerDisplay : 0x4CC0EC, 0x94, 0x420 /*blazeit*/, 0x18, 0x2C; // Display for player life at top of screen

	// Misc Stats
/*	uint Kills : 0x4CF818;
	uint BossKills : 0x4D0AA8; // not sure if this is boss kills, per se -- gets set to 1 after color screen effect at end of stage, reset to 0 on map.*/
	uint StageID : 0x4CF994;
	byte SaveSlot : 0x4CEDE8; // 9 in title, becomes (saveslot - 1) when "yes" is pressed -- this is 0-based

	/* List of stage IDs:
	8: The Plains (✓)
	9: Pridemoor Keep (✓)
	10: The Lich Yard (✓)
	*/

	// Boss HPs
	float HPBossDisplay : 0x4CC0EC, 0x94, 0x424, /*notsoblazeit*/ 0x18, 0x2C; // Display for boss life at top of screen -- if this is anything but 0 or null we're in a boss fight.
	
}

startup
{
	settings.Add("splits", true, "Splits");

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
}

init 
{

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
	if (current.HPPlayerDisplay == null) {
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
	if (vars.BossRecentlyDefeated && current.PlayerGold > old.PlayerGold) {
		vars.BossRecentlyDefeated = false;
		vars.BossKillCounter = 0;
		switch((uint)current.StageID) {
			case 8:
				// The Plains
			case 9:
				// Pridemoor Keep
			case 10:
				// The Lich Yard
			case 11:
			case 12:
			case 13:
			case 15:
			case 16:
			case 17:
				return true;
			case 38:
				return current.CharacterSelected == 1;
			default:
				return false;
		}
	}
	// split after boss rush (broken)
	else if (vars.BossKillCounter == 9 && vars.StageID == 18) {
		vars.BossRecentlyDefeated = false;
		vars.BossKillCounter = 0;
		return true;
	}
	// split after Tinker (broken)
	else if (current.StageID == 14 && ((vars.BossKillCounter == 2 && current.CharacterSelected == 0) || (current.CharacterSelected == 1 && vars.BossKillCounter == 3))) {
		vars.BossRecentlyDefeated = false;
		vars.BossKillCounter = 0;
		return true;
	}


}
