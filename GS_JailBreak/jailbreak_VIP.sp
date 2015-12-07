
#include <sourcemod>
#include <sdktools>

#include <emitsoundany>
#include <cstrike>
#include <smlib>

#define PLUGIN_VERSION   "3.0.1"
#include <sdkhooks>
#define MAX_WEAPONS2		25
#define NAME_LENGTH 64
#define VD_TIMER 70.0
#define VD_TIMER_HVD 70.0
#define SHOP_ITEM1 "Bayonet"
#define SHOP_ITEM2 "Gut"
#define SHOP_ITEM3 "Flip"
#define SHOP_ITEM4 "Rychlost"
#define SHOP_ITEM5 "Volny den"
#define SHOP_ITEM6 "Neviditelnost"
#define SHOP_ITEM7 "Deagle"
#define SHOP_ITEM1_CENA 6
#define SHOP_ITEM2_CENA 30
#define SHOP_ITEM3_CENA 70
#define SHOP_ITEM4_CENA 35
#define SHOP_ITEM5_CENA 50
#define SHOP_ITEM6_CENA 70
#define SHOP_ITEM7_CENA 70
#define SHOP_ITEM1_CT "Rychlost"
#define SHOP_ITEM2_CT "Zivoty"
#define SHOP_ITEM1_CENA_CT 70
#define SHOP_ITEM2_CENA_CT 70
#define SHOP_ITEM3_CENA_CT 3
#define SHOP_ITEM4_CENA_CT 4
#define SHOP_ITEM5_CENA_CT 5
#define SHOP_ITEM6_CENA_CT 6


#define VIP ADMFLAG_CUSTOM5
#define EVIP ADMFLAG_CUSTOM6

#define KnifeSpeed 1.2
#define KnifeGravity 0.8

#define COLLISION_GROUP_PUSHAWAY            17
#define COLLISION_GROUP_PLAYER              5



//new g_iAccount = -1;
new Handle: hvdtimer = INVALID_HANDLE
new g_bits[MAXPLAYERS+1];
new opencell
new Warden = -1;
new Handle:g_cVar_mnotes = INVALID_HANDLE;
new Handle:g_fward_onBecome = INVALID_HANDLE;
new Handle:g_fward_onRemove = INVALID_HANDLE;
new Handle: forceendround = INVALID_HANDLE;
new String:named[64]
new String:Entities[][] = {"func_door", "func_door_rotating", "func_rotating", "func_movelinear", "func_elevator", "func_tracktrain","prop_door" }; //, "func_door_rotating", "func_door"
new bool:Open = false;
new boxmod
new blokwarden = 0
new freeday = 1
new start_futbal = 0
new simon_gun[MAXPLAYERS+1]
new ct_gun[MAXPLAYERS+1]
new stopky
new stopky2
new stopky_hodnota
new team_hraca[MAXPLAYERS+1]
new vd_next_round[MAXPLAYERS+1]
new vybrana_duel_guna
new duel_lock
new duelant[MAXPLAYERS+1]
new prebieha_duel
new knife_skin[MAXPLAYERS+1]
new invis[MAXPLAYERS+1]
new hrac_dozorce[MAXPLAYERS+1]
new hrac_vezen[MAXPLAYERS+1]
new jedna_zmena[MAXPLAYERS+1]
new vypis_chat_damage[MAXPLAYERS+1]
new ochrana_join_team[MAXPLAYERS+1]
new mikrofon
new mod
new hraje_alarm
new vzbura
new koneckola
new zbran_prestrelka
new matrix
new zombie
new hracsvd[MAXPLAYERS+1]
new pocet_dni
new pocet_ct = 0
new pocet_t
new zive_t
new zive_ct
new Float: gravitace
new String:mapname[120]
new cely_otvorene_mod_nejde
new cislo_skinu[MAXPLAYERS+1]
new cislo_skinu_aktual[MAXPLAYERS+1]
new Handle: hrac_vd[MAXPLAYERS+1] = INVALID_HANDLE;
new penaze[MAXPLAYERS+1]
//new maximumplayers
new hraci_a
new hraci_b
//new redcolor[] = {255, 0, 0, 255};
//new bluecolor[] = {0, 0, 255, 255};
//new greencolor[] = {0, 255, 0, 255};
//new BeamSprite
//new HaloSprite
new const String:prestrelka_zbran[3][] = { "weapon_m4a1", "weapon_ak47", "weapon_ssg08"
};
/*
Informace:

Sloty zbrani 0 az 4
1. Slot0 - hlavna zbran
2. Slot1 - pistolka
3. Slot2 - Knife
4. Slot3 - Hecko
5. Slot4 - asi flash neoskusane
6. Slot4 - asi smoke neoskusane

#define VOICE_NORMAL        0     Allow the client to listen and speak normally.
#define VOICE_MUTED            1   < Mutes the client from speaking to everyone.
#define VOICE_SPEAKALL        2    < Allow the client to speak to everyone.
#define VOICE_LISTENALL        4   < Allow the client to listen to everyone.
#define VOICE_TEAM            8    < Allow the client to always speak to team, even when dead.
#define VOICE_LISTENTEAM    16    < Allow the client to always hear teammates, including dead ones.
*/

new const String:g_weapons[MAX_WEAPONS2][] = {
	"weapon_ak47", "weapon_aug", "weapon_bizon", "weapon_deagle", "weapon_elite", "weapon_famas", "weapon_fiveseven",
	"weapon_g3sg1", "weapon_galilar", "weapon_glock", "weapon_hkp2000", "weapon_m249", "weapon_m4a1",
	"weapon_mac10", "weapon_mag7", "weapon_mp7", "weapon_mp9", "weapon_p250", "weapon_p90",
	"weapon_scar20", "weapon_sg556", "weapon_ssg08", "weapon_tec9", "weapon_ump45", "weapon_xm1014"
};
new const String:duel_weapons[4][] = { "weapon_knife", "weapon_hegrenade", "weapon_deagle", "weapon_m249"
};
/*
new const String:g_weapons[MAX_WEAPONS2][] = {
	"weapon_ak47", "weapon_aug", "weapon_bizon", "weapon_deagle", "weapon_decoy", "weapon_elite", "weapon_famas", "weapon_fiveseven", "weapon_flashbang",
	"weapon_g3sg1", "weapon_galilar", "weapon_glock", "weapon_hegrenade", "weapon_hkp2000", "weapon_incgrenade", "weapon_knife", "weapon_m249", "weapon_m4a1",
	"weapon_mac10", "weapon_mag7", "weapon_molotov", "weapon_mp7", "weapon_mp9", "weapon_negev", "weapon_nova", "weapon_p250", "weapon_p90", "weapon_sawedoff",
	"weapon_scar20", "weapon_sg556", "weapon_smokegrenade", "weapon_ssg08", "weapon_taser", "weapon_tec9", "weapon_ump45", "weapon_xm1014"
};*/

public Plugin:myinfo = {
	name = "Jailbreak",
	author = "Gamesites.cz",
	description = "Jailbreak Gamesites.cz ",
	version = PLUGIN_VERSION,
	url = "gamesites.cz"
};

public OnPluginStart()
{

	// Initialize our phrases
	LoadTranslations("warden.phrases");

	// Register our admin commands
	RegAdminCmd("sm_rw", RemoveWarden, ADMFLAG_GENERIC);
	RegAdminCmd("sm_rc", RemoveWarden, ADMFLAG_GENERIC);
	//g_iAccount = FindSendPropOffs("CCSPlayer", "m_iAccount");

	// Hooking the events
	HookEvent("round_start", roundStart); // For the round start
	HookEvent("round_end", konec_kola);
	HookEvent("player_death", playerDeath); // To check when our warden dies :)
	HookEvent("player_spawn", event_Spawn);
	HookEvent("weapon_fire", ClientWeaponReload, EventHookMode_Pre);

	// For our warden to look some extra cool
	AddCommandListener(HookPlayerChat, "say");
	AddCommandListener(HookPlayerChat, "say_team");
	AddCommandListener(Command_JoinTeam, "jointeam");

	HookEvent("player_connect_full", Event_OnFullConnect, EventHookMode_Pre);

	// May not touch this line
	CreateConVar("sm_warden_version", PLUGIN_VERSION,  "The version of the SourceMod plugin JailBreak Warden, by ecca", FCVAR_REPLICATED|FCVAR_SPONLY|FCVAR_PLUGIN|FCVAR_NOTIFY|FCVAR_DONTRECORD);
	g_cVar_mnotes = CreateConVar("sm_warden_better_notifications", "0", "0 - disabled, 1 - Will use hint and center text", FCVAR_PLUGIN, true, 0.0, true, 1.0);

	g_fward_onBecome = CreateGlobalForward("warden_OnWardenCreated", ET_Ignore, Param_Cell);
	g_fward_onRemove = CreateGlobalForward("warden_OnWardenRemoved", ET_Ignore, Param_Cell);


}

public OnMapStart()
{
	//vezen 1
	AddFileToDownloadsTable("materials/models/player/prisoner/hands.vmt");
	AddFileToDownloadsTable("materials/models/player/prisoner/hands.vtf");
	AddFileToDownloadsTable("materials/models/player/prisoner/prisoner.vmt");
	AddFileToDownloadsTable("materials/models/player/prisoner/prisoner_n.vtf");
	AddFileToDownloadsTable("materials/models/player/prisoner/prisoner.vtf");

	AddFileToDownloadsTable("models/player/prisoner/prisoner.phy");
	AddFileToDownloadsTable("models/player/prisoner/prisoner.mdl");
	AddFileToDownloadsTable("models/player/prisoner/prisoner.vvd");
	AddFileToDownloadsTable("models/player/prisoner/prisoner.dx90.vtx");

	PrecacheModel("models/player/prisoner/prisoner.mdl")
	PrecacheModel("models/player/zombie.mdl")
	PrecacheModel("models/player/ctm_sas.mdl")

	//Dozorca 1
	AddFileToDownloadsTable("materials/models/player/mapeadores/kaem/police/chp_pants_n.vtf");
	AddFileToDownloadsTable("materials/models/player/mapeadores/kaem/police/chp_hands_m_n.vtf");
	AddFileToDownloadsTable("materials/models/player/mapeadores/kaem/police/chp_holster.vmt");
	AddFileToDownloadsTable("materials/models/player/mapeadores/kaem/police/chp_male_face.vmt");
	AddFileToDownloadsTable("materials/models/player/mapeadores/kaem/police/chp_male_face.vtf");
	AddFileToDownloadsTable("materials/models/player/mapeadores/kaem/police/chp_male_face_n.vtf");
	AddFileToDownloadsTable("materials/models/player/mapeadores/kaem/police/chp_pants.vmt");
	AddFileToDownloadsTable("materials/models/player/mapeadores/kaem/police/chp_pants.vtf");
	AddFileToDownloadsTable("materials/models/player/mapeadores/kaem/police/chp_coat.vtf");
	AddFileToDownloadsTable("materials/models/player/mapeadores/kaem/police/chp_coat_n.vtf");
	AddFileToDownloadsTable("materials/models/player/mapeadores/kaem/police/chp_hands_m.vmt");
	AddFileToDownloadsTable("materials/models/player/mapeadores/kaem/police/chp_hands_m.vtf");
	AddFileToDownloadsTable("materials/models/player/mapeadores/kaem/police/chp_coat.vmt");
	AddFileToDownloadsTable("materials/models/player/mapeadores/kaem/police/chp_holster.vtf");

	AddFileToDownloadsTable("models/player/mapeadores/kaem/police/police.mdl");
	AddFileToDownloadsTable("models/player/mapeadores/kaem/police/police.phy");
	AddFileToDownloadsTable("models/player/mapeadores/kaem/police/police.vvd");
	AddFileToDownloadsTable("models/player/mapeadores/kaem/police/police.dx90.vtx");

	PrecacheModel("models/player/mapeadores/kaem/police/police.mdl")

	AddFileToDownloadsTable("sound/jbextreme/brass_bell_C.mp3");
	PrecacheSoundAny("jbextreme/brass_bell_C.mp3");

	AddFileToDownloadsTable("sound/jbextreme/siren.mp3");
	PrecacheSoundAny("jbextreme/siren.mp3");

	AddFileToDownloadsTable("sound/jbextreme/end_gss.mp3");
	PrecacheSoundAny("jbextreme/end_gss.mp3");

	AddFileToDownloadsTable("sound/jbextreme/duel_gs.mp3");
	PrecacheSoundAny("jbextreme/duel_gs.mp3");

	AddFileToDownloadsTable("sound/jbextreme/pisk2.mp3");
	PrecacheSoundAny("jbextreme/pisk2.mp3");

	AddFileToDownloadsTable("sound/jbextreme/pisk_e1.mp3");
	PrecacheSoundAny("jbextreme/pisk_e1.mp3");

	AddFileToDownloadsTable("sound/jbextreme/gong.mp3");
	PrecacheSoundAny("jbextreme/gong.mp3");

	AddFileToDownloadsTable("sound/jbextreme/scout_gs.mp3");
	PrecacheSoundAny("jbextreme/scout_gs.mp3");

	AddFileToDownloadsTable("sound/jbextreme/prestrelka_gs.mp3");
	PrecacheSoundAny("jbextreme/prestrelka_gs.mp3");

	AddFileToDownloadsTable("sound/jbextreme/prestrelka_ak_gs.mp3");
	PrecacheSoundAny("jbextreme/prestrelka_ak_gs.mp3");

	AddFileToDownloadsTable("sound/jbextreme/matrix_gs.mp3");
	PrecacheSoundAny("jbextreme/matrix_gs.mp3");

	AddFileToDownloadsTable("sound/jbextreme/ghost_gs.mp3");
	PrecacheSoundAny("jbextreme/ghost_gs.mp3");

	//BeamSprite = PrecacheModel("materials/sprites/laser.vmt");
	//HaloSprite = PrecacheModel("materials/sprites/halo01.vmt")

	//maximumplayers = GetMaxClients()
	pocet_dni = 0
	pocet_ct = 0
	zive_ct = 0
	zive_t = 0
}

public Action:Event_OnFullConnect(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	if(!client || !IsClientInGame(client))
		return Plugin_Continue;

	ChangeClientTeam(client, 2);
	hrac_vezen[client] = 1
	spocitej_hrace()
	penaze[client] = 6
	return Plugin_Continue;
}
public Action Command_BlockRadio(int client, const char[] command, args)
{
	return Plugin_Handled;
}
public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max)
{
	CreateNative("warden_exist", Native_ExistWarden);
	CreateNative("warden_iswarden", Native_IsWarden);
	CreateNative("warden_set", Native_SetWarden);
	CreateNative("warden_remove", Native_RemoveWarden);

	RegPluginLibrary("warden");

	return APLRes_Success;
}

public ClientWeaponReload(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event,  "userid"));

	if (!IsPlayerAlive(client))
		return

	if(!IsClientInGame(client))
		return

	decl String:wpn[32];
	GetClientWeapon( client, wpn, 32);

	if (matrix)
	{
		if ( StrEqual( wpn, "weapon_deagle" ) )
		{
		Client_SetWeaponPlayerAmmo(client, "weapon_deagle",35, -1)
		}
		else
		if ( StrEqual( wpn, "weapon_elite" ) )
		{
		Client_SetWeaponPlayerAmmo(client, "weapon_elite",120, -1)
		}
		else
		if ( StrEqual( wpn, "weapon_p250" ) )
		{
		Client_SetWeaponPlayerAmmo(client, "weapon_p250",26, -1)
		}
	}

	if (zombie)
	{
		if ( StrEqual( wpn, "weapon_tec9" ) )
		{
		Client_SetWeaponPlayerAmmo(client, "weapon_tec9",120, -1)
		}
		else
		if ( StrEqual( wpn, "weapon_nova" ) )
		{
		Client_SetWeaponPlayerAmmo(client, "weapon_nova",32, -1)
		}
		else
		if ( StrEqual( wpn, "weapon_mag7" ) )
		{
		Client_SetWeaponPlayerAmmo(client, "weapon_mag7",32, -1)
		}
	}
}

public Action:OnPlayerRunCmd(client, &buttons, &impulse, Float:vel[3], Float:angles[3], &weapon)
{
	if (!IsPlayerAlive(client))
		return Plugin_Continue

	if(!IsClientInGame(client))
		return Plugin_Continue

	if (!zombie)
		return Plugin_Continue

	if ((buttons & IN_JUMP) == IN_JUMP && hrac_dozorce[client])
		buttons &= ~IN_JUMP

	return Plugin_Continue
}

public Action:RestrictRadio(client ,args)
{
	return Plugin_Handled;
}

public Action:Command_JoinTeam(client, const String:command[], args)
{
	if (!client)
		return Plugin_Continue;

	if (jedna_zmena[client])
		return Plugin_Handled;

	if (!ochrana_join_team[client])
		return Plugin_Handled;

	decl String:g_szTeam[4];
	GetCmdArgString(g_szTeam, sizeof(g_szTeam));
	new team = StringToInt(g_szTeam);
	if(pocet_ct < 2)
	{
		if (team == 3)
		{
		ChangeClientTeam(client, 3);
		jedna_zmena[client] = 1
		SetEntProp(client, Prop_Send, "m_iAccount", 6);
		spocitej_hrace()
		return Plugin_Continue
		}

	}


	if (team == 0)
		return Plugin_Handled

	if (pocet_ct >= pocet_t/3 && !(GetUserFlagBits(client) & ADMFLAG_BAN))
	{
		if (team == 3)
		{
		PrintToChat(client,"Je zde prilis dozorcu! (%d)", pocet_ct)
		return Plugin_Handled;
		}
	}

	if (team == 3)
	{
	hrac_dozorce[client] = 1
	hrac_vezen[client] = 0
	ChangeClientTeam(client, 3);
	}

	if (team == 2)
	{
	hrac_vezen[client] = 1
	hrac_dozorce[client] = 0
	}

	if (team == 1)
	{
	hrac_dozorce[client] = 0
	hrac_vezen[client] = 0
	}

	jedna_zmena[client] = 1
	SetEntProp(client, Prop_Send, "m_iAccount", 6);
	spocitej_hrace()

	return Plugin_Continue;
}
public spocitej_hrace()
{

	pocet_ct = 0
	zive_ct = 0
	pocet_t = 0
	zive_t = 0
	new maximumplayers
	maximumplayers = GetMaxClients()
	for (new idx = 1; idx <= maximumplayers; idx++)
	{
		if(!IsValidClient(idx))
		{
		continue
		}
		if(IsClientInGame(idx) && hrac_dozorce[idx])
		{
			pocet_ct++

			if (IsPlayerAlive(idx))
			{
			zive_ct++
			}
		}

		if(IsClientInGame(idx) && hrac_vezen[idx])
		{
			pocet_t++

			if (IsPlayerAlive(idx))
			{
			zive_t++
			}
		}

	}


}

public Action:cmd_kill(client, args) {
	PrintToChat(client, "Ve hre se nelze zabit !!!");
	return Plugin_Handled;
}
public Action:cmd_explode(client, args) {
	PrintToChat(client, "Ve hre se nelze zabit !!!");
	return Plugin_Handled;
}
public Action:BecomeWarden(client, args)
{
	if (blokwarden != 1)
	{
		if (Warden == -1) // There is no warden , so lets proceed
		{
			if (GetClientTeam(client) == 3) // The requested player is on the Counter-Terrorist side
			{
				if (IsPlayerAlive(client)) // A dead warden would be worthless >_<
				{
					SetEntityRenderColor(client, 0, 255, 0, 255);
					SetTheWarden(client);
					GetClientName(client, named, sizeof(named));
					spust_menu_simona(client)
					CS_SetClientClanTag(client, "[SIMON]");
					//CreateTimer(0.1, simon_efekt, client)
				}
				else // Grr he is not alive -.-
				{

				}
			}
			else // Would be wierd if an terrorist would run the prison wouldn't it :p
			{

			}
		}
		else // The warden already exist so there is no point setting a new one
		{

		}
	}
	else // The warden already exist so there is no point setting a new one
	{
		PrintToChat(client, "Kdyz je volny den, tak nelze brat simona");
	}
}

public Action:ExitWarden(client, args)
{
	if(client == Warden) // The client is actually the current warden so lets proceed
	{

		if(GetConVarBool(g_cVar_mnotes))
		{


		}
		Warden = -1; // Open for a new warden
		SetEntityRenderColor(client, 255, 255, 255, 255); // Lets remove the awesome color
	}
	else // Fake dude!
	{

	}
}

public Action:povol_alarm(Handle: timer, any: client)
{
	hraje_alarm = 0
}

public Action: chat_damage(Handle:timer, any: client)
{
		vypis_chat_damage[client] = 0
}

public Action:TraceAttack(victim, &attacker, &inflictor, &Float:damage, &damagetype, &ammotype, hitbox, hitgroup)
{
	if(!IsValidClient(victim))
	return Plugin_Continue
	if(!IsValidClient(attacker))
	return Plugin_Continue
	new String: weapons[64]
	GetClientWeapon(attacker, weapons, 64);

	decl String:name[65]
	decl String:name2[65]

	GetClientName(attacker, name, sizeof(name));
	GetClientName(victim, name2, sizeof(name2));
	if(prebieha_duel == 1)
	{
			if(duelant[attacker] != duelant[victim])
			{
				damage *= 0.0;
				return Plugin_Changed

			}

	}
	if(GetClientTeam(attacker) == 3 && GetClientTeam(victim) == 2 && !vypis_chat_damage[victim] && zive_t > 1 && !duel_lock && !mod)
	{
	PrintToChatAll("*\x06%s \x01zautocil na \x07%s",name, name2)
	vypis_chat_damage[victim] = 1
	CreateTimer(10.0, chat_damage, victim)
	}


	if(GetClientTeam(attacker) == 2 && GetClientTeam(victim) == 3)
	{
			if(StrEqual(weapons,"weapon_knife"))
			{
				if (GetUserFlagBits(attacker) & EVIP)
				{
					SetClientMoney(attacker, 2);
				}
				else
				if (GetUserFlagBits(attacker) & VIP)
				{
					SetClientMoney(attacker, 1);
				}
				else
					SetClientMoney(attacker, 1);
			}
			vzbura = 1
			if (!prebieha_duel && !mod && !hraje_alarm && !koneckola)
			{
			EmitSoundToAllAny("jbextreme/siren.mp3");
			hraje_alarm = 1
			CreateTimer(7.0, povol_alarm)
			}

	}
	if (boxmod == 1)
	{
			if(GetClientTeam(attacker) == 3 && GetClientTeam(victim) == 3)
			{
			damage *= 0.0;
			return Plugin_Changed;
			}
			else
			{
				if(StrEqual(weapons,"weapon_knife"))
				{
				if(knife_skin[attacker] == 0)
				{
				damage = 30.0;
				return Plugin_Changed;
				}
				if(knife_skin[attacker] == 1)
				{
				damage = 50.0;
				return Plugin_Changed;
				}
				if(knife_skin[attacker] == 2)
				{
				damage = 70.0;
				return Plugin_Changed;
				}
				if(knife_skin[attacker] == 3)
				{
				damage = 100.0;
				return Plugin_Changed;
				}
				}
			}
	}
	else
	if (boxmod == 2)
	{
		if(GetClientTeam(attacker) == 3 && GetClientTeam(victim) == 3)
		{
		damage *= 0.0;
		return Plugin_Changed;
		}
		else
		if(GetClientTeam(attacker) == 2 && GetClientTeam(victim) == 2)
		{
			if(!StrEqual(weapons,"weapon_knife"))
			{
			damage *= 0.0;
			return Plugin_Changed;

			}
			else
			{
				if(StrEqual(weapons,"weapon_knife"))
				{
				if(knife_skin[attacker] == 0)
				{
				damage = 30.0;
				return Plugin_Changed;
				}
				if(knife_skin[attacker] == 1)
				{
				damage = 50.0;
				return Plugin_Changed;
				}
				if(knife_skin[attacker] == 2)
				{
				damage = 70.0;
				return Plugin_Changed;
				}
				if(knife_skin[attacker] == 3)
				{
				damage = 100.0;
				return Plugin_Changed;
				}
				}

			}
			//return Plugin_Continue;

		}
	}
	else
	{
			if(StrEqual(weapons,"weapon_knife"))
			{

			if(knife_skin[attacker] == 0)
			{

				damage = 30.0;
				return Plugin_Changed;
			}
			if(knife_skin[attacker] == 1)
			{


				damage = 50.0;
				return Plugin_Changed;
			}
			if(knife_skin[attacker] == 2)
			{


				damage = 70.0;
				return Plugin_Changed;
			}
			if(knife_skin[attacker] == 3)
			{

				damage = 100.0;
				return Plugin_Changed;
			}
			}
	}

	return Plugin_Continue;
}




public OnClientPutInServer(client)
{
	if(!IsValidClient(client))
		return

	SDKHook(client, SDKHook_TraceAttack, TraceAttack);
	SDKHook(client, SDKHook_PreThink, Playerprethink);
	SDKHook(client, SDKHook_PostThinkPost, OnPostThinkPost);
	SDKHook(client, SDKHook_WeaponCanUse, BlockPickup);
	SDKHook(client, SDKHook_Touch, OnTouch);
	vd_next_round[client] = 0
	duelant[client] = 0
	hrac_dozorce[client] = 0
	hrac_vezen[client] = 1
	jedna_zmena[client] = 0
	cislo_skinu[client] = 0
	cislo_skinu_aktual[client] = 0
	ochrana_join_team[client] = 0
	duelant[client] = 0

	if (GetUserFlagBits(client) & ADMFLAG_KICK)
	{
	SetClientListeningFlags(client, VOICE_SPEAKALL);
	}
	else
	{
	SetClientListeningFlags(client, VOICE_MUTED)
	}

}
public OnTouch(client, other)
{
	if(!IsValidClient(client))
	return
	if(!IsValidClient(other))
	return
	if(client == other)
	return
	new Float:clientposition[3];
	GetClientAbsOrigin(client, clientposition)
	new Float:clientposition2[3];
	GetClientAbsOrigin(other, clientposition2)


//PrintToChat(client, "%f - %f /// %f - %f /// %f - %f", clientposition[0], clientposition2[0],clientposition[1], clientposition2[1],clientposition[2], clientposition2[2])
	//new Float: osy = clientposition[1]	- clientposition2[1]
	//new Float: osx = clientposition[0]	- clientposition2[0]
	new Float: vysledok

	//vysledok = osy*osy + osx*osx
	vysledok = GetVectorDistance(clientposition,clientposition2)
	if(vysledok < 32.0)
	{
	SetEntProp(client, Prop_Data, "m_CollisionGroup", COLLISION_GROUP_PUSHAWAY);
	PrintToChat(client,"Byl jsi odseknuty")
	}
	CreateTimer(0.1,remove,client)


}
public Action: remove(Handle: time, any client)
SetEntProp(client, Prop_Data, "m_CollisionGroup", COLLISION_GROUP_NONE);

public Action:BlockPickup(client, weapon)
{
	if (koneckola)
		return Plugin_Continue;

	new String:weaponClass[64];
	GetEntityClassname(weapon, weaponClass, sizeof(weaponClass));

	if (StrEqual(weaponClass, "weapon_smokegrenade"))
		return Plugin_Handled;

	///// OCHRANA GRANATU U DOZORCU /////

	if (hrac_dozorce[client] && !duelant[client] && !zombie)
	{
	if (StrEqual(weaponClass, "weapon_molotov"))
		return Plugin_Handled;

	if (StrEqual(weaponClass, "weapon_flashbang"))
		return Plugin_Handled;

	if (StrEqual(weaponClass, "weapon_hegrenade"))
		return Plugin_Handled;

	if (StrEqual(weaponClass, "weapon_decoy"))
		return Plugin_Handled;
	}

	///// OCHRANA ZBRANI PRI MATRIXU /////

	if (matrix)
	{
	if (StrEqual(weaponClass, "weapon_knife"))
		return Plugin_Continue;

	if (StrEqual(weaponClass, "weapon_deagle"))
		return Plugin_Continue;

	if (StrEqual(weaponClass, "weapon_elite"))
		return Plugin_Continue;

	if (StrEqual(weaponClass, "weapon_p250"))
		return Plugin_Continue;

	return Plugin_Handled;
	}

	///// OCHRANA ZBRANI PRI ZOMBIE /////

	if (zombie)
	{
		if (hrac_vezen[client])
		{
			if (StrEqual(weaponClass, "weapon_knife"))
				return Plugin_Continue;
		}

		if (hrac_dozorce[client])
		{
			if (StrEqual(weaponClass, "weapon_knife"))
				return Plugin_Continue;

			if (StrEqual(weaponClass, "weapon_tec9"))
				return Plugin_Continue;

			if (StrEqual(weaponClass, "weapon_nova"))
				return Plugin_Continue;

			if (StrEqual(weaponClass, "weapon_molotov"))
				return Plugin_Continue;

			if (StrEqual(weaponClass, "weapon_mag7"))
				return Plugin_Continue;
		}
		return Plugin_Handled;
	}

	///// OCHRANA ZBRANI PRI DUELU /////

	if(duelant[client] == 1 && !StrEqual(weaponClass,duel_weapons[vybrana_duel_guna]))
		return Plugin_Handled;

	///// OCHRANA ZBRANI PRI PRESTRELCE /////

	if(mod && zbran_prestrelka != 99)
	{

		if (StrEqual(weaponClass,prestrelka_zbran[zbran_prestrelka-1]))
			return Plugin_Continue;

		return Plugin_Handled;
	}

	return Plugin_Continue
}

stock ClearTimer(&Handle:timer)
{
    if (timer != INVALID_HANDLE)
    {
        KillTimer(timer);
        timer = INVALID_HANDLE;
    }
}
stock SetClientSpeed(client,Float:speed)
{
    SetEntPropFloat(client, Prop_Send, "m_flLaggedMovementValue",speed)
}
stock SetClientMoney(int client,int hodnota,bool plus = true)
{
  if(IsClientInGame(client))
  {
    if(plus)
    {
      int money = GetClientMoney(client) + hodnota;
      if (money <= 200) SetEntProp(client, Prop_Send, "m_iAccount", money);
      else  SetEntProp(client, Prop_Send, "m_iAccount", 200);
    }
    else
    {
      int money = GetClientMoney(client) - hodnota;
      if (money <= 0) SetEntProp(client, Prop_Send, "m_iAccount", 0);
      else  SetEntProp(client, Prop_Send, "m_iAccount", money);
    }
  }
  penaze[client] = GetClientMoney(client)
}
stock GetClientMoney(client)
{
  return GetEntProp(client, Prop_Send, "m_iAccount");
}
stock IsValidClient(client, bool:replaycheck = true)
{
	new maximumplayers
	maximumplayers = GetMaxClients()
	if(client <= 0 || client > maximumplayers)
    {
        return false;
    }
	if(!IsClientInGame(client))
    {
        return false;
    }

	if(replaycheck)
	{
	if(IsClientSourceTV(client) || IsClientReplay(client)) return false;
	}
	return true;
}
public Action:removebit(client, argc)
{
    decl String:arg1[16];
    GetCmdArg(1, arg1, sizeof(arg1));

    g_bits[client] &= ~(1<<StringToInt(arg1));

    return Plugin_Handled;
}
public OnPostThinkPost(client)
{
    SetEntProp(client, Prop_Send, "m_iAddonBits", g_bits[client]);
}
public Playerprethink(client)
{

	if(IsClientInGame(client) && IsPlayerAlive(client))
	{
		if(duelant[client] == 1)
		{
			if(vybrana_duel_guna == 1)
			{
			if(!IsValidEntity( GetPlayerWeaponSlot(client, 3) ))
			GivePlayerItem(client,"weapon_hegrenade");
			}
		}
	}
	if(invis[client] == 1)
	{

		//SetEntityRenderMode(client , RENDER_NONE);
		new m_hMyWeapons = FindSendPropOffs("CBasePlayer", "m_hMyWeapons");

		for(new i = 0, weapon; i < 47; i += 4)
		{
			weapon = GetEntDataEnt2(client, m_hMyWeapons + i);
			if (weapon > -1 )
			{
			SetEntityRenderMode(weapon, RENDER_NONE);
			}
		}


	}
}
public Action: dajprachy(Handle: timer, any client)
{
	SetEntProp(client, Prop_Send, "m_iAccount", penaze[client]);
}
public Action:event_Spawn(Handle:event, const String:name[], bool:dontBroadcast)
{

	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	ClearTimer(hrac_vd[client])
	SetEntityGravity(client, 1.0)
	CreateTimer(0.5,dajprachy, client)
	simon_gun[client] = 0
	ct_gun[client] = 0
	team_hraca[client] = 0
	knife_skin[client] = 0
	duelant[client] = 0
	jedna_zmena[client] = 0
	hracsvd[client] = 0
	vypis_chat_damage[client] = 0
	ochrana_join_team[client] = 1
	SetClientSpeed(client, 1.0)
	strip_user_weapons(client)
	CS_SetClientClanTag(client, "");
	new knife = GivePlayerItem(client,"weapon_knife");
	EquipPlayerWeapon(client, knife);

	if (GetClientTeam(client) == 3)
	{
	SetEntityModel(client, "models/player/mapeadores/kaem/police/police.mdl");
	hrac_dozorce[client] = 1
	hrac_vezen[client] = 0
	SetClientListeningFlags(client, VOICE_SPEAKALL);
	main_menu(client)
	}

	if (GetClientTeam(client) == 2)
	{
	CreateTimer(GetRandomFloat(0.1,1.0),setskin,client)
	hrac_vezen[client] = 1
	hrac_dozorce[client] = 0


	if (GetUserFlagBits(client) & ADMFLAG_KICK)
	{
	SetClientListeningFlags(client, VOICE_SPEAKALL);

	}
	else
	{
	SetClientListeningFlags(client, VOICE_MUTED);

	}

	}

	if(freeday == 0)
	SetEntityRenderColor(client, 255, 255, 255, 255);
	if(freeday != 1)
	{
		if(vd_next_round[client] == 1)
		{
		hracsvd[client] = 1
		vd_next_round[client] = 0
		SetEntityRenderColor(client, 255, 255, 0, 255);
		decl String:menicko[65];
		GetClientName(client, menicko, sizeof(menicko));
		PrintToChatAll("Hrac %s dostal volny den z posledniho prani",menicko)
		hrac_vd[client] = CreateTimer(VD_TIMER, zrus_vd, client)
		}
	}
}
public Action:main_menu(clientId)
{
	if(!IsValidClient(clientId))
	return Plugin_Continue

	new Handle:menu = CreateMenu(main_menu_handler);
	decl String:itemtext2[256];

	if(IsClientInGame(clientId) && GetClientTeam(clientId) == 2)
	{
		SetMenuTitle(menu, "Vezenske Menu - /menu");
	}
	else
	{
		SetMenuTitle(menu, "Dozorca Menu - /menu");
	}
	Format(itemtext2, sizeof(itemtext2), "Herni obchod")
	AddMenuItem(menu, "option1", itemtext2);
	Format(itemtext2, sizeof(itemtext2), "Vybrat vzhled")
	AddMenuItem(menu, "option2", itemtext2);
	Format(itemtext2, sizeof(itemtext2), "Pravidla")
	AddMenuItem(menu, "option3", itemtext2);
	if (GetUserFlagBits(clientId) & EVIP)
	{

	}
	else
	if (GetUserFlagBits(clientId) & VIP)
	{

	}
	else
	{
	Format(itemtext2, sizeof(itemtext2), "Aktivace VIP")
	AddMenuItem(menu, "option4", itemtext2);
	}



	SetMenuExitButton(menu, true);
	DisplayMenu(menu, clientId, 120);
	return Plugin_Handled;
}
public main_menu_handler(Handle:menu, MenuAction:action, client, itemNum)
{
	if(!IsValidClient(client))
	return

	if ( action == MenuAction_Select )
	{
		new String:info[32]; GetMenuItem(menu, itemNum, info, sizeof(info));
		if ( strcmp(info,"option1") == 0 )
		{
			if(IsClientInGame(client) && GetClientTeam(client) == 2)
			{
				Shop_menu(client)
			}
			else
			{
				Shop_menu_ct(client)
			}
		}
		if ( strcmp(info,"option2") == 0 )
		{

		}
		if ( strcmp(info,"option3") == 0 )
		{

		}
		if ( strcmp(info,"option4") == 0 )
		{

		}



	}

}
public Action: setskin(Handle: timer, any: client)
{
	if(IsValidClient(client) && IsPlayerAlive(client))
	///// ANTI STUCK SPAWN  ////
	//SetEntProp(client, Prop_Data, "m_CollisionGroup", COLLISION_GROUP_PUSHAWAY);
	//CreateTimer(1.0, Timer_UnBlockPlayer, client);
	///////////////////////////
	SetEntityModel(client, "models/player/prisoner/prisoner.mdl");
}

public Action:Timer_UnBlockPlayer(Handle:timer, any:client)
{
	if (IsClientInGame(client) && IsPlayerAlive(client))
	{
		SetEntProp(client, Prop_Data, "m_CollisionGroup", COLLISION_GROUP_PLAYER);
	}
	return Plugin_Continue;
}

public Action:konec_kola(Handle:event, const String:name[], bool:dontBroadcast)
{

	EmitSoundToAllAny("jbextreme/end_gss.mp3");
	koneckola = 1
	freeday = 0
	blokwarden = 0
	matrix = 0
	mod = 0


}

public Action:roundStart(Handle:event, const String:name[], bool:dontBroadcast)
{
	CreateTimer(3.0 , choddobrany)
	PrintToChatAll("*\x06Pravidla JailBreaku po napsani \x04/pravidla \x06do chatu!");
	ClearTimer(forceendround)
	ClearTimer(hvdtimer)
	opencell = 0
	vzbura = 0
	Open = false;
	boxmod = 0
	Warden = -1;
	if (start_futbal)
	{
	ServerCommand("ballendmatch2");
	start_futbal = 0
	}
	stopky = 0
	stopky2 = 0
	stopky_hodnota = 0
	vybrana_duel_guna = 0
	duel_lock = 0
	prebieha_duel = 0
	mikrofon = 0
	mod = 0
	hraje_alarm = 0
	koneckola = 0
	zbran_prestrelka = 0
	matrix = 0
	zombie = 0
	cely_otvorene_mod_nejde = 0
	pocet_dni++
	blokwarden = 0
	hraci_a = 0
	hraci_b = 0

	ServerCommand("mp_tkpunish 0")
	ServerCommand("mp_autokick 0")
	ServerCommand("mp_disable_autokick 1")
	ServerCommand("mp_friendlyfire 0")
	//ServerCommand("mp_roundtime 15")

	//PrintToChatAll("pocet ct %d",pocet_ct)
	 // Lets remove the current warden if he exist

	if (GetRandomInt(1,100) < 10 || pocet_dni == 1 || pocet_dni == 2 || pocet_ct <= 0)
	{
	freeday = 1
	blokwarden = 1

	hvdtimer = CreateTimer(VD_TIMER_HVD, Zrus_HVD)
	CreateTimer(1.0, Zacni_HVD)
	}
	else
	{
	freeday = 0
	blokwarden = 0
	}


	//dorobit podmienku aby zlty boli len T a dorobit aby sa vyplo HVD po case
	if(freeday == 1)
	{
		opencell = 1
		auto_open()
		new maximumplayers
		maximumplayers = GetMaxClients()
		for (new idx = 1; idx <= maximumplayers; idx++)
		{
			if(!IsValidClient(idx))
				continue
			if(IsClientInGame(idx) && IsPlayerAlive(idx) && GetClientTeam(idx) == 2)
			{

			SetEntityRenderColor(idx, 255, 255, 0, 255);
			}
		}
	}


}

public Action: close_cell()
{

	new iEnt = -1;
	new String:strModel[150];
	GetCurrentMap(mapname, 119)
	for(new i; i < sizeof(Entities); i++)
	{

		while((iEnt = FindEntityByClassname(iEnt, Entities[i])) != -1)
		{
			GetEntPropString(iEnt, Prop_Data, "m_iName", strModel, sizeof(strModel));
			if(StrEqual(mapname,"ba_jail_modern_castle_csgo"))
			{
				if(StrEqual(strModel,"map_cells_doors"))
				{
				AcceptEntityInput(iEnt, Open? "Open":"Close");
				}
				else
				if(StrEqual(strModel,"map_armoury_door"))
				{
				AcceptEntityInput(iEnt, Open? "Open":"Close")
				}
			}
			else
			if(StrEqual(mapname,"ba_jail_electric_revamp_beta"))
			{

				if(StrEqual(strModel,"armory_door"))
				{
				AcceptEntityInput(iEnt, Open? "Open":"Close");
				}
				else
				if(StrEqual(strModel,"cell_door"))
				{
				AcceptEntityInput(iEnt, Open? "Open":"Close");
				}

			}
			if(StrEqual(mapname,"ba_jail_soar_beta2"))
			{

				if(StrEqual(strModel,"cell_door_1"))
				{
				AcceptEntityInput(iEnt, Open? "Open":"Close");
				}
				else
				if(StrEqual(strModel,"cell_door_2"))
				{
				AcceptEntityInput(iEnt, Open? "Open":"Close");
				}
				else
				if(StrEqual(strModel,"cell_door_3"))
				{
				AcceptEntityInput(iEnt, Open? "Open":"Close");
				}
				else
				if(StrEqual(strModel,"cell_door_4"))
				{
				AcceptEntityInput(iEnt, Open? "Open":"Close");
				}
				else
				if(StrEqual(strModel,"cell_door_5"))
				{
				AcceptEntityInput(iEnt, Open? "Open":"Close");
				}
				else
				if(StrEqual(strModel,"cell_door_6"))
				{
				AcceptEntityInput(iEnt, Open? "Open":"Close");
				}
				else
				if(StrEqual(strModel,"cell_door_7"))
				{
				AcceptEntityInput(iEnt, Open? "Open":"Close");
				}
				else
				if(StrEqual(strModel,"cell_door_8"))
				{
				AcceptEntityInput(iEnt, Open? "Open":"Close");
				}
				else
				if(StrEqual(strModel,"cell_door_9"))
				{
				AcceptEntityInput(iEnt, Open? "Open":"Close");
				}
				else
				if(StrEqual(strModel,"cell_door_10"))
				{
				AcceptEntityInput(iEnt, Open? "Open":"Close");
				}


			}
			if(StrEqual(mapname,"jb_citrus_v2"))
			{

				if(StrEqual(strModel,"cell door"))
				{
				AcceptEntityInput(iEnt, Open? "Open":"Close");
				}
			}
			if(StrEqual(mapname,"jb_fairway_csgo"))
			{

				if(StrEqual(strModel,"cell door"))
				{
				AcceptEntityInput(iEnt, Open? "Open":"Close");
				}
			}
			if(StrEqual(mapname,"jb_mountaincraft_v4"))
			{

				if(StrEqual(strModel,"cell_door_1"))
				{
				AcceptEntityInput(iEnt, Open? "Open":"Close");
				}
				else
				if(StrEqual(strModel,"cell_door_2"))
				{
				AcceptEntityInput(iEnt, Open? "Open":"Close");
				}
				else
				if(StrEqual(strModel,"cell_door_3"))
				{
				AcceptEntityInput(iEnt, Open? "Open":"Close");
				}
				else
				if(StrEqual(strModel,"cell_door_4"))
				{
				AcceptEntityInput(iEnt, Open? "Open":"Close");
				}
				else
				if(StrEqual(strModel,"cell_door_5"))
				{
				AcceptEntityInput(iEnt, Open? "Open":"Close");
				}
				else
				if(StrEqual(strModel,"cell_door_6"))
				{
				AcceptEntityInput(iEnt, Open? "Open":"Close");
				}
				else
				if(StrEqual(strModel,"cell_door_7"))
				{
				AcceptEntityInput(iEnt, Open? "Open":"Close");
				}
				else
				if(StrEqual(strModel,"cell_door_8"))
				{
				AcceptEntityInput(iEnt, Open? "Open":"Close");
				}
				else
				if(StrEqual(strModel,"cell_door_9"))
				{
				AcceptEntityInput(iEnt, Open? "Open":"Close");
				}
				else
				if(StrEqual(strModel,"cell_door_10"))
				{
				AcceptEntityInput(iEnt, Open? "Open":"Close");
				}
				else
				if(StrEqual(strModel,"cell_door_11"))
				{
				AcceptEntityInput(iEnt, Open? "Open":"Close");
				}
			}
			else
			{

				AcceptEntityInput(iEnt, Open? "Open":"Close");
			}


		}
	}

}
public Action: auto_open()
{

	new iEnt = -1;
	new String:strModel[150];
	GetCurrentMap(mapname, 119)
	for(new i; i < sizeof(Entities); i++)
	{

		while((iEnt = FindEntityByClassname(iEnt, Entities[i])) != -1)
		{
			GetEntPropString(iEnt, Prop_Data, "m_iName", strModel, sizeof(strModel));
			if(StrEqual(mapname,"ba_jail_modern_castle_csgo"))
			{
				if(StrEqual(strModel,"map_cells_doors"))
				{
				AcceptEntityInput(iEnt, Open? "Close":"Open");
				}
				else
				if(StrEqual(strModel,"map_armoury_door"))
				{
				AcceptEntityInput(iEnt, Open? "Close":"Open");
				}
			}
			else
			if(StrEqual(mapname,"ba_jail_electric_revamp_beta"))
			{

				if(StrEqual(strModel,"armory_door"))
				{
				AcceptEntityInput(iEnt, Open? "Close":"Open");
				}
				else
				if(StrEqual(strModel,"cell_door"))
				{
				AcceptEntityInput(iEnt, Open? "Close":"Open");
				}


			}
			if(StrEqual(mapname,"ba_jail_soar_beta2"))
			{

				if(StrEqual(strModel,"cell_door_1"))
				{
				AcceptEntityInput(iEnt, Open? "Close":"Open");
				}
				else
				if(StrEqual(strModel,"cell_door_2"))
				{
				AcceptEntityInput(iEnt, Open? "Close":"Open");
				}
				else
				if(StrEqual(strModel,"cell_door_3"))
				{
				AcceptEntityInput(iEnt, Open? "Close":"Open");
				}
				else
				if(StrEqual(strModel,"cell_door_4"))
				{
				AcceptEntityInput(iEnt, Open? "Close":"Open");
				}
				else
				if(StrEqual(strModel,"cell_door_5"))
				{
				AcceptEntityInput(iEnt, Open? "Close":"Open");
				}
				else
				if(StrEqual(strModel,"cell_door_6"))
				{
				AcceptEntityInput(iEnt, Open? "Close":"Open");
				}
				else
				if(StrEqual(strModel,"cell_door_7"))
				{
				AcceptEntityInput(iEnt, Open? "Close":"Open");
				}
				else
				if(StrEqual(strModel,"cell_door_8"))
				{
				AcceptEntityInput(iEnt, Open? "Close":"Open");
				}
				else
				if(StrEqual(strModel,"cell_door_9"))
				{
				AcceptEntityInput(iEnt, Open? "Close":"Open");
				}
				else
				if(StrEqual(strModel,"cell_door_10"))
				{
				AcceptEntityInput(iEnt, Open? "Close":"Open");
				}


			}
			if(StrEqual(mapname,"jb_citrus_v2"))
			{

				if(StrEqual(strModel,"cell door"))
				{
				AcceptEntityInput(iEnt, Open? "Close":"Open");
				}
			}
			if(StrEqual(mapname,"jb_fairway_csgo"))
			{

				if(StrEqual(strModel,"cell door"))
				{
				AcceptEntityInput(iEnt, Open? "Close":"Open");
				}
			}
			if(StrEqual(mapname,"jb_mountaincraft_v4"))
			{

				if(StrEqual(strModel,"cell_door_1"))
				{
				AcceptEntityInput(iEnt, Open? "Close":"Open");
				}
				else
				if(StrEqual(strModel,"cell_door_2"))
				{
				AcceptEntityInput(iEnt, Open? "Close":"Open");
				}
				else
				if(StrEqual(strModel,"cell_door_3"))
				{
				AcceptEntityInput(iEnt, Open? "Close":"Open");
				}
				else
				if(StrEqual(strModel,"cell_door_4"))
				{
				AcceptEntityInput(iEnt, Open? "Close":"Open");
				}
				else
				if(StrEqual(strModel,"cell_door_5"))
				{
				AcceptEntityInput(iEnt, Open? "Close":"Open");
				}
				else
				if(StrEqual(strModel,"cell_door_6"))
				{
				AcceptEntityInput(iEnt, Open? "Close":"Open");
				}
				else
				if(StrEqual(strModel,"cell_door_7"))
				{
				AcceptEntityInput(iEnt, Open? "Close":"Open");
				}
				else
				if(StrEqual(strModel,"cell_door_8"))
				{
				AcceptEntityInput(iEnt, Open? "Close":"Open");
				}
				else
				if(StrEqual(strModel,"cell_door_9"))
				{
				AcceptEntityInput(iEnt, Open? "Close":"Open");
				}
				else
				if(StrEqual(strModel,"cell_door_10"))
				{
				AcceptEntityInput(iEnt, Open? "Close":"Open");
				}
				else
				if(StrEqual(strModel,"cell_door_11"))
				{
				AcceptEntityInput(iEnt, Open? "Close":"Open");
				}
			}
			else
			{

				AcceptEntityInput(iEnt, Open? "Close":"Open");
			}


		}
	}

}
public Action: auto_open_name()
{

	new iEnt = -1;
	new String:strModel[150];
	GetCurrentMap(mapname, 119)
	PrintToChatAll("%s", mapname)
	for(new i; i < sizeof(Entities); i++)
	{
		while((iEnt = FindEntityByClassname(iEnt, Entities[i])) != -1)
		{
			GetEntPropString(iEnt, Prop_Data, "m_iName", strModel, sizeof(strModel));
			AcceptEntityInput(iEnt, Open? "Close":"Open");
			PrintToChatAll("%s", strModel)
		}
	}
}

public Action: Zacni_HVD(Handle:timer)
{
	PrintHintTextToAll("<font color='#FFCC00' size='30'>ZACAL VOLNY DEN!</font><br><font color='#FFFFFF' size='17'>vezni maji volny pohyb po veznici</font>")
	EmitSoundToAllAny("jbextreme/brass_bell_C.mp3");
}

public Action: Zrus_HVD(Handle:timer)
{
	hvdtimer = INVALID_HANDLE

	freeday = 0
	blokwarden = 0
	PrintHintTextToAll("<font color='#FFCC00' size='30'>SKONCIL VOLNY DEN!</font><br><font color='#FFFFFF' size='17'>vezni cekaji na zvoleni simona</font>")
	EmitSoundToAllAny("jbextreme/brass_bell_C.mp3");
	new maximumplayers
	maximumplayers = GetMaxClients()
	for (new idx = 1; idx <= maximumplayers; idx++)
	{
		if(!IsValidClient(idx))
		{
		continue
		}
		if(!IsPlayerAlive(idx))
		{
		continue
		}
		SetEntityRenderColor(idx, 255, 255, 255, 255);
	}


}
public Action: menu_zrusene(client)
{

	team_hraca[client] = 0

	SetEntityGravity(client, 1.0)

	if(team_hraca[client] > 0)
	SetEntityRenderColor(client, 255, 255, 255, 255);


}
public Action:playerDeath(Handle:event, const String:name[], bool:dontBroadcast)
{

	new client = GetClientOfUserId(GetEventInt(event, "userid")); // Get the dead clients id
	new attaker = GetClientOfUserId(GetEventInt(event, "attacker"));
	new assistent = GetClientOfUserId(GetEventInt(event, "assister"));

	if(!IsValidClient(client))
	return
	ClearTimer(hrac_vd[client])
	if (GetUserFlagBits(client) & ADMFLAG_KICK)
	{

	SetClientListeningFlags(client, VOICE_SPEAKALL);
	}
	else
	{

	SetClientListeningFlags(client, VOICE_MUTED);
	}
	if(client == Warden) // Aww damn , he is the warden
	{
		CS_SetClientClanTag(client, "");
		PrintHintTextToAll("<font color='#00FF00' size='30'>SIMON BYL ZABIT</font><br><font color='#FFFFFF' size='20'>Vsechny prikazy a zakazy se rusi</font>")
		if (start_futbal)
		{
		ServerCommand("ballendmatch2");

		PrintToChatAll("*\x09Fotbal byl preruseny");
		//PrintHintTextToAll("<font color='#00FF00' size='20'>SIMON BYL ZABIT</font><br><font color='#FFFFFF' size='30'>FOTBAL JE ZRUSENY</font>")
		EmitSoundToAllAny("jbextreme/pisk_e1.mp3");
		start_futbal = 0

		hraci_a = 0
		hraci_b = 0
		new maximumplayers
		maximumplayers = GetMaxClients()
		for (new i=1; i<=maximumplayers; i++)
		{
			team_hraca[i] = 0

			if(!IsValidClient(i))
				continue

			if(!IsPlayerAlive(i))
				continue

			if (!IsClientInGame(i))
				continue;

			if (client == i)
				continue;

			if (hracsvd[i] == 1)
				continue;

			SetEntityRenderColor(i, 255, 255, 255, 255);
		}
		}

		//SetEntityRenderColor(client, 255, 255, 255, 255); // Lets give him the standard color back

		ServerCommand("mp_tkpunish 0")
		ServerCommand("mp_autokick 0")
		ServerCommand("mp_disable_autokick 1")
		ServerCommand("mp_friendlyfire 0")

		boxmod = 0
		Warden = -1;
		mikrofon = 0
		new maximumplayers
		maximumplayers = GetMaxClients()
		for (new i=1; i<=maximumplayers; i++)
		{
			if(!IsValidClient(i))
			{
			continue
			}
			if(!IsPlayerAlive(i))
			{
			continue
			}
			menu_zrusene(i)

		}

	}
	if(duelant[client] == 1)
	{
		duel_lock = 0
	}
	duelant[client] = 0
	CreateTimer(0.1,duel_vykonaj)

	if(IsValidClient(attaker) && attaker != client)
	{
		if (GetUserFlagBits(attaker) & EVIP)
		{
			SetClientMoney(attaker, 15);
		}
		else
		if (GetUserFlagBits(attaker) & VIP)
		{
			SetClientMoney(attaker, 10);
		}
		else
			SetClientMoney(attaker, 2);
	}


	if(IsValidClient(assistent) && assistent != client)
	SetClientMoney(assistent, 1);


	if (hrac_vezen[attaker] && hrac_vezen[client] && attaker != client)
	{
	SetEntProp(attaker, Prop_Data, "m_iFrags", GetClientFrags(attaker)+2);
	}

	if (GetUserFlagBits(attaker) & VIP)
	{
	new health = GetClientHealth(client);
	SetEntityHealth(client, health + 5);
	}


}
public Action: duel_vykonaj(Handle: timer)
{
	spocitej_hrace()
	if(mod != 1)
	{

		if(duel_lock == 0)
		{

			if(zive_ct > 0 && zive_t == 1)
			{

				duel_lock = 1
				prebieha_duel = 0
				blokwarden = 1;
				new maximumplayers
				maximumplayers = GetMaxClients()
				for (new idl = 1; idl <= maximumplayers; idl++)
				{

					if(!IsValidClient(idl))
					continue

					if(idl == Warden)
					RemoveTheWarden(idl)


					if(IsClientInGame(idl) && IsPlayerAlive(idl) && GetClientTeam(idl) == 2)
					{
						decl String:namek[65]


						GetClientName(idl, namek, sizeof(namek));

						open_pp_menu(idl)
						SetEntityHealth(idl, 100);
						SetEntityGravity(idl, 1.0)
						//PrintToChatAll("PPPPPP %s",namek)

					}
				}



			}
		}
	}
}
public Action:open_pp_menu(clientId)
{
	if(!IsValidClient(clientId))
	return
	if(duel_lock == 1)
	{
	if(IsPlayerAlive(clientId))
	{
	new Handle:menu = CreateMenu(DIDMenuHandler_pp);
	SetMenuTitle(menu, "Posledni prani");
	AddMenuItem(menu, "option2", "Volny den");
	AddMenuItem(menu, "option3", "Souboj Deagle");
	AddMenuItem(menu, "option4", "Souboj Box");
	AddMenuItem(menu, "option5", "Souboj HE");
	AddMenuItem(menu, "option6", "Souboj Armagedon");
	SetMenuExitButton(menu, true);
	DisplayMenu(menu, clientId, 120);
	}
	}

}
public Action:ForceGameEnd(Handle: timer)
{
	forceendround = INVALID_HANDLE
	CS_TerminateRound(5.0, CSRoundEnd_Draw)
	return Plugin_Handled;
}
public DIDMenuHandler_pp(Handle:menu, MenuAction:action, client, itemNum)
{
	if(!IsValidClient(client))
	return
	if(duel_lock == 1)
	{
	if(IsPlayerAlive(client))
	{
	if ( action == MenuAction_Select )
	{
		new String:info[32]; GetMenuItem(menu, itemNum, info, sizeof(info));
		if ( strcmp(info,"option2") == 0 )
		{
			PrintToChatAll("Hrac si vybral volny den");
			ForcePlayerSuicide(client)
			vd_next_round[client] = 1
			duel_lock = 0

		}
		if ( strcmp(info,"option3") == 0 )
		{
			vybrana_duel_guna = 2
			suboj_menu(client)

		}
		if ( strcmp(info,"option4") == 0 )
		{
			vybrana_duel_guna = 0
			suboj_menu(client)

		}
		if ( strcmp(info,"option5") == 0 )
		{
			vybrana_duel_guna = 1
			suboj_menu(client)

		}
		if ( strcmp(info,"option6") == 0 )
		{
			vybrana_duel_guna = 3
			suboj_menu(client)

		}


	}
	else if ( action == MenuAction_Cancel )
	{
		duel_lock = 0
		PrintToChat(client, "Menu posledniho prani otevres prikazem /pp")
	}

	}
	}


}
/*public Action: duelantA(Handle: timer, any client)
{
	if(duelant[client] == 1)
	{
	new Float:vec[3];
	GetClientAbsOrigin(client, vec);
	vec[2] += 0;
	TE_SetupBeamRingPoint(vec, 10.0, 25.0, BeamSprite, HaloSprite, 0, 1, 0.1, 5.0, 1.0, redcolor, 20, 0);
	//TE_SetupBeamFollow(client,BeamSprite,0,2.0,10.0,10.0,10,{255,255,0,255});
	TE_SendToAll()
	//CreateTimer(0.1, duelantA, client)
	}


}
public Action: duelantB(Handle: timer, any client)
{
	if(duelant[client] == 1)
	{
	new Float:vec[3];
	GetClientAbsOrigin(client, vec);
	vec[2] += 0;
	TE_SetupBeamRingPoint(vec, 10.0, 25.0, BeamSprite, HaloSprite, 0, 1, 0.1, 5.0, 1.0, bluecolor, 20, 0);
	//TE_SetupBeamFollow(client,BeamSprite,0,2.0,10.0,10.0,10,{255,255,0,255});
	TE_SendToAll()
	//CreateTimer(0.1, duelantB, client)
	}

}
public Action: simon_efekt(Handle: timer, any client)
{
	if(client == Warden)
	{
	new Float:vec[3];
	GetClientAbsOrigin(client, vec);
	vec[2] += 0;
	TE_SetupBeamRingPoint(vec, 10.0, 25.0, BeamSprite, HaloSprite, 0, 1, 0.1, 5.0, 1.0, greencolor, 20, 0);
	//TE_SetupBeamFollow(client,BeamSprite,0,2.0,10.0,10.0,10,{255,255,0,255});
	TE_SendToAll()
	CreateTimer(0.1, simon_efekt, client)
	}

}*/
public Action:suboj_menu(client)
{
	if(!IsValidClient(client))
	return
	new Handle:menu = CreateMenu(MenuHandlerswad_suboj_menu)
	SetMenuTitle(menu, "Vyber hrace na duel")
	new maximumplayers
	maximumplayers = GetMaxClients()
	for (new i=1; i<=maximumplayers; i++)
		{
			if(!IsValidClient(i))
			{
			continue
			}
			if(!IsPlayerAlive(i))
			{
			continue
			}
			if (!IsClientInGame(i))
			{
				continue;
			}
			if(GetClientTeam(i) == 2)
			{
				continue;
			}

			decl String:name[65];
			GetClientName(i, name, sizeof(name));
			AddMenuItem(menu, name, name)
		}
	SetMenuExitButton(menu, true)
	DisplayMenu(menu, client, 20)


}
public MenuHandlerswad_suboj_menu(Handle:menu, MenuAction:action, param1, param2)
{

	new target = -1
	/* Either Select or Cancel will ALWAYS be sent! */
	if (action == MenuAction_Select)
	{
	new String:info[64]
	GetMenuItem(menu, param2, info, sizeof(info))
	new maximumplayers
	maximumplayers = GetMaxClients()
	for (new i=1; i<=maximumplayers; i++)
	{
		if(!IsValidClient(i))
		{
		continue
		}
		if(!IsPlayerAlive(i))
		{
		continue
		}
		if (!IsClientConnected(i))
		{
			continue
		}
		decl String:other[64]
		GetClientName(i, other, sizeof(other))
		if (StrEqual(info, other))
		{
			target = i
		}
	}
	decl String:other2[64]
	GetClientName(target, other2, sizeof(other2))
	decl String:other3[64]
	GetClientName(param1, other3, sizeof(other3))
	strip_user_weapons(param1)
	strip_user_weapons(target)

	new zbran_1 = GivePlayerItem(param1,duel_weapons[vybrana_duel_guna]);
	EquipPlayerWeapon(param1, zbran_1);

	new zbran_2 = GivePlayerItem(target,duel_weapons[vybrana_duel_guna]);
	EquipPlayerWeapon(target, zbran_2);


	SetEntityRenderColor(param1, 255, 0, 0, 255);
	SetEntityRenderColor(target, 0, 0, 255, 255);
	duelant[param1] = 1
	duelant[target] = 1
	prebieha_duel = 1
	//CreateTimer(1.0, duelantA, param1)
	//CreateTimer(1.0, duelantB, target)

	if(vybrana_duel_guna == 0 || vybrana_duel_guna == 1 || vybrana_duel_guna == 2 )
	{
	SetEntityHealth(target, 100);
	SetEntityHealth(param1, 100);

	}
	else
	if(vybrana_duel_guna == 3)
	{
	SetEntityHealth(target, 1500);
	SetEntityHealth(param1, 1500);
	}
	PrintToChatAll("%s VS %s",other2,other3)
	EmitSoundToAllAny("jbextreme/duel_gs.mp3");
	}


}
public OnClientDisconnect(client)
{
	if(!IsValidClient(client))
	return

	SDKUnhook(client, SDKHook_TraceAttack, TraceAttack);
	SDKUnhook(client, SDKHook_PreThink, Playerprethink);
	SDKUnhook(client, SDKHook_PostThinkPost, OnPostThinkPost);
	SDKUnhook(client, SDKHook_WeaponCanUse, BlockPickup);
	SDKUnhook(client, SDKHook_Touch, OnTouch);

	if(client == Warden) // Aww damn , he is the warden
	{
		PrintHintTextToAll("<font color='#00FF00' size='30'>SIMON SE ODPOJIL</font><br><font color='#FFFFFF' size='15'>Vsechny prikazy a zakazy se rusi</font>")
		if (start_futbal)
		{
		ServerCommand("ballendmatch2");

		PrintToChatAll("*\x09Fotbal byl preruseny");
		//PrintHintTextToAll("<font color='#00FF00' size='20'>SIMON SE ODPOJIL</font><br><font color='#FFFFFF' size='30'>FOTBAL JE ZRUSENY</font>")
		EmitSoundToAllAny("jbextreme/pisk_e1.mp3");
		start_futbal = 0

		hraci_a = 0
		hraci_b = 0
		new maximumplayers
		maximumplayers = GetMaxClients()
		for (new i=1; i<=maximumplayers; i++)
		{
			team_hraca[i] = 0

			if(!IsValidClient(i))
				continue

			if(!IsPlayerAlive(i))
				continue

			if (!IsClientInGame(i))
				continue;

			if (client == i)
				continue;

			if (hracsvd[i] == 1)
				continue;

			SetEntityRenderColor(i, 255, 255, 255, 255);
		}
		}

		ServerCommand("mp_tkpunish 0")
		ServerCommand("mp_autokick 0")
		ServerCommand("mp_disable_autokick 1")
		ServerCommand("mp_friendlyfire 0")

		boxmod = 0
		Warden = -1;
		mikrofon = 0
		new maximumplayers
		maximumplayers = GetMaxClients()
		for (new i=1; i<=maximumplayers; i++)
		{
			if(!IsValidClient(i))
			{
			continue
			}
			if(!IsPlayerAlive(i))
			{
			continue
			}
			menu_zrusene(i)
		}


	}

	hrac_dozorce[client] = 0
	hrac_vezen[client] = 0


	spocitej_hrace()

	if(duelant[client] == 1)
	{
		duel_lock = 0
	}
	duelant[client] = 0
	CreateTimer(0.1,duel_vykonaj)

}

public Action:RemoveWarden(client, args)
{
	if(Warden != -1) // Is there an warden at the moment ?
	{
		RemoveTheWarden(client);
	}
	else
	{

	}

	return Plugin_Handled; // Prevent sourcemod from typing "unknown command" in console
}
public Action:choddobrany(Handle: timer)
{
	new iEnt = -1;
	GetCurrentMap(mapname, 119)
	while((iEnt = FindEntityByClassname(iEnt, "*")) != -1)
	{
	//decl String:className[35];
	//GetEdictClassname(iEnt, className, sizeof(className));
	//PrintToChatAll("%s",className)
	new String:strModel[150];
	new String:modelname[128];
	GetEntPropString(iEnt, Prop_Data, "m_iName", strModel, sizeof(strModel));
	GetEntPropString(iEnt, Prop_Data, "m_ModelName", modelname, 128);
	//PrintToChatAll("%s %s",strModel,modelname)

	if(StrEqual(mapname,"jb_citrus_v2"))
	{
		if(StrEqual(strModel,"ball"))
		{
				RemoveEdict(iEnt)
		}
	}
	else if(StrEqual(mapname,"ba_jail_summer_go"))
	{
	new iEnt2 = -1
	iEnt2 = FindEntityByClassname(iEnt2, "func_physbox")
	if(iEnt2)
	RemoveEdict(iEnt2)
	}
	else if(StrEqual(mapname,"ba_jail_sand_csgo"))
	{
	if(StrEqual(strModel,"balon"))
	{
	RemoveEdict(iEnt)
	}
	}
	else if(StrEqual(mapname,"ba_jail_minecraftparty_v6"))
	{
	CreateTimer(0.1 , wtf)
	}
	else if(StrEqual(mapname,"jb_junglejail_v6"))
	{
		CreateTimer(0.1 , wtf)

	}
	else if(StrEqual(mapname,"ba_jail_electric_revamp_beta"))
	{
	CreateTimer(0.1 , wtf)
	}

	}
}
public Action: wtf(Handle: timer)
{
	new iEntE = -1;
	GetCurrentMap(mapname, 119)

	while((iEntE = FindEntityByClassname(iEntE, "*")) != -1)
	{
			new String:strModel[150];
			GetEntPropString(iEntE, Prop_Data, "m_iName", strModel, sizeof(strModel))
			if(StrEqual(mapname,"ba_jail_electric_revamp_beta"))
			{
				if(StrEqual(strModel,"foot_ball_end"))
				{
				DispatchKeyValue(iEntE, "disableshadows", "1");
				DispatchKeyValue(iEntE, "solid", "0");
				SetEntityMoveType(iEntE, MOVETYPE_NOCLIP);
				new Float:clientposition[3];
				clientposition[0]= 0.0
				clientposition[1]= 0.0
				clientposition[2] = 0.0
				TeleportEntity(iEntE, clientposition, NULL_VECTOR, NULL_VECTOR);
				}
			}
			if(StrEqual(strModel,"soccer_ball2"))
			{
			DispatchKeyValue(iEntE, "disableshadows", "1");
			DispatchKeyValue(iEntE, "solid", "0");
			SetEntityMoveType(iEntE, MOVETYPE_NOCLIP);
			new Float:clientposition[3];
			clientposition[0]= 0.0
			clientposition[1]= 0.0
			clientposition[2] = 0.0
			TeleportEntity(iEntE, clientposition, NULL_VECTOR, NULL_VECTOR);
			}
			if(StrEqual(strModel,"soccer"))
			{
			DispatchKeyValue(iEntE, "disableshadows", "1");
			DispatchKeyValue(iEntE, "solid", "0");
			SetEntityMoveType(iEntE, MOVETYPE_NOCLIP);
			new Float:clientposition[3];
			clientposition[0]= 0.0
			clientposition[1]= 0.0
			clientposition[2] = 0.0
			TeleportEntity(iEntE, clientposition, NULL_VECTOR, NULL_VECTOR);
		}
	}
}

public Action:HookPlayerChat(client, const String:command[], args)
{
		new String:szText[256];
		GetCmdArg(1, szText, sizeof(szText));
		if(StrEqual(szText,"/smenu"))
		{
			if(blokwarden !=1)
			{
			if(Warden == client)
			{
			DID(client);
			}
			}
			return Plugin_Handled
		}
		if(StrEqual(szText,"/simon"))
		{
			if(blokwarden !=1)
			{
				BecomeWarden(client, args);
				if(Warden == client)
				{
				DID(client);
				}
			}
			else
			{
			PrintToChat(client,"Nyni nelze vzit Simona!")
			}
			return Plugin_Handled

		}

		if(StrEqual(szText,"/shop"))
		{
		if(IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) == 2)
		Shop_menu(client)

		return Plugin_Handled
		}
		if(StrEqual(szText,"/tmenu"))
		{
		if(IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) == 2)
		Shop_menu(client)

		return Plugin_Handled
		}
		if(StrEqual(szText,"/ctshop"))
		{
		if(IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) == 3)
		Shop_menu_ct(client)

		return Plugin_Handled
		}

		if(StrEqual(szText,"/pp"))
		{
		if(mod != 1)
		{

		if(duel_lock == 0)
		{
			if(GetClientTeam(client) == 2)
			{
			spocitej_hrace()
			if(zive_ct > 0 && zive_t == 1)
			{
				duel_lock = 1
				prebieha_duel = 0
				blokwarden = 1;
				open_pp_menu(client)
				SetEntityHealth(client, 100);
				SetEntityGravity(client, 1.0)
				PrintToChatAll("Posledni vezen si muze vybrat posledni prani!")

			}
			}
			}
			}
		}

		/*if(StrEqual(szText,"/dej"))
		{
			GivePlayerItem(client, "weapon_m4a1");
			GivePlayerItem(client, "weapon_deagle");
			auto_open()
			return Plugin_Handled

		}*/

		if(StrEqual(szText,"/open"))
		{
			if(Warden == client)
			{
				if(opencell == 0)
				{
					cely_otvorene_mod_nejde = 1
					opencell = 1
					auto_open()
				}
				else
				{
					cely_otvorene_mod_nejde = 1
					opencell = 0
					close_cell()
				}
			}
			return Plugin_Handled
		}
		if(StrEqual(szText,"/close"))
		{
			if(Warden == client)
			{
				cely_otvorene_mod_nejde = 1
				close_cell()
			}
			return Plugin_Handled
		}
		if(StrEqual(szText,"/aopen"))
		{
			if (GetUserFlagBits(client) & ADMFLAG_BAN)
			{
				if(opencell == 0)
				{
					opencell = 1
					auto_open()
				}
				else
				{
					opencell = 0
					close_cell()
				}
			}
			return Plugin_Handled
		}
		if(StrEqual(szText,"/atopen"))
		{

			if (GetUserFlagBits(client) & ADMFLAG_BAN)
			{
			auto_open_name()
			}
			return Plugin_Handled

		}
		/*if(StrEqual(szText,"/aheal"))
		{

		new health = GetClientHealth(client);
		SetEntityHealth(client, health + 10);
		}*/
		/*if(StrEqual(szText,"/enti"))
		{
			if (GetUserFlagBits(client) & ADMFLAG_BAN)
			{
				new String:modelname[128];
				new iEntE = -1;
				GetCurrentMap(mapname, 119)

				while((iEntE = FindEntityByClassname(iEntE, "*")) != -1)
				{
						new String:strModel[150];
						GetEntPropString(iEntE, Prop_Data, "m_iName", strModel, sizeof(strModel));
						GetEntPropString(iEntE, Prop_Data, "m_ModelName", modelname, 128);
						//SetEntityRenderMode(iEntE , RENDER_NONE);

					//PrintToChatAll("%s /// %s",strModel, modelname)
			if(StrEqual(mapname,"ba_jail_electric_revamp_beta"))
			{

				if(StrEqual(strModel,"foot_ball_end"))
				{
				PrintToChatAll("jetu")
				RemoveEdict(iEntE)
				}
			}
				}
				}



		}	*/
		if(StrEqual(szText,"/amoney"))
		{
			if (GetUserFlagBits(client) & ADMFLAG_BAN)
			{
			SetClientMoney(client, 200);

			}
			return Plugin_Handled
		}

		if(StrEqual(szText,"/pravidla"))
		{

			decl String:itemsurl[128];
			Format(itemsurl, sizeof(itemsurl), "http://fastdownload.gamesites.cz/global/motd/pravidla_jb.html");
			ShowMOTDPanel(client, "Backpack", itemsurl, MOTDPANEL_TYPE_URL);

			return Plugin_Handled
		}
		if(StrEqual(szText,"/aaa"))
		{
			if (GetUserFlagBits(client) & ADMFLAG_BAN)
			{
			decl String:itemsurl[128];
			Format(itemsurl, sizeof(itemsurl), "http://tradua.cz/test");
			ShowMOTDPanel(client, "Backpack", itemsurl, MOTDPANEL_TYPE_URL);
			}
			return Plugin_Handled
		}

		return Plugin_Continue;
}
public SetTheWarden(client)
{
	Warden = client;

	SetEntityRenderColor(client, 0, 255, 0, 255);
	//SetClientListeningFlags(client, VOICE_NORMAL);
	Forward_OnWardenCreation(client);
	DID(client);
}

public RemoveTheWarden(client)
{

	if(GetConVarBool(g_cVar_mnotes))
	{

	}
	SetEntityRenderColor(Warden, 255, 255, 255, 255);
	Warden = -1;

	Forward_OnWardenRemoved(client);
}

public Native_ExistWarden(Handle:plugin, numParams)
{
	if(Warden != -1)
		return true;

	return false;
}

public Native_IsWarden(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);

	if(!IsClientInGame(client) && !IsClientConnected(client))
		ThrowNativeError(SP_ERROR_INDEX, "Client index %i is invalid", client);

	if(client == Warden)
		return true;

	return false;
}

public Native_SetWarden(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);

	if (!IsClientInGame(client) && !IsClientConnected(client))
		ThrowNativeError(SP_ERROR_INDEX, "Client index %i is invalid", client);

	if(Warden == -1)
	{
		SetTheWarden(client);

	}
}

public Native_RemoveWarden(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);

	if (!IsClientInGame(client) && !IsClientConnected(client))
		ThrowNativeError(SP_ERROR_INDEX, "Client index %i is invalid", client);

	if(client == Warden)
	{
		RemoveTheWarden(client);
	}
}

public Forward_OnWardenCreation(client)
{
	Call_StartForward(g_fward_onBecome);
	Call_PushCell(client);
	Call_Finish();
}

public Forward_OnWardenRemoved(client)
{
	Call_StartForward(g_fward_onRemove);
	Call_PushCell(client);
	Call_Finish();
}
public Action:DID(clientId)
{
	if(clientId == Warden)
	{
		new Handle:menu = CreateMenu(DIDMenuHandler);
		SetMenuTitle(menu, "Simon Menu");
		AddMenuItem(menu, "option2", "Vybrat Zbran");
		if(opencell == 0)
		{
			AddMenuItem(menu, "option3", "Otevrit cely");
		}
		else
		{
			AddMenuItem(menu, "option3", "Zavrit cely")
		}
		AddMenuItem(menu, "option4", "Dat Freeday");
		AddMenuItem(menu, "option5", "Herni Mody");
		AddMenuItem(menu, "option6", "Ostatni");
		SetMenuExitButton(menu, true);
		DisplayMenu(menu, clientId, 120);
	}
	return Plugin_Handled;
}
public DIDMenuHandler(Handle:menu, MenuAction:action, client, itemNum)
{
	if(client == Warden)
	{
		if ( action == MenuAction_Select )
		{
			new String:info[32]; GetMenuItem(menu, itemNum, info, sizeof(info));
			if ( strcmp(info,"option2") == 0 )
			{
				DID_vyber_zbran(client)

			}
			if ( strcmp(info,"option3") == 0 )
			{
				if(opencell == 0)
				{
					cely_otvorene_mod_nejde = 1
					opencell = 1
					auto_open()
				}
				else
				{
					cely_otvorene_mod_nejde = 1
					opencell = 0
					close_cell()
				}
				DID(client);
			}
			if ( strcmp(info,"option4") == 0 )
			{
				udel_vd(client);
			}
			if ( strcmp(info,"option5") == 0 )
			{
				DID_hernimod(client)
			}
			if ( strcmp(info,"option6") == 0 )
			{
				ostatni_menu(client)

			}


		}
	}

}
public Action:DID_vyber_zbran(clientId)
{

	if(clientId == Warden)
	{
    new Handle:menu = CreateMenu(DIDMenuHandler_vyber_zbran);

    SetMenuTitle(menu, "Simon Menu - /smenu");
    AddMenuItem(menu, "option2", "M4A1");
    AddMenuItem(menu, "option3", "AK47");
    AddMenuItem(menu, "option4", "UMP45");
    AddMenuItem(menu, "option5", "AWP");
    AddMenuItem(menu, "option6", "Zpet");


//AddMenuItem(menu, "option1", "[KS] About Knife Shop");
    SetMenuExitButton(menu, true);
    DisplayMenu(menu, clientId, 120);
	}
	return Plugin_Handled;
}
public DIDMenuHandler_vyber_zbran(Handle:menu, MenuAction:action, client, itemNum)
{
	if(client == Warden)
	{
		if ( action == MenuAction_Select )
		{
			new String:info[32];
			GetMenuItem(menu, itemNum, info, sizeof(info));
			if ( strcmp(info,"option2") == 0 )
			{
				if(simon_gun[client] == 0)
				{
				strip_user_weapons(client)

				GivePlayerItem(client, "weapon_m4a1");
				GivePlayerItem(client, "weapon_deagle");
				new knife = GivePlayerItem(client,"weapon_knife")
				EquipPlayerWeapon(client, knife);
				DID(client);
				simon_gun[client] = 1
				}
				else
				{
					DID(client);
					PrintToChat(client, "Dalsi vyber zbrani neni mozny!")
				}

			}
			if ( strcmp(info,"option3") == 0 )
			{

				if(simon_gun[client] == 0)
				{
				strip_user_weapons(client)


				GivePlayerItem(client, "weapon_ak47");
				GivePlayerItem(client, "weapon_deagle");
				new knife = GivePlayerItem(client,"weapon_knife")
				EquipPlayerWeapon(client, knife);
				DID(client);
				simon_gun[client] = 1
				}
				else
				{
					DID(client);
					PrintToChat(client, "Dalsi vyber zbrani neni mozny!")
				}
			}
			if ( strcmp(info,"option4") == 0 )
			{

			if(simon_gun[client] == 0)
				{
				strip_user_weapons(client)



				GivePlayerItem(client, "weapon_ump45");
				GivePlayerItem(client, "weapon_deagle");
				new knife = GivePlayerItem(client,"weapon_knife")
				EquipPlayerWeapon(client, knife);
				DID(client);
				simon_gun[client] = 1
				}
				else
				{
					DID(client);
					PrintToChat(client, "Dalsi vyber zbrani neni mozny!")
				}
			}
			if ( strcmp(info,"option5") == 0 )
			{

				if(simon_gun[client] == 0)
				{
				strip_user_weapons(client)



				GivePlayerItem(client, "weapon_awp");
				GivePlayerItem(client, "weapon_deagle");
				new knife = GivePlayerItem(client,"weapon_knife")
				EquipPlayerWeapon(client, knife);
				DID(client);
				simon_gun[client] = 1
				}
				else
				{
					DID(client);
					PrintToChat(client, "Dalsi vyber zbrani neni mozny!")
				}
			}
			if ( strcmp(info,"option6") == 0 )
			{

			DID(client);
			}


	}
	}

}

public spust_menu_simona(client)
{
	PrintHintTextToAll("<font color='#FFFFFF' size='20'>%s</font><br><font color='#00FF00' size='30'>JE NYNI SIMON</font>", named)

	DID(client)

	PrintToChatAll("*\x09%s je simon! Vsichni poslouchaji!", named)
	PrintToChatAll("*\x09%s je simon! Vsichni poslouchaji!", named)
	PrintToChatAll("*\x09%s je simon! Vsichni poslouchaji!", named)
	PrintToChatAll("*\x09%s je simon! Vsichni poslouchaji!", named)

}
public Action:CMD_OPEN(client)
{
if(GetClientTeam(client) != 3 || !IsPlayerAlive(client))
{

return Plugin_Handled;
}
new iEnt = -1;
for(new i; i < sizeof(Entities); i++)
{
while((iEnt = FindEntityByClassname(iEnt, Entities[i])) != -1)
{
AcceptEntityInput(iEnt, Open? "Close":"Open");
}
}
return Plugin_Handled;
}

public Action:udel_vd(client)
{
	new Handle:menu = CreateMenu(MenuHandlerswad)
	SetMenuTitle(menu, "Vyber hrace kteremu das VD")
	new maximumplayers
	maximumplayers = GetMaxClients()
	for (new i=1; i<=maximumplayers; i++)
		{
			if(!IsValidClient(i))
			{
			continue
			}
			if(!IsPlayerAlive(i))
			{
			continue
			}
			if (!IsClientInGame(i))
			{
				continue;
			}
			if(GetClientTeam(i) == 3)
			{
				continue;
			}
			decl String:name[65];
			GetClientName(i, name, sizeof(name));
			AddMenuItem(menu, name, name)
		}
	SetMenuExitButton(menu, true)
	DisplayMenu(menu, client, 20)

	return Plugin_Handled
}
public MenuHandlerswad(Handle:menu, MenuAction:action, param1, param2)
{
	if(param1 == Warden)
	{
	new target = -1
	/* Either Select or Cancel will ALWAYS be sent! */
	if (action == MenuAction_Select)
	{
	new String:info[64]
	GetMenuItem(menu, param2, info, sizeof(info))
	new maximumplayers
	maximumplayers = GetMaxClients()
	for (new i=1; i<=maximumplayers; i++)
	{
		if(!IsValidClient(i))
		{
		continue
		}
		if(!IsPlayerAlive(i))
		{
		continue
		}
		if (!IsClientConnected(i))
		{
			continue
		}
		decl String:other[64]
		GetClientName(i, other, sizeof(other))
		if (StrEqual(info, other))
		{
			target = i
		}
	}
	decl String:other2[64]
	GetClientName(target, other2, sizeof(other2))
 	PrintToChatAll("*\x09%s dostal volny den a nemusi poslouchat simona",other2)
	SetEntityRenderColor(target, 255, 255, 0, 255);
	hrac_vd[target] = CreateTimer(VD_TIMER, zrus_vd, target)
	DID(param1)
	hracsvd[target] = 1

	}
	}

}
public Action:zrus_vd(Handle: timer, any: client)
{
	hrac_vd[client] = INVALID_HANDLE
	hracsvd[client] = 0
	decl String:other[64]
	GetClientName(client,other, sizeof(other))
	PrintToChatAll("%s uz nema volny den a musi poslouchat simona",other)
	PrintCenterText(client,"Pozor! skoncil ti volny den!")
	SetEntityRenderColor(client, 255, 255, 255, 255);
}
public Action:ostatni_menu(clientId)
{
	if(clientId == Warden)
	{
		new Handle:menu = CreateMenu(DIDMenuHandler_ostatni);
		SetMenuTitle(menu, "Simon Menu /smenu");
		AddMenuItem(menu, "option2", "Priklady");
		AddMenuItem(menu, "option3", "Kostka");
		AddMenuItem(menu, "option4", "Gravitace");
		if(stopky == 0)
		AddMenuItem(menu, "option5", "Stopky [vypnuto]");
		else
		AddMenuItem(menu, "option5", "Stopky [zapnuto]");
		if(mikrofon == 0)
		AddMenuItem(menu, "option6", "Mikrofon [vypnuto]");
		else
		AddMenuItem(menu, "option6", "Mikrofon [zapnuto]");
		AddMenuItem(menu, "option7", "Zpet");
		SetMenuExitButton(menu, true);
		DisplayMenu(menu, clientId, 120);
	}
	return Plugin_Handled;
}
public DIDMenuHandler_ostatni(Handle:menu, MenuAction:action, client, itemNum)
{
	if(client == Warden)
	{
    if ( action == MenuAction_Select )
    {
        new String:info[32];

        GetMenuItem(menu, itemNum, info, sizeof(info)); if ( strcmp(info,"option2") == 0 )
        {
			priklady_menu(client)

        } if ( strcmp(info,"option3") == 0 )
        {
			kocka_menu(client)
        } if ( strcmp(info,"option4") == 0 )
        {
			gravity_menu(client)
        } if ( strcmp(info,"option5") == 0 )
        {
			EmitSoundToAllAny("jbextreme/gong.mp3");

			if(stopky == 0)
			{
			stopky_hodnota = 0
			stopky2 = 1
			stopky_funkce(client)
			stopky = 1
			}
			else
			{
			stopky = 0
			stopky2 = 0
			stopky_funkce_vypis(client)
			}
			ostatni_menu(client)

        } if ( strcmp(info,"option6") == 0 )
        {
			ostatni_menu(client)

			if(mikrofon == 0)
			{
				PrintHintTextToAll("<font color='#00FF00' size='20'>SIMON UPRAVIL NASTAVENI</font><br><font color='#FFFFFF' size='30'>MIKROFONY ZAPNUTY</font>")
				mikrofon = 1
				new maximumplayers
				maximumplayers = GetMaxClients()
				for (new idx = 1; idx <= maximumplayers; idx++)
				{
				if(!IsValidClient(idx))
				{
				continue
				}
				if(!IsPlayerAlive(idx))
				{
				continue
				}
				spusti_mikrofon(idx)
				}



			}
			else
			{
				PrintHintTextToAll("<font color='#00FF00' size='20'>SIMON UPRAVIL NASTAVENI</font><br><font color='#FFFFFF' size='30'>MIKROFONY VYPNUTY</font>")
				mikrofon = 0
				new maximumplayers
				maximumplayers = GetMaxClients()
				for (new idx = 1; idx <= maximumplayers; idx++)
				{
					if(!IsValidClient(idx))
					{
					continue
					}
					if(!IsPlayerAlive(idx))
					{
					continue
					}
					if(IsClientInGame(idx)  && GetClientTeam(idx) != 2)
					continue
					vypni_mikrofon(idx)


				}



			}


        } if ( strcmp(info,"option7") == 0 )
        {
			DID(client);
        }



	}
	}

}
public Action:spusti_mikrofon(client)
{

	if(IsClientInGame(client)  && GetClientTeam(client) == 2)
	{
		SetClientListeningFlags(client, VOICE_SPEAKALL);
		/*for (new idx = 1; idx <= maxplayers; idx++)
		{
			if(idx == client)
				continue
			SetListenOverride(idx, client, Listen_Yes);
			SetClientListeningFlags(idx, VOICE_SPEAKALL);
			SetClientListeningFlags(idx, VOICE_LISTENALL);
		}	*/


	}

}
public Action:vypni_mikrofon(client)
{

	if(IsClientInGame(client)  && GetClientTeam(client) == 2)
	{
		if (GetUserFlagBits(client) & ADMFLAG_KICK)
		{
		SetClientListeningFlags(client, VOICE_SPEAKALL);
		}
		else
		SetClientListeningFlags(client, VOICE_MUTED);
		/*for (new idx = 1; idx <= maxplayers; idx++)
		{
			if(idx == client)
				continue
			SetListenOverride(idx, client, Listen_No);
			SetClientListeningFlags(idx, VOICE_MUTED);
			SetClientListeningFlags(idx, VOICE_LISTENALL);
		}*/


	}
}
public Action:stopky_funkce_vypis(client)
{
	if(client == Warden)
	{
	PrintHintTextToAll("<font color='#00FF00' size='20'>SIMON VYPNUL STOPKY</font><br><font color='#FFFFFF' size='30'>CAS: %d</font>", stopky_hodnota)
	PrintToChatAll("Cas: %d", stopky_hodnota)
	}
	stopky_hodnota = 0


}
public Action:stopky_funkce(client)
{
	if(client == Warden)
	{
		if(stopky2 == 1)
		{
		stopky_hodnota++
		CreateTimer(0.1,stopky_funkce2,client)
		}
		else
		{
		PrintHintTextToAll("<font color='#00FF00' size='20'>SIMON VYPNUL STOPKY</font><br><font color='#FFFFFF' size='30'>CAS: %d</font>", stopky_hodnota)
		PrintToChatAll("Cas: %d", stopky_hodnota)
		}
	}

}
public Action:stopky_funkce2(Handle: timer, any: client)
{
	if(client == Warden)
	{
		if(stopky2 == 1)
		{
		PrintHintTextToAll("<font color='#00FF00' size='20'>SIMON ZAPNUL STOPKY</font><br><font color='#FFFFFF' size='30'>CAS: %d</font>", stopky_hodnota)
		stopky_hodnota++
		CreateTimer(0.1,stopky_funkce2,client)
		}
	}
}
public Action:priklady_menu(clientId)
{
	if(clientId == Warden)
	{
		new Handle:menu = CreateMenu(DIDMenuHandler_priklady);
		SetMenuTitle(menu, "Simon Menu /smenu");
		AddMenuItem(menu, "option2", "Scitani");
		AddMenuItem(menu, "option3", "Odcitani");
		AddMenuItem(menu, "option4", "Nasobeni");
		AddMenuItem(menu, "option5", "Deleni");
		AddMenuItem(menu, "option6", "Zpet");
		SetMenuExitButton(menu, true);
		DisplayMenu(menu, clientId, 120);
	}
	return Plugin_Handled;
}
public DIDMenuHandler_priklady(Handle:menu, MenuAction:action, client, itemNum)
{
	if(client == Warden)
	{
		if ( action == MenuAction_Select )
		{
			new String:info[32];
			new priklad1 = GetRandomInt(0 , 70), priklad2 = GetRandomInt(0 , 70), priklad3 = GetRandomInt(1 , 15), priklad4 = GetRandomInt(1 , 15);
			new vysledok1, vysledok2;
			GetMenuItem(menu, itemNum, info, sizeof(info));
			if ( strcmp(info,"option2") == 0 )
			{
				vysledok1 = priklad1 + priklad2;
				PrintToChatAll( "*\x09[Priklady] Kolik je %d + %d",priklad1,priklad2);
				PrintHintTextToAll("<font color='#00FF00' size='20'>SIMON SE PTA KOLIK JE</font><br><font color='#FFFFFF' size='30'>%d + %d</font>",priklad1,priklad2)
				PrintToChat(client,"Skryta odpoved - Vysledek prikladu je: %d",vysledok1)
				priklady_menu(client)
			}
			if ( strcmp(info,"option3") == 0 )
			{
				vysledok1 = priklad1 - priklad2;
				PrintToChatAll( "*\x09[Priklady] Kolik je %d - %d",priklad1,priklad2);
				PrintHintTextToAll("<font color='#00FF00' size='20'>SIMON SE PTA KOLIK JE</font><br><font color='#FFFFFF' size='30'>%d - %d</font>",priklad1,priklad2)
				PrintToChat(client,"Skryta odpoved - Vysledek prikladu je: %d",vysledok1)
				priklady_menu(client)
			}
			if ( strcmp(info,"option4") == 0 )
			{
				vysledok2 = priklad3 * priklad4;
				PrintToChatAll( "*\x09[Priklady] Kolik je %d * %d",priklad3,priklad4);
				PrintHintTextToAll("<font color='#00FF00' size='20'>SIMON SE PTA KOLIK JE</font><br><font color='#FFFFFF' size='30'>%d * %d</font>",priklad3,priklad4)
				PrintToChat(client,"Skryta odpoved - Vysledek prikladu je: %d",vysledok2)
				priklady_menu(client);
			}
			if ( strcmp(info,"option5") == 0 )
			{
				vysledok1 = priklad3 * priklad4;
				vysledok2 = vysledok1 / priklad3
				PrintToChatAll( "*\x09[Priklady] Kolik je %d / %d",vysledok1,priklad3);
				PrintHintTextToAll("<font color='#00FF00' size='20'>SIMON SE PTA KOLIK JE</font><br><font color='#FFFFFF' size='30'>%d / %d</font>",vysledok1,priklad3)
				PrintToChat(client,"Skryta odpoved - Vysledek prikladu je: %d",vysledok2)
				priklady_menu(client)
			}
			if ( strcmp(info,"option6") == 0 )
			{
				ostatni_menu(client)
			}
		}
	}

}
public Action:kocka_menu(clientId)
{
	if(clientId == Warden)
	{
		new Handle:menu = CreateMenu(DIDMenuHandler_kocka);
		SetMenuTitle(menu, "Simon Menu /smenu");
		AddMenuItem(menu, "option2", "Kostka 6 cisel");
		AddMenuItem(menu, "option3", "Kostka 12 cisel");
		AddMenuItem(menu, "option4", "Kostka 24 cisel");
		AddMenuItem(menu, "option5", "Kostka 32 cisel");
		AddMenuItem(menu, "option6", "Kostka 64 cisel");
		AddMenuItem(menu, "option7", "Zpet");
		SetMenuExitButton(menu, true);
		DisplayMenu(menu, clientId, 120);
	}
	return Plugin_Handled;
}
public DIDMenuHandler_kocka(Handle:menu, MenuAction:action, client, itemNum)
{
	if(client == Warden)
	{
		if ( action == MenuAction_Select )
		{
			new String:info[32];

			GetMenuItem(menu, itemNum, info, sizeof(info));
			if ( strcmp(info,"option2") == 0 )
			{
				new random = GetRandomInt(1 , 6)
				PrintToChatAll( "*\x09[Kostka] Pri hode kostkou 6 padlo cislo: %d",random);
				PrintHintTextToAll("<font color='#00FF00' size='20'>SIMON HODIL KOSTKOU 6</font><br><font color='#FFFFFF' size='30'>PADLO CISLO: %d</font>",random)
				kocka_menu(client)
			}
			if ( strcmp(info,"option3") == 0 )
			{
				new random = GetRandomInt(1 , 12)
				PrintToChatAll( "*\x09[Kostka] Pri hode kostkou 12 padlo cislo: %d",random);
				PrintHintTextToAll("<font color='#00FF00' size='20'>SIMON HODIL KOSTKOU 12</font><br><font color='#FFFFFF' size='30'>PADLO CISLO: %d</font>",random)
				kocka_menu(client)
			}
			if ( strcmp(info,"option4") == 0 )
			{
				new random = GetRandomInt(1 , 24)
				PrintToChatAll( "*\x09[Kostka] Pri hode kostkou 24 padlo cislo: %d",random);
				PrintHintTextToAll("<font color='#00FF00' size='20'>SIMON HODIL KOSTKOU 24</font><br><font color='#FFFFFF' size='30'>PADLO CISLO: %d</font>",random)
				kocka_menu(client)
			}
			if ( strcmp(info,"option5") == 0 )
			{
				new random = GetRandomInt(1 , 32)
				PrintToChatAll( "*\x09[Kostka] Pri hode kostkou 32 padlo cislo: %d",random);
				PrintHintTextToAll("<font color='#00FF00' size='20'>SIMON HODIL KOSTKOU 32</font><br><font color='#FFFFFF' size='30'>PADLO CISLO: %d</font>",random)
				kocka_menu(client)
			}
			if ( strcmp(info,"option6") == 0 )
			{
				new random = GetRandomInt(1 , 64)
				PrintToChatAll( "*\x09[Kostka] Pri hode kostkou 64 padlo cislo: %d",random);
				PrintHintTextToAll("<font color='#00FF00' size='20'>SIMON HODIL KOSTKOU 64</font><br><font color='#FFFFFF' size='30'>PADLO CISLO: %d</font>",random)
				kocka_menu(client)
			}
			if ( strcmp(info,"option7") == 0 )
			{
				ostatni_menu(client)
			}
		}
	}

}
public Action:gravity_menu(clientId)
{
	if(clientId == Warden)
	{
		new Handle:menu = CreateMenu(DIDMenuHandler_gravity);
		SetMenuTitle(menu, "Simon Menu /smenu");
		AddMenuItem(menu, "option2", "Mirna gravitace");
		AddMenuItem(menu, "option3", "Stredni gravitace");
		AddMenuItem(menu, "option4", "Velka gravitace");
		AddMenuItem(menu, "option5", "Normalni gravitace");
		AddMenuItem(menu, "option6", "Zpet");
		SetMenuExitButton(menu, true);
		DisplayMenu(menu, clientId, 120);
	}
	return Plugin_Handled;
}
public DIDMenuHandler_gravity(Handle:menu, MenuAction:action, client, itemNum)
{
	if(client == Warden)
	{
		if ( action == MenuAction_Select )
		{
			new String:info[32];
			new maximumplayers
			maximumplayers = GetMaxClients()
			GetMenuItem(menu, itemNum, info, sizeof(info));
			if ( strcmp(info,"option2") == 0 )
			{

				for (new i=1; i<=maximumplayers; i++)
				{
					if(!IsValidClient(i))
					{
					continue
					}
					if(!IsPlayerAlive(i))
					{
					continue
					}
					if (!IsClientConnected(i))
					{
					continue
					}
					if(GetClientTeam(i) == 3)
					{
					continue
					}

					gravitace = 0.2
					SetEntityGravity(i, gravitace)
				}
				gravity_menu(client)
			}
			if ( strcmp(info,"option3") == 0 )
			{
				for (new i=1; i<=maximumplayers; i++)
				{
					if(!IsValidClient(i))
					{
					continue
					}
					if(!IsPlayerAlive(i))
					{
					continue
					}
					if (!IsClientConnected(i))
					{
					continue
					}
					if(GetClientTeam(i) == 3)
					{
					continue
					}
					gravitace = 0.4
					SetEntityGravity(i, gravitace)
				}
				gravity_menu(client)
			}
			if ( strcmp(info,"option4") == 0 )
			{
				for (new i=1; i<=maximumplayers; i++)
				{
					if(!IsValidClient(i))
					{
					continue
					}
					if(!IsPlayerAlive(i))
					{
					continue
					}
					if (!IsClientConnected(i))
					{
					continue
					}
					if(GetClientTeam(i) == 3)
					{
					continue
					}
					gravitace = 0.6
					SetEntityGravity(i, gravitace)
				}
				gravity_menu(client)
			}
			if ( strcmp(info,"option5") == 0 )
			{
				for (new i=1; i<=maximumplayers; i++)
				{
					if(!IsValidClient(i))
					{
					continue
					}
					if(!IsPlayerAlive(i))
					{
					continue
					}
					if (!IsClientConnected(i))
					{
					continue
					}
					if(GetClientTeam(i) == 3)
					{
					continue
					}
					gravitace = 1.0
					SetEntityGravity(i, gravitace)
				}
				gravity_menu(client)
			}
			if ( strcmp(info,"option6") == 0 )
			{
				ostatni_menu(client)
			}
		}
	}

}
public Action:DID_hernimod(clientId)
{
	if (koneckola)
		return Plugin_Continue

	if(clientId == Warden)
	{
	new Handle:menu = CreateMenu(DIDMenuHandler_hernimod);

	SetMenuTitle(menu, "Simon Menu");
	AddMenuItem(menu, "option2", "Prestrelka mod");
	AddMenuItem(menu, "option3", "Matrix mod");
	AddMenuItem(menu, "option4", "Zombie mod");
	AddMenuItem(menu, "option5", "Fotbal mod");
	AddMenuItem(menu, "option6", "Boxovaci mod");
	AddMenuItem(menu, "option7", "Zpet");

	SetMenuExitButton(menu, true);
	DisplayMenu(menu, clientId, 120);
	}
	return Plugin_Handled;
}
public DIDMenuHandler_hernimod(Handle:menu, MenuAction:action, client, itemNum)
{
	if(client == Warden)
	{
		if ( action == MenuAction_Select )
		{
			new String:info[32]; GetMenuItem(menu, itemNum, info, sizeof(info));
			if ( strcmp(info,"option2") == 0 )
			{
				if(cely_otvorene_mod_nejde == 0 && vzbura == 0)
				{
					DID_prestelka(client)
				}
				else
				{
					PrintToChat(client, "Nini nelze dat mod")
					DID(client)
				}

			}
			if ( strcmp(info,"option3") == 0 )
			{
				if(cely_otvorene_mod_nejde == 0 && vzbura == 0)
				{
				matrix_mod(client)
				forceendround = CreateTimer(240.0, ForceGameEnd)
				//ServerCommand("mp_roundtime 4")
				}
				else
				{
					PrintToChat(client, "Nini nelze dat mod")
					DID(client)
				}
			}
			if ( strcmp(info,"option4") == 0 )
			{
				if(cely_otvorene_mod_nejde == 0 && vzbura == 0)
				{
				zombie_mod(client)
				forceendround = CreateTimer(240.0, ForceGameEnd)
				//ServerCommand("mp_roundtime 4")
				}
				else
				{
					PrintToChat(client, "Nini nelze dat mod")
					DID(client)
				}
			}
			if ( strcmp(info,"option5") == 0 )
			{
				DID_futbal(client)
			}
			if ( strcmp(info,"option6") == 0 )
			{
				DID_boxom(client);
			}
			if ( strcmp(info,"option7") == 0 )
			{
				DID(client);
			}
		}
	}

}
public Action:DID_futbal(clientId)
{
	if (koneckola)
			return Plugin_Continue

	if(clientId == Warden)
	{
		new Handle:menu = CreateMenu(DIDMenuHandler_futbal);
		SetMenuTitle(menu, "Simon Menu - /smenu");
		AddMenuItem(menu, "option2", "Vyber team A");
		AddMenuItem(menu, "option3", "Vyber team B");

		if(start_futbal == 0)
		{
		AddMenuItem(menu, "option4", "Zacit zapas");
		}
		else
		{
		AddMenuItem(menu, "option4", "Ukoncit zapas");
		}

		AddMenuItem(menu, "option5", "Respawn mice");
		AddMenuItem(menu, "option6", "Zpet");
		SetMenuExitButton(menu, true);
		DisplayMenu(menu, clientId, 120);
	}
	return Plugin_Handled;
}
public DIDMenuHandler_futbal(Handle:menu, MenuAction:action, client, itemNum)
{
	if(client == Warden)
	{
		if ( action == MenuAction_Select )
		{
			new maximumplayers
			maximumplayers = GetMaxClients()
			new String:info[32]; GetMenuItem(menu, itemNum, info, sizeof(info));
			if ( strcmp(info,"option2") == 0 )
			{
				vyber_teamA(client)
			}
			if ( strcmp(info,"option3") == 0 )
			{
				vyber_teamB(client)
			}
			if ( strcmp(info,"option4") == 0 )
			{
				if (hraci_a == 0 || hraci_b == 0)
				{
				PrintToChat(client, "Musis vybrat Teamy!");
				PrintHintText(client,"Musis vybrat Teamy!")
				DID_futbal(client);
				return
				}

				if(start_futbal == 0)
				{
				PrintToChatAll("*\x09Simon spustil fotbal");
				PrintHintTextToAll("<font color='#00FF00' size='20'>SIMON VYTVORIL TEAMY</font><br><font color='#FFFFFF' size='30'>FOTBAL JE SPUSTENY</font>")
				EmitSoundToAllAny("jbextreme/pisk2.mp3");
				start_futbal = 1
				FakeClientCommand(client, "ballstartmatch");
				DID_futbal(client);
				}
				else
				{
				PrintToChatAll("*\x09Simon ukoncil fotbal");
				PrintHintTextToAll("<font color='#00FF00' size='20'>SIMON ZRUSIL TEAMY</font><br><font color='#FFFFFF' size='30'>FOTBAL JE ZRUSENY</font>")
				EmitSoundToAllAny("jbextreme/pisk_e1.mp3");
				start_futbal = 0
				FakeClientCommand(client, "ballendmatch");
				hraci_a = 0
				hraci_b = 0
				DID_futbal(client);

				for (new i=1; i<=maximumplayers; i++)
				{
				team_hraca[i] = 0
				if(!IsValidClient(i))
				{
				continue
				}
				if(!IsPlayerAlive(i))
				{
				continue
				}
				if (!IsClientInGame(i))
				{
				continue;
				}
				if (client == i)
				{
				continue;
				}
				if (hracsvd[i] == 1)
				{
				continue;
				}
				SetEntityRenderColor(i, 255, 255, 255, 255);
				}
				}

			}
			if ( strcmp(info,"option5") == 0 )
			{
				DID_futbal(client);
				FakeClientCommand(client, "ballrespawnsimon");
			}
			if ( strcmp(info,"option6") == 0 )
			{
				DID(client);
			}


		}
	}

}
public Action:vyber_teamA(client)
{
	new Handle:menu = CreateMenu(MenuHandlers_vyber_teamA)
	SetMenuTitle(menu, "Vyber hrace do teamu A")
	new maximumplayers
	maximumplayers = GetMaxClients()
	for (new i=1; i<=maximumplayers; i++)
		{
			if(!IsValidClient(i))
			{
			continue
			}
			if(!IsPlayerAlive(i))
			{
			continue
			}
			if (!IsClientInGame(i))
			{
				continue;
			}
			if(GetClientTeam(i) == 3)
			{
				continue;
			}
			decl String:itemtext2[256];
			decl String:name[65];
			GetClientName(i, name, sizeof(name));
			if(team_hraca[i] == 0)
			{
			Format(itemtext2, sizeof(itemtext2), "[nic] %s",name)
			}
			if(team_hraca[i] == 1)
			{
			Format(itemtext2, sizeof(itemtext2), "[A] %s",name)
			}
			if(team_hraca[i] == 2)
			{
			Format(itemtext2, sizeof(itemtext2), "[B] %s",name)
			}

			AddMenuItem(menu, name, itemtext2)
		}
	SetMenuExitButton(menu, true)
	DisplayMenu(menu, client, 20)

	return Plugin_Handled
}
public MenuHandlers_vyber_teamA(Handle:menu, MenuAction:action, param1, param2)
{
	if(param1 == Warden)
	{
	new target = -1
	/* Either Select or Cancel will ALWAYS be sent! */
	if (action == MenuAction_Select)
	{
	new String:info[64]
	GetMenuItem(menu, param2, info, sizeof(info))
	new maximumplayers
	maximumplayers = GetMaxClients()
	for (new i=1; i<=maximumplayers; i++)
	{
		if(!IsValidClient(i))
		{
		continue
		}
		if(!IsPlayerAlive(i))
		{
		continue
		}
		if (!IsClientConnected(i))
		{
			continue
		}
		decl String:other[64]
		GetClientName(i, other, sizeof(other))
		if (StrEqual(info, other))
		{
			target = i
		}
	}
	decl String:other2[64]
	GetClientName(target, other2, sizeof(other2))
 	PrintCenterText(target,"Byl jsi priradeny do teamu A")
	SetEntityRenderColor(target, 0, 255, 255, 255);
	team_hraca[target] = 1
	hraci_a++
	DID_futbal(param1)
	}
	}

}public Action:vyber_teamB(client)
{
	new Handle:menu = CreateMenu(MenuHandlers_vyber_teamB)
	SetMenuTitle(menu, "Vyber hrace do teamu B")
	new maximumplayers
	maximumplayers = GetMaxClients()
	for (new i=1; i<=maximumplayers; i++)
		{
			if(!IsValidClient(i))
			{
			continue
			}
			if(!IsPlayerAlive(i))
			{
			continue
			}
			if (!IsClientInGame(i))
			{
				continue;
			}
			if(GetClientTeam(i) == 3)
			{
				continue;
			}
			decl String:itemtext2[256];
			decl String:name[65];
			GetClientName(i, name, sizeof(name));
			if(team_hraca[i] == 0)
			{
			Format(itemtext2, sizeof(itemtext2), "[nic] %s",name)
			}
			if(team_hraca[i] == 1)
			{
			Format(itemtext2, sizeof(itemtext2), "[A] %s",name)
			}
			if(team_hraca[i] == 2)
			{
			Format(itemtext2, sizeof(itemtext2), "[B] %s",name)
			}

			AddMenuItem(menu, name, itemtext2)
		}
	SetMenuExitButton(menu, true)
	DisplayMenu(menu, client, 20)

	return Plugin_Handled
}
public MenuHandlers_vyber_teamB(Handle:menu, MenuAction:action, param1, param2)
{
	if(param1 == Warden)
	{
	new target = -1
	/* Either Select or Cancel will ALWAYS be sent! */
	if (action == MenuAction_Select)
	{
	new String:info[64]
	GetMenuItem(menu, param2, info, sizeof(info))
	new maximumplayers
	maximumplayers = GetMaxClients()
	for (new i=1; i<=maximumplayers; i++)
	{
		if(!IsValidClient(i))
		{
		continue
		}
		if(!IsPlayerAlive(i))
		{
		continue
		}
		if (!IsClientConnected(i))
		{
			continue
		}
		decl String:other[64]
		GetClientName(i, other, sizeof(other))
		if (StrEqual(info, other))
		{
			target = i
		}
	}
	decl String:other2[64]
	GetClientName(target, other2, sizeof(other2))
 	PrintCenterText(target,"Byl jsi prirazeny do teamu B")
	SetEntityRenderColor(target, 255, 0, 255, 255);
	team_hraca[target] = 2
	hraci_b++
	DID_futbal(param1)

	}
	}

}
public Action:DID_prestelka(clientId)
{
	if (koneckola)
		return Plugin_Continue

	if(clientId == Warden)
	{
    new Handle:menu = CreateMenu(DIDMenuHandler_prestrelka);

    SetMenuTitle(menu, "Simon Menu");
    AddMenuItem(menu, "option2", "Nahodna zbran");
    AddMenuItem(menu, "option3", "M4A1");
    AddMenuItem(menu, "option4", "AK47");
    AddMenuItem(menu, "option5", "Scout");
    AddMenuItem(menu, "option6", "Zpet");


	//AddMenuItem(menu, "option1", "[KS] About Knife Shop");
    SetMenuExitButton(menu, true);
    DisplayMenu(menu, clientId, 120);
	}
	return Plugin_Handled;
}
public DIDMenuHandler_prestrelka(Handle:menu, MenuAction:action, client, itemNum)
{
	if(client == Warden)
	{
		if ( action == MenuAction_Select )
		{
			new String:info[32]; GetMenuItem(menu, itemNum, info, sizeof(info));
			if ( strcmp(info,"option2") == 0 )
			{
			Prestrelka_vsetko(client)
			forceendround = CreateTimer(240.0, ForceGameEnd)
			}
			if ( strcmp(info,"option3") == 0 )
			{
			Prestrelka_m4(client)
			forceendround = CreateTimer(240.0, ForceGameEnd)
			}
			if ( strcmp(info,"option4") == 0 )
			{
			Prestrelka_ak(client)
			forceendround = CreateTimer(240.0, ForceGameEnd)
			}
			if ( strcmp(info,"option5") == 0 )
			{
			Prestrelka_scout(client)
			forceendround = CreateTimer(240.0, ForceGameEnd)
			}
			if ( strcmp(info,"option6") == 0 )
			{
				DID_hernimod(client)
			}


		}
	}

}
public Action: dajgun(Handle: time, any: client)
{
	new knife = GivePlayerItem(client,"weapon_knife")
	EquipPlayerWeapon(client, knife);

	if(zbran_prestrelka == 99)
	{
	new random_gun = GivePlayerItem(client,g_weapons[GetRandomInt(1, 24)]);
	EquipPlayerWeapon(client, random_gun)
	}
	else
	if(zbran_prestrelka == 1)
	{
	new m4a1 = GivePlayerItem(client,"weapon_m4a1")
	EquipPlayerWeapon(client, m4a1);
	}
	else
	if(zbran_prestrelka == 2)
	{
	new ak47 = GivePlayerItem(client,"weapon_ak47")
	EquipPlayerWeapon(client, ak47);
	}
	else
	if(zbran_prestrelka == 3)
	{
	new scout = GivePlayerItem(client,"weapon_ssg08")
	EquipPlayerWeapon(client, scout);
	}
	else
	if(zombie && hrac_dozorce[client])
	{
	GivePlayerItem(client,"weapon_tec9")
	GivePlayerItem(client,"weapon_molotov")

	if (GetRandomInt(1,2) == 1)
	{
	new brokovnice = GivePlayerItem(client,"weapon_nova")
	EquipPlayerWeapon(client, brokovnice)
	}
	else
	{
	new brokovnice = GivePlayerItem(client,"weapon_mag7")
	EquipPlayerWeapon(client, brokovnice)
	}

	}
}

public Action:matrix_menu(clientId)
{
	if (koneckola)
		return Plugin_Continue
	if(!IsValidClient(clientId))
		return Plugin_Continue

	if (!IsClientInGame(clientId))
		return Plugin_Continue

	if (!IsPlayerAlive(clientId))
		return Plugin_Continue

	if (!matrix)
		return Plugin_Continue

	new Handle:menu = CreateMenu(matrix_menu_pokracovani);

	if(GetClientTeam(clientId) == 3)
	{
	SetMenuTitle(menu, "Matrix - vyber postavu");
	AddMenuItem(menu, "option2", "Agent Smith");
	AddMenuItem(menu, "option3", "Soldier");
	}
	else if(GetClientTeam(clientId) == 2)
	{
	SetMenuTitle(menu, "Matrix - vyber postavu");
	AddMenuItem(menu, "option2", "Neo");
	AddMenuItem(menu, "option3", "Trinity");
	AddMenuItem(menu, "option4", "Morpheus");
	}

	SetMenuExitButton(menu, true);
	DisplayMenu(menu, clientId, 120);

	return Plugin_Handled;
}
public Action: cekni_deagle(Handle: time, any client)
{
	if(!IsValidEntity( GetPlayerWeaponSlot(client, 1) ))
	{
		new deagle = GivePlayerItem(client,"weapon_deagle")
		EquipPlayerWeapon(client, deagle)
	}
}
public Action: cekni_elite(Handle: time, any client)
{
	if(!IsValidEntity( GetPlayerWeaponSlot(client, 1) ))
	{
		new deagle = GivePlayerItem(client,"weapon_elite")
		EquipPlayerWeapon(client, deagle)
	}
}
public Action: cekni_p250(Handle: time, any client)
{
	if(!IsValidEntity( GetPlayerWeaponSlot(client, 1) ))
	{
		new deagle = GivePlayerItem(client,"weapon_p250")
		EquipPlayerWeapon(client, deagle)
	}
}
public matrix_menu_pokracovani(Handle:menu, MenuAction:action, client, itemNum)
{
		if(!IsClientInGame(client))
			return

		if(!IsPlayerAlive(client))
			return

		if (!matrix)
			return

		if(GetClientTeam(client) == 3)
		{
			if ( action == MenuAction_Select )
			{
				new String:info[32]; GetMenuItem(menu, itemNum, info, sizeof(info));
				if ( strcmp(info,"option2") == 0 )
				{
				SetEntityHealth(client, 1000);
				SetClientSpeed(client,2.5)
				SetEntityGravity(client, 0.2)

				new deagle = GivePlayerItem(client,"weapon_deagle")
				EquipPlayerWeapon(client, deagle);
				CreateTimer(3.0, cekni_deagle, client)

				}

				if ( strcmp(info,"option3") == 0 )
				{
				SetEntityHealth(client, 1300);
				SetClientSpeed(client,1.5)
				SetEntityGravity(client, 0.4)

				new elite = GivePlayerItem(client,"weapon_elite")
				EquipPlayerWeapon(client, elite);
				CreateTimer(3.0, cekni_elite, client)
				}
			}
		}

		if(GetClientTeam(client) == 2)
		{
			if ( action == MenuAction_Select )
			{
				new String:info[32]; GetMenuItem(menu, itemNum, info, sizeof(info));
				if ( strcmp(info,"option2") == 0 )
				{
				SetEntityHealth(client, 300);
				SetClientSpeed(client,2.5)
				SetEntityGravity(client, 0.3)

				new deagle = GivePlayerItem(client,"weapon_deagle")
				EquipPlayerWeapon(client, deagle);
				CreateTimer(3.0, cekni_deagle, client)
				}

				if ( strcmp(info,"option3") == 0 )
				{
				SetEntityHealth(client, 400);
				SetClientSpeed(client,2.0)
				SetEntityGravity(client, 0.2)

				new elite = GivePlayerItem(client,"weapon_elite")
				EquipPlayerWeapon(client, elite);
				CreateTimer(3.0, cekni_elite, client)
				}

				if ( strcmp(info,"option4") == 0 )
				{
				SetEntityHealth(client, 500);
				SetClientSpeed(client,1.5)
				SetEntityGravity(client, 0.4)

				new p250 = GivePlayerItem(client,"weapon_p250")
				EquipPlayerWeapon(client, p250);
				CreateTimer(3.0, cekni_p250, client)
				}
			}
		}
}

public Action:matrix_mod(clientId)
{
	if(Warden != -1) // Is there an warden at the moment ?
	{
		RemoveTheWarden(clientId);
	}

	auto_open()
	blokwarden = 1
	Warden = -1
	mod = 1
	matrix = 1
	CreateTimer(1.0, hudba_matrix)
	new maximumplayers
	maximumplayers = GetMaxClients()

	for (new idx = 1; idx <= maximumplayers; idx++)
	{
			if(!IsValidClient(idx))
			{
			continue
			}
			if(!IsPlayerAlive(idx))
			{
			continue
			}
			if (!IsClientConnected(idx))
			{
				continue
			}
			strip_user_weapons(idx)
			SetEntityRenderColor(idx, 255, 255, 255, 255);

			new knife = GivePlayerItem(idx,"weapon_knife")
			EquipPlayerWeapon(idx, knife);

			matrix_menu(idx)

	}

}

public Action:zombie_mod(clientId)
{
	if(Warden != -1) // Is there an warden at the moment ?
	{
		RemoveTheWarden(clientId);
	}
	auto_open()
	blokwarden = 1
	Warden = -1
	mod = 1
	zombie = 1
	CreateTimer(1.0, hudba_zombie)
	new maximumplayers
	maximumplayers = GetMaxClients()

	for (new idx = 1; idx <= maximumplayers; idx++)
	{
			if(!IsValidClient(idx))
			{
			continue
			}
			if(!IsPlayerAlive(idx))
			{
			continue
			}
			if (!IsClientConnected(idx))
			{
				continue
			}
			strip_user_weapons(idx)
			SetEntityRenderColor(idx, 255, 255, 255, 255);
			CreateTimer(0.5, dajgun,idx)

			if (hrac_dozorce[idx])
			{
			CS_RespawnPlayer(idx)
			SetClientSpeed(idx,1.0)

			SetEntityHealth(idx, 100);
			SetClientSpeed(idx,1.0)
			SetEntityGravity(idx, 1.0)

			SetEntityModel(idx, "models/player/ctm_sas.mdl")
			}
			else
			if (hrac_vezen[idx])
			{
			SetClientSpeed(idx,0.8)
			SetEntityHealth(idx, 1200);
			SetEntityGravity(idx, 0.8)

			SetEntityModel(idx, "models/player/zombie.mdl")
			}
	}
}

public Action:Prestrelka_vsetko(clientId)
{
	if(Warden != -1) // Is there an warden at the moment ?
	{
		RemoveTheWarden(clientId);
	}

	auto_open()
	blokwarden = 1
	Warden = -1
	mod = 1
	zbran_prestrelka = 99
	CreateTimer(1.0, hudba_prestrelka)
	new maximumplayers
	maximumplayers = GetMaxClients()

	for (new idx = 1; idx <= maximumplayers; idx++)
	{
			if(!IsValidClient(idx))
			{
			continue
			}
			if(!IsPlayerAlive(idx))
			{
			continue
			}
			if (!IsClientConnected(idx))
			{
				continue
			}

			strip_user_weapons(idx)
			CreateTimer(0.5, dajgun,idx)
			SetEntityRenderColor(idx, 255, 255, 255, 255);


			if(IsClientInGame(idx) && IsPlayerAlive(idx) && GetClientTeam(idx) == 3)
			{
				SetEntityHealth(idx, 150);
			}
			else
			if(IsClientInGame(idx) && IsPlayerAlive(idx) && GetClientTeam(idx) == 2)
			{
				SetEntityHealth(idx, 100);
			}
	}
}
public Action:Prestrelka_m4(clientId)
{
	if(Warden != -1) // Is there an warden at the moment ?
	{
		RemoveTheWarden(clientId);
	}

	auto_open()
	blokwarden = 1
	Warden = -1
	mod = 1
	zbran_prestrelka = 1
	CreateTimer(1.0, hudba_prestrelka)
	new maximumplayers
	maximumplayers = GetMaxClients()

	for (new idx = 1; idx <= maximumplayers; idx++)
	{
			if(!IsValidClient(idx))
			{
			continue
			}
			if(!IsPlayerAlive(idx))
			{
			continue
			}
			if (!IsClientConnected(idx))
			{
				continue
			}

			strip_user_weapons(idx)
			SetEntityRenderColor(idx, 255, 255, 255, 255);
			CreateTimer(0.5, dajgun,idx)
			if(IsClientInGame(idx) && IsPlayerAlive(idx) && GetClientTeam(idx) == 3)
			{
				SetEntityHealth(idx, 150);
			}
			else
			if(IsClientInGame(idx) && IsPlayerAlive(idx) && GetClientTeam(idx) == 2)
			{
				SetEntityHealth(idx, 100);
			}
	}

}
public Action:Prestrelka_ak(clientId)
{
	if(Warden != -1) // Is there an warden at the moment ?
	{
		RemoveTheWarden(clientId);
	}

	auto_open()
	blokwarden = 1
	Warden = -1
	mod = 1
	zbran_prestrelka = 2
	CreateTimer(1.0, hudba_ak)
	new maximumplayers
	maximumplayers = GetMaxClients()

	for (new idx = 1; idx <= maximumplayers; idx++)
	{
			if(!IsValidClient(idx))
			{
			continue
			}
			if(!IsPlayerAlive(idx))
			{
			continue
			}
			if (!IsClientConnected(idx))
			{
				continue
			}

			strip_user_weapons(idx)
			SetEntityRenderColor(idx, 255, 255, 255, 255);
			CreateTimer(0.5, dajgun,idx)
			if(IsClientInGame(idx) && IsPlayerAlive(idx) && GetClientTeam(idx) == 3)
			{
				SetEntityHealth(idx, 150);
			}
			else
			if(IsClientInGame(idx) && IsPlayerAlive(idx) && GetClientTeam(idx) == 2)
			{
				SetEntityHealth(idx, 100);
			}
	}

}
public Action:Prestrelka_scout(clientId)
{
	if(Warden != -1) // Is there an warden at the moment ?
	{
		RemoveTheWarden(clientId);
	}

	auto_open()
	blokwarden = 1
	Warden = -1
	mod = 1
	zbran_prestrelka = 3
	CreateTimer(1.0, hudba_scout)
	new maximumplayers
	maximumplayers = GetMaxClients()

	for (new idx = 1; idx <= maximumplayers; idx++)
	{
			if(!IsValidClient(idx))
			{
			continue
			}
			if(!IsPlayerAlive(idx))
			{
			continue
			}
			if (!IsClientConnected(idx))
			{
				continue
			}

			PrintHintText(idx, "<font color='#00FF00' size='17'>SIMON SPUSTIL</font><br><font color='#6699CC' size='30'><i>PRESTRELKA (SCOUT)</i></font>")

			strip_user_weapons(idx)
			SetEntityRenderColor(idx, 255, 255, 255, 255);
			CreateTimer(0.5, dajgun,idx)
			if(IsClientInGame(idx) && IsPlayerAlive(idx) && GetClientTeam(idx) == 3)
			{
				SetEntityHealth(idx, 150);
			}
			else
			if(IsClientInGame(idx) && IsPlayerAlive(idx) && GetClientTeam(idx) == 2)
			{
				SetEntityHealth(idx, 100);
			}
	}

}

public Action:hudba_prestrelka(Handle: timer)
{
	EmitSoundToAllAny("jbextreme/prestrelka_gs.mp3");

	if (zbran_prestrelka == 99)
	{
	PrintHintTextToAll("<font color='#00FF00' size='17'>SIMON SPUSTIL</font><br><font color='#6699CC' size='30'><i>PRESTRELKA (NAHODNA)</i></font>")
	}

	if (zbran_prestrelka == 1)
	{
	PrintHintTextToAll("<font color='#00FF00' size='17'>SIMON SPUSTIL</font><br><font color='#6699CC' size='30'><i>PRESTRELKA (M4)</i></font>")
	}
}

public Action:hudba_ak(Handle: timer)
{
	EmitSoundToAllAny("jbextreme/prestrelka_ak_gs.mp3");

	PrintHintTextToAll("<font color='#00FF00' size='17'>SIMON SPUSTIL</font><br><font color='#6699CC' size='30'><i>PRESTRELKA (AK47)</i></font>")
}

public Action:hudba_matrix(Handle: timer)
{
	EmitSoundToAllAny("jbextreme/matrix_gs.mp3");

	PrintHintTextToAll("<font color='#00FF00' size='17'>SIMON SPUSTIL</font><br><font color='#CC33CC' size='30'><i>MATRIX MOD</i></font>");
}

public Action:hudba_scout(Handle: timer)
{
	EmitSoundToAllAny("jbextreme/scout_gs.mp3");
}

public Action:hudba_zombie(Handle: timer)
{
	EmitSoundToAllAny("jbextreme/ghost_gs.mp3");

	PrintHintTextToAll("<font color='#00FF00' size='17'>SIMON SPUSTIL</font><br><font color='#FF0000' size='30'><i>ZOMBIE MOD</i></font>");
}

public Action:DID_boxom(clientId)
{

	if(clientId == Warden)
	{
    new Handle:menu = CreateMenu(DIDMenuHandler_boxom);

    SetMenuTitle(menu, "Simon Menu");
    AddMenuItem(menu, "option2", "Classic Box");
    AddMenuItem(menu, "option3", "Restrict Box");
    AddMenuItem(menu, "option4", "Vypni Box");
    AddMenuItem(menu, "option5", "Zpet");



    SetMenuExitButton(menu, true);
    DisplayMenu(menu, clientId, 120);
	}
	return Plugin_Handled;
}
public DIDMenuHandler_boxom(Handle:menu, MenuAction:action, client, itemNum)
{
	if(client == Warden)
	{
		if ( action == MenuAction_Select )
		{
			new maximumplayers
			maximumplayers = GetMaxClients()
			new String:info[32]; GetMenuItem(menu, itemNum, info, sizeof(info));
			if ( strcmp(info,"option2") == 0 )
			{
				ServerCommand("mp_friendlyfire 1")
				PrintToChatAll("*\x09Simon %s pustil Classic box, muzes vyuzit strelne zbrane", named)
				PrintHintTextToAll("<font color='#00FF00' size='20'>SIMON POVOLUJE BITKU A</font><br><font color='#FFFFFF' size='30'>SPUSTIL CLASSIC BOX</font>")
				boxmod= 1
				DID_boxom(client)

				for (new idx = 1; idx <= maximumplayers; idx++)
				{
					if(!IsValidClient(idx))
					{
					continue
					}
					if(IsClientInGame(idx) && IsPlayerAlive(idx) && GetClientTeam(idx) == 2)
					{
						SetEntityHealth(idx, 100);
					}
				}


			}
			if ( strcmp(info,"option3") == 0 )
			{
				ServerCommand("mp_friendlyfire 1")
				PrintToChatAll("*\x09Simon %s pustil Restrict box, nejde vyuzivat strelne zbrane", named)
				PrintHintTextToAll("<font color='#00FF00' size='20'>SIMON POVOLUJE BITKU A</font><br><font color='#FFFFFF' size='30'>SPUSTIL RESTRICT BOX</font>")
				boxmod = 2
				DID_boxom(client)

				for (new idx = 1; idx <= maximumplayers; idx++)
				{
					if(!IsValidClient(idx))
					{
					continue
					}
					if(IsClientInGame(idx) && IsPlayerAlive(idx) && GetClientTeam(idx) == 2)
					{
						SetEntityHealth(idx, 100);
					}
				}
			}
			if ( strcmp(info,"option4") == 0 )
			{
				ServerCommand("mp_friendlyfire 0")
				PrintToChatAll("*\x09Simon %s vypl box", named)
				PrintHintTextToAll("<font color='#00FF00' size='20'>SIMON ZAKAZUJE BITKU A</font><br><font color='#FFFFFF' size='30'>VYPNUL BOX</font>")
				boxmod = 0
				DID_boxom(client)

				for (new idx = 1; idx <= maximumplayers; idx++)
				{
					if(!IsValidClient(idx))
					{
					continue
					}
					if(IsClientInGame(idx) && IsPlayerAlive(idx) && GetClientTeam(idx) == 2)
					{
						SetEntityHealth(idx, 100);
					}
				}
			}
			if ( strcmp(info,"option5") == 0 )
			{
				DID(client)


			}


		}
	}

}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                                                                    //
//										SHOP PLUGIN PART         																																		  //
//																																															          //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
public Action:Shop_menu(clientId)
{
	if(!IsValidClient(clientId))
	return Plugin_Continue
	if(IsClientInGame(clientId) && IsPlayerAlive(clientId) && GetClientTeam(clientId) == 2)
	{
	new Handle:menu = CreateMenu(DIDMenuHandler_Shop_menu);
	decl String:itemtext2[256];
	SetMenuTitle(menu, "Vezenske menu - /shop");
	Format(itemtext2, sizeof(itemtext2), "%17s [$%d]",SHOP_ITEM1, SHOP_ITEM1_CENA)
	AddMenuItem(menu, "option2", itemtext2);
	Format(itemtext2, sizeof(itemtext2), "%20s [$%d]",SHOP_ITEM2, SHOP_ITEM2_CENA)
	AddMenuItem(menu, "option3", itemtext2);
	Format(itemtext2, sizeof(itemtext2), "%21s [$%d]",SHOP_ITEM3, SHOP_ITEM3_CENA)
	AddMenuItem(menu, "option4", itemtext2);
	Format(itemtext2, sizeof(itemtext2), "%17s [$%d]",SHOP_ITEM4, SHOP_ITEM4_CENA)
	AddMenuItem(menu, "option5", itemtext2);
	Format(itemtext2, sizeof(itemtext2), "%16s [$%d]",SHOP_ITEM5, SHOP_ITEM5_CENA)
	AddMenuItem(menu, "option6", itemtext2);
	Format(itemtext2, sizeof(itemtext2), "%15s [$%d]",SHOP_ITEM6, SHOP_ITEM6_CENA)
	AddMenuItem(menu, "option7", itemtext2);
	Format(itemtext2, sizeof(itemtext2), "%15s [$%d]",SHOP_ITEM7, SHOP_ITEM7_CENA)
	AddMenuItem(menu, "option8", itemtext2);
	SetMenuExitButton(menu, true);
	DisplayMenu(menu, clientId, 120);
	}

	return Plugin_Handled;
}
public DIDMenuHandler_Shop_menu(Handle:menu, MenuAction:action, client, itemNum)
{
	if(!IsValidClient(client))
	return
	if(IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) == 2)
	{
	if ( action == MenuAction_Select )
	{
		new String:info[32]; GetMenuItem(menu, itemNum, info, sizeof(info));
		if ( strcmp(info,"option2") == 0 )
		{
			if(GetClientMoney(client) >= SHOP_ITEM1_CENA)
			{
				SetClientMoney(client, SHOP_ITEM1_CENA, false);
				knife_skin[client] = 1
				Shop_menu(client) ;
			}
			else
			{
				PrintToChat(client, "Nemas dostatek penez")
				Shop_menu(client)
			}

		}
		if ( strcmp(info,"option3") == 0 )
		{
			if(GetClientMoney(client) >= SHOP_ITEM2_CENA)
			{
				SetClientMoney(client, SHOP_ITEM2_CENA, false);
				knife_skin[client] = 2
				Shop_menu(client) ;
			}
			else
			{
				PrintToChat(client, "Nemas dostatek penez")
				Shop_menu(client)
			}
		}
		if ( strcmp(info,"option4") == 0 )
		{
			if(GetClientMoney(client) >= SHOP_ITEM3_CENA)
			{
				SetClientMoney(client, SHOP_ITEM3_CENA, false);
				knife_skin[client] = 3
				Shop_menu(client) ;
			}
			else
			{
				PrintToChat(client, "Nemas dostatek penez")
				Shop_menu(client)
			}
		}
		if ( strcmp(info,"option5") == 0 )
		{
			if(GetClientMoney(client) >= SHOP_ITEM4_CENA)
			{
				SetClientMoney(client, SHOP_ITEM4_CENA, false);
				SetClientSpeed(client,1.5)
				Shop_menu(client) ;
			}
			else
			{
				PrintToChat(client, "Nemas dostatek penez")
				Shop_menu(client)
			}
		}
		if ( strcmp(info,"option6") == 0 )
		{
			if(GetClientMoney(client) >= SHOP_ITEM5_CENA)
			{
				SetClientMoney(client, SHOP_ITEM5_CENA, false);
				decl String:other2[64]
				GetClientName(client, other2, sizeof(other2))
				PrintToChatAll("%s Si koupil Volny den a nemusi poslouchat simona cele kolo",other2)
				SetEntityRenderMode(client , RENDER_WORLDGLOW);
				SetEntityRenderColor(client, 255, 0, 255, 255);
				hracsvd[client] = 1
				Shop_menu(client) ;
			}
			else
			{
				PrintToChat(client, "Nemas dostatek penez")
				Shop_menu(client)
			}
		}
		if ( strcmp(info,"option7") == 0 )
		{
			if(GetClientMoney(client) >= SHOP_ITEM6_CENA)
			{
				SetClientMoney(client, SHOP_ITEM6_CENA, false);
				SetEntityRenderMode(client , RENDER_NONE);
				invis[client] = 1
				Shop_menu(client) ;
				CreateTimer(10.0, zrus_invis, client)
			}
			else
			{
				PrintToChat(client, "Nemas dostatek penez")
				Shop_menu(client)
			}
		}
		if ( strcmp(info,"option8") == 0 )
		{
			if(GetClientMoney(client) >= SHOP_ITEM7_CENA)
			{
				SetClientMoney(client, SHOP_ITEM7_CENA, false);
				Shop_menu(client) ;
				GivePlayerItem(client, "weapon_deagle");
				Client_SetWeaponPlayerAmmo(client, "weapon_deagle",0, -1)

			}
			else
			{
				PrintToChat(client, "Nemas dostatek penez")
				Shop_menu(client)
			}
		}

	}
	}

}
public Action: zrus_invis(Handle: timer, any: client)
{

	SetEntityRenderMode(client , RENDER_NORMAL);
	PrintToChat(client, "Neviditelnost skoncila!")

	invis[client] = 0
	//new String: weapons[64]
	//GetClientWeapon(client, weapons, 64);
	//SetEntityRenderMode(client, RENDER_NORMAL);
	new m_hMyWeapons = FindSendPropOffs("CBasePlayer", "m_hMyWeapons");

	for(new i = 0, weapon; i < 47; i += 4)
	{
		weapon = GetEntDataEnt2(client, m_hMyWeapons + i);

		if (weapon > -1 )
		{
			SetEntityRenderMode(weapon, RENDER_NORMAL);

		}
	}

}

public Action:Shop_menu_ct(clientId)
{
	if(!IsValidClient(clientId))
	return Plugin_Continue
	if(IsClientInGame(clientId) && IsPlayerAlive(clientId) && GetClientTeam(clientId) == 3)
	{
	new Handle:menu = CreateMenu(DIDMenuHandler_Shop_menuct);
	decl String:itemtext2[256];
	SetMenuTitle(menu, "Dozorce Menu - /shop");
	Format(itemtext2, sizeof(itemtext2), "Vyber zbrani")
	AddMenuItem(menu, "option1", itemtext2);
	Format(itemtext2, sizeof(itemtext2), "%10s [$%d]",SHOP_ITEM1_CT, SHOP_ITEM1_CENA_CT)
	AddMenuItem(menu, "option2", itemtext2);
	Format(itemtext2, sizeof(itemtext2), "%12s [$%d]",SHOP_ITEM2_CT, SHOP_ITEM2_CENA_CT)
	AddMenuItem(menu, "option3", itemtext2);

	SetMenuExitButton(menu, true);
	DisplayMenu(menu, clientId, 120);
	}
	return Plugin_Handled;
}
public DIDMenuHandler_Shop_menuct(Handle:menu, MenuAction:action, client, itemNum)
{
	if(!IsValidClient(client))
	return
	if(IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) == 3)
	{
	if ( action == MenuAction_Select )
	{
		new String:info[32]; GetMenuItem(menu, itemNum, info, sizeof(info));
		if ( strcmp(info,"option1") == 0 )
		{
			if (GetUserFlagBits(client) & EVIP)
			{
			if(ct_gun[client] == 0)
			{
				DID_vyber_zbran_ct(client)
			}
			else
			{
				Shop_menu_ct(client);
				PrintToChat(client, "Dalsi vyber zbrani neni mozny!")
			}
			}
			else
			{
				Shop_menu_ct(client);
				PrintToChat(client, "Nejsi Extra VIP")
			}



		}
		if ( strcmp(info,"option2") == 0 )
		{
			if(GetClientMoney(client) >= SHOP_ITEM1_CENA_CT)
			{
			SetClientMoney(client, SHOP_ITEM1_CENA_CT, false);
			SetClientSpeed(client,1.5)
			Shop_menu(client) ;
			}
			else
			{
			PrintToChat(client, "Nemas dostatek penez")
			Shop_menu_ct(client)
			}

		}
		if ( strcmp(info,"option3") == 0 )
		{
			if(GetClientMoney(client) >= SHOP_ITEM2_CENA_CT)
			{
			SetClientMoney(client, SHOP_ITEM2_CENA_CT, false);
			//new health = GetClientHealth(client);
			SetEntityHealth(client, 150);
			Shop_menu(client) ;

			}
			else
			{
			PrintToChat(client, "Nemas dostatek penez")
			Shop_menu_ct(client)
			}
		}


	}
    }
}
public Action:DID_vyber_zbran_ct(clientId)
{

	if(!IsValidClient(clientId))
	return Plugin_Continue
	if(IsClientInGame(clientId) && IsPlayerAlive(clientId) && GetClientTeam(clientId) == 3)
	{
    new Handle:menu = CreateMenu(DIDMenuHandler_vyber_zbran_ct);

    SetMenuTitle(menu, "Simon Menu - /smenu");
    AddMenuItem(menu, "option2", "M4A1 + Deagle");
    AddMenuItem(menu, "option3", "AK47 + Deagle");
    AddMenuItem(menu, "option4", "UMP45 + Deagle");
    AddMenuItem(menu, "option5", "AWP + Deagle");
    AddMenuItem(menu, "option6", "Zpet");


//AddMenuItem(menu, "option1", "[KS] About Knife Shop");
    SetMenuExitButton(menu, true);
    DisplayMenu(menu, clientId, 120);
	}
	return Plugin_Handled;
}
public DIDMenuHandler_vyber_zbran_ct(Handle:menu, MenuAction:action, client, itemNum)
{
	if(!IsValidClient(client))
	return
	if(IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) == 3)
	{
		if ( action == MenuAction_Select )
		{
			new String:info[32];
			GetMenuItem(menu, itemNum, info, sizeof(info));
			if ( strcmp(info,"option2") == 0 )
			{
				if(ct_gun[client] == 0)
				{
				strip_user_weapons(client)

				GivePlayerItem(client, "weapon_m4a1");
				GivePlayerItem(client, "weapon_deagle");
				new knife = GivePlayerItem(client,"weapon_knife")
				EquipPlayerWeapon(client, knife);
				DID_vyber_zbran_ct(client);
				ct_gun[client] = 1
				}
				else
				{
					DID(client);
					PrintToChat(client, "Dalsi vyber zbrani neni mozny!")
				}

			}
			if ( strcmp(info,"option3") == 0 )
			{

				if(ct_gun[client] == 0)
				{
				strip_user_weapons(client)


				GivePlayerItem(client, "weapon_ak47");
				GivePlayerItem(client, "weapon_deagle");
				new knife = GivePlayerItem(client,"weapon_knife")
				EquipPlayerWeapon(client, knife);
				DID_vyber_zbran_ct(client);
				ct_gun[client] = 1
				}
				else
				{
					DID(client);
					PrintToChat(client, "Dalsi vyber zbrani neni mozny!")
				}
			}
			if ( strcmp(info,"option4") == 0 )
			{

			if(ct_gun[client] == 0)
				{
				strip_user_weapons(client)



				GivePlayerItem(client, "weapon_ump45");
				GivePlayerItem(client, "weapon_deagle");
				new knife = GivePlayerItem(client,"weapon_knife")
				EquipPlayerWeapon(client, knife);
				DID_vyber_zbran_ct(client);
				ct_gun[client] = 1
				}
				else
				{
					DID(client);
					PrintToChat(client, "Dalsi vyber zbrani neni mozny!")
				}
			}
			if ( strcmp(info,"option5") == 0 )
			{

				if(ct_gun[client] == 0)
				{
				strip_user_weapons(client)



				GivePlayerItem(client, "weapon_awp");
				GivePlayerItem(client, "weapon_deagle");
				new knife = GivePlayerItem(client,"weapon_knife")
				EquipPlayerWeapon(client, knife);
				DID_vyber_zbran_ct(client);
				ct_gun[client] = 1
				}
				else
				{
					DID(client);
					PrintToChat(client, "Dalsi vyber zbrani neni mozny!")
				}
			}
			if ( strcmp(info,"option6") == 0 )
			{

			DID_vyber_zbran_ct(client);
			}


	}
	}

}
public strip_user_weapons(client) {
    for(new i = 0; i < 4; i++) {
        new ent = GetPlayerWeaponSlot(client, i);

        if(ent != -1) {
            RemovePlayerItem(client, ent);
            RemoveEdict(ent);
        }
    }
}
public strip_user_weapon(client, slot)
{
	new ent = GetPlayerWeaponSlot(client, slot)
	RemovePlayerItem(client,ent );
	RemoveEdict(ent)
}



/*public Action:Vyber_skin(clientId)
{
	new Handle:menu = CreateMenu(DIDMenuHandlerVyber_skin);
	SetMenuTitle(menu, "Vezenske menu - /shop");
	if(cislo_skinu[clientId] == 1)
	{
	AddMenuItem(menu, "option2", "Bile obleceni [ON]");
	}
	else
	{
	AddMenuItem(menu, "option2", "Bile obleceni [OFF]");
	}
	if(cislo_skinu[clientId] == 2)
	{
	AddMenuItem(menu, "option3", "Oranzove obleceni [ON]");
	}
	else
	{
	AddMenuItem(menu, "option3", "Oranzove obleceni [OFF]");
	}
	AddMenuItem(menu, "option4", "Skin3");
	AddMenuItem(menu, "option4", "Zpet");
	SetMenuExitButton(menu, true);
	DisplayMenu(menu, clientId, 120);
	return Plugin_Handled;
}*/

/*public DIDMenuHandlerVyber_skin(Handle:menu, MenuAction:action, client, itemNum)
{
	if(IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) == 2)
	{
		if ( action == MenuAction_Select )
		{
			new String:info[32]; GetMenuItem(menu, itemNum, info, sizeof(info));
			if ( strcmp(info,"option2") == 0 )
			{
				cislo_skinu[client] = 1
				Vyber_skin(client)
			}
			if ( strcmp(info,"option3") == 0 )
			{
				cislo_skinu[client] = 2
				Vyber_skin(client)
			}
			if ( strcmp(info,"option4") == 0 )
			{
				t_menu(client)
			}

		}
	}

}*/
/*public Action:t_menu(clientId)
{
	if(IsClientInGame(clientId) && IsPlayerAlive(clientId) && GetClientTeam(clientId) == 2)
	{
	new Handle:menu = CreateMenu(DIDMenuHandlert_menu);
	SetMenuTitle(menu, "Vezenske menu - /shop");
	AddMenuItem(menu, "option2", "Obchod");

	if(cislo_skinu_aktual[clientId]  == 0)
	{
	AddMenuItem(menu, "option3", "Vzhled \r Mas bile obleceni\n");
	}
	else
	if(cislo_skinu_aktual[clientId]  == 1)
	{
	AddMenuItem(menu, "option3", "Vzhled \r Mas bile obleceni\n");
	}
	else
	if(cislo_skinu_aktual[clientId]  == 2)
	{
	AddMenuItem(menu, "option3", "Vzhled \r Mas bile obleceni\n");
	}

	AddMenuItem(menu, "option4", "Pravidla");


	SetMenuExitButton(menu, true);
	DisplayMenu(menu, clientId, 120);
	}
	return Plugin_Handled;
}*/
/*public DIDMenuHandlert_menu(Handle:menu, MenuAction:action, client, itemNum)
{
	if(IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) == 2)
	{
		if ( action == MenuAction_Select )
		{
			new String:info[32]; GetMenuItem(menu, itemNum, info, sizeof(info));
			if ( strcmp(info,"option2") == 0 )
			{
				Shop_menu(client)
			}
			if ( strcmp(info,"option3") == 0 )
			{
				Vyber_skin(client)
			}
			if ( strcmp(info,"option4") == 0 )
			{
				ShowMOTDPanel(client, "pravidla gamesites.cz", "http://www.gamesites.cz/serversoubory/pravidla_jb.html", MOTDPANEL_TYPE_URL);
				t_menu(client)
			}


		}
	}

}*/
