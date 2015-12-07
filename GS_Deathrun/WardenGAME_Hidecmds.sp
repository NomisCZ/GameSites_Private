#include <sourcemod>
public Plugin myinfo =
{
	name = "WardenGAME HideCommands",
	author = "ESK0",
	description = "",
	version = "1.0",
	url = "https://github.com/ESK0"
}

public OnPluginStart()
{
	AddCommandListener(HideCommands,"say");
	AddCommandListener(HideCommands,"say_team");
}

public Action HideCommands(client, const char[] command, argc)
{
	if(IsChatTrigger())
  {
    return Plugin_Handled;
  }
	return Plugin_Continue;
}
