void () vote_repeat;
void () vote_accept;
void () vote_reject;
void () vote_clear;
float () vote_majority;
void () SUB_Null;
.string wad;
.string map;
void () vote_yes;

float (string s1, string s2, void() accept) vote_init =
{

   if (vote_request.owner != world) 
      {
       sprint(self, "Vote in progress\n");
       return 0;
      }    
   
    vote_request = spawn();
    vote_request.classname = "vote_request";
    vote_request.th_die = SUB_Null;
    vote_request.think = vote_repeat;
    vote_request.use = accept;
    vote_request.wad = s1;
    vote_request.map = s2;
    vote_request.count = 0;
    vote_request.owner = self;
    
    utils_do_players(vote_clear);

    if  (!(vote_majority()))
        {
         vote_repeat();
        }
        
    return 1;        
};


void () vote_clear =
{
    self.style = self.style - (self.style & VOTE_YES);
};


void () vote_yes =
{
    if (self.style & RA_ADMIN)
    {
        // accept immediately
        vote_accept();
        return;
    }

    if (self.style & VOTE_YES)
    {
        sprint(self, "\nyou already voted.\n");
        return;
    }

    self.style = self.style | VOTE_YES;
    
    if (vote_majority()) vote_accept();
};


void () vote_no =
{
    if (self.style & RA_ADMIN)
    {
        // reject immediately
        vote_reject();
        return;
    }

    vote_clear();
};

float () vote_majority =
{
    local entity player;
    local float vote_count;

    vote_count = 0;                                                
    player = find(world, classname, "player");
    while (player)
    {
        if (player.style & RA_CONNECTED)
          {
            local float vote;

            if (self.style & RA_OBSERVER)
                vote = 100;//1
                else
                vote = 100;

            if (player.style & VOTE_YES || player == self)
                vote_count = vote_count + vote;
            else
                vote_count = vote_count - vote;
          }
        player = find(player, classname, "player");
    }
    if (vote_count > 0) return TRUE;
    else
    return FALSE;
};

void () vote_repeat =
{
    sound(world, CHAN_AUTO, "misc/talk.wav", 1, ATTN_NONE);
    bprint("vote request to ", vote_request.wad, vote_request.map, "\n");
    bprint("Type \byes\b or \bno\b in console to vote\n");
    vote_request.nextthink = time + 5;
    vote_request.count = vote_request.count + 1;
    if (vote_request.count == 4) vote_request.think = vote_reject;
};


void () vote_accept =
{
    vote_request.use();
    remove(vote_request);
    vote_request = world;
};


void () vote_reject =
{
    bprint("Vote cancelled\n");
    vote_request.th_die();
    remove(vote_request);
    vote_request = world;
};


void () vote_impulse =
{
    if (!vote_request)
    {
        sprint(self, "Nothing to vote on.\n");
        return;
    }

    if (self.impulse == 80)
        vote_yes();
        
    else 
    
    if (self.impulse == 81)
        vote_no();
};
