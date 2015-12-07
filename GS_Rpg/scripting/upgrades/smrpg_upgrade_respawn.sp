/**
 * SM:RPG Example Upgrade
 * Adds a random effect
 */
// Remove this line ;)

#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <multicolors>
#include <cstrike>
#include <smrpg>

// Change the upgrade's shortname to a descriptive abbrevation
#define UPGRADE_SHORTNAME "respawn"
#define PLUGIN_VERSION "1.0"

#define s_Tag "[{LightBlue}Respawn{default}]"

Handle g_hCChance;

public Plugin:myinfo =
{
	name = "SM:RPG Upgrade > Respawn",
	author = "ESK0",
	description = "Respawn upgrade for SM:RPG. Stealth enemy skin.",
	version = PLUGIN_VERSION,
	url = "http://www.github.com/ESK0"
}

public OnPluginStart()
{
	HookEvent("player_death", Event_OnPlayerDeath);
	LoadTranslations("smrpg_stock_upgrades.phrases");
}

public OnPluginEnd()
{
	if(SMRPG_UpgradeExists(UPGRADE_SHORTNAME))
		SMRPG_UnregisterUpgradeType(UPGRADE_SHORTNAME);
}

public OnAllPluginsLoaded()
{
	OnLibraryAdded("smrpg");
}

public OnLibraryAdded(const String:name[])
{
	// Register this upgrade in SM:RPG
	if(StrEqual(name, "smrpg"))
	{
		// Register the upgrade type.
		SMRPG_RegisterUpgradeType("Respawn", UPGRADE_SHORTNAME, "Respawn player", 10, true, 5, 15, 10, _, SMRPG_BuySell, SMRPG_ActiveQuery);
		SMRPG_SetUpgradeTranslationCallback(UPGRADE_SHORTNAME, SMRPG_TranslateUpgrade);
		g_hCChance = SMRPG_CreateUpgradeConVar(UPGRADE_SHORTNAME, "smrpg_respawn_chance", "5", "Chance");
	}
}

public OnClientDisconnect(client)
{
	// Don't forget to reset your effect when the client leaves ;)
	SMRPG_ResetEffect(client);
}

/**
 * SM:RPG Upgrade callbacks
 */

public SMRPG_BuySell(client, UpgradeQueryType:type)
{
	// Here you can apply your effect directly when the client's upgrade level changes.
	// E.g. adjust the maximal health of the player immediately when he bought the upgrade.
	// The client doesn't have to be ingame here!
}

public bool:SMRPG_ActiveQuery(client)
{
	// If this is a passive effect, it's always active, if the player got at least level 1.
	// If it's an active effect (like a short speed boost) add a check for the effect as well.
	new upgrade[UpgradeInfo];
	SMRPG_GetUpgradeInfo(UPGRADE_SHORTNAME, upgrade);
	return SMRPG_IsEnabled() && upgrade[UI_enabled] && SMRPG_GetClientUpgradeLevel(client, UPGRADE_SHORTNAME) > 0;
}

// Some plugin wants this effect to end?
public SMRPG_ResetEffect(client)
{
	// Stop your temporary effects here.
}


// The core wants to display your upgrade somewhere. Translate it into the clients language!
public SMRPG_TranslateUpgrade(client, const String:shortname[], TranslationType:type, String:translation[], maxlen)
{
	// Easy pattern is to use the shortname of your upgrade in the translation file
	if(type == TranslationType_Name)
		Format(translation, maxlen, "%T", UPGRADE_SHORTNAME, client);
	// And "shortname description" as phrase in the translation file for the description.
	else if(type == TranslationType_Description)
	{
		new String:sDescriptionKey[MAX_UPGRADE_SHORTNAME_LENGTH+12] = UPGRADE_SHORTNAME;
		StrCat(sDescriptionKey, sizeof(sDescriptionKey), " description");
		Format(translation, maxlen, "%T", sDescriptionKey, client);
	}
}

// Optionally block some other conflicting effect, if i'm currently active.
/*
public Action:SMRPG_OnUpgradeEffect(client, const String:shortname[])
{
	if(SMRPG_IsUpgradeActiveOnClient(client, UPGRADE_SHORTNAME) && StrEqual(shortname, "other_conflicting_effect"))
		return Plugin_Handled;
	return Plugin_Continue;
}
*/

// This holds the basic checks you should run before applying your effect.
public ApplyMyUpgradeEffect(client)
{
	// SM:RPG is disabled?
	if(!SMRPG_IsEnabled())
		return;

	// The upgrade is disabled completely?
	new upgrade[UpgradeInfo];
	SMRPG_GetUpgradeInfo(UPGRADE_SHORTNAME, upgrade);
	if(!upgrade[UI_enabled])
		return;

	// Are bots allowed to use this upgrade?
	if(IsFakeClient(client) && SMRPG_IgnoreBots())
		return;

	// Player didn't buy this upgrade yet.
	new iLevel = SMRPG_GetClientUpgradeLevel(client, UPGRADE_SHORTNAME);
	if(iLevel <= 0)
		return;

	// This calls the SMRPG_OnUpgradeEffect global forward where other plugins can stop you from applying your effect, if it conflicts with theirs.
	// This also returns false, if the client doesn't have the required admin flags to use the upgrade, so no need to call SMRPG_CheckUpgradeAccess.
	if(!SMRPG_RunUpgradeEffect(client, UPGRADE_SHORTNAME))
		return; // Some other plugin doesn't want this effect to run

	// Optionally check for conflicting effects?
	/*
	if(SMRPG_IsUpgradeActiveOnClient(client, "other_conflicting_effect"))
		SMRPG_ResetUpgradeEffectOnClient(client, "other_conflicting_effect");
	*/

	// Do my upgrade effect
	// ...

	// Does this client want some visual effects?
	if(SMRPG_ClientWantsCosmetics(client, UPGRADE_SHORTNAME, SMRPG_FX_Visuals))
	{
		// SetEntityRenderColor(client, 255, 0, 0, 255);
		// See smrpg_helper.inc for some helpful stocks like SMRPG_EmitSoundToAllEnabled and SMRPG_TE_SendToAllEnabled
	}
}
public Event_OnPlayerDeath(Handle event, const char[] name, bool dontBroadcast)
{
	int victim = GetClientOfUserId(GetEventInt(event, "userid"));
	int attacker = GetClientOfUserId(GetEventInt(event, "attacker"));
	if(IsValidClient(attacker) && IsValidClient(victim) && GetClientTeam(attacker) != GetClientTeam(victim))
	{
		int iLevel = SMRPG_GetClientUpgradeLevel(victim, UPGRADE_SHORTNAME);
		if(iLevel > 0)
		{
			if(GetChance(iLevel))
			{
				CreateTimer(2.0,Timer_RespawnClient,victim,TIMER_FLAG_NO_MAPCHANGE);
			}
		}
	}
}
public Action Timer_RespawnClient(Handle timer,any victim)
{
	CPrintToChatAll("%s Hráč {Lime}%N {default}získal další život.",s_Tag, victim);
	CS_RespawnPlayer(victim);
}
stock bool IsValidClient(client, bool alive = false)
{
	if(client >= 1 && client <= MaxClients && IsClientConnected(client) && IsClientInGame(client) && (alive == false || IsPlayerAlive(client)))
	{
		return true;
	}
	return false;
}
bool GetChance(level)
{
	int randomnum = GetRandomInt(0, 100);
	if(level > 0 && (randomnum <= GetConVarInt(g_hCChance) * level)) return true;
	return false;
}
