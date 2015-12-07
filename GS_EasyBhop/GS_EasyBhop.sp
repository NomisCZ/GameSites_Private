#include <sourcemod>

public Plugin myinfo =
{
    name = "GameSites EasyBhop",
    author = "ESKO",
    description = "",
}
public OnPluginStart()
{
  HookEvent("round_start", Event_OnRoundStart)
  RegAdminCmd("sm_forcebhop", Event_ForceBhop, ADMFLAG_ROOT);
}
public Action Event_OnRoundStart(Handle event, const char[] name, bool dontbroadcast)
{
  SetCvar("sv_enablebunnyhopping", "1");
  SetCvar("sv_staminamax", "0");
  SetCvar("sv_airaccelerate", "2000");
  SetCvar("sv_staminajumpcost", "0");
  SetCvar("sv_staminalandcost", "0");
}
public Action Event_ForceBhop(int client, int args)
{
  SetCvar("sv_enablebunnyhopping", "1");
  SetCvar("sv_staminamax", "0");
  SetCvar("sv_airaccelerate", "2000");
  SetCvar("sv_staminajumpcost", "0");
  SetCvar("sv_staminalandcost", "0");
}
stock SetCvar(String:scvar[], String:svalue[])
{
	new Handle:cvar = FindConVar(scvar);
	SetConVarString(cvar, svalue, true);
}
