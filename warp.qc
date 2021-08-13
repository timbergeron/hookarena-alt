float (string s1, string s2, void() accept) vote_init;
void () votables_request_change_level;
void () client_select_warp;

void () warp_menu_top =
{
 sprint (self,"\n");
 sprint (self," “ RA MAPS # - A\n");
 sprint (self," ” RA MAPS A - C\n");
 sprint (self," • RA MAPS C - I\n");
 sprint (self," – RA MAPS I - P\n");
 sprint (self," — RA MAPS P - X\n");
 sprint (self," ˜ RA Extended Maps # - E\n");
 sprint (self,"  RA Extended Maps E - Z\n");
 sprint (self,"  Next Level In Map Rotation\n");

 sprint (self," ’ \bEXIT\n"); 
 sprint (self,"\n");
 sprint (self, "select map category\n");
};

void () warp_menu_one =
{
 sprint (self,"\n");
 sprint (self, " \b1\b 23ar-a   \bplatarena23-a\n");
 sprint (self, " \b2\b 2pyramid \btwo pyramids\n");
 sprint (self, " \b3\b 2towers  \btwin towers arena\n");
 sprint (self, " \b4\b arenarg2 \brocket jump this\n");
 sprint (self, " \b5\b arenarg4 \bspongebath\n");
 sprint (self, " \b6\b arenarg5 \bthe wicked empty base\n");
 sprint (self, " \b7\b arenarg6 \bthe pit\n");
 sprint (self, " \b8\b arenax   \barenaX\n");
 sprint (self, " \b9\b arenazap \bzaphods arena\n");
 sprint (self, " ’ \bEXIT\n");      
 sprint (self,"\n");
 sprint (self, "select map\n");
};

void () warp_menu_two=
{
 sprint (self,"\n");
 sprint (self, " \b1\b arendm1a \bplace to die\n");
 sprint (self, " \b2\b arenrg3a \bedge of insanity\n");
 sprint (self, " \b3\b arma4    \barmageddon 4\n");
 sprint (self, " \b4\b barena1  \bBowl arena\n");
 sprint (self, " \b5\b basarena \bbase arena\n");
 sprint (self, " \b6\b bbarena2 \bblood bath\n");
 sprint (self, " \b7\b bunmoo3  \bfirst bunny on  the moon\n");
 sprint (self, " \b8\b bunski   \bski bunny\n");
 sprint (self, " \b9\b chamber1 \bthe chamber of pain\n");
 sprint (self, " ’ \bEXIT\n");      
 sprint (self,"\n");
 sprint (self, "select map\n");
};

void () warp_menu_three=
{
 sprint (self,"\n");
 sprint (self, " \b1\b crandome \n");
 sprint (self, " \b2\b dm2arena \bclaustarena\n");
 sprint (self, " \b3\b dom2_1ra \bDoom2map01RA\n");
 sprint (self, " \b4\b egyptra  \begyptra\n");
 sprint (self, " \b5\b football \brocket football arena\n");
 sprint (self, " \b6\b gear8    \bcensored\n");
 sprint (self, " \b7\b gnurena  \bseek-and-hide\n");
 sprint (self, " \b8\b hill20\n");
 sprint (self, " \b9\b iarena2  \b2 castles\n");
 sprint (self, " ’ \bEXIT\n");      
 sprint (self,"\n");
 sprint (self, "select map\n");
};

void () warp_menu_four=
{
 sprint (self,"\n");
 sprint (self, " \b1\b id3      \bdm6 arena\n");
 sprint (self, " \b2\b lowgrav  \breduced gravity\n");
 sprint (self, " \b3\b marena2  \barena2 by mungo\n");
 sprint (self, " \b4\b marena3  \barena3 by mungo\n");
 sprint (self, " \b5\b marena4  \barena4 by mungo\n");
 sprint (self, " \b6\b mayan1   \bmayan showdown\n");
 sprint (self, " \b7\b nilsrar3 \bnils arena 3\n");
 sprint (self, " \b8\b pen2             \n");
 sprint (self, " \b9\b pitarena \bthe pit arena\n");

 sprint (self, " ’ \bEXIT\n");      
 sprint (self,"\n");
 sprint (self, "select map\n");
};

void () warp_menu_five=
{
 sprint (self,"\n");
 sprint (self,"\n");
 sprint (self, " \b1\b ptucket  \bpawtucket palladium\n");
 sprint (self, " \b2\b ra_funkf \bfunkadooda's revenge\n");
 sprint (self, " \b3\b rarena3  \brage arena\n");
 sprint (self, " \b4\b rgarden  \brock garden\n");
 sprint (self, " \b5\b soyarena \bflesh arena\n");
 sprint (self, " \b6\b terrain2 \bterrain\n");
 sprint (self, " \b7\b uarena1  \bunknown arena\n");
 sprint (self, " \b8\b unholy   \bunholy chapel\n");
 sprint (self, " \b9\b xarena3  \bX arena\n");
 sprint (self, "\b10\b yard1    \bthe backyard\n");
 sprint (self, " ’ \bEXIT\n");      
 sprint (self,"\n");
 sprint (self, "select map\n");
};

void () warp_menu_six=
{
 sprint (self,"\n");

 sprint (self, " \b1\b bundes     \bBunny In Desert\n");
 sprint (self, " \b2\b cdff       \bcrazy dopefish\n");
 sprint (self, " \b3\b cockra     \bcock arena\n");
 sprint (self, " \b4\b ctf1raff2  \bmckinley arena\n");
 sprint (self, " \b5\b cy2        \bthe courtyard\n");
 sprint (self, " \b6\b dark       \bthe dark arena\n");
 sprint (self, " \b7\b death1     \bsudden death\n");
 sprint (self, " \b8\b doomfsky   \bdoom2 arena\n");
 sprint (self, " \b9\b efra       \bred pool\n");

 sprint (self, " ’ \bEXIT\n");      
 sprint (self,"\n");
 sprint (self, "select map\n");
};

void () warp_menu_seven=
{
 sprint (self,"\n");

 sprint (self, " \b1\b gear9     \bGalapagos\n");
 sprint (self, " \b2\b jexra1    \bloophole\n");
 sprint (self, " \b3\b lostcave  \bthe lost cave\n");
 sprint (self, " \b4\b macarena  \bthe mac arena\n");
 sprint (self, " \b5\b rcra2     \bbrodman's arena\n");
 sprint (self, " \b6\b tigra3    \btigger-on's arena\n");
 sprint (self, " \b7\b tree      \bthe tree\n");
 sprint (self, " \b8\b warhous   \bthe warehouse arena\n");
 sprint (self, " \b9\b zaprmx    \bzaphods arena rmx\n");

 sprint (self, " ’ \bEXIT\n");      
 sprint (self,"\n");
 sprint (self, "select map\n");
};



/*
void () warp_menu_eight=
{
 (self,"\n");
 sprint (self," “ \n");
 sprint (self," ” \n");
 sprint (self," • \n");
 sprint (self," – \n");
 sprint (self," — \n");
 sprint (self," ˜ \n");
 sprint (self," ™ \n");
 sprint (self," š \n");
 sprint (self," › \n");
 sprint (self," ’ \bEXIT\n");      
 sprint (self, "\n");
 sprint (self, "select map\n");
};

void () warp_menu_nine=
{
 sprint (self,"\n");
 sprint (self," “ \n");
 sprint (self," ” \n");
 sprint (self," • \n");
 sprint (self," – \n");
 sprint (self," — \n");
 sprint (self," ˜ \n");
 sprint (self," ™ \n");
 sprint (self," š \n");
 sprint (self," › \n");
 sprint (self," ’ \bEXIT\n");      
 sprint (self, "\n");
 sprint (self, "select map\n");
};

void () warp_menu_ten=
{
 sprint (self,"\n");
 sprint (self," “ \n");
 sprint (self," ” \n");
 sprint (self," • \n");
 sprint (self," – \n");
 sprint (self," — \n");
 sprint (self," ˜ \n");
 sprint (self," ™ \n");
 sprint (self," š \n");
 sprint (self," › \n");
 sprint (self," ’ \bEXIT\n");      
 sprint (self, "\n");
 sprint (self, "select map\n");
};

void () warp_menu_eleven=
{
 sprint (self,"\n");
 sprint (self," “ \n");
 sprint (self," ” \n");
 sprint (self," • \n");
 sprint (self," – \n");
 sprint (self," — \n");
 sprint (self," ˜ \n");
 sprint (self," ™ \n");
 sprint (self," š \n");
 sprint (self," › \n");
 sprint (self," ’ \bEXIT\n");      
 sprint (self, "\n");
 sprint (self, "select map\n");
};
*/

void () select_map =

{ 
if (!(self.impulse >= 230) && (self.impulse <= 245)) return;


if ((self.finaldest_z==0)&&(self.warp_map==0)) 
     {
      sprint (self,"\bCanceled\n");
      self.use=SUB_Null;
      self.warp_map=0;
      self.warp_episode=0;
     }
 else
 {
  if (self.finaldest_z==1) 
     {
      self.warp_map=1;
      client_select_warp();
     }
 else{    
  if (self.finaldest_z==2) 
     {
      self.warp_map=2;
      client_select_warp();
     }
 else{
  if (self.finaldest_z==3) 
     {
      self.warp_map=3;
      client_select_warp();
     }
 else{ 
  if (self.finaldest_z==4) 
     {
      self.warp_map=4;
      client_select_warp();
     }
 else{     
  if (self.finaldest_z==5) 
     {
      self.warp_map=5;
      client_select_warp();
     }
 else{     
  if (self.finaldest_z==6) 
     {
      self.warp_map=6;
      client_select_warp();
     }
 else{     
     
  if (self.finaldest_z==7) 
     {
      self.warp_map=7;
      client_select_warp();
     }

 else{     
 if (self.finaldest_z==8) 
     {
      self.warp_map=8;
      client_select_warp();
     }
 else
 {     
 if (self.finaldest_z==9) 
     {
      self.warp_map=9;
      client_select_warp();
     }
 else
 {     
 if (self.finaldest_z==10) 
     {
      self.warp_map=10;
      client_select_warp();
     }
     else
 {     
 if (self.finaldest_z==11) 
     {
      self.warp_map=11;
      client_select_warp();
     }

 else
 {   
      sprint (self,"\bcanceled\n");
      self.use=SUB_Null;
      self.warp_map=0;
      self.warp_episode=0;
                   
                       }//11
                      }//10
                     }//9
                    }//8
                   }//7
                  }//6
                 }//5
                }//4
               }//3
              }//2
             }//1
            }//else
self.use=SUB_Null;
};

void () select_episode =

{ 
if ((self.finaldest_z==0)&&(self.warp_episode==0)) 
     {
      sprint (self,"\bCanceled\n");
      self.use=SUB_Null;
      self.warp_episode=0;
      self.warp_map=0;
      return;
     }
 else{
  if (self.finaldest_z==1) 
     {
      warp_menu_one();  
      self.warp_episode=1;
      self.use=select_map;
     }
 else{     
  if (self.finaldest_z==2) 
     {
      warp_menu_two();  
      self.warp_episode=2;
      self.use=select_map;
     }
 else{     
  if (self.finaldest_z==3) 
     {
      warp_menu_three();  
      self.warp_episode=3;
      self.use=select_map;
     }
 else{     
  if (self.finaldest_z==4) 
     {
      warp_menu_four();  
      self.warp_episode=4;
      self.use=select_map;
     }
 else{     
  if (self.finaldest_z==5) 
     {
      warp_menu_five();  
      self.warp_episode=5;
      self.use=select_map;
     }
 
 else{     
 
 
 
 if (self.finaldest_z==6) 
          
    {
      warp_menu_six();  
      self.warp_episode=6;
      self.use=select_map;
     } 
 
 else{     
     
  if (self.finaldest_z==7) 
     {
      warp_menu_seven();  
      self.warp_episode=7;
      self.use=select_map;
     }
  
// Added new maps and change to the next map in roration. Added this an and impulse in SERVER.QC - woods
 
   
 else{  
  if (self.finaldest_z==8) 
     


     {
      vote_init ("change to ", "the next level", NextLevel); 
      vote_yes(); 
      
     }

  // End change -- woods

/* else{
  if (self.finaldest_z==9) 
     {
      warp_menu_nine();
      self.warp_episode=9;
      self.use=select_map;
     }


   */  


 else
  {  
      sprint (self,"canceled\n");
      self.use=SUB_Null;
      self.warp_episode=0;
      return;
              }//1
             }//2
            }//3
           }//4
          }//5
         }//6
        }//7
      }//8
    //}//9
 }//else

};


void () client_select_warp =
{  
 if (!self.warp_episode)
    {
     warp_menu_top();
     self.use=select_episode;
    }
 
 if (self.warp_map)
    {  
     self.warp_map=(self.finaldest_z);
     votables_request_change_level();
    }
};

