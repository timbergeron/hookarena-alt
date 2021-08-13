// code for ghosting keep score -- woods

void() js_backup =
{
         // create a temp 'ghost' player storing name and frags
         
                gh = spawn();
                gh.classname = "ghost";     // had to call it something !
                gh.think = SUB_Remove;      // -* cleared after five
                gh.nextthink = time + 300;  //   minutes of absence *-           
                gh.netname = self.netname;
                gh.frags = self.frags;
};        

void() js_resume =
{
        local   entity jstest;
        local   float list;
        local entity jstest;
        list = 16;                   
        jstest = find (world, classname, "ghost");
        if (jstest)
        {       
                while (list > 1)
                {
                        jstest = find (jstest, classname, "ghost");
                        if (!jstest)
                                jstest = find (jstest, classname, "ghost");
                        list = list - 1;
                        if (self.netname == jstest.netname)      
                        {                                //a nick that matches 
                             self.frags = jstest.frags;  //a ghost-name restores
                             return;                     // your fragcount
                        }
                        
                }
                
        }

};
                                                        
void() js_update =
{
        local   entity jstest;
        local   float list;
        local entity jstest;
        list = 16;  
                         
        jstest = find (world, classname, "ghost");
        if (jstest)
        {       
                while (list > 1)
                {
                        jstest = find (jstest, classname, "ghost");
                        if (!jstest)
                                jstest = find (jstest, classname, "ghost");
                        list = list - 1;
                        if (self.netname == jstest.netname)                                                          
                        {
                                jstest.frags = self.frags;
                                jstest.nextthink = time + 300; 
                                return;                                                            //the server 
                        }
                }
                
        }

};
