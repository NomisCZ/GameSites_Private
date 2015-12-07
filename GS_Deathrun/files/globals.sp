#define s_Tag "[{Lightblue}GameSites{default}]"
#define JokerModel "models/player/mapeadores/morell/joker/joker.mdl"
#define CTModel "models/player/kuristaja/ak/batman/batman.mdl"
#define JokerVyhral "overlays/GameSites/jokervyhral"
#define ENT_RADAR 1 << 12

char SongList[1024];

int i_DrTerrorist = -1;

float fr_enabletime = 6.0;
float RoundStartTime;

bool fr_enable = false;
bool joker_speedup = false;
bool joker_bhop = false;
bool b_HidePlayers[MAXPLAYERS+1] = {false,...};

bool b_CTBhop[MAXPLAYERS+1] = {false,...};
bool b_CTDoubleJump[MAXPLAYERS+1] = {false,...};

int i_LastFlags[MAXPLAYERS+1];
int i_LastButtons[MAXPLAYERS+1];
int i_JumpsCount[MAXPLAYERS+1];

int i_ClientLifes[MAXPLAYERS+1] = {1,...};
bool b_ClientRespawn[MAXPLAYERS+1] = {false,...};
float f_ClientRespawnTime[MAXPLAYERS+1];
