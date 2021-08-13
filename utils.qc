void (void () dofunc) utils_do_players =
{
    local entity oldself;

    oldself = self;
    self = find(world, classname, "player");
    while (self)
    {
        if (self.style & RA_CONNECTED)
            dofunc();
        self = find(self, classname, "player");
    }
    self = oldself;
};

void (void () dofunc) utils_do_non_players =
{
    local entity oldself;

    oldself = self;
    self = find(world, classname, "player");
    while (self)
    {
        if ((self.style & RA_CONNECTED) && (self != winner) && (self != loser))
            dofunc();
        self = find(self, classname, "player");
    }
    self = oldself;
};


entity (void() think_function, float think_time) utils_make_scheduled_event =
{
    local entity temp;
    temp = spawn();
    temp.classname = "RA_temp";
    temp.owner = self;
    temp.nextthink = time + think_time;
    temp.think = think_function;
    return temp;
};

//
//  P R I N T  I N T 3
//
//  Prints a 3 character integer to 'self'.
//  Developed by JPG (RA v2.2a)

void (float f) utils_print_int3 =
{
    local float n;
    local string s;

    n = rint(f);
    if (n < 0)
    {
        if (n < -99)
            sprint(self, "-99");
        else if (n > -10)
            sprint(self, " ");
    }
    else
    {
        if (n < 100)
            sprint(self, " ");
        if (n < 10)
            sprint(self, " ");
    }
    s = ftos(n);
    sprint(self, s);
};

void (entity client, float x) utils_sprint_time =
{
	local float minutes;
	local float seconds;
	local string temp;

	minutes = floor ((x / 60));
	seconds = floor ((x - (60 * minutes)));
	temp = ftos (minutes);
	sprint (client, temp);
	sprint (client, ":");
	temp = ftos (seconds);
	if ((seconds < TE_LAVASPLASH))
	{
		sprint (client, "0");
	}
	sprint (client, temp);
};

//
//  S E T  C V A R
//
//  Set the console variable 'var' to 'value'.
//
void (string var, float value) utils_set_cvar =
{
    local string temp;

    temp = ftos(value);
    cvar_set(var, temp);
};
