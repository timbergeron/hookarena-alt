//
//  C O M M A N D
//
//  Interpret a console command.  Called from start_frame.
//
void (float command) console_command =
{
    if (command >= 1000)
    {
        ra_password = command;
    }    
};
