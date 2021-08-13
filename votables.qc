string request_mapname;

void () votables_change_level =
{    
 changelevel(request_mapname);   
};

void () votables_request_change_level =
{
   	local float level;
   	local string newmap;

   	self.use = SUB_Null;

        level = (self.warp_episode * 10) + (self.warp_map);
   	newmap = strings_get_mapname(level);
        self.warp_episode=0;
      	self.warp_map=0;
      	
   	if (newmap == "") 
   	{
    	sprint(self, "Invalid map\n");
        self.warp_episode=0;
      	self.warp_map=0;
      	return;
        }

   	if (self.style & RA_ADMIN) 
   	{
      	 request_mapname = newmap;
      	 self.warp_episode=0;
      	 self.warp_map=0;
      	 votables_change_level();
        }
   	
   	else
	
	if (vote_init("change map to ", newmap, votables_change_level)) 
	{
    	 request_mapname = newmap;
       	 vote_yes();
  	}
     
};

void (float episode) votables_init_warp =
{
   self.count = episode;
   self.use = votables_request_change_level;
};

