void () W_SetCurrentAmmo;
void () SetArenaParms;
void () PutClientInArena;
//crt

//crt
void () PrintPos =
{
	local float pos;
	local entity myent;
	local string mystr;

	
	if (!(self.style & RA_OBSERVER)) return;
	
	if (self == first)
	{
		sprint (self, "You are next.\n");
		return;
	}
	if (self.next == world)
	{
		sprint (self, "You are out of line.\n type \bready\b to return.\n");
		return;
	}

	pos = 0;
	myent = self;
	do
	{
		myent = myent.prev;
		pos = pos + 1;
	} while (myent != first);
	mystr = ftos(pos);

	if (pos != 1)
	{
		sprint (self, "There are ");
		sprint (self, mystr);
		sprint (self, " people ahead of you\n");
	} else
		sprint (self, "There is one person ahead of you.\n");
};

void() UpdateWinner =
{ 
 winner.takedamage   = DAMAGE_NO;
 
 // Start Added for the Grappling Hook -- woods
 
 // old code winner.items        = ((((((((IT_SHOTGUN | IT_AXE) | IT_ROCKET_LAUNCHER) | IT_ARMOR3) | IT_SUPER_SHOTGUN) | IT_NAILGUN) | IT_GRENADE_LAUNCHER) | IT_LIGHTNING) | IT_SUPER_NAILGUN) | IT_ARMOR3;
 
 winner.items        = (((((((((IT_SHOTGUN | IT_AXE) | IT_MORNINGSTAR) | IT_ROCKET_LAUNCHER) | IT_ARMOR3) | IT_SUPER_SHOTGUN) | IT_NAILGUN) | IT_GRENADE_LAUNCHER) | IT_LIGHTNING) | IT_SUPER_NAILGUN) | IT_ARMOR3;
 
 
 
 // End Added for the Grappling Hook -- woods
 
 
 winner.health       = 100;
 winner.armorvalue   = 200;
 winner.ammo_shells  = 100;
 winner.ammo_nails   = 100;
 winner.ammo_rockets = 100;
 winner.ammo_cells   = 100;	       
 winner.armortype    = (80.000999) * 0.01;         	        
 winner.currentammo  = 100;
 sound(winner, CHAN_BODY, "items/r_item1.wav", 0.4, ATTN_NONE);    
 sound(winner, 1, "weapons/lock4.wav", 0.4, ATTN_NONE);    
};

void(entity anent) addtoqueue=
{
	local	entity	trail;
	local	float	pos;
	
	if (anent.classname != "player") return;
	
	if (first.classname != "player")
	{
		first=anent;
		first.next=first;
		first.prev=first;
		sprint(anent,"You are first in line.\n");
		anent.mypos = 1;
	}
	else
	{
		trail=first.prev;
		trail.next=anent;
		anent.prev=trail;
		first.prev=anent;
		anent.next=first;
		sprint(anent,"You are last in line.\n");
		
		trail = first;
		pos = 1;
		
		//update positions
		
		while (trail != anent)
		{
		 trail = trail.next;
		 pos = pos + 1;
		}
		
		anent.mypos = pos;		
	}
};

void () InitLineUp =
{
	 if (intermission_running) return;
  
	 if (winner.classname != "player")
	 {
		winner = self;
		PutClientInArena();
		self.next=self;
		self.prev=self;		
		//bprint("\nwaiting for opponent\n");
	 }
	  else
		if (loser.classname != "player")
		{	
		 loser = self;
		 PutClientInArena();
		 timetofight = TRUE;
		 //UpdateWinner();
		 self.next=self;
		 self.prev=self;
		 bprint ("\n");
		 bprint (self.netname);
		 bprint (" is the new challenger.\n");
		}		
		else
		{	  	                  
                 addtoqueue(self);	 	  	                       
                }         
};

void () ChangeLineStatus =
{
 local entity holder;	
 
	if ((winner == self) || (loser == self)) 
	   {
	    sprint(self,"You are already in the arena.\n");
	    return;
	   }

	if (self.next != world) //take OUT of line
	{
		if (self == first)
		{
		 if (self != self.next)	
		     first = self.next;
		 else
		     first = world;
		}
		
		holder      = self.prev;
		holder.next = self.next;
		holder      = self.next;
		holder.prev = self.prev;
		self.next   = world;
		self.prev   = world;		
		sprint(self,"Type \bREADY\b to get back in line.\n");
		return;
		//self.idletime = time + MAXIDLETIME;
		//sprint (self,"You can have up to a 5 minute break.\n ");		
	}
	else //put INTO line
	{	 
	 addtoqueue(self);
	}			
};

void() getnewopponent = 
{
	local entity holder,tmp;
	local float pos;


	if (first.classname == "player")
	{
		loser = first;
		holder = first.prev;
		if (first == first.next)
			first=world;
		else
		{
			first = first.next;
			first.prev=holder;
			holder.next=first;
			
		}
		
		tmp=self;
		self=loser;		
		PutClientInArena();		
		self=tmp;
		timetofight = TRUE;
		
		bprint ("The new challenger is ");
		bprint (loser.netname);
		bprint ("\n");
		if (first.classname == "player")
		{
			holder = first;
			pos = 0;
			do
			{
				pos = pos + 1;
				holder.mypos = pos;
				holder = holder.next;
			} while (holder.classname == "player" && holder != first);
		}
	}
	else
	{
		loser=world;
		//bprint ("Waiting for opponent\n");	
	}
};

void () ra_stop_countdown =
{ 
 local entity dead_counter;
	
 if (ra_count)
             {
              dead_counter = find (world,classname,"RA_COUNTER");
              if (dead_counter)
                 {
                  ra_count    =     0;
                  timetofight = FALSE;         
                  remove(dead_counter);
                 }	
             }
 nofire      =  TRUE;                 
};

void () arena_disconnect_notify =
{
	local entity holder;
	local float wasdead;

	if (self.deadflag == DEAD_NO)
		wasdead = 0;
	else
		wasdead = 1;

	if (winner == self)
	{		
	 ra_stop_countdown();
	 bprint ("The champion has left\n");		
	 winner = loser;
	 	
	 if (winner.classname == "player")
	 {
	  bprint ("The new champion is ");
	  bprint (winner.netname);
	  bprint ("\n");
	  winner.takedamage = DAMAGE_NO;
	 }
	 else
	  bprint ("Waiting for contestant\n");			
	  getnewopponent();
	}
	
	else
	
	if (loser == self)
	{
	 ra_stop_countdown();
	 bprint ("The challenger has left\n");
	 winner.takedamage = DAMAGE_NO;			
	 getnewopponent();
	}
	
	else
	
	if (self == first)
	{		
	 if (first.next == first) first=world;
	 else
	 {
	  holder=first.prev;
	  first=first.next;
	  first.prev=holder;
	  holder.next=first;
	 }
	}
	else //in the chain
	{
	 if (wasdead == 1) //I'm dead.. doesn't matter
			return;
	 if (self.next == world) //got out of line
			return;

	 holder=self.next;
	 holder.prev=self.prev;
	 holder=self.prev;
	 holder.next=self.next;
	}
};

void () ra_countdown_think =
{  
   local string valstr;
	   
   self.count     = (self.count) - 0.5;
   self.nextthink = (time + 0.5);      
   valstr         = ftos(ceil(self.count));
      
  if ((!gameover))
     {       	
       if ((self.count > 0) && ((winner.classname == "player") && (loser.classname == "player")))
          {          
            if ((self.count) == 8)
               {
               	UpdateWinner();
               }
            
            if ((self.count) == 7.0)
               {  
               
               
       // removed by woods         sound(world, CHAN_AUTO, "ra/prepare.wav", 1, ATTN_NONE);
                
                
                centerprint(winner,"ŽPrepare to FightŽ");
                centerprint(loser,"ŽPrepare to FightŽ");
               }          
                           
            if ((self.count) == 3) 
               {                
                sound(world, CHAN_AUTO, "ra/3.wav", 1, ATTN_NONE);
             	}
             	
            if ((self.count) == 2)
            	{            	
            	 sound(world, CHAN_AUTO, "ra/2.wav", 1, ATTN_NONE);
            	}
            	
            if ((self.count) == 1)
               {                
                sound(world, CHAN_AUTO, "ra/1.wav", 1, ATTN_NONE);
               }
            
            centerprint (winner, loser.netname, "\n\n",valstr);
	    centerprint (loser, winner.netname, "\n\n",valstr);         
	   }      	      
                     
      if (self.count == 0) 
         {
          sound(world, CHAN_AUTO, "ra/fight.wav", 1, ATTN_NONE);    
          centerprint(winner,"\bfight\b\n\n\n");	
          centerprint(loser,"\bfight\b\n\n\n");             		      
         }
      
      if (self.count == (-0.50))
         {
          winner.takedamage = DAMAGE_AIM;
          loser.takedamage  = DAMAGE_AIM;          
          nofire            =      FALSE;           
          ra_count          =          0;
          timetofight       =          0;                    
          remove(self);   
         }        
     }       
};
//-----------------------------------------------------------------------------
void () ra_countdown =
{
   local entity countdown;
      
   countdown          = spawn();
   countdown.think    = ra_countdown_think;
   countdown.classname= "RA_COUNTER";
   countdown.owner    = world;
   countdown.nextthink= 1;
   countdown.count    = 10;   
   bprint ("\n");
   bprint (winner.netname, " vs ", loser.netname," \n");  
};
//-----------------------------------------------------------------------------
//eof


