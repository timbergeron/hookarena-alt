void () SetNewParms2;
void() GibPlayer;
void (entity client) observer_disconnect_notify;
// prototypes
void () W_WeaponFrame;
void () W_SetCurrentAmmo;
void () player_pain;
void () player_stand1;
void (vector org) spawn_tfog;
void (vector org, entity death_owner) spawn_tdeath;

float	modelindex_eyes, modelindex_player;
/*
=============================================================================

				LEVEL CHANGING / INTERMISSION

=============================================================================
*/


/*QUAKED info_intermission (1 0.5 0.5) (-16 -16 -16) (16 16 16)
This is the camera point for the intermission.
Use mangle instead of angle, so you can set pitch or roll as well as yaw.  'pitch roll yaw'
*/
void() info_intermission =
{
};


void() SetChangeParms =
{
	if (self.health <= 0)
	{
	 SetNewParms2 ();
	 return;
	}
        
	if (self.health > 100) self.health = 100;
	if (self.health < 50) self.health = 50;
		
	parm1  = self.items;
	parm2  = self.health;
	parm3  = self.armorvalue;

	if (self.ammo_shells < 25) 
	   parm4  = 25;
	   else
	   parm4  = self.ammo_shells;
	
	parm5  = self.ammo_nails;
	parm6  = self.ammo_rockets;
	parm7  = self.ammo_cells;
	parm8  = self.weapon;
	parm9  = self.armortype * 100;
	parm10 = self.style;      
	parm11 = self.state;    // player ID
        parm12 = self.lip;      // ID of player being watched in observer mode

};

void() SetNewParms =
{
	
// Start Added for the Grappling Hook (Changed don't want hook as observer)  -- woods
	
// old code	parm1 = IT_AXE;
	
	
	
	
	parm1 = IT_AXE;
	
// End Added for the Grappling Hook (Changed)  -- woods
	
	parm2 = 100;
	parm3 = 0;
	parm4 = 0;
	parm5 = 0;
	parm6 = 0;
	parm7 = 0;
	parm8 = 4096;
	parm9 = 0;
	// RA Observer Code by JPG -start-	
	parm10 = NEW_CLIENT;
        parm11 = 0; // player ID
        parm12 = 0; // ID of player being watched in observer mode
	// RA Observer Code by JPG -end-
};

void () SetArenaParms =
{
 
// Start Added for the Grappling Hook   -- woods
 
// old code   parm1 = ((((((((IT_SHOTGUN | IT_AXE) | IT_ROCKET_LAUNCHER) | IT_ARMOR3) | IT_SUPER_SHOTGUN) | IT_NAILGUN) | IT_GRENADE_LAUNCHER) | IT_LIGHTNING) | IT_SUPER_NAILGUN) | IT_ARMOR3;
   
  
   
   parm1 = (((((((((IT_SHOTGUN | IT_AXE) | IT_MORNINGSTAR) | IT_ROCKET_LAUNCHER) | IT_ARMOR3) | IT_SUPER_SHOTGUN) | IT_NAILGUN) | IT_GRENADE_LAUNCHER) | IT_LIGHTNING) | IT_SUPER_NAILGUN) | IT_ARMOR3;
   
// End Added for the Grappling Hook   -- woods
   
   parm2 = 100;
   parm3 = 200;
   parm4 = 100;
   parm5 = 100;
   parm6 = 100;
   parm7 = 100;
   parm8 = 32;
   parm9 = 80.000999;   
   parm10 = self.style;   
};

void () SetNewParms2 =
{   
   
// Start Added for the Grappling Hook (Changed dont want hook as observer)  -- woods
   
// old code   parm1  = IT_AXE;
   
   parm1  = IT_AXE;
   
// End Added for the Grappling Hook (Changed)  -- woods

   parm2  = 100;
   parm3  = 0;
   parm4  = 0;
   parm5  = 0;
   parm6  = 0;
   parm7  = 0;
   parm8  = 0;
   parm9  = 0;
   parm10 = self.style;      
};

void() DecodeLevelParms =
{
	if (serverflags)
	{
		if (world.model == "maps/start.bsp")
			SetNewParms ();		// take away all stuff on starting new episode
	}
	
        self.style = parm10;
        self.state = parm11;	
        self.lip   = parm12;	
	
	SetNewParms2();
	
	self.items        = parm1;
	self.health       = parm2;
	self.armorvalue   = parm3;
	self.ammo_shells  = parm4;
	self.ammo_nails   = parm5;
	self.ammo_rockets = parm6;
	self.ammo_cells   = parm7;
	self.weapon       = parm8;
	self.armortype    = parm9 * 0.01;
	self.style        = parm10;
};

/*
============
FindIntermission

Returns the entity to view from
============
*/
entity() FindIntermission =
{
	local	entity spot;
	local	float cyc;

// look for info_intermission first
	spot = find (world, classname, "info_intermission");
	if (spot)
	{	// pick a random one
		cyc = random() * 4;
		while (cyc > 1)
		{
			spot = find (spot, classname, "info_intermission");
			if (!spot)
				spot = find (spot, classname, "info_intermission");
			cyc = cyc - 1;
		}
		return spot;
	}

// then look for the start position
	spot = find (world, classname, "info_player_start");
	if (spot)
		return spot;
	
// testinfo_player_start is only found in regioned levels
	spot = find (world, classname, "testplayerstart");
	if (spot)
		return spot;
	
	objerror ("FindIntermission: no spot");
	return world;
};


string nextmap;
void() GotoNextMap =
{
	changelevel (nextmap);
};

void() ExitIntermission =
{
// skip any text in deathmatch
	if (deathmatch)
	{
		bprint("\nLoading Map...Please Wait.\n");
		GotoNextMap ();
		return;
	}
	
	intermission_exittime = time + 1;
	intermission_running = intermission_running + 1;
};

/*
============
IntermissionThink

When the player presses attack or jump, change to the next level
============
*/
void() IntermissionThink =
{
	if (time < intermission_exittime)
		return;

	if (!self.button0 && !self.button1 && !self.button2)
		return;
	
	ExitIntermission ();
};

void() execute_changelevel =
{
	local entity	pos;

	intermission_running = 1;
	lightstyle(0, "f");// DIM THE LIGHTING	
        
        // enforce a wait time before allowing changelevel
	if (deathmatch)
		intermission_exittime = time + 5;
	else
		intermission_exittime = time + 2;
	
	pos = FindIntermission ();

	other = find (world, classname, "player");
	while (other != world)
	{
		other.view_ofs   = '0 0 0';
		other.angles     = other.v_angle = pos.mangle;
		other.fixangle   = TRUE;		// turn this way immediately
		other.nextthink  = time + 0.5;
		other.takedamage = DAMAGE_NO;
		other.solid      = SOLID_NOT;
		other.movetype   = MOVETYPE_NONE;
		other.modelindex = 0;		
		setorigin (other, pos.origin);
		
		other = find (other, classname, "player");
	}	

	WriteByte (MSG_ALL, SVC_INTERMISSION);
};


void() changelevel_touch =
{
 return;
};

/*QUAKED trigger_changelevel (0.5 0.5 0.5) ? NO_INTERMISSION
When the player touches this, he gets sent to the map listed in the "map" variable.  Unless the NO_INTERMISSION flag is set, the view will go to the info_intermission spot and display stats.
*/
void() trigger_changelevel =
{
 return;
};


/*
=============================================================================

				PLAYER GAME EDGE FUNCTIONS

=============================================================================
*/

void() set_suicide_frame;

// called by ClientKill and DeadThink

void() respawn =
{	
	SetNewParms2();
	// respawn		
        PutClientInServer ();	
};

/*
============
ClientKill

Player entered the suicide command
============
*/
void() ClientKill =
{
 return;	
};

float() CheckSpawnPoint =
{
 return FALSE;
};

/*
============
SelectSpawnPoint

Returns the entity to spawn at
============
*/

entity(string cname, float spawns) SelectSpawnPoint =
{
	local	entity spot;
	local	entity thing;	
   	local   float  pcount;        
        
        pcount = random() * (spawns - 0.001);
   	pcount = floor(pcount);
           	
   	spot = find(world, classname, cname);
        lastspawn = spot;

   	while (pcount > 0) 
   	{
    	spot = find(spot, classname, cname);

      	if (spot != world) 
        	pcount = pcount - 1;
  	}
   	
   	while (TRUE) 
   	{
 	 if (spot != world) 
      	 {
		if (spot == self.trigger_field)
            	pcount = 1;
         	else 
         	{
            	thing = findradius(spot.origin, 64);

            	while (thing) 
            	{
			if (((thing.classname == "player") && (thing.style & RA_CONNECTED)) && (!(thing.style & RA_OBSERVER))) 
               		{
                  		pcount = 1;
                  		thing = world;
               		}
              	 	else
                  		thing = thing.chain;
             	}
         }

        	if (pcount == 0) return spot;
         
         	pcount = 0;
      	}
      	
      	spot = find(spot, classname, cname);

      	if (spot == lastspawn) 
      	{
         	pcount = 0;
         	thing = findradius(self.trigger_field.origin, 32);

         	while (thing) 
         	{
		 if (((thing.classname == "player") && (thing.style & RA_CONNECTED)) && (!(thing.style & RA_OBSERVER))) 
            	{
               		pcount = 1;
               		thing = world;
            	}
            	else
               		thing = thing.chain;
         	}

         	if (pcount == 0) 
         		return self.trigger_field;
         
         	return lastspawn;
		}
	}


	spot = find (world, classname, "info_player_start");
	if (!spot)
		error ("PutClientInServer: no info_player_start on level");
	
	return spot;
};

void() player_touch =
{	
	local float up;	
        		
	if ((other.solid == SOLID_BSP) && (self.button2) && (!(self.style & RA_OBSERVER)) )
	   {	    
	    up = vlen (self.velocity);            
	    
	    if (up < 50)
	       {
	         if ((!self.flags & FL_ONGROUND)) self.flags = self.flags + FL_ONGROUND;                
	         return; 	        
	       }
	   }
	
	if (other.classname != "player") return;
		
	if (other.health <= 0) return;
		
	if ((!other.flags & FL_ONGROUND) && (other.absmin_z >= self.absmax_z - 2))
	   other.flags = other.flags + FL_ONGROUND;
};

/*
===========
PutClientInServer

called each time a player is spawned
============
*/
void() DecodeLevelParms;
void() PlayerDie;

void() PutClientInArena =
{
	local entity spot;        
 
         //remove observer stuff---------
         if (self.style & RA_OBSERVER) 
         self.style        = self.style - (self.style & RA_OBSERVER);
         
         self.dest1        = self.dest2 
                            = self.dest 
                            = self.mangle 
                            = '0 0 0';
         //--convert to player-----------                   
         
         //spot = find(world, classname, "info_teleport_destination");
         spot = SelectSpawnPoint ("info_teleport_destination",ra_spawns);
         self.trigger_field= spot;
         
	 self.touch        = player_touch;
	 self.classname    = "player";
	 self.health       = 100;
	 self.takedamage   = DAMAGE_NO;
         self.solid        = SOLID_SLIDEBOX;
	 self.movetype     = MOVETYPE_WALK;	 
	 self.max_health   = 100;
	 self.flags        = FL_CLIENT;	 
	 self.dmg          = 2;   		// initial water damage
	 self.air_finished = time + 12;
         self.effects      = 0;
         
	 //--make him phat----------------
	 
	 
	// Start Added for the Grappling Hook  -- woods
	 
	 
	
	// old code  self.items        = ((((((((IT_SHOTGUN | IT_AXE) | IT_ROCKET_LAUNCHER) | IT_ARMOR3) | IT_SUPER_SHOTGUN) | IT_NAILGUN) | IT_GRENADE_LAUNCHER) | IT_LIGHTNING) | IT_SUPER_NAILGUN) | IT_ARMOR3;
	 
	 self.items        = (((((((((IT_SHOTGUN | IT_AXE) | IT_MORNINGSTAR) | IT_ROCKET_LAUNCHER) | IT_ARMOR3) | IT_SUPER_SHOTGUN) | IT_NAILGUN) | IT_GRENADE_LAUNCHER) | IT_LIGHTNING) | IT_SUPER_NAILGUN) | IT_ARMOR3;
	
	// End Added for the Grappling Hook  -- woods
	
	 self.health       = 100;
	 self.armorvalue   = 200;
	 self.ammo_shells  = 100;
	 self.ammo_nails   = 100;
	 self.ammo_rockets = 100;
	 self.ammo_cells   = 100;
	 self.weapon       = 32;
	 self.armortype    = (80.000999) * 0.01;         
         //--lock*&*load-----
  	 W_SetCurrentAmmo ();

	 self.attack_finished = time;
	 self.th_pain         = player_pain;
	 self.th_die          = PlayerDie;
	
	 self.deadflag  = DEAD_NO;
         
	 self.pausetime = 0;// paustime is set by teleporters to keep the player from moving a while
	 self.origin    = spot.origin + '0 0 1';
	 self.angles    = spot.angles;
	 self.fixangle  = TRUE;		// turn this way immediately
         self.velocity  = '0 0 0'; 
         self.velocity  = v_forward * 300;
	 setmodel (self, "progs/player.mdl");
	 
	 if (modelindex_player==0) modelindex_player = self.modelindex;

	 setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
	 player_stand1 ();
	 self.view_ofs = '0 0 28';//default was 22 :) taller!
	 self.height = (self.team) - 1;
         	 
	 makevectors(self.angles);
	 spawn_tdeath (self.origin, self);	 
	 spawn_tfog (self.origin);	 
};

void() PutClientInServer =
{
	local entity spot;        
        
        spot = SelectSpawnPoint ("info_player_deathmatch",dm_spawns);
        self.trigger_field = spot;
        
	 self.touch        = player_touch;
	 self.classname    = "player";
	 self.health       = 100;
	 self.takedamage   = DAMAGE_NO; //crt	 
         self.solid        = SOLID_SLIDEBOX;
	 self.movetype     = MOVETYPE_WALK;	 
	 self.max_health   = 100;
	 self.flags        = FL_CLIENT;	 
	 self.dmg          = 2;   		// initial water damage
	 self.air_finished = time + 12;
         self.effects      = 0;
         
	 DecodeLevelParms ();
  	 W_SetCurrentAmmo ();

	 self.attack_finished = time;
	 self.th_pain         = player_pain;
	 self.th_die          = PlayerDie;
	
	 self.deadflag  = DEAD_NO;
         
	 self.pausetime = 0;// paustime is set by teleporters to keep the player from moving a while
         	 
	 self.origin    = spot.origin + '0 0 1';
	 self.angles    = '0 0 0';
	 self.angles    = spot.angles;
	 self.fixangle  = TRUE;		// turn this way immediately
         self.velocity  = '0 0 0'; 
         
	 setmodel (self, "progs/player.mdl");
	 
	 if (modelindex_player==0) modelindex_player = self.modelindex;

	 setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
	
	 self.view_ofs = '0 0 22';//make taller
	 self.height = (self.team) - 1;
                
	 player_stand1 ();	
	 makevectors(self.angles);
	 
	 
	 
	 
	 

	
	 
	 
	 
	 
	 if (self.netname == "unconnected") return;         
                  
         self.style = self.style | RA_CONNECTED;        
         
         observer_start();// non contestants forced observers                  
	 
	 InitLineUp();         
};



 // Added this new function to allow for change to old observer style -- woods

void() PutClientInServerReg =
{
	local entity spot;        
        
        spot = SelectSpawnPoint ("info_player_deathmatch",dm_spawns);
        self.trigger_field = spot;
        
	 self.touch        = player_touch;
	 self.classname    = "player";
	 self.health       = 100;
	 self.takedamage   = DAMAGE_NO; //crt	 
         self.solid        = SOLID_SLIDEBOX;
	 self.movetype     = MOVETYPE_WALK;	 
	 self.max_health   = 100;
	 self.flags        = FL_CLIENT;	 
	 self.dmg          = 2;   		// initial water damage
	 self.air_finished = time + 12;
         self.effects      = 0;
         
	 DecodeLevelParms ();
  	 W_SetCurrentAmmo ();

	 self.attack_finished = time;
	 self.th_pain         = player_pain;
	 self.th_die          = PlayerDie;
	
	 self.deadflag  = DEAD_NO;
         
	 self.pausetime = 0;// paustime is set by teleporters to keep the player from moving a while
         	 
	 self.origin    = spot.origin + '0 0 1';
	 self.angles    = '0 0 0';
	 self.angles    = spot.angles;
	 self.fixangle  = TRUE;		// turn this way immediately
         self.velocity  = '0 0 0'; 
         
	 setmodel (self, "progs/player.mdl");
	 
	 if (modelindex_player==0) modelindex_player = self.modelindex;

	 setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
	
	 self.view_ofs = '0 0 22';//make taller
	 self.height = (self.team) - 1;
                
	 player_stand1 ();	
	 makevectors(self.angles);
	 
	 
	 
	 
	 

	
	 
	 
	 
	 
	 if (self.netname == "unconnected") return;         
                  
         self.style = self.style | RA_CONNECTED;        
         
     //    observer_start();  // non contestants forced observers  --woods (do not force in this function.. and do not init lineup)                
	 
	          
};


 // End Added this new function to allow for change to old observer style -- woods























void() info_player_start =
{
};

void() info_player_start2 =
{
};

void() testplayerstart =
{
};

void() item_arena_rune =
{

};

void() info_player_deathmatch =
{
 dm_spawns = (dm_spawns + 1.00);
};

void() info_player_coop =
{
};


/*
===============================================================================

RULES

===============================================================================
*/

/*
go to the next level for deathmatch
only called if a time or frag limit has expired ..or if a vote happens -- woods
*/
void() NextLevel =
{
	local entity o;
//crt
	     	if (mapname == "arenax") nextmap = "xarena3";
	else if (mapname == "xarena3") nextmap = "arenazap";
	else if (mapname == "arenazap") nextmap = "arenarg4";
	else if (mapname == "arenarg4") nextmap = "arenarg5";
	else if (mapname == "arenarg5") nextmap = "arenarg6";
	else if (mapname == "arenarg6") nextmap = "crandome";
	else if (mapname == "crandome") nextmap = "egyptra";
	else if (mapname == "egyptra") nextmap = "bbarena2";
	else if (mapname == "bbarena2") nextmap = "dm2arena";
	else if (mapname == "dm2arena") nextmap = "marena2";
	else if (mapname == "marena2") nextmap = "rarena3";
	else if (mapname == "rarena3") nextmap = "23ar-a";
	else if (mapname == "23ar-a") nextmap = "basarena";
	else if (mapname == "basarena") nextmap = "chamber1";
	else if (mapname == "chamber1") nextmap = "gear8";
	else if (mapname == "gear8") nextmap = "ptucket";
	else if (mapname == "ptucket") nextmap = "yard1";
	else if (mapname == "yard1") nextmap = "mayan1";
	else if (mapname == "mayan1") nextmap = "rgarden";
	else if (mapname == "rgarden") nextmap = "arenax";

  // added by woods so maps out of rotation do not get stuck on server

      else nextmap = "arenax";


	gameover = TRUE;

	o = spawn();
	o.map = nextmap;
	o.think = execute_changelevel;
	o.nextthink = time + 0.1;
};
/*
============
CheckRules

Exit deathmatch games upon conditions
============
*/
void() CheckRules =
{
	local	float		timelimit;
	local	float		fraglimit;
	
	if (gameover) return;
		
	timelimit = cvar("timelimit") * 60;
	fraglimit = cvar("fraglimit");
	
	if (timelimit && time >= timelimit)
	{
		gameover = TRUE;
		NextLevel ();
		//stats_show_stats();
		return;
	}
	
	if (fraglimit && self.frags >= fraglimit)
	{
		gameover = TRUE;
		NextLevel ();
		//stats_show_stats();
		return;
	}
};

//============================================================================

void() PlayerDeathThink =
{
	//local entity	old_self;
	local float forward;

	if ((self.flags & FL_ONGROUND))
	{
		forward = vlen (self.velocity);
		forward = forward - 20;
	
		if (forward <= 0)
			self.velocity = '0 0 0';
		else	
			self.velocity = forward * normalize(self.velocity);
	}

// wait for all buttons released
	if (self.deadflag == DEAD_DEAD)
	{
		if (self.button2 || self.button1 || self.button0)
			return;
		self.deadflag = DEAD_RESPAWNABLE;
		return;
	}

// wait for any button down
//	if (!self.button2 && !self.button1 && !self.button0) return;
	self.button0 = 0;
	self.button1 = 0;
	self.button2 = 0;
	respawn();
};


void() PlayerJump =
{
	if (self.flags & FL_WATERJUMP)
		return;
	
	if (self.waterlevel >= 2)
	{
		if (self.watertype == CONTENT_WATER)
			self.velocity_z = 100;
		else if (self.watertype == CONTENT_SLIME)
			self.velocity_z = 80;
		else
			self.velocity_z = 50;

                // play swiming sound
		if (self.swim_flag < time)
		{
			self.swim_flag = time + 1;
			if (random() < 0.5)
				sound (self, CHAN_BODY, "misc/water1.wav", 1, ATTN_NORM);
			else
				sound (self, CHAN_BODY, "misc/water2.wav", 1, ATTN_NORM);
		}

		return;
	}
        
	if (!(self.flags & FL_ONGROUND)) 
	{	 
	 return;// already in air...
	}

	if ( !(self.flags & FL_JUMPRELEASED) )	
	{
	 return; // don't pogo stick
	}

	self.flags = self.flags - (self.flags & FL_JUMPRELEASED);

	self.flags = self.flags - FL_ONGROUND;	// don't stairwalk
	
	self.button2 = 0;
	// player jumping sound
	sound (self, CHAN_BODY, "player/plyrjmp8.wav", 1, ATTN_NORM);
        
        self.velocity_z  = (self.velocity_z) + 270;
        self.timetojump  = time + (0.2);                
};

/*
===========
WaterMove
============
*/
.float	dmgtime;

void() WaterMove =
{
        if (self.health < 0) return;
        
        if (self.movetype == MOVETYPE_NOCLIP) return;

        if (!self.waterlevel)
	{
		if (self.flags & FL_INWATER)
		{       
			// play leave water sound
			sound (self, CHAN_BODY, "misc/outwater.wav", 1, ATTN_NORM);
			self.flags = self.flags - FL_INWATER;
		}
		return;
	}

	if ( !(self.flags & FL_INWATER) )
	{	

         // player enter water sound
                        
            
		if (self.watertype == CONTENT_LAVA)
			sound (self, CHAN_BODY, "player/inlava.wav", 1, ATTN_NORM);
		if (self.watertype == CONTENT_WATER)
			sound (self, CHAN_BODY, "player/inh2o.wav", 1, ATTN_NORM);
		if (self.watertype == CONTENT_SLIME)
			sound (self, CHAN_BODY, "player/slimbrn2.wav", 1, ATTN_NORM);
            
		self.flags = self.flags + FL_INWATER;
		self.dmgtime = 0;
		
	}
	else
	if (self.waterlevel != 3)
	{
             
           if (!(self.style & RA_OBSERVER))
           {
            if (self.air_finished < time)
                sound (self, CHAN_VOICE, "player/gasp2.wav", 1, ATTN_NORM);
            else if (self.air_finished < time + 9)
                sound (self, CHAN_VOICE, "player/gasp1.wav", 1, ATTN_NORM);
           }
                
		self.air_finished = time + 12;
		self.dmg = 2;
	}
			
	else if (self.air_finished < time)
	{	// drown!
		if (self.pain_finished < time)
		{
			self.dmg = self.dmg + 1;
			if (self.dmg > 10)
				self.dmg = 5;
			self.deathtype = "drowning";	// 1998-08-12 optional: Drowning doesn't hurt armor by Maddes/Athos
			T_Damage (self, world, world, self.dmg);
			self.pain_finished = time + 1;
		}
	}

	if (self.watertype == CONTENT_LAVA)
	{	// do damage
		if (self.dmgtime < time)
		{
			if (self.radsuit_finished > time)
				self.dmgtime = time + 1;
			else
				self.dmgtime = time + 0.2;

			T_Damage (self, world, world, 10*self.waterlevel);
		}
	}
	else if (self.watertype == CONTENT_SLIME)
	{	// do damage
		if (self.dmgtime < time && self.radsuit_finished < time)
		{
			self.dmgtime = time + 1;
			T_Damage (self, world, world, 4*self.waterlevel);
		}
	}
	
	
	if (! (self.flags & FL_WATERJUMP) )
		self.velocity = self.velocity - 0.8*self.waterlevel*frametime*self.velocity;
};

void() CheckWaterJump =
{
	local vector start, end;

// check for a jump-out-of-water
	makevectors (self.angles);
	start = self.origin;
	start_z = start_z + 8; 
	v_forward_z = 0;
	normalize(v_forward);
	end = start + v_forward*24;
	traceline (start, end, TRUE, self);
	if (trace_fraction < 1)
	{	// solid at waist
		start_z = start_z + self.maxs_z - 8;
		end = start + v_forward*24;
		self.movedir = trace_plane_normal * -50;
		traceline (start, end, TRUE, self);
		if (trace_fraction == 1)
		{	// open at eye level
			self.flags = self.flags | FL_WATERJUMP;
			self.velocity_z = 225;
			self.flags = self.flags - (self.flags & FL_JUMPRELEASED);
			self.teleport_time = time + 2;	// safety net
			return;
		}
	}
};


/*
================
PlayerPreThink

Called every frame before physics are run
================
*/
void() PlayerPreThink =
{
  
if (gameover)
    {
   	
        if (intermission_running)
        {
            // otherwise a button could be missed between the think tics
            IntermissionThink ();   
        }
		return;		// intermission or finale
    }
    	
  	if (self.view_ofs == '0 0 0') return;		// intermission or finale

	makevectors (self.v_angle);		// is this still used

        self.deathtype = "";
 
	CheckRules ();
	
	if (self.style & RA_OBSERVER)//RA OBSERVER code by JPG
    	{
        // find the closest teleport
        observer_find_teleport();

        // check for 'squished'
        observer_check_size();
	}
	
	if (self.style & RA_OBSERVER)// RA Observer Code by JPG
    	{
          observer_pre_think();
          return;
        }
	
	if ((self.waterlevel) || (self.flags & FL_INWATER)) WaterMove ();   
	//WaterMove ();

	if (self.waterlevel == 2) CheckWaterJump ();

		
	if (self.deadflag >= DEAD_DEAD)
	{
		PlayerDeathThink ();
		return;
	}
	
	if (self.deadflag == DEAD_DYING)
		return;	// dying, so do nothing

	if (self.button2)
	{
		PlayerJump ();
	}
	else
		self.flags = self.flags | FL_JUMPRELEASED;

// teleporters can force a non-moving pause time	
	if (time < self.pausetime) self.velocity = '0 0 0';

	if (!(self.currentammo))
           {
           
           
 // added hook to axe here (woods)
 
 
 
        
 
            if ((self.weapon != IT_AXE) && (self.weapon != IT_MORNINGSTAR))
            
            
 // End added hook to axe here (woods)           
	       {
                if (time > self.attack_finished)
                   {
                    self.weapon = W_BestWeapon ();
                    W_SetCurrentAmmo ();
                   }
               
               
             }
           }
           
          
	
};	

/*
================
PlayerPostThink

Called every frame after physics are run
================
*/
void() PlayerPostThink =
{            
        	
        if (self.style & RA_OBSERVER)
        {
         observer_post_think();
         return;
        }
        
        
        
        
        
        // Added By woods to correct scores on return .. reusme patch part 1  -- woods 
	
	       self.cnt = self.cnt + 1;
	
	       if (self.cnt == 10)
	       {
	               js_update();     //update the backup entity with fragcount
	               self.cnt = 0;    //once every second.
	       }
	
	// correct patch ends  reusme patch part 1 -- woods
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
       
	if (self.view_ofs == '0 0 0') return;		// intermission or finale
	
	if (self.deadflag) return;
	
        // do weapon stuff
/*	if (time >= self.attack_finished) */
    	W_WeaponFrame();
        
        if (self.impulse) 
	{                            
      	  if (self.impulse > 12) 
      	     {
	      ra_impulse();
       	     }
      	  else 
      	      self.next_impulse = self.impulse;
	}	             	                		
	
// check to see if player landed and play landing sound	
	if ((self.jump_flag < -300) && (self.flags & FL_ONGROUND) && (self.health > 0))
	{
		if (self.watertype == CONTENT_WATER)
			sound (self, CHAN_BODY, "player/h2ojump.wav", 1, ATTN_NORM);
		else if (self.jump_flag < -650)
		{
			self.deathtype = "falling";                  	
                        
                        T_Damage (self, world, world, 5);
                        
			sound (self, CHAN_VOICE, "player/land2.wav", 1, ATTN_NORM);
			self.deathtype = "falling";
		}
		else
			sound (self, CHAN_VOICE, "player/land.wav", 1, ATTN_NORM);

		self.jump_flag = 0;
	}

	if (!(self.flags & FL_ONGROUND)) self.jump_flag = self.velocity_z;               
};


/*
===========
ClientConnect

called when a player connects to a server
============
*/
void() ClientConnect =
{






	//IP SUB_MASK code by JPG  
	self.cl = SubInt(AddInt(PSTRING_TO_PQUAKEC, &self.netname), 4 * CL_NAME);   
	self.qs = AddInt(self.cl[CL_NETCONNECTION], PC_TO_PQUAKEC);
   	//-end
	ra_connect();
	
	
	
	
	// resume patch begins ad by woods resume patch part 2 of 2 -- woods
		
		js_resume();            
				      
		if (self.frags == 0)  
			    js_backup();   
	
		bprint (self.netname);         
		bprint (self.netname);
		bprint (" entered the game\n");
	 	
		if (self.frags == 0)                             
		{
			    bprint (" entered the game\n");
		}
		else
		{
			    bprint (" re-entered the game with "); //an alternative
			    bprint (ftos(self.frags));             //message is
			    bprint (" frag");                      //printed to 
			    if (self.frags == 1)                   //let people know
				    bprint("\n");                  //that a player
			    else                                   //has returned
				    bprint("s\n");                 //and regained
		}                                                  //previous frags
		
		//resume patch ends ad by woods resume patch part 2 of 2 -- woods

	
	
	
	
	
	
	
	
        
        // a client connecting during an intermission can cause problems	
	if (intermission_running)  ExitIntermission ();	 	
	   
};

/*
===========
ClientDisconnect

called when a player disconnects from a server
============
*/
void() ClientDisconnect =
{	
	if (gameover) return;
	
	if (!(self.style & RA_CONNECTED)) return;
	
	self.style = (self.style) - ((self.style) & RA_CONNECTED);
	
	if (self.netname == "") self.netname = "someone";
	
	if (self.cnt != -99)
	{
	 bprint (self.netname);
	 bprint (" disconnected.\n");
	}		
	
	sound (self, CHAN_BODY, "player/tornoff2.wav", 1, ATTN_NONE);
	if (!(self.style & RA_OBSERVER)) GibPlayer();
	set_suicide_frame ();
	
	self.effects = 0;
        ra_client_disconnect();        
        
	self.model      = string_null;//remove ghosts
	self.solid      = SOLID_NOT;
	self.takedamage = DAMAGE_NO;               
	self.classname  = string_null;
	self.health     = 0; 		
 	self.nextthink  = time;
    	self.think      = SUB_Null;	    		
};

/*

===========
ClientObituary

called when a player dies
============
*/
void(entity targ, entity attacker) ClientObituary =
{
	local	float rnum;
	local	string deathstring, deathstring2;
	rnum = random();

	if (targ.classname == "player")
	{
		if (attacker.classname == "teledeath")
		{
		 bprint(targ.netname, " was telefragged by ", attacker.owner.netname,"\n");
                 return;	       
		}
		
		if (targ.deathtype == "squish")
		{
			if (teamplay && targ.team == attacker.team && targ != attacker)
			{
				bprint(attacker.netname, " squished a teammate\n");
				return;
			}
			else if (attacker.classname == "player" && targ != attacker)
			{
				bprint(attacker.netname, " squishes ", targ.netname,"\n");
				return;
			}
			else
			{
				bprint(targ.netname, " was squished\n");
				return;
			}
			return;
		}

		if (attacker.classname == "player")
		{
			if (targ == attacker)
			{
				if (targ.deathtype == "grenade")
				{
					bprint(targ.netname, " tries to put the pin back in\n");
					return;
				}
				else if (targ.deathtype == "rocket")
				{
					if (targ.health < -40)
						bprint(targ.netname, " explodes with his own rocket\n");
					else
						bprint(targ.netname, " dies through his own rocket\n");
					return;
				}
				else

				if (targ.weapon == IT_LIGHTNING && targ.waterlevel > 1)
				{
					if (targ.watertype == CONTENT_SLIME)
						bprint(targ.netname, " discharges into the slime\n");
					else if (targ.watertype == CONTENT_LAVA)
						bprint(targ.netname, " discharges into the lava\n");
					else
						bprint(targ.netname, " discharges into the water\n");
					return;
				}

				bprint(targ.netname, " becomes bored with life\n");
				return;
			}
			
			else if ( (teamplay == 2) && (targ.team > 0) && (targ.team == attacker.team) )
			{
				deathstring = " frags a teammate\n";
				bprint(attacker.netname, deathstring);
				
				return;
			}
			else
			{
              	
				deathstring2 = "";
		
				
				rnum = attacker.weapon;
				if (targ.deathtype == "nail")
				{
					deathstring = " was nailed by ";
					deathstring2 = "\n";
				}	
				else if (targ.deathtype == "supernail")
				{
					deathstring = " was punctured by ";
					deathstring2 = "\n";
				}
				else if (targ.deathtype == "grenade")
				{
					deathstring = " eats ";
					deathstring2 = "'s pineapple\n";
					if (targ.health < -40)
					{
						deathstring = " was gibbed by ";
						deathstring2 = "'s grenade\n";
					}
				}
				else if (targ.deathtype == "rocket")
				{					
						deathstring = " rides ";
						deathstring2 = "'s rocket\n";
						if (targ.health < -40)
						{
							deathstring = " was gibbed by ";
							deathstring2 = "'s rocket\n" ;
						}
					
				}
				else
				if (rnum == IT_AXE)
				{
					deathstring = " was ax-murdered by ";
					deathstring2 = "\n";
				}
		
// Start Added for the Grappling Hook -- woods
		
		 else if (rnum == IT_MORNINGSTAR)
						{
							deathstring = " was disemboweled by ";
							deathstring2 = "\n";
				}		
		
// End Added for the Grappling Hook  -- woods	
		
				else
				if (rnum == IT_SHOTGUN)
				{
					deathstring = " chewed on ";
					deathstring2 = "'s boomstick\n";
				}
				else
				if (rnum == IT_SUPER_SHOTGUN)
				{
					deathstring = " ate 2 loads of ";
					deathstring2 = "'s buckshot\n";
				}
				else
				if (rnum == IT_LIGHTNING)
				{
					deathstring = " accepts ";
					if (attacker.waterlevel > 1)
						deathstring2 = "'s discharge";
					else
						deathstring2 = "'s shaft\n";
				}
				bprint(targ.netname, deathstring, attacker.netname, deathstring2);
			}
			return;
		}
		else
		{
		
			// tricks and traps
			if (attacker.classname == "explo_box")
			{
				bprint(targ.netname, " blew up\n");
				return;
			}
			if (targ.deathtype == "falling")
			{
				bprint(targ.netname, " fell to his death\n");				
				return;
			}
			if (targ.deathtype == "nail" || targ.deathtype == "supernail")
			{
				bprint(targ.netname, " was spiked\n");				
				return;
			}
			if (targ.deathtype == "laser")
			{
				bprint(targ.netname, " was zapped\n");				
				return;
			}
			if (attacker.classname == "fireball")
			{
				bprint(targ.netname, " ate a lavaball\n");				
				return;
			}
			if (attacker.classname == "trigger_changelevel")
			{
				bprint(targ.netname, " tried to leave\n");	
				return;
			}
			// in-water deaths
			rnum = targ.watertype;
			if (rnum == -3)
			{
				if (random() < 0.5)
					bprint(targ.netname, " sleeps with the fishes\n");
				else
					bprint(targ.netname, " sucks it down\n");	
				return;
			}
			else if (rnum == -4)
			{
				if (random() < 0.5)
					bprint(targ.netname, " gulped a load of slime\n");
				else
					bprint(targ.netname, " can't exist on slime alone\n");
				return;
			}
			else if (rnum == -5)
			{
				if (targ.health < -15)
				{
					bprint(targ.netname, " burst into flames\n");					
					return;
				}
				if (random() < 0.5)
					bprint(targ.netname, " turned into hot slag\n");				
				else
					bprint(targ.netname, " visits the Volcano God\n");				
				return;
			}
								
			bprint(targ.netname, " died\n");		
		}
	}
};
