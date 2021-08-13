 //
// Observer.qc
// Developed by J.P. Grossman
// Contains code for handling observers.
//
// Fields used:
//
// .wait            - time to look for teleports when observing
// .trigger_field   - closest teleport entity; used when observing
// .t_wth           - activation radius for closest teleport
// .dest            - stores destination for popping forward
// .dest1           - stores velocity for popping forward
// .movetarget      - player being watched in observer mode (world if none)
// .delay           - time to refresh head's up display for observing
// .speed           - z component of velocity from previous frame (for fly)
// .state           - unique player id
// .lip             - id of player being watched (0 if none)
//

// function declarations

entity (entity e) observer_find_target;
void () observer_set_chase_position;
void (entity client) observer_disconnect_notify;
//void () SetNewParms2;
void () respawn;
//void () PutClientInServer;
void () observer_get_target;
void () WaterMove;
void () CheckWaterJump;
void () ra_impulse;


//
//  M I N 3
//
float (float a, float b, float c) utils_min3 =
{
    local float d;
    if (a < b)
        d = a;
    else
        d = b;
    if (d < c)
        return d;
    return c;
};

//
//  M I N
//
float (float a, float b) utils_min =
{
    if (a < b)
        return a;
    return b;
};

//
//  F I N D  T E L E P O R T
//
//  Find the closest teleport and remember it.  Called once every second.
//
void () observer_find_teleport =
{
    local entity e;
    local float d, mindist;
        
    // find the closest teleport
    mindist = 99999999;
    e = self.trigger_field = find(world, classname, "trigger_teleport");
    while (e)
    {
        d = vlen(self.origin - (e.mins + e.maxs) * 0.5);
        if (d < mindist)
        {
            mindist = d;
            self.trigger_field = e;
        }
        e = find(e, classname, "trigger_teleport");
    }
    e = self.trigger_field;

    // compute an 'activation radius'
    if (e)
        self.t_width = utils_min3(e.size_x, e.size_y, e.size_z) * 0.7;
};

//
//  C H E C K  T E L E P O R T
//
//  Check to see if on observer hit the closest teleport.
//

void () observer_check_teleport =
{
    local entity t;
    local vector d;

    t = self.trigger_field;
    if (!t)
        return;

    // Only check if the observer is not completely above/below the teleport
    if (self.absmin_z < t.absmax_z && self.absmax_z > t.absmin_z)
    {
        d = self.origin - (t.absmin + t.absmax) * 0.5;
        d_z = 0;
        if (vlen(d) < 24 + self.t_width)
        {
            // find the destination
            t = find(world, targetname, t.target);
            if (!t)
                return;

            
            makevectors(t.mangle);
            
            // move the observer
            setorigin(self, t.origin);
            self.angles = t.mangle;
            self.fixangle = 1;
            self.velocity = v_forward * 300;
            if (self.style & RA_OBSERVER_WALK)
                self.flags = self.flags - self.flags & FL_ONGROUND;
        }
    }
};

//
//  G E T  T A R G E T  F R O M  I D
//
//  Finds a player to watch given that player's ID, or world if that
//  player can't be found.
//

entity (float id) observer_get_target_from_id =
{
    local entity e;

    if (!id)
        return world;

    e = find(world, classname, "player");
    while (e)
    {
        if (e.state == id && !(e.style & RA_OBSERVER) )
            return e;
        e = find(e, classname, "player");
    }
    return world;
};

//
//  C L E A R  F L A G S
//
void () observer_clear_flags =
{
    self.style = self.style - self.style & (RA_OBSERVER_WALK | RA_OBSERVER_CHASE);
};

//
//  W A L K  S T A R T
//
void () observer_walk_start =
{
    observer_clear_flags();
    self.style = self.style | RA_OBSERVER_WALK;
    self.movetype = MOVETYPE_WALK;
    self.flags = self.flags - self.flags & FL_ONGROUND;
    self.view_ofs = '0 0 22';
    //stuffcmd(self, "cl_nolerp 0\n");    
};

//
//  C H A S E  S T A R T
//
void () observer_chase_start =
{    
    if ((!self.movetarget)||(self.movetarget == world))
    {
        // see if we can find a target to chase
        self.movetarget = observer_find_target(world);
        
        if ((!self.movetarget)||(self.movetarget == world))
        {
            sprint(self, "no chase target found\n");
            observer_walk_start();
            return;
        }
        self.delay = 0;
        self.lip = self.movetarget.state; // store the target ID
    }
    
    observer_clear_flags();
    
    self.style = (self.style | RA_OBSERVER_CHASE);
    self.movetype = MOVETYPE_FLY;
    self.flags = self.flags - self.flags & FL_ONGROUND;
    self.view_ofs = '0 0 0';
    makevectors(self.angles);
    self.angles = self.movetarget.v_angle;
    observer_set_chase_position();    
    sprint(self,"\n\b[\bFIRE\b]\b FREELOOK\n\b[\bJUMP\b]\b NEXT PLAYER\n");
};

//
//  S T A R T
//
//  Enter observer mode.
//
void () observer_start =
{
    if (self == winner || self == loser) 
       {
       	sprint(self,"you are already in the arena\n");
        return;
       }
           
    if (self.deadflag != DEAD_NO)
    {
        if (self.deadflag >= DEAD_DEAD) respawn();
        
        return;
    }

    self.style = (self.style | RA_OBSERVER);

    self.takedamage = DAMAGE_NO;
    self.solid      = SOLID_NOT;
    self.effects    = 0;

    // status bar stuff
    self.health       = 100;
    self.items        = 0;
    self.armorvalue   = 0;
    self.ammo_shells  = 0;
    self.ammo_nails   = 0;
    self.ammo_rockets = 0;
    self.ammo_cells   = 0;
    self.currentammo  = 0;
    //self.frags        = -99;//dont reset frags between rounds
    self.show_hostile = 0;
    self.movetarget   = world;

    // model and view offset
    self.model       = string_null;
    self.weaponmodel = string_null;
    self.view_ofs    = '0 0 22';
    self.nextthink   = -1;    // thinking is used to animate client models
    self.think       = SUB_Null;
    setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);

    // teleport stuff
    observer_find_teleport();
    self.wait = time + 1;
    // which player is being watched
    self.movetarget = observer_get_target_from_id(self.lip);
    self.delay      = 0;
        
    observer_chase_start();
    
    // Check to see if anyone was observing this client
    observer_disconnect_notify(self);        
};

//
//  O B S E R V E R  E N D
//
//  Return to normal player mode.
//
void () observer_end =
{    
    self.style = self.style - (self.style & RA_OBSERVER);
    self.dest1 = self.dest2 = self.dest = self.mangle = '0 0 0';
    //self.frags = 0;    
    //SetNewParms2();
    //PutClientInServer();
};

//
//  P O P  F O R W A R D
//
//  Move forward 100 units if possible.
//
void () observer_pop_forward =
{
    local vector newpos;

    makevectors(self.angles);
    newpos   = v_forward;
    newpos_z = 0;
    newpos   = newpos * (100 / vlen(newpos));
    newpos   = newpos + self.origin;
    
    if (pointcontents(newpos) != CONTENT_SOLID) setorigin(self, newpos);
};

//
//  P O P  D O W N
//
//  Move down 100 units if possible.
//
void () observer_pop_down =
{
    local vector newpos;

    newpos = self.origin + '0 0 -100';
    if (pointcontents(newpos) != CONTENT_SOLID) setorigin(self, newpos);
};

//
//  P O P  U P
//
//  Move up 100 units if it is possible to do so.
//
void () observer_pop_up =
{
    local vector newpos;

    newpos = self.origin + '0 0 100';
    if (pointcontents(newpos) != CONTENT_SOLID) setorigin(self, newpos);
};

//
//  F I N D  T A R G E T
//
//  Returns the next watch target after the given entity.
//
entity (entity e) observer_find_target =
{
    local entity targ;

    
    
    
    if (e.classname != "player" || e.style & RA_OBSERVER || !winner || !loser)        
    {
        e = world;
    }
    
    targ = find(e, classname, "player");
    
    while (targ != e && (!targ || targ.style & RA_OBSERVER || !winner || !loser))
    {
        targ = find(targ, classname, "player");
    }
    
    

    
    
    if (targ.classname == "player") return targ;
    
    else
    
    targ = find(world, classname, "info_intermission");
          
    if (targ) return targ;    
    
    else
    
    return world;   
     
};

//
//  N E X T  T A R G E T
//
//  Get the next target to watch.
//
void () observer_next_target =
{

    self.movetarget = observer_find_target(self.movetarget);
    if (self.movetarget)
    {
        // Get the target's ID
        self.lip = self.movetarget.state;
    }
    else
        self.lip = 0;

    // Force an immediate update of the heads-up display
    self.delay = 0;    
};

//
//  P R E V  T A R G E T
//
//  Get the previous target to watch.
//
void () observer_prev_target =
{
    local entity e, curr;

    if ((!self.movetarget)||(self.movetarget == world))
    {
        observer_next_target();
        return;
    }

    curr = self.movetarget;
    if (curr.style & RA_OBSERVER || curr.classname != "player")
        
    {
        self.movetarget = curr = observer_find_target(curr);
    }
    e = observer_find_target(curr);
    while (e != curr)
    {
        self.movetarget = e;
        e = observer_find_target(e);
    }
    if (self.movetarget)
    {
        //Get the target's ID
        self.lip = self.movetarget.state;
    }
    else
        self.lip = 0;

    // Force an immediate update of the heads-up display
    self.delay = 0;    
};

//
//  G E T  T A R G E T
//
//  Looks for a client in the line of sight.
//
void () observer_get_target =
{
    local entity e, targ;
    local float score, bestscore, dotprod;
    local vector v;

    makevectors(self.v_angle);

    bestscore = 99999999;
    targ = world;
    e = find(world, classname, "player");
    while (e)
    {
        if (!(e.style & RA_OBSERVER))
        {
            // The 'score' of a potential target is computed in the
            // following ad-hoc manner.  Lower scores are better.  I
            // arrived at the following through trial and error; it works
            // pretty well.
            v = e.origin - self.origin;
            score = vlen(v); // distance to target
            v = normalize(v);
            traceline(self.origin, e.origin - 48 * v, FALSE, self);
            if (trace_fraction == 1.0)
            {
                dotprod = v * v_forward;
                if (dotprod > 0.9) // reject players too far from view center
                {
                    // score is a combination of distance and angle
                    // (lower distances/angles are better)
                    score = score * (1 - dotprod);
                    if (score < bestscore)
                    {
                        bestscore = score;
                        targ = e;
                    }
                }
            }
        }
        e = find(e, classname, "player");
    }
    if (targ)
    {
        self.movetarget = targ;
        self.lip = targ.state;  // Get the target's ID
        self.delay = 0;         // Force update of heads-up display
    }
};

//
//  M O V E  T O  T A R G E T
//
//  Used to locate the player being watched in walk/fly mode.  Tries to
//  position the observer behind, to the right, in front of, and to the
//  left of the target in that order.
//
void () observer_move_to_target =
{
    local vector newpos;
    local vector newangles;

    if ((!self.movetarget) || (self.movetarget==world)) return;

    newangles_x = newangles_z = 0;
    newangles_y = self.movetarget.angles_y;
    makevectors(newangles);
    newpos = self.movetarget.origin - 50 * v_forward;
    if (pointcontents(newpos) == CONTENT_SOLID)
    {
        newangles_y = newangles_y + 90;
        newpos = self.movetarget.origin + 50 * v_right;
    }
    if (pointcontents(newpos) == CONTENT_SOLID)
    {
        newangles_y = newangles_y + 90;
        newpos = self.movetarget.origin + 50 * v_forward;
    }
    if (pointcontents(newpos) == CONTENT_SOLID)
    {
        newangles_y = newangles_y + 90;
        newpos = self.movetarget.origin - 50 * v_right;
    }

    // If we've found a spot then put the observer there
    if (pointcontents(newpos) != CONTENT_SOLID)
    {
        setorigin(self, newpos);
        self.angles = newangles;
        self.fixangle = 1;
    }
};

//
//  D I S C O N N E C T  N O T I F Y
//
//  Called when a client disconnects or becomes an observer.  Used to
//  update the watch target for any observers that were watching this client.
//
void (entity client) observer_disconnect_notify =
{
    local entity e, oself;

    e = find(world, classname, "player");
    while (e)
    {
        if (e.style & RA_OBSERVER && e.lip == client.state)
        {
            oself = self;
            self = e;
            observer_next_target();
            if (!self.movetarget && self.style & RA_OBSERVER_CHASE)
            {                
                observer_walk_start();
            }
            self = oself;
        }
        e = find(e, classname, "player");
    }
};

//
//  R E M O V E  T A R G E T
//
//  Don't watch anyone; get rid of the heads up display.
//
void () observer_remove_target =
{
    self.movetarget = world;
    self.delay = 0;
    self.lip = 0;
};

//
//  S E T  C H A S E  P O S I T I O N
//
//  Called every frame for observers in chase mode.  Used to position
//  the observer behind the player being chased.
//
//  Chase cameras are tricky business - they are notoriously choppy.
//  This choppines is due to two problems:
//
//  1.  The network protocol quantizes angles into 256 discreet values.
//      The client, on the other hand, can set the angle (through user
//      input) much more precisely.  Hence, the chase target's view
//      angle is constantly being rounded off.
//
//  2.  The client side doesn't use the exact positions sent by the server
//
//  To address problem 1, we quantize the angles of the player being chased
//  *before* using them to calculate the new position.  This ensures that
//  the player being watched will stay in the center of the screen and will
//  not jitter back and forth due to angle roundoff.
//
//  To address problem 2, we stuff "cl_nolerp 1" into the client when they
//  enter chase mode.
//
void () observer_set_chase_position =
{
    local vector pos;
    local float da;
    local vector angle;

    // First quantize the player's angle so that the angle we use here will
    // be the same as the one used by the client (after the angle has been
    // garbled by the network protocol)
    //
    angle_x = 360.0 / 65536.0 * rint(self.movetarget.v_angle_x * 65536.0 / 360.0);
    angle_y = 360.0 / 65536.0 * rint(self.movetarget.v_angle_y * 65536.0 / 360.0);
    angle_z = 0;

    // The "ideal" position is 40 units behind and 85 units above the
    // chase target.  To deal with walls and ceilings, we first trace a
    // line 50 units backwards and then move 80% of the way along the
    // part of the line that was traced.  We then trace a line 100 units up
    // and move 85% of the way along the part that was traced.
    //
    makevectors(angle);
    pos = self.movetarget.origin;
    traceline(pos, pos + 50 * v_up, TRUE, self.movetarget);
    pos = pos + (trace_fraction * 40) * v_up;
    traceline(pos, pos - 100 * v_forward, TRUE, self.movetarget);
    pos = pos - (trace_fraction * 85) * v_forward;
    setorigin(self, pos);
    self.velocity = self.movetarget.velocity;

    if (self.button0) return;  // freelook; don't set the viewing angle

    // Set the new angles.  The 0.1 angles are subtracted to ensure
    // that self.angles will get rounded off to angle (which was obtained
    // by rounding off self.movetarget.v_angles).  Don't ask me why you
    // have to subtract; logic dictates that you should be adding.  But
    // I tried adding and it didn't work; I tried subtracting and it did.
    // Take it up with id.
    //
    self.angles = angle - '0.1 0.1 0.1';    
    self.angles_z = 0;
    self.fixangle = TRUE;
};

//
//  C Y C L E  M O D E
//
void () observer_cycle_mode =
{
    if (self.style & RA_OBSERVER_WALK)
        observer_chase_start();
    else
        observer_walk_start();
};


//
//  I M P U L S E
//

void () observer_impulse =
{

    if  ((self.impulse == 1) && (self.style & RA_OBSERVER_CHASE))
	{	
	  observer_next_target ();         	  
	  self.impulse = 0;
	}
	
    else
    
    if  ((self.impulse == 2) && (self.style & RA_OBSERVER_CHASE))
	{	
	  observer_prev_target ();         	  
	  self.impulse = 0;
	}	    

    else
    
    ra_impulse();    
};

//
//  J U M P
//
//  Modified version of PlayerJump in Client.qc
//  Fast movement in water/slime/lava; no sounds.
//
//  jump is TRUE if 'jump' was just pressed, FALSE if it is being
//  held down.
//
void (float jump) observer_jump =
{
        
    if (self.flags & FL_WATERJUMP) return;

    if (self.waterlevel >= 2)
	{
        if (self.waterlevel == 3)
            self.velocity_z = 320;
        else
            self.velocity_z = 100;
	return;
	}

    if (!(self.flags & FL_ONGROUND) || !jump) return;

    self.flags = self.flags - FL_ONGROUND;	// don't stairwalk
    self.velocity_z = 270;
};

//
//  C H E C K  S I Z E
//
//  If an observer gets caught in a door/platform etc, their size can
//  be set to zero.  This routine is called once every second to make
//  sure that this doesn't last.
//
void () observer_check_size =
{
    if (self.maxs_x < 16 || self.maxs_y < 16)
        setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
};

//
//  U P D A T E  S T A T U S  B A R
//
//  Copy the chasetarget's status into the observer's status bar.
//
void () observer_update_status_bar =
{
    if (self.movetarget == world)
    {
        self.health = 100;
        self.items = 0;
        self.armorvalue = 0;
        self.ammo_shells = 0;
        self.ammo_nails = 0;
        self.ammo_rockets = 0;
        self.ammo_cells = 0;
        self.currentammo = 0;
        self.show_hostile = 0;
        self.weapon = 0;
    }
    else
    {
        self.health = self.movetarget.health;
        self.items = self.movetarget.items;
        self.armorvalue = self.movetarget.armorvalue;
        self.ammo_shells = self.movetarget.ammo_shells;
        self.ammo_nails = self.movetarget.ammo_nails;
        self.ammo_rockets = self.movetarget.ammo_rockets;
        self.ammo_cells = self.movetarget.ammo_cells;
        self.currentammo = self.movetarget.currentammo;
        self.show_hostile = self.movetarget.show_hostile;
        self.weapon = self.movetarget.weapon;
    	if ((self.health) <= 0) 
           { 
            self.health = 1000;
           }
    }
    
    
};

//
//  F L Y  M O V E
//
//  Called every frame for observers in Fly mode.
//
void () observer_fly_move =
{
    local float dz, zvel, right_coef, forward_coef, norm;
    local vector f;

    // Check if the observer is pressing up or down by looking at the
    // change in velocity_z.  zvel is set to 1 if the observer is pressing
    // up (or jump), -1 if the observer is pressing down, and 0 otherwise.
    // Note that velocity_z can change as a result of hitting the ground/
    // ceiling, so it is necessary to verify that the change in velocity_z
    // has the same sign as velocity_z.
    //
    dz = self.velocity_z - self.speed;
    if (self.button2 || (dz > 0 && self.velocity_z > 0))
        zvel = 1;
    else if (dz < 0 && self.velocity_z < 0)
        zvel = -1;
    else
        zvel = 0;

    // If there is no horizonal movement, then move up/down.
    if (!self.velocity_x && !self.velocity_y)
    {
        self.speed = self.velocity_z = zvel * 300;
        return;
    }

    // Project the velocity onto the xy plane.  v_right gives one basis
    // vector for the xy plane; '-vright_y vright_x 0' gives the other one
    // (in the forward direction).  The resulting forward component gives
    // the forward component of motion, which will be in the v_forward
    // direction.  The orthogonal component gives the strafing component
    // of motion, which will be in the v_right direction.  Note that if
    // the player is pointing up or down the forward component will appear
    // smaller (since the magnintude of the forward component is the length
    // of v_foward projected onto the xy plane).  The purpose of dividing
    // by vlen(f) is to compensate for this.
    //
    makevectors(self.v_angle);
    f = v_forward;
    f_z = 0;
    right_coef = self.velocity * v_right;
    forward_coef = self.velocity_y * v_right_x - self.velocity_x * v_right_y;
    forward_coef = forward_coef / vlen(f);
    self.velocity = right_coef * v_right + forward_coef * v_forward;

    // Now compute the observer's velocity by taking zvel into account
    // and imposing a maximum speed limit.
    norm = vlen(self.velocity);
    if (zvel)
    {
        if (norm > 280)
            self.velocity = self.velocity * (280 / norm);
        self.velocity_z = 150 * zvel;
    }
    else if (norm > 320)
        self.velocity = self.velocity * (320 / norm);

    self.speed = self.velocity_z;
};

void () observer_pre_think =
{
    local float jump;
    
    if (self.button2)
    {
                
        if (self.flags & FL_JUMPRELEASED)
        {
            jump = TRUE;
            self.flags = self.flags - FL_JUMPRELEASED;
        }
        else
            jump = FALSE;
    }
    else
    {
        jump = FALSE;
        self.flags = self.flags | FL_JUMPRELEASED;
    }

     if (self.style & RA_OBSERVER_WALK && !self.button0)
        {
            WaterMove ();
    
            if (self.waterlevel == 2)
                CheckWaterJump ();
    
            if (self.button2)
                observer_jump(jump);
    
            self.movetype = MOVETYPE_WALK;
        }
        
        else
        
        {
            observer_fly_move();
            self.flags = self.flags | FL_ONGROUND;
            self.movetype = MOVETYPE_FLY;            
        }

        observer_check_teleport();
        // Update the status bar every frame
   
        observer_update_status_bar();
     
    
};

//
//  P O S T  T H I N K
//
//  Called from PlayerPostThink in Client.qc
//
void () observer_post_think =
{
    if (self.style & RA_OBSERVER_CHASE)
    	{
         observer_set_chase_position();
         if (!(self.see_motd)) centerprint(self,"\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n",self.movetarget.netname,"\n");
         if (self.button2)
         {
	  observer_next_target();
	  stuffcmd(self, "-jump\n");
	  stuffcmd(self, "-jump\n");
         }
        }
    

    // When an observer touches a door they are not teleported through
    // the door immediately as this doesn't seem to work.  Instead, the
    // POP_FORWARD flag is set and they are teleported through the next
    // time observer_post_think is called.
    //
    if (self.style & RA_POP_FORWARD)
    {
        self.style = self.style - RA_POP_FORWARD;
        setorigin(self, self.dest);
        self.velocity = self.dest1;
    }
    
    if (self.impulse) observer_impulse();//observer_impulse();
};

//
//  D O O R  T O U C H
//
//  Called from door_touch in Doors.qc.  When an observer in walk or
//  fly mode touches a door, their POP_FORWARD flag is set when it is
//  possible to teleport them through the door.  The global variable
//  'other' points to the player that touched the door.
//
void () observer_door_touch =
{
    local float temp;
    
    // Ignore observers that are in chase mode or who are above the door
    if (other.origin_z > self.absmax_z || self.style & RA_OBSERVER_CHASE)
        return;

    temp = utils_min(self.size_x, self.size_y) + 40;
    other.dest1 = other.dest = other.velocity;
    other.dest_z = 0;
    other.dest = other.dest * (temp / vlen(other.dest));
    other.dest = other.origin + other.dest;
    if (pointcontents(other.dest) != CONTENT_SOLID)
        other.style = other.style | RA_POP_FORWARD;
};
