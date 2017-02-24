state("ShovelKnight", "Version 2.4A")
{
	// Player stats
	uint PlayerGold : 0x4CEB14; // S
	float HPPlayer : 0x4CC0EC, 0x94, 0x420 /*blazeit*/, 0x18, 0x2C; // Display for player life at top of screen

	// Boss HPs
	float HPBossDisplay : 0x4CC0EC, 0x94, 0x424, /*notsoblazeit*/ 0x18, 0x2C; // Display for boss life at top of screen
	float HPBlackKnight : 0x4CC0EC, 0x20, 0x38, 0x198, 0x20;
}

startup
{

	vars.BossRecentlyDefeated = false;

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
	if (current.HPBossDisplay == 0 && old.HPBossDisplay != 0 && current.HPPlayer > 0 && (old.HPPlayer != null && old.HPPlayer != 0)) {
		vars.BossRecentlyDefeated = true;
	}
}

start
{

}

split
{
	if (vars.BossRecentlyDefeated && current.PlayerGold > old.PlayerGold) {
		vars.BossRecentlyDefeated = false;
		return true;
	}
}
