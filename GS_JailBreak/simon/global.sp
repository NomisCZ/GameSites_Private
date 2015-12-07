#define VZPOURA "GameSites/gs_jailbreak/siren.mp3"
#define GONG "GameSites/gs_jailbreak/gong.mp3"
#define ROUNDEND "GameSites/gs_jailbreak/end_gss.mp3"
#define MATRIX "GameSites/gs_jailbreak/matrix_gs.mp3"
#define PRESTRELKA_AK "GameSites/gs_jailbreak/prestrelka_ak_gs.mp3"
#define PRESTRELKA "GameSites/gs_jailbreak/prestrelka_gs.mp3"
#define PRESTRELKA_SCOUT "GameSites/gs_jailbreak/scout_gs.mp3"
#define SCHOVKA "GameSites/gs_jailbreak/shovka_gs.mp3"
#define ZOMBIE "GameSites/gs_jailbreak/zombie_gs.mp3"

#define CTSHOP_ZIVOTYCOST 80
#define CTSHOP_GRAVITACECOST 50
#define CTSHOP_SPEEDCOST 70

#define TSHOP_GUTCOST 6
#define TSHOP_BAYONETCOST 40
#define TSHOP_FLIPCOST 70
#define TSHOP_RYCHLOSTCOST 35
#define TSHOP_VOLNYDENCOST 50
#define TSHOP_NEVIDITELNOSTCOST 70
#define TSHOP_GRANATYCOST 30
#define TSHOP_LOTERIECOST 20
#define TSHOP_DOZORCECOST 60

#define DMG_NONE 30
#define DMG_GUT 50
#define DMG_BAYONET 80
#define DMG_FLIP 115

#define PP_FREEDAY 1
#define PP_PROTIVSEM 2
#define PP_ARMAGEDON 3
#define PP_DEAGLE 4
#define PP_SCOUT 5
#define PP_AWP 6

int simon = -1;
int CurrentJailDoorID = -1;
int CurrentCloseJailDoorID = -1;
int CurrentArmoryDoorID = -1;

char logfile[256];
Handle SimonColorFix = INVALID_HANDLE;
Handle MoneyHandle;

char s_weaponlistclass[][] = {"weapon_m4a1","weapon_ak47","weapon_ump45", "weapon_awp"};
char s_weaponlistnames[][] = {"M4A4","AK47","UMP","AWP"};

char prestrelka_weaponlistclass[][] = {"weapon_m4a1","weapon_ak47","weapon_ump45","weapon_ssg08","weapon_awp"};
char prestrelka_weaponlistnames[][] = {"M4A4","AK47","UMP","SCOUT","AWP"};

char prestrelka_weaponlistclass_secondary[][] = {"weapon_deagle","weapon_usp_silencer","weapon_glock","weapon_p250"};
char prestrelka_weaponlistnames_secondary[][] = {"DEAGLE","USP-S","GLOCK","P250"};

char s_weaponlistclass_random[][] =
{
	"weapon_ak47", "weapon_aug", "weapon_bizon", "weapon_deagle", "weapon_elite", "weapon_famas", "weapon_fiveseven",
	"weapon_g3sg1", "weapon_galilar", "weapon_glock", "weapon_hkp2000", "weapon_m249", "weapon_m4a1",
	"weapon_mac10", "weapon_mag7", "weapon_mp7", "weapon_mp9", "weapon_p250", "weapon_p90",
	"weapon_scar20", "weapon_sg556", "weapon_ssg08", "weapon_tec9", "weapon_ump45", "weapon_xm1014"
};

char s_allweaponslist[][] =
{
	"weapon_m4a1","weapon_m4a1_silencer","weapon_ak47","weapon_aug","weapon_awp","weapon_bizon","weapon_c4","weapon_deagle","weapon_decoy",
	"weapon_elite","weapon_famas","weapon_fiveseven","weapon_flashbang","weapon_G3SG1","weapon_galilar","weapon_glock","weapon_hegrenade","weapon_hkp2000",
	"weapon_usp_silencer","weapon_incgrenade","weapon_m249","weapon_mac10","weapon_mag7","weapon_molotov","weapon_mp7","weapon_mp9","weapon_negev","weapon_nova",
	"weapon_p90","weapon_p250","weapon_cz75a","weapon_sawedoff","weapon_scar20","weapon_sg556","weapon_sg557","weapon_smokegrenade","weapon_ssg08","weapon_taser",
	"weapon_tec9","weapon_ump45","weapon_xm1014"
};

char DoorTypes[][] = {"func_door", "func_door_rotating", "func_rotating", "func_movelinear", "func_elevator", "func_tracktrain","prop_door"};

bool PrestrelkaEnable = false;
char Prestrelka_Wep[32];

bool Grab[MAXPLAYERS+1] = false;
bool GrabNew[MAXPLAYERS+1] = false;
bool GrabCanMove[MAXPLAYERS+1] = false;
float GrabDistance[MAXPLAYERS+1];
int GrabTarget[MAXPLAYERS+1] = -1;

bool MatrixEnable = false;
char MatrixClientWeapon[MAXPLAYERS+1][32];

bool Fotbal = false;
bool Box = false;

Handle Box_Cvars[5];

bool Stopky = false;
float StopkyTime;
float s_Timeleft;

bool Mic = false;
bool JailDoors = false;
bool JailDoorsToggle = false;

char DoorNames[256];

bool HasFreeDay[MAXPLAYERS+1] = false;
float ClientFreeDayStartTime[MAXPLAYERS+1];
float ClientFreeDayTime[MAXPLAYERS+1];

bool Pauza = false;
float PauzaTime;

bool StopySimona = false;
int Stopy = 0;

bool BoxRestrict = false;

bool SimonDisabled = false;
bool GameEnabled = true;

bool Schovka = false;
bool SchovkaOdpocet = false;
float SchovkaStartTime;

bool Alarm = false;
bool WeaponChooseAllowed[MAXPLAYERS+1] = true;

//bool Noblock = false;
int NoBlockOffSet;

bool AutoBhop = false;

bool HealthBought[MAXPLAYERS+1] = false;

int ClientKnifeDamage[MAXPLAYERS+1];

float ClientInvisibleStartTime[MAXPLAYERS+1];
bool IsClientInvisible[MAXPLAYERS+1] = false;



int PP_Guard = -1;
int PP_Prisoner = -1;
int PP_Chosen;
int PP_FreeDay = -1;
bool PPEnabled = false;
bool PPAvailable = false;
bool PPActive = false;


int Days = 0;

bool GlobalFreeDay = false;
float GlobalFreeDayStartTime;
float GlobalFreeDayTime;

float NoSimonVD;
bool b_NoSimonVD = false;
