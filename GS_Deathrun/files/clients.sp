stock bool IsPlayerVIP(client)
{
	if(IsValidClient(client))
	{
		if (GetAdminFlag(GetUserAdmin(client), Admin_Reservation))
		{
			return true;
		}
	}
	return false;
}
stock bool IsPlayerAdmin(client)
{
	if (GetAdminFlag(GetUserAdmin(client), Admin_Generic))
    {
		return true;
	}
	return false;
}
stock bool IsValidClient(client, bool alive = false)
{
	if(client >= 1 && client <= MaxClients && IsClientConnected(client) && IsClientInGame(client) && (alive == false || IsPlayerAlive(client)))
	{
		return true;
	}
	return false;
}
stock CountPlayersInTeam(int team)
{
	int count = 0;
	LoopClients(i)
	{
		if(IsValidClient(i) && GetClientTeam(i) == team)
		{
			count++;
		}
	}
	return count;
}
stock bool IsClientJoker(int client)
{
	if(client == i_DrTerrorist) return true;
	return false;
}
stock GetRandomPlayer(int team, bool alive = false)
{
	new clients[MaxClients+1];
	int clientCount;
	LoopClients(i)
	{
		if(IsValidClient(i, alive) && GetClientTeam(i) == team)
		{
			clients[clientCount++] = i;
		}
	}
	return (clientCount == 0) ? -1 : clients[GetRandomInt(0, clientCount-1)];
}
