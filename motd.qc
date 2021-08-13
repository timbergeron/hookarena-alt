string motd_top1 = "\n\n\nQuake1 Çrapple Òocket Árena+ v1.2\n";
string motd_top2 = "by woods - woods@jukebox.dhs.org\n\n";
string motd_top3 = "Please agree before using hook.\n\n"
string motd_top4 = "Äï÷îìïáä ÒÁ Íáðóº\n\n"
string motd_top5 = "http://www.smackeron.com/arena\n\n"
string motd_top6;



void () intro_think=
{     
     self.owner.see_motd = 1;
     self.cnt=self.cnt+1;
     stuffcmd(self.owner,"crosshair 0\n");
     
     if (self.cnt == 1) centerprint (self.owner, "no bots");    
      
     if ((self.owner.button0) || (self.owner.button2) || (self.owner.button1))
	{
         if (!(self.style & RA_MOTD)) self.owner.style = self.owner.style | RA_MOTD;
         self.owner.see_motd = 0;
         self.cnt = 300;         
         centerprint(self.owner, " ");
         stuffcmd(self.owner,"crosshair 1\n");
         remove(self);
         return;
   	}        
      	
        centerprint(self.owner,motd_top1,motd_top2,motd_top3,motd_top4,motd_top5,motd_top6);
        
        self.think=intro_think;
        self.nextthink = (time + 0.1);             	 	

 	if (self.cnt == 300)
      	{
          if (!(self.style & RA_MOTD)) self.owner.style = self.owner.style | RA_MOTD;
  	  stuffcmd(self.owner,"crosshair 1\n");
  	  self.owner.see_motd = 0;
          centerprint(self.owner, " ");
          self.think = SUB_Null;
          self.nextthink = -1;
          remove(self);
      	  return;
      	}   
};

void () motd_create =
{   
local entity intro;

if (self.see_motd) 

{
 sprint(self,"already viewing motd.\n");
 return;
}

intro = utils_make_scheduled_event(intro_think, 2);
intro.cnt = 0;
};










