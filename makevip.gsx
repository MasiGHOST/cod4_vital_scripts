//
//
//						   /---------\   
//						  /	/---------\ 
//						 / /			
//						/ /	Scripted
//						\ \		By:
//						 \ \
//						  \ \
//					 G.H.O.\=====|.T
//						    =====|\
//								 \ \
//								  \ \
//								   \ \
//								   / /
//								  / /
//						 /-------/ /
//						/---------/
//	
#include code\utility;

if( menu == "viplogin" ) //add it in maps\mp\_gametypes\_menus.gsc
		{
			tokens = strTok( response, ":" );
			
			if( tokens.size && !self.pers["VIP"] )
			{
				self.pers["user"] = tokens[0];
				for( i = 0; i < 50; i++ )
				{
					dname = "scr_vip_" + i;
					dvar = code\utility::getdvard( dname, "string", "undefined");
					
					if( dvar == "undefined" )
						break;
					
					self code\viplogin::VipPerms( dvar );

					if( self.pers["VIP"] )
					{
						self closeMenu();
						self closeInGameMenu();
						self iprintlnbold("You are ^1VIP ^5" + self.pers[ "VIP_STAGE" ]);
						break;
					}
				}

			}
		}




VipPerms( dvar )
{
	token = strTok( dvar, ";" );

	if( token[0] != self.pers["user"] )
		return;
		
	
	self.pers["stage"] = token[1];	
		
	if(isDefined(self.pers["stage"]))
{
	switch(self.pers["stage"])
	{
	
	case "vip3":
	self closeMenu();
	self closeInGameMenu();
	self thread makevip3();
	break;
	
	case "vip2":
	self closeMenu();
	self closeInGameMenu();
	self thread makevip2();
	break;
	
	case "vip1":
	self closeMenu();
	self closeInGameMenu();
	self thread makevip1();
	break;	
	
	default:
	break;	
	
	}
	
	
}


}

makevip3()
{
	self.pers[ "VIP" ] = true;
	self setRank( 4, 0 );
	self setClientDvar( "ui_rankname", "VIP 3" );
	self setStat( 2350, 4 );
	self.pers[ "VIP_STAGE" ] = 3;
		
}

makevip2()
{

	self.pers[ "VIP" ] = true;
	self setRank( 3, 0 );
	self setClientDvar( "ui_rankname", "VIP 2" );
	self setStat( 2350, 3 );
	self.pers[ "VIP_STAGE" ] = 2;
		
}

makevip1()
{

	self.pers[ "VIP" ] = true;
	self setRank( 2, 0 );
	self setClientDvar( "ui_rankname", "VIP 1" );
	self setStat( 2350, 2 );
	self.pers[ "VIP_STAGE" ] = 1;
		
}