state("ShovelKnight", "Version 2.4A")
{
	// Player stats
	byte CharacterSelected : 0x4CEB04; // 0 for Shovel Knight, 1 for Plague Knight
	uint PlayerGold : 0x4CEB14; // S
	bool PlayerIsAlive : 0x4CC09E;
	float HPPlayerDisplay : 0x4CC0EC, 0x94, 0x420 /*blazeit*/, 0x18, 0x2C; // Display for player life at top of screen

	// Misc Stats
	uint Kills : 0x4CF818;
	uint BossKills : 0x4D0AA8; // not sure if this is boss kills, per se -- gets set to 1 after color screen effect at end of stage, reset to 0 on map.
	uint StageID : 0x4CF994;

	/* List of stage IDs:
	8: The Plains
	*/

	// Boss HPs
	float HPBossDisplay : 0x4CC0EC, 0x94, 0x424, /*notsoblazeit*/ 0x18, 0x2C; // Display for boss life at top of screen -- if this is anything but 0 or null we're in a boss fight.

	// Uncategorized
	byte StartCheck : 0x4CEDE8; // 9 in title, becomes (saveslot - 1) when "yes" is pressed
}

startup
{

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

	// HPPlayer offsets: 0x94, 0x420, 0x18, 0x2C
	// HPBossDisplay offsets: 0x94, 0x424, 0x18, 0x2C
	// HPBlackKnight offsets: 0x20, 0x38, 0x198, 0x20
	// HPBlackKnight base address scan (if game updates):
	/*	vars.HPBlackKnightTarget = new SigScanTarget(1,
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
	// going back to title screen may break this logic -- also may need to check old.HPPlayer for stage transistion?
	if (current.HPBossDisplay == 0 && old.HPBossDisplay != 0 && current.HPPlayerDisplay > 0) {
		vars.BossRecentlyDefeated = true;
		vars.BossKillCounter++;
	}


	if (!current.PlayerIsAlive || current.HPPlayerDisplay == null) {
		vars.BossRecentlyDefeated = false;
		vars.BossKillCounter = 0;
	}
}

start
{
	return current.StartCheck < 9 && old.StartCheck == 9;
}

split
{
	if (vars.BossRecentlyDefeated && current.PlayerGold > old.PlayerGold) {
		vars.BossRecentlyDefeated = false;
		vars.BossKillCounter = 0;
		switch((uint)current.StageID) {
			case 8:
			case 9:
				return true;
			default:
				return false;
		}
	}
	else if (vars.BossKillCounter == 9 && vars.StageID == 18) {
		vars.BossRecentlyDefeated = false;
		vars.BossKillCounter = 0;
		return true;
	}
	else if (vars.BossKillCounter == 2 && vars.StageID == 14) {
		vars.BossRecentlyDefeated = false;
		vars.BossKillCounter = 0;
		return true;
	}


}
