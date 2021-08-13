// function declarations
void () admin_cancel_kick;
void () admin_confirm_kick;
void () admin_do_kick;


void (entity p) kick_player =
{
 local string temp;
 local entity oself;
 
 temp = ftos(p.colormap);
 localcmd ("kick # ");
 localcmd (temp);
 localcmd ("\n");
 
 oself = self;
 self = p;
 ClientDisconnect(); 
 self = oself; 
};

void () admin_send_aliases2 =
{
    // kick a player
    stuffcmd(self, "alias kick! impulse 213\n");
};

void () admin_create =
{
    self.style = self.style | RA_ADMIN;
    self.use = SUB_Null;
    centerprint(self, "You are now an administrator");
    bprint(self.netname, " has become an administrator\n");
    admin_send_aliases2();
};

//
//  E N T E R  C O D E
//
//  Enter another code digit.
//  The digit being entered is stored in self.finaldest_z.
//  The digits that are entered are accumulated by self.count;
//  when self.count == ra_password the client is made into an
//  administrator.
//
void () admin_enter_code = 
{
    if (self.finaldest_z > 9)
	return;

    self.count = self.count * 10 + self.finaldest_z;
    if (self.count >= 10000000)
    {
        sprint(self, "Invalid code\n");
        self.use = SUB_Null;
        return;
    }
    if (self.count == ra_password) admin_create();
    else
        sprint(self, "Enter the next code digit:\n");
};

//
//  S T A R T  C O D E
//
//  Initiate the admin code sequence.
//
void () admin_start_code =
{
    if (self.style & RA_ADMIN)
    {
        sprint(self, "You are already an administrator\n");
        return;
    }
    sprint(self, "Enter the first code digit:\n");
    self.count = 0;
    self.use = admin_enter_code;
};

//
//  C H A N G E  L E V E L
//
//  Called when a request to change level passses.  The level name is
//  stored in request_mapname.
//
//
//  P R I N T  K I C K  C H O I C E
//
//  Display a choice of players to kick.
//
void () admin_print_kick_choice =
{
    local entity client;
    local float index;
    local string num;

    // Print the choice
    sprint(self, "Which player do you want to kick?\n");
    sprint(self, " 0  cancel\n");
    index = 1;
    while (index <= 15)
    {
        client = array_get_kick(index);
        if (client)
        {
            num = ftos(index);
            sprint(self, " ", num, " ", client.netname, "\n");
        }
        index = index + 1;
    }
};

//
//  S T A R T  K I C K
//
//  Get a list of players and ask the admin which one to kick.
//
void () admin_start_kick =
{
    if (ra_state & RA_KICKING)
    {
        sprint(self, "There is already a kick in progress\n");
        return;
    }

    // Get the list of players
    local entity client;
    local float index;
    index = 1;
    client = find(world, classname, "player");
    while (client)
    {
        if (!(client.style & RA_ADMIN) && (client.style & RA_CONNECTED))
        {
            array_set_kick(index, client);
            index = index + 1;
        }
        client = find(client, classname, "player");
    }
    if (index == 1)
    {
        sprint(self, "There is no-one to kick\n");
        return;
    }
    while (index <= 15)
    {
        array_set_kick(index, world);
        index = index + 1;
    }

    // Print the choice
    admin_print_kick_choice();

    // Set up the kick
    local entity kick_timeout;
    self.use = admin_confirm_kick;
    kick_timeout = spawn();
    kick_timeout.movetarget = self;
    kick_timeout.classname = "ra_kick_timeout";
    kick_timeout.think = admin_cancel_kick;
    kick_timeout.nextthink = time + 10;
    ra_state = ra_state | RA_KICKING;
};

//
//  C O N F I R M  K I C K
//
//  Ask for confirmation to kick the selected player.  The index of
//  the player to be kicked is stored in self.finaldest_z.
//
void () admin_confirm_kick =
{
    if (self.finaldest_z == 0)
    {
        // Cancel the kick
        local entity oself;
        oself = self;
        self = find(world, classname, "ra_kick_timeout");
        admin_cancel_kick();
        self = oself;
        return;
    }

    kick_target = array_get_kick(self.finaldest_z);

    // sanity checks
    if (!kick_target)
    {
        sprint(self, "Invalid\n");
        admin_print_kick_choice();
        return;
    }
    
    if (kick_target.style & RA_ADMIN)
    {
        sprint(self, kick_target.netname, " is an administrator\n");
        admin_print_kick_choice();
        return;
    }

    admin_do_kick();
    /*
    // ask for confirmation
    sprint(self, "kick ", kick_target.netname, "?\n");
    self.style = self.style | RA_KICK_CONFIRM;
    */
};

//
//  C O N F I R M  K I C K  R E S P O N S E
//
//  Called when the administrator enters 'yes' or 'no' in
//  response to the confirmation request.
//  
void (float fDoKick) admin_confirm_kick_response =
{
    if (fDoKick)
        admin_do_kick();
    else
    {
        // Cancel the kick
        local entity oself;
        oself = self;
        self = find(world, classname, "ra_kick_timeout");
        admin_cancel_kick();
        self = oself;
    }
};

//
//  D O  K I C K
//
//  Kick a player once the admin has confirmed.
//
void () admin_do_kick =
{
    bprint(kick_target.netname, " kicked by administrator\n");
    kick_player(kick_target);

    // Clean up
    self.use = SUB_Null;
    kick_target = find(world, classname, "ra_kick_timeout");
    remove(kick_target);
    ra_state = ra_state - RA_KICKING;
    self.style = self.style - RA_KICK_CONFIRM;
};

//
//  C A N C E L  K I C K
//
//  Called when the kick times out or is cancelled by the admin.
//
void () admin_cancel_kick =
{
    sprint(self.movetarget, "Kick cancelled\n");
    self.movetarget.use = SUB_Null;
    remove(self);
    ra_state = ra_state - RA_KICKING;
    self.movetarget.style = self.movetarget.style -
        (self.movetarget.style & RA_KICK_CONFIRM);
};

void () admin_impulse =
{

    if (!(self.style & RA_ADMIN))
        return;

    if (self.impulse == 213) admin_start_kick();
    
};

//
//  D I S C O N N E C T  N O T I F Y
//
//  Remove this player from the list of kickable players.
//
void (entity player) admin_disconnect_notify = 
{
    local float index;

    index = 1;
    while (index < 16)
    {
	if (player == array_get_kick(index)) array_set_kick(index, world);
	index = index + 1;
    }
};
