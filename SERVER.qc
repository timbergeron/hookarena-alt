void () ChangeLineStatus;
void () set_aliases =
{
   local entity temp;

   temp = self;
   self = self.owner;
  
   stuffcmd(self, "chase_active 0;wait\n");
   stuffcmd(self, "alias chase_active \" \"\n");  // no psuedo wall hacking
   stuffcmd(self, "r_novis 0;wait\n");
   
   stuffcmd(self, "alias warp impulse 40\n");
   stuffcmd(self, "alias ready impulse 70\n");
   stuffcmd(self, "alias notready impulse 70\n");
   stuffcmd(self, "alias admin impulse 108\n");
   
   stuffcmd(self, "alias yes impulse 80\n");
   stuffcmd(self, "alias no impulse 81\n");   
   stuffcmd(self, "alias 0 impulse 230\n");
   stuffcmd(self, "alias 1 impulse 231\n");
   stuffcmd(self, "alias 2 impulse 232\n");
   stuffcmd(self, "alias 3 impulse 233\n");
   stuffcmd(self, "alias 4 impulse 234\n");
   stuffcmd(self, "alias 5 impulse 235\n");
   stuffcmd(self, "alias 6 impulse 236\n");
   stuffcmd(self, "alias 7 impulse 237\n");
   stuffcmd(self, "alias 8 impulse 238\n");
   stuffcmd(self, "alias 9 impulse 239\n");
   stuffcmd(self, "alias 10 impulse 240\n");
   stuffcmd(self, "alias 11 impulse 241\n");
   stuffcmd(self, "alias 12 impulse 242\n");
   stuffcmd(self, "alias 13 impulse 243\n");
   stuffcmd(self, "alias 14 impulse 244\n");
   stuffcmd(self, "alias 15 impulse 245\n");
   
   
   // my commands -- woods
   
   stuffcmd(self, "alias +hook impulse 22\n");
   stuffcmd(self, "alias motd impulse 25\n");
   stuffcmd(self, "alias commands impulse 50\n");
   stuffcmd(self, "alias observe impulse 75\n");
   stuffcmd(self, "alias chase impulse 76\n");
   stuffcmd(self, "alias break impulse 70\n");
   stuffcmd(self, "alias about impulse 99\n");
   stuffcmd(self, "alias stats impulse 57\n");
   
   
   
   self = temp;
   remove(self);
};

//show console info, settings, commands, etc...
void () login_display =
{
   local entity temp;

   temp = self;
   self = self.owner;

        
   sprint(self,"type \bcommands\b for help/information\n");   
   self = temp;
   remove(self);
};



/*
============
About -- woods

============
*/


void() AboutServer =	

	{
	        sprint (self, "\n\n\n\n\nQ1 Çrapple Òocket Árena+ v1.0 (Released July 2003)\n\n");
		sprint (self, "This mod is by woods, using code by:\n\n");
		sprint (self, "Morning Star Grapple by Michael A.\n");
		sprint (self, "Rocket Arena 1.2 by David 'crt' Wright\n");
		sprint (self, "Rocket Arena G3 1.2 by rook\n");
		sprint (self, "Observer Mode by JP Grossman\n");
		sprint (self, "3rd Person Chase Cam by ShockMan\n");
		sprint (self, "Voting by Dr. Banzai\n\n\n\n");
		sprint (self, "Contact woods:\n\n");
		
		
		sprint (self, "Email: woods@jukebox.dhs.org\n");
		sprint (self, "IRC: irc.enterthegame.com #crctf\n");
		sprint (self, "Website: http://www.smackeron.com/arena\n\n");
	};	



// added this, but took it out -- woods

/*

void (entity e) PrintaStat =
{
	local	string	mystr;

	if (e.classname != "player")
		return;
	if (e.loses+e.wins == 0)
		e.ratio = 0;
	else
		e.ratio = (e.wins * 100) / (e.loses + e.wins);
	sprint(self, e.netname);
	sprint(self, "  W:");
	mystr = ftos(e.wins);
	sprint(self, mystr);
	sprint(self, "  L:");
	mystr = ftos(e.loses);
	sprint(self, mystr);
	sprint(self, "  SKILL:");
	mystr = ftos(e.ratio);
	sprint(self, mystr);
	sprint(self, "%\n");
};
		
//crt		
void () PrintRAStats =
{
	local entity myent;

	PrintaStat(winner);
	PrintaStat(loser);
	if (first.classname == "player")
	{
		myent = first;
		do
		{
			PrintaStat(myent);
			myent = myent.next;
		} while (myent != first);
	}
};
//crt





*/


// end added this, but took it out -- woods




















/*
============
My MOTD, different from motd.qc

============
*/


void() PrintMOTD =	

	{
		sprint (self, "\n\n\nQuake1 Çrapple Òocket Árena+ v1.2\n");
		sprint (self, "by woods - woods@jukebox.dhs.org\n\n");
		
		sprint (self, "Äï÷îìïáä ÒÁ Íáðóº\n\n");
		sprint (self, "http://www.smackeron.com/arena\n\n");
		sprint (self, "\n\n");
		sprint (self, "Type: Ãïííáîäó\n\n");
		
	};	





void () show_commands =
{
   sprint (self, "\n\n\n\nÓåòöåò Ãïííáîäó\n\n");
		sprint (self, "+hookœœœœœœœœœœœœœœ22  Grappling Hook\n");
		sprint (self, "motdœœœœœœœœœœœœœœœ25  Display MOTD\n");
		sprint (self, "warpœœœœœœœœœœœœœœœ40  Change Level\n");
	
		sprint (self, "commandsœœœœœœœœœœœ50  Server Commands\n");
	
		sprint (self, "observeœœœœœœœœœœœœ75  Old RA Spectator Mode\n");
		sprint (self, "chaseœœœœœœœœœœœœœœ76  New RA Spectator Chase\n");
		
	        sprint (self, "breakœœœœœœœœœœœœœœ70  Step Out Of Line\n");
	        sprint (self, "yesœœœœœœœœœœœœœœœœ80  Vote Yes\n");
	        sprint (self, "noœœœœœœœœœœœœœœœœœ81  Vote No\n");
		sprint (self, "aboutœœœœœœœœœœœœœœ99  About This Mod\n\n");
		sprint (self, "Auto Ghost Score Update On Disconnects\n\n");     
};


void () ra_connect = 
{		
        if (parm10 & NEW_CLIENT)
	{

         if (!net_connect ())
		{
		 return;
		}
	 
	 if (!(self.style & RA_MOTD))
            {
             if (!(self.see_motd)) motd_create();         
            }
             
	 //sound(world, CHAN_AUTO, "items/itembk2.wav", 1, ATTN_NONE);    
	 bprint (self.netname, " joined the game.\n");
	 utils_make_scheduled_event(set_aliases, 1.5);    
         utils_make_scheduled_event(login_display, 1.75);             
         parm10 = parm10 - NEW_CLIENT;         
	}	
	
	self.next            = world;
	self.prev            = world;
	
	self.style           = 0;
	self.use             = SUB_Null;	
	self.attack_finished = time;
	self.frags           = 0;	
	self.next_impulse    = 0;	        
};

void () ra_client_disconnect =
{
   self.style = (self.style) - ((self.style) & RA_CONNECTED);

   observer_disconnect_notify(self);
   admin_disconnect_notify(self);
   arena_disconnect_notify();           
};

void () exec_config =
{
  if ((cvar("deathmatch")) == 0) cvar_set("deathmatch", "1");
  localcmd("sv_aim 2;wait\n");
  localcmd("sv_friction 5;wait\n");
  localcmd("sv_accelerate 11;wait\n");
  dprint("Loading Configuration File\n");  
  localcmd("exec ra.cfg;wait\n");
  remove(self);
};

void () RA_Init =
{
 ra_version = "\bG3\bArena \bv1.2";
 
 cvar_set("net_messagetimeout", "60");//forced 
  
 serverflags = 0;
             
 utils_make_scheduled_event(exec_config, 1);
 
 cvar_set("teamplay",   "0");	  
 cvar_set("fraglimit", "10"); 
 cvar_set("timelimit", "60");//put timelimit for empty servers to get refreshed

 ra_maxclients = cvar("maxclients");
 vote_request  = world; 
 nofire	       = TRUE;
 timetofight   = 0; 
  
 winner = spawn(); winner = world;
 loser  = spawn(); loser  = world;
 first  = spawn(); first  = world; 
};

void () ra_startframe =
{ 
 local float command; 
  
 command = cvar("temp1");
 
 cvar_set("temp1", "0");
 
 if (command) console_command(command);	    
  
 if ( (timetofight) && (!ra_count) && (winner.classname=="player") && (loser.classname=="player") )
    {     
     nofire      = TRUE;
     ra_count    =    1;
     ra_countdown ();		
    }	    
 
};

void () ra_impulse =
{
        if (self.impulse == 40)//warp function
     	   {
      	    self.finaldest_z=0;
            self.warp_episode=0; 
            self.warp_map=0;
            self.warp_menu=1;
            self.use=SUB_Null;    
            client_select_warp();
           }
  	
  	else
	
	  
	
// Start Added for the Grappling Hook -- woods
	  	
	 
// We do not want observers to use hook, only players	  -- woods
	 
	if ((winner == self) || (loser == self))   
	
// End we do not want observers to use hook, only players -- woods	 
	  	
	  	if (self.impulse == 22)
	                W_ChangeWeapon ();
	  	
// End Added for the Grappling Hook -- woods

// Start Added impulses -- woods


 if (self.impulse == 99)
	AboutServer ();

 if (self.impulse == 25)
	PrintMOTD ();

	  

if ((winner == self) || (loser == self))    
if (self.impulse == 75) 
   
   sprint(self, "You cannot chase if you are playing!\n");  
		
if ((winner == self) || (loser == self)) 		
if (self.impulse == 76) 
   
   sprint(self, "You cannot chase if you are playing!\n"); 


	  
if ((winner != self) && (loser != self))  	  
if (self.impulse == 75)
   PutClientInServerReg ();
		
if ((winner != self) && (loser != self)) 		
if (self.impulse == 76)
   observer_start ();
   
  
  

	  
if (self.impulse == 97)	
  	  	{
  	
vote_init ("change to ", "the next level", NextLevel);
vote_yes(); }
  	  	
  	
  	
// End Added impulses -- woods  	
  	
  	
  	if (self.impulse == 70)	ChangeLineStatus();
  	
  	
  	
  	
  	else
  	        
        if (self.impulse == 50) show_commands();//menu
        
        else
        
        if (self.impulse == 108) admin_start_code();	
		
	else
	
        if (self.impulse == 109) motd_create();//menu
        
        else
        	
        if (self.impulse == 80 || self.impulse == 81) 
           {
            vote_impulse();//voting
           }
        
        else
                
        //else
        
        //if (self.impulse == 170) stats_impulse();
        if ((self.impulse > 200) && (self.impulse < 230)) admin_impulse();
        
        else      
                        
  	if ((self.impulse >= 230) && (self.impulse <= 245)) // 1-15 
	{
		if (self.use) 
		{
			self.finaldest_z = self.impulse - 230;
			self.use();
      	        }
        }
   	
//------------------------------------------------------------
  self.impulse = 0;
};