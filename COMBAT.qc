void () getnewopponent;
void () T_MissileTouch;
void () info_player_start;
void (entity targ, entity attacker) ClientObituary;
//============================================================================
float(float v) anglemod =
{
	while (v >= 360)
		v = v - 360;
	while (v < 0)
		v = v + 360;
	return v;
};


float(entity targ, entity inflictor) CanDamage =
{
// bmodels need special checking because their origin is 0,0,0
	if (targ.movetype == MOVETYPE_PUSH)
	{
		traceline(inflictor.origin, 0.5 * (targ.absmin + targ.absmax), TRUE, self);
		if (trace_fraction == 1)
			return TRUE;
		if (trace_ent == targ)
			return TRUE;
		return FALSE;
	}

	traceline(inflictor.origin, targ.origin, TRUE, self);

	if (trace_fraction == 1)
		return TRUE;

// 1998-09-16 CanDamage fix by Maddes/Kryten start
	local vector	dif;

	// testing middle of half-size bounding box
	dif_z = 0;

	// ...front right
	dif_y = targ.maxs_y * 0.5;
	dif_x = targ.maxs_x * 0.5;
//	traceline(inflictor.origin, targ.origin + '15 15 0', TRUE, self);
	traceline(inflictor.origin, targ.origin + dif, TRUE, self);
// 1998-09-16 CanDamage fix by Maddes/Kryten end

	if (trace_fraction == 1)
		return TRUE;

// 1998-09-16 CanDamage fix by Maddes/Kryten start
	// ...front left
	dif_x = targ.mins_x * 0.5;
//	traceline(inflictor.origin, targ.origin + '-15 -15 0', TRUE, self);
	traceline(inflictor.origin, targ.origin + dif, TRUE, self);
// 1998-09-16 CanDamage fix by Maddes/Kryten end
	if (trace_fraction == 1)
		return TRUE;

// 1998-09-16 CanDamage fix by Maddes/Kryten start
	// ...back left
	dif_y = targ.mins_y * 0.5;
//	traceline(inflictor.origin, targ.origin + '-15 15 0', TRUE, self);
	traceline(inflictor.origin, targ.origin + dif, TRUE, self);
// 1998-09-16 CanDamage fix by Maddes/Kryten end
	if (trace_fraction == 1)
		return TRUE;

// 1998-09-16 CanDamage fix by Maddes/Kryten start
	// ...back right
	dif_x = targ.maxs_x * 0.5;
//	traceline(inflictor.origin, targ.origin + '15 -15 0', TRUE, self);
	traceline(inflictor.origin, targ.origin + dif, TRUE, self);
// 1998-09-16 CanDamage fix by Maddes/Kryten end
	if (trace_fraction == 1)
		return TRUE;

// 1998-09-16 CanDamage fix by Maddes/Kryten start
	// testing top of half-sized bounding box
	dif_z = targ.maxs_z * 0.5;

	// ...front right
	dif_y = targ.maxs_y * 0.5;
	dif_x = targ.maxs_x * 0.5;
	traceline(inflictor.origin, targ.origin + dif, TRUE, self);
	if (trace_fraction == 1)
		return TRUE;

	// ...front left
	dif_x = targ.mins_x * 0.5;
	traceline(inflictor.origin, targ.origin + dif, TRUE, self);
	if (trace_fraction == 1)
		return TRUE;

	// ...back left
	dif_y = targ.mins_y * 0.5;
	traceline(inflictor.origin, targ.origin + dif, TRUE, self);
	if (trace_fraction == 1)
		return TRUE;

	// ...back right
	dif_x = targ.maxs_x * 0.5;
	traceline(inflictor.origin, targ.origin + dif, TRUE, self);
	if (trace_fraction == 1)
		return TRUE;

	// testing bottom of half-sized bounding box
	dif_z = targ.mins_z * 0.5;

	// ...front right
	dif_y = targ.maxs_y * 0.5;
	dif_x = targ.maxs_x * 0.5;
	traceline(inflictor.origin, targ.origin + dif, TRUE, self);
	if (trace_fraction == 1)
		return TRUE;

	// ...front left
	dif_x = targ.mins_x * 0.5;
	traceline(inflictor.origin, targ.origin + dif, TRUE, self);
	if (trace_fraction == 1)
		return TRUE;

	// ...back left
	dif_y = targ.mins_y * 0.5;
	traceline(inflictor.origin, targ.origin + dif, TRUE, self);
	if (trace_fraction == 1)
		return TRUE;

	// ...back right
	dif_x = targ.maxs_x * 0.5;
	traceline(inflictor.origin, targ.origin + dif, TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
// 1998-09-16 CanDamage fix by Maddes/Kryten end

	return FALSE;
};


/*
============
Killed
============
*/
void(entity targ, entity attacker) Killed =
{
	local entity oself;

	oself = self;
	self = targ;
	
	if (self.health < -99) self.health = -99;// don't let sbar look bad if a player

	if (self.movetype == MOVETYPE_PUSH || self.movetype == MOVETYPE_NONE)
	{	// doors, triggers, etc
		self.th_die ();
		self = oself;
		return;
	}

	self.enemy = attacker;
	ClientObituary(self, attacker);		
		
	self.takedamage = DAMAGE_NO;
	self.touch      = SUB_Null;	
	self.th_die ();	
	self = oself;
};

/*
============
T_Damage

The damage is coming from inflictor, but get mad at attacker
This should be the only function that ever reduces health.
============
*/
void(entity targ, entity inflictor, entity attacker, float damage) T_Damage=
{
	local	vector	dir;
	local	entity	oldself;
	local	float	save;
	local	float	take;
	local   string  temp;

  if (!targ.takedamage) return;
      
  // used by buttons and triggers to set activator for target firing
  damage_attacker = attacker;

  //Direct hit
  //FIXME: discharge announce acc
 	if ( (damage >=118 ) && (targ != attacker) && (targ.classname=="player") && (attacker.classname=="player") ) 
	{
      	// removed by woods	sound(world, CHAN_AUTO, "ra/accuracy.wav", 1, ATTN_NONE);
     	}
         
  save=0;

  if ( (targ.armorvalue) && (targ.classname=="player") )//player has armor?
     {     
      if (targ.deathtype != "drowning")       
         {
      	  save = ceil(targ.armortype * damage); 
    	  if (save >= targ.armorvalue)
	     {
	      save = targ.armorvalue; 
	      targ.armortype = 0;
	      targ.items = targ.items - (targ.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3));
	     }	     
	  targ.armorvalue = targ.armorvalue - save;// armorvalue is zero
         } 
     }

take = ceil(damage-save);

// add to the damage total for clients, which will be sent as a single
// message at the end of the frame
// FIXME: remove after combining shotgun blasts?
	if (targ.flags & FL_CLIENT)
	{
		targ.dmg_take = targ.dmg_take + take;
		targ.dmg_save = targ.dmg_save + save;
		targ.dmg_inflictor = inflictor;
	}

// figure momentum add
if ( (inflictor != world) && (targ.movetype == MOVETYPE_WALK) )
	{
 	 dir = targ.origin - (inflictor.absmin + inflictor.absmax) * 0.5;
	 dir = normalize(dir);
	 targ.velocity = targ.velocity + dir*damage*8;
	}   
		











// do the damage
        
	targ.health = targ.health - take;
        
        
    if ((targ.health <= 0) && (targ.classname == "player"))
    {    	 
    	 if (attacker.classname == "player")
	    {			
	     stuffcmd(attacker,"-attack\n");
	     attacker.ammo_shells  = 000;
 	     attacker.ammo_nails   = 000;
             attacker.ammo_rockets = 000;
             attacker.ammo_cells   = 000;	       
             attacker.currentammo  = 000;             
	    }
         
         if (targ == winner) winner = loser;  
                  
    	 nofire               = TRUE;//hold your fire!         	 
	 if (attacker.classname == "player")
         {
         	attacker.oldfragtime = attacker.newfragtime;//used for 'impressive'         
	 	attacker.newfragtime = time;
	 }
	  
       if ((attacker.classname == "player") && (targ != attacker)) attacker.frags = attacker.frags + 1;
       
       if (targ == attacker) attacker.frags = attacker.frags - 1;
			
       if ( (targ.classname == "player" && attacker.classname == "player" && targ != attacker && attacker.health > 0) )
       {
             temp = ftos(ceil(attacker.armorvalue));
             bprint("\n",attacker.netname, " had \b[\b", temp, "\b]\bArmor \n");
             
             temp = ftos(ceil(attacker.health));
             bprint("\b[\b",temp, "\b]\bHealth\n");
       
         if ((attacker.newfragtime - attacker.oldfragtime) <= 10) 
         {         	
          // removed by woods   	sound(world, CHAN_AUTO, "ra/impressive.wav", 1, ATTN_NONE);                         	
         }
            
         else
         
         if ((attacker.weapon==IT_AXE)||(attacker.weapon==IT_SHOTGUN))
            {
         // removed by woods    sound(world, CHAN_AUTO, "ra/humiliation.wav", 1, ATTN_NONE);             
            }

         else
        
         if ((attacker.health==100)&&(attacker.armorvalue==200))
            {
          // removed by woods   sound(world, CHAN_AUTO, "ra/flawless.wav", 1, ATTN_NONE);
            }
      
         else
         
         if ( (attacker.health >= 75) && (attacker.armorvalue >= 100) )
            {
          // removed by woods   sound(world, CHAN_AUTO, "ra/excellent.wav", 1, ATTN_NONE);
            }	
       }
        
	Killed (targ, attacker);	
	getnewopponent();//ra
      }// END if (targ.health <= 0)

        // react to the damage
	oldself = self;
	self = targ;
	
	if (self.th_pain)
	{
	 self.th_pain (attacker, take);		
	}

	self = oldself;
};

/*
============
T_RadiusDamage
============
*/
//void(entity inflictor, entity attacker, float damage, entity ignore) T_RadiusDamage =
void(entity inflictor, entity attacker, float damage, entity ignore, string dtype) T_RadiusDamage =
{
local float points;
local entity head;
local vector org;
local	float	attacker_damaged;
local	float	attacker_points;

head = findradius(inflictor.origin, damage+40);
 while (head)
 {
 if (head != ignore)
   {
     if (head.takedamage)
       {
         org = head.origin + (head.mins + head.maxs)*0.5;
         points = 0.5*vlen (inflictor.origin - org);
         if (points < 0)	points = 0;
         points = damage - points;
         if (points > 0)
           {
             if (CanDamage (head, inflictor))
                {
			  head.deathtype = dtype;	// Wrong obituary messages fix
	 		  if (head != attacker)
                    {
                     T_Damage (head, inflictor, attacker, points);// T_RadiusDamage workaround 
                    }
	            else
	               {
	                attacker_damaged = TRUE;
	   		      attacker_points = points * 0.5;
	               }
                }
           }
       }
    }
  head = head.chain;
 }
if (attacker_damaged) T_Damage (attacker, inflictor, attacker, attacker_points);
};
