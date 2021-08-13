
void (entity Head) BreakChain =
{
	local entity link;

	link = Head.goalentity;
	while ((link != world))
	{
		Head = link.goalentity;
		remove (link);
		link = Head;
	}
};

void () LinkPos =
{
	makevectors (self.enemy.angles);
	setorigin (self, (self.owner.origin + ((((self.enemy.origin + ((v_up * 20) * !self.enemy.button2)) + (v_forward * FL_INWATER)) - self.owner.origin) * self.weapon)));
	self.nextthink = (time + 0.01);
};
entity (entity head,entity tail,float num) MakeChain =
{
	local entity link;
	local entity prevlink;
	local float linknum;

	linknum = num;
	num = (num + TRUE);
	prevlink = world;
	while ((linknum > FALSE))
	{
		link = spawn ();
		link.goalentity = prevlink;
		prevlink = link;
		link.owner = head;
		link.enemy = tail;
		link.weapon = (linknum / num);
		link.movetype = MOVETYPE_NOCLIP;
		link.solid = SOLID_NOT;
		link.angles_z = (51 * linknum);
		link.angles_y = (41 * linknum);
		link.angles_x = (SVC_FINALE * linknum);
		link.avelocity = '310 410 510';
		setmodel (link, "progs/s_spike.mdl");
		setsize (link, VEC_ORIGIN, VEC_ORIGIN);
		makevectors (tail.angles);
		setorigin (link, (head.origin + ((((tail.origin + ((v_up * 20) * !tail.button2)) + (v_forward * FL_INWATER)) - head.origin) * link.weapon)));
		link.nextthink = (time + 0.01);
		link.think = LinkPos;
		linknum = (linknum - TRUE);
	}
	return (link);
};

void () HookVanish =
{
	self.owner.hook_out = FALSE;
	if ((self.enemy.classname == "player"))
	{
		self.enemy.attack_finished = (time + 0.1);
	}
	
	BreakChain (self);
	remove (self);
};

void () HookPull =
{
	local vector vel;
	local vector spray;
	local float v;
	local float dorg;

	if ((((!self.owner.button0 && (self.owner.weapon == IT_MORNINGSTAR)) || (self.owner.teleport_time > time)) || self.owner.deadflag))
	{
		if ((self.enemy.takedamage && (self.weapon > FALSE)))
		{
			self.enemy.nextthink = (time + 0.1);
		}
		HookVanish ();
		return ;
	}
	
	
	
	// don't hurt each other in countdown using hook -- woods
	
				if ((self.enemy.classname == "player") && (timetofight == TRUE))

					
					{
						HookVanish();
						return;
				}
	
	
	// end don't hurt each other in countdown using hook  -- woods
	
	
	
	
	
	else
	{
		makevectors (self.owner.angles);
		vel = (self.origin - ((self.owner.origin + ((v_up * 20) * ((1.25 * !self.owner.button2) - 0.25))) + (v_forward * FL_INWATER)));
		v = vlen (vel);
		if ((v <= 100))
		{
			vel = ((normalize (vel) * v) * MOVETYPE_BOUNCE);
		}
		else
		{
			vel = (normalize (vel) * 1000);
		}
		dorg = vlen ((self.owner.origin - self.dest));
		if (((dorg > MOVETYPE_BOUNCE) && (self.style == MOVETYPE_WALK)))
		{
			
			self.style = FL_SWIM;
		}
		if (((dorg < MOVETYPE_BOUNCE) && (self.style == FL_SWIM)))
		{
			
			self.style = MOVETYPE_WALK;
		}
		self.owner.velocity = vel;
		self.dest = self.owner.origin;
		
		
		
		//  if (self.enemy.takedamage)  
		
		
		// The hook will only make players bleed and make annyoing sound  -- woods
		
		if ((self.enemy.takedamage) && (self.enemy.classname =="player")) 
		
		// End the hook will only make players bleed and make annyoing sound  -- woods
		
		{
			
			
			
			
			sound (self, CHAN_WEAPON, "blob/land1.wav", TRUE, ATTN_NORM);
			T_Damage (self.enemy, self, self.owner, TRUE);
			makevectors (self.v_angle);
			spray_x = (100 * crandom ());
			spray_y = (100 * crandom ());
			spray_z = ((100 * crandom ()) + 50);
			SpawnBlood (self.origin, spray, 20); 
			if ((self.enemy.health <= FALSE))
			{
				if ((self.weapon > FALSE))
				{
					self.enemy.nextthink = (time + 0.1);
				}
			}
			if ((self.enemy.solid == SOLID_SLIDEBOX))
			{
				self.velocity = VEC_ORIGIN;
				setorigin (self, ((self.enemy.origin + self.enemy.mins) + (self.enemy.size * 0.5)));
			}
			else
			{
				self.velocity = self.enemy.velocity;
			
			
			}
		
		
		
		
		}
		
		
		
		
		
		else
		{
			self.velocity = self.enemy.velocity;
		}
		if ((self.enemy.solid == SOLID_NOT))
		{
			HookVanish ();
			return ;
		}
		self.nextthink = (time + 0.1);
		self.think = HookPull;
	}
};

void () T_ChainTouch =
{
	local float rand;

	if ((other == self.owner))
	{
		return ;
	}
	if ((pointcontents (self.origin) == CONTENT_SKY))
	{
		HookVanish ();
		return ;
	}
	
	// added by woods, no blood unless player  -- woods
	
	if ((other.takedamage) && (other.classname =="player")) 
	
	// end added by woods, no blood unless player  -- woods
	
	{
		T_Damage (other, self, self.owner, MOVETYPE_BOUNCE);
		SpawnBlood (self.origin, self.velocity, MOVETYPE_BOUNCE);
	}
	else
	{
		self.avelocity = VEC_ORIGIN;
	}
	
	// added by woods, no axe sound when hitting a playing, they are not a wall  -- woods
	
	if (other.classname !="player")
	
	// End added by woods, no axe sound when hitting a playing, they are not a wall  -- woods
	
	sound (self, CHAN_AUTO, "player/axhit2.wav", TRUE, ATTN_NORM);
	if (!self.owner.button0)
	{
		HookVanish ();
		return ;
	}
	else
	{
		if ((other.solid == SOLID_SLIDEBOX))
		{
			setorigin (self, ((other.origin + other.mins) + (other.size * 0.5)));
			self.velocity = VEC_ORIGIN;
			rand = random ();
			if ((rand <= (vlen ((other.origin - self.owner.origin)) * 0.001)))
			{
				sound (self.owner, CHAN_VOICE, "weapons/gotcha.wav", TRUE, ATTN_STATIC);
			}
		}
		else
		{
			self.velocity = other.velocity;
		}
		self.weapon = (other.nextthink - time);
		
		self.style = FL_SWIM;
		self.enemy = other;
		self.think = HookPull;
		self.nextthink = (time + 0.1);
		self.touch = SUB_Null;
	}
};

void () W_FireChain =
{
	local entity hook;

	self.hook_out = TRUE;
	hook = spawn ();
	hook.owner = self;
	hook.movetype = MOVETYPE_FLY;
	hook.solid = SOLID_BBOX;
	makevectors (self.v_angle);
	hook.velocity = aim (self, 1000);
	hook.velocity = (hook.velocity * 1000);
	hook.angles = vectoangles (hook.velocity);
	hook.avelocity = '0 0 -500';
	hook.touch = T_ChainTouch;
	hook.think = HookVanish;
	hook.nextthink = (time + MOVETYPE_FLY);
	setmodel (hook, "progs/v_spike.mdl");
	setsize (hook, VEC_ORIGIN, VEC_ORIGIN);
	setorigin (hook, ((self.origin + (v_forward * FL_INWATER)) + '0 0 20'));
	sound (self, CHAN_WEAPON, "hknight/hit.wav", TRUE, ATTN_NORM);
	hook.goalentity = MakeChain (hook, self, FL_CLIENT);
};
