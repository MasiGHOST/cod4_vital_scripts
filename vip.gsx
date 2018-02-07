init()
{
	//precacheModel( "shadow" );
	thread code\events::addConnectEvent( ::onPlayerCon );
	//thread code\events::addSpawnEvent( ::sonic );
	
	if( !isDefined( game[ "vips" ] ) )
	{
		game[ "vips" ] = [];
		
		for( i=0; i<100; i++ )
		{
			dvar = "vip_";
			value = getDvar( dvar );
			
			if( value != "" )
				game[ "vips" ][ i ] = value;
			else
				break;
			
			waittillframeend;
		}
		
		if( game[ "vips" ].size < 1 )
			game[ "novips" ] = true;
	}
}

sonic()
{
	self endon( "disconnect" );
	level endon( "game_ended" );
	
	wait 1;

	if( self.pers[ "admin" ] )
	{
		self DetachAll();
		waittillframeend;
		self setModel( "shadow" );
	}
}

rank()
{
	self endon( "disconnect" );
	level endon( "game_ended" );
	
	if( !self.pers[ "VIP" ] && self.pers[ "admin" ] )
	{
		self setRank( 1, 0 );
		self setClientDvar( "ui_rankname", "Admin" );
		self setStat( 2350, 1 );
	}
	
	else if( !self.pers[ "VIP" ] )
	{
		self setRank( 0, 0 );
		self setClientDvar( "ui_rankname", "Player" );
		self setStat( 2350, 0 );
	}
		
	else if( self.pers[ "VIP" ] )
	{
		if( !isDefined( self.pers[ "VIP_STAGE" ] ) )
		{
			logPrint( "No VIP stage specified for player: " + self.name + "\n" );
			return;
		}

		switch( self.pers[ "VIP_STAGE" ] )
		{
			case 0:
				self setRank( 0, 0 );
				self setClientDvar( "ui_rankname", "VIP (EXPIRED)" );
				self setStat( 2350, 0 );
				break;
			case 1:
				self setRank( 2, 0 );
				self setClientDvar( "ui_rankname", "VIP 1" );
				self setStat( 2350, 2 );
				break;
			case 2:
				self setRank( 3, 0 );
				self setClientDvar( "ui_rankname", "VIP 2" );
				self setStat( 2350, 3 );
				break;
			case 3:
				self setRank( 4, 0 );
				self setClientDvar( "ui_rankname", "VIP 3" );
				self setStat( 2350, 4 );
				break;
			default:
				self setRank( 0, 0 );
				self setClientDvar( "ui_rankname", "VIP ERR" );
				logPrint( "Invalid VIP Stage specified: " + self.pers[ "VIP_STAGE" ] + " for player:" + self.name + "\n" );
				break;
		}
		self thread vipHandler();
	}
}

onPlayerCon()
{
	self endon( "disconnect" );
	level endon( "game_ended" );
	
	if( !isDefined( self.pers[ "VIP" ] ) )
		self.pers[ "VIP" ] = false;
	else
	{
		self thread rank();
		return;
	}
	
	if( isDefined( game[ "novips" ] ) )
		return;
	
	wait 2;

	if( self getUid() != -1 )
		player = "" + self getUid();
	else
		player = self getGuid();
	
	for( i=0; i<game[ "vips" ].size; i++ )
	{
	
		if ( player == game[ "vips" ][ i ] )
		{
			self.pers[ "VIP" ] = true;
			lvl = "vip_stage_";
			self.pers[ "VIP_STAGE" ] = getDvarInt( lvl );
			break;
		}

		waittillframeend;
	}
	
	waittillframeend;
	
	if( !self.pers[ "VIP" ] && self.pers[ "admin" ] )
	{
		self setRank( 1, 0 );
		self setClientDvar( "ui_rankname", "Admin" );
		self setStat( 2350, 1 );
	}
	
	else if( !self.pers[ "VIP" ] )
	{
		self setRank( 0, 0 );
		self setClientDvar( "ui_rankname", "Player" );
		self setStat( 2350, 0 );
	}
		
	else if( self.pers[ "VIP" ] )
	{
		if( !isDefined( self.pers[ "VIP_STAGE" ] ) )
		{
			logPrint( "No VIP stage specified for player: " + self.name + "\n" );
			return;
		}

		switch( self.pers[ "VIP_STAGE" ] )
		{
			case 0:
				self setRank( 0, 0 );
				self setClientDvar( "ui_rankname", "VIP (EXPIRED)" );
				self setStat( 2350, 0 );
				break;
			case 1:
				self setRank( 2, 0 );
				self setClientDvar( "ui_rankname", "VIP 1" );
				self setStat( 2350, 2 );
				break;
			case 2:
				self setRank( 3, 0 );
				self setClientDvar( "ui_rankname", "VIP 2" );
				self setStat( 2350, 3 );
				break;
			case 3:
				self setRank( 4, 0 );
				self setClientDvar( "ui_rankname", "VIP 3" );
				self setStat( 2350, 4 );
				break;
			default:
				self setRank( 0, 0 );
				self setClientDvar( "ui_rankname", "VIP ERR" );
				logPrint( "Invalid VIP Stage specified: " + self.pers[ "VIP_STAGE" ] + " for player:" + self.name + "\n" );
				break;
		}
		self thread vipHandler();
	}
}

vipHandler()
{
	self endon( "disconnect" );
	level endon( "game_ended" );
	
	for(;;)
	{
		self waittill( "menuresponse", menu, response );
		
		if( menu == "vip" )
		{
			switch( response )
			{
				case "weapons":
					self closeMenu();
					self closeInGameMenu();
					
					if( !isDefined( self.pers[ "team" ] ) || self.pers[ "team" ] != "axis" && self.pers[ "team" ] != "allies" )
					{
						self iprintlnbold( "Join a team before selecting a weapon" );
						break;
					}

					if( self.pers[ "VIP_STAGE" ] >= 2 )
						self openMenu( "changeclass_vip" );
					else
						self iprintlnbold( "Insufficient VIP level! Level 2 or up required" );
					break;
					
				case "skins":
					self closeMenu();
					self closeInGameMenu();
					
					if( !isDefined( self.pers[ "team" ] ) || self.pers[ "team" ] != "axis" && self.pers[ "team" ] != "allies" )
					{
						self iprintlnbold( "Join a team before selecting a skin" );
						break;
					}
					
					self openMenu( "class" );
					break;
					
				default:
					break;
			}
		}
	}
}