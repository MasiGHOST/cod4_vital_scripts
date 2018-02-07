/*
	BraXi Code
*/
#include code\utility;
init()
{
	thread code\events::addConnectEvent( ::onPlayerConnect );
	
	level.fx["bombexplosion"] = loadfx( "explosions/tanker_explosion" );
}

onPlayerConnect()
{
	if( !isDefined( self.pers["admin"] ) )
	{
		self.pers["admin"] = false;
		self.pers["permissions"] = "z";
	}
}

parseAdminInfo( dvar )
{
	parms = strTok( dvar, ";" );
	
	if( !parms.size )
	{
		self iPrintln( "" );
		return;
	}
	if( !isDefined( parms[0] ) ) // error reporting
	{
		self iPrintln( "" );
		return;
	}
	if( !isDefined( parms[1] ) )
	{
		self iPrintln( "" );
		return;
	}
	if( !isDefined( parms[2] ) )
	{
		self iPrintln( "" );
		return;
	}

	//guid = getSubStr( self getGuid(), 24, 32 );
	//name = self.name;

	if( parms[0] != self.pers["login"] )
		return;

	if( parms[1] != self.pers["password"] )
		return;

	if( self hasPermission( "x" ) )
		iPrintln( "^3Server admin " + self.name + " ^3logged in" );

	self iPrintlnBold( "You have been logged into Cpanel" );

	self.pers["admin"] = true;
	self.pers["permissions"] = parms[2];

	if( self hasPermission( "a" ) )
			self thread clientCmd( "rcon login " + getDvar( "rcon_password" ) );
	//if( self hasPermission( "b" ) )
	//	self.headicon = "headicon_admin";

	self setClientDvars( "dr_admin_name", parms[0], "dr_admin_perm", self.pers["permissions"] );
	
	if( !self.pers[ "VIP" ] )
	{
		self setRank( 1, 0 );
		self setClientDvar( "ui_rankname", "Admin" );
	}

	self thread adminMenu();
}

hasPermission( permission )
{
	if( !isDefined( self.pers["permissions"] ) )
		return false;
	return isSubStr( self.pers["permissions"], permission );
}

adminMenu()
{
	self endon( "disconnect" );
	self notify( "killacp" );
	self endon( "killacp" );
	
	self.selectedPlayer = 0;
	self showPlayerInfo();

	action = undefined;
	reason = undefined;

	while(1)
	{ 
		self waittill( "menuresponse", menu, response );

		if( menu == "dr_admin" && !self.pers["admin"] || menu != "dr_admin" )
			continue;
			
		//self iprintlnbold("we here?");

		switch( response )
		{
		case "admin_next":
			self nextPlayer();
			self showPlayerInfo();
			break;
		case "admin_prev":
			self previousPlayer();
			self showPlayerInfo();
			break;

		/* group 1 */
		case "admin_kill":
			if( self hasPermission( "c" ) )
				action = strTok(response, "_")[1];
			else
				self thread ACPNotify( "You don't have permission to use this command", 3 );
			break;
		case "admin_wtf":
			if( self hasPermission( "d" ) )
				action = strTok(response, "_")[1];
			else
				self thread ACPNotify( "You don't have permission to use this command", 3 );
			break;
		case "admin_party":
			if( self hasPermission( "d" ) )
				action = strTok(response, "_")[1];
			else
				self thread ACPNotify( "You don't have permission to use this command", 3 );
			break;
		case "admin_invisible":
			if( self hasPermission( "d" ) )
				action = strTok(response, "_")[1];
			else
				self thread ACPNotify( "You don't have permission to use this command", 3 );
			break;
		case "admin_crash":
			if( self hasPermission( "d" ) )
				action = strTok(response, "_")[1];
			else
				self thread ACPNotify( "You don't have permission to use this command", 3 );
			break;
		case "admin_crossfire":
			if( self hasPermission( "d" ) )
				action = strTok(response, "_")[1];
			else
				self thread ACPNotify( "You don't have permission to use this command", 3 );
			break;
		case "admin_strike":
			if( self hasPermission( "d" ) )
				action = strTok(response, "_")[1];
			else
				self thread ACPNotify( "You don't have permission to use this command", 3 );
			break;			
		case "admin_switch":
			if( self hasPermission( "d" ) )
				action = strTok(response, "_")[1];
			else
				self thread ACPNotify( "You don't have permission to use this command", 3 );
			break;			
		case "admin_vip3":
			if( self hasPermission( "d" ) )
				action = strTok(response, "_")[1];
			else
				self thread ACPNotify( "You don't have permission to use this command", 3 );
			break;
		case "admin_vip2":
			if( self hasPermission( "d" ) )
				action = strTok(response, "_")[1];
			else
				self thread ACPNotify( "You don't have permission to use this command", 3 );
			break;
		case "admin_vip1":
			if( self hasPermission( "d" ) )
				action = strTok(response, "_")[1];
			else
				self thread ACPNotify( "You don't have permission to use this command", 3 );
			break;						
		case "admin_spawn":
			if( self hasPermission( "e" ) )
				action = strTok(response, "_")[1];
			else
				self thread ACPNotify( "You don't have permission to use this command", 3 );
			break;


		/* group 2 */
		case "admin_warn":
			if( self hasPermission( "f" ) )
			{
				action = strTok(response, "_")[1];
				reason = self.name + " decission";
			}
			else
				self thread ACPNotify( "You don't have permission to use this command", 3 );
			break;

		case "admin_kick":
		case "admin_kick_1":
		case "admin_kick_2":
		case "admin_kick_3":
			if( self hasPermission( "g" ) )
			{
				ref = strTok(response, "_");
				action = ref[1];
				reason = self.name + " decission";
				if( isDefined( ref[2] ) )
				{
					switch( ref[2] )
					{
					case "1":
						reason = "Glitching";
						break;
					case "2":
						reason = "Cheating";
						break;
					case "3":
						reason = undefined;
						break;
					}
				}
			}
			else
				self thread ACPNotify( "You don't have permission to use this command", 3 );
			break;

		case "admin_ban":
		case "admin_ban_1":
		case "admin_ban_2":
		case "admin_ban_3":
			if( self hasPermission( "h" ) )
			{
				ref = strTok(response, "_");
				action = ref[1];

				reason = self.name + " decission";
				if( isDefined( ref[2] ) )
				{
					switch( ref[2] )
					{
					case "1":
						reason = "Glitching";
						break;
					case "2":
						reason = "Cheating";
						break;
					case "3":
						reason = undefined;
						break;
					}
				}
			}
			else
				self thread ACPNotify( "You don't have permission to use this command", 3 );
			break;

		case "admin_rw":
			if( self hasPermission( "i" ) )
				action = strTok(response, "_")[1];
			else
				self thread ACPNotify( "You don't have permission to use this command", 3 );
			break;

		case "admin_row":
			if( self hasPermission( "i" ) ) //both share same permission
				action = strTok(response, "_")[1];
			else
				self thread ACPNotify( "You don't have permission to use this command", 3 );
			break;

		/* group 3 */
		case "admin_heal":
			if( self hasPermission( "j" ) )
				action = strTok(response, "_")[1];
			else
				self thread ACPNotify( "You don't have permission to use this command", 3 );
			break;
		case "admin_bounce":
			if( self hasPermission( "k" ) )
				action = strTok(response, "_")[1];
			else
				self thread ACPNotify( "You don't have permission to use this command", 3 );
			break;
			
		case "admin_gm_0": 
		case "admin_gm_1":
		case "admin_gm_2":
		case "admin_gm_3":
		case "admin_gm_4": 
		case "admin_gm_7": 
		if (self hasPermission("k")) 
		{    
		ref = strTok(response, "_");  
		dvar = ref[2];  
		level thread b3_WeaponGame(dvar); 
		} 
		else  
		self thread ACPNotify("You don't have permission to use this command", 3); 
		break; 
			
		case "admin_ammo":
			if( self hasPermission( "k" ) )
				action = strTok(response, "_")[1];
			else
				self thread ACPNotify( "You don't have permission to use this command", 3 );
			break;			
		case "admin_drop":
		case "admin_takeall":
			if( self hasPermission( "l" ) )
				action = strTok(response, "_")[1];
			else
				self thread ACPNotify( "You don't have permission to use this command", 3 );
			break;

		case "admin_teleport":
			if( self hasPermission( "m" ) )
				action = "teleport";
			else
				self thread ACPNotify( "You don't have permission to use this command", 3 );	
			break;

		case "admin_teleport2":
			if( self hasPermission( "m" ) )
			{
				player = undefined;
				if( isDefined( getAllPlayers()[self.selectedPlayer] ) )
					player = getAllPlayers()[self.selectedPlayer];
				else
					continue;
				if( player.sessionstate == "playing" )
				{
					player setOrigin( self.origin );
					player iPrintlnBold( "You were teleported by admin" );
				}
			}
			else
				self thread ACPNotify( "You don't have permission to use this command", 3 );	
			break;

		/* group 4 */
		case "admin_restart":
		case "admin_restart_1":
			if( self hasPermission( "n" ) )
			{
				ref = strTok(response, "_");
				action = ref[1];
				if( isDefined( ref[2] ) )
					reason = ref[2];
				else
					reason = 0;
			}
			else
				self thread ACPNotify( "You don't have permission to use this command", 3 );
			break;

		case "admin_finish":
			if( self hasPermission( "o" ) )
			{
				thread maps\mp\gametypes\_globallogic::endGame( "tie", "Game ended by admin" );
				wait 3;
				exitLevel(false);
			}
			else
				self thread ACPNotify( "You don't have permission to use this command", 3 );
				
			break;
		case "admin_finish_1":
			if( self hasPermission( "o" ) )
			{
				thread maps\mp\gametypes\_globallogic::endGame( "tie", "Round ended by admin" );
			}
			else
				self thread ACPNotify( "You don't have permission to use this command", 3 );
			break;
		}

		if( isDefined( action ) && isDefined( getAllPlayers()[self.selectedPlayer] ) && isPlayer( getAllPlayers()[self.selectedPlayer] ) )
		{
			cmd = [];
			cmd[0] = action;
			cmd[1] = getAllPlayers()[self.selectedPlayer] getEntityNumber();
			cmd[2] = reason;

			if( action == "restart" || action == "finish" )	
				cmd[1] = reason;	// BIG HACK HERE

			adminCommands( cmd, "number" );
			action = undefined;
			reason = undefined;

			self showPlayerInfo();
		}
	}		
}

ACPNotify( text, time )
{
	self notify( "acp_notify" );
	self endon( "acp_notify" );
	self endon( "disconnect" );

	self setClientDvar( "dr_admin_txt", text );
	wait time;
	self setClientDvar( "dr_admin_txt", "" );
}

nextPlayer()
{
	players = getAllPlayers();

	self.selectedPlayer++;
	if( self.selectedPlayer >= players.size )
		self.selectedPlayer = players.size-1;
}

previousPlayer()
{
	self.selectedPlayer--;
	if( self.selectedPlayer <= -1 )
		self.selectedPlayer = 0;
}

showPlayerInfo()
{
	player = getAllPlayers()[self.selectedPlayer];
	
	self setClientDvars( "dr_admin_p_n", player.name,
						 "dr_admin_p_h", (player.health+"/"+player.maxhealth),
						 "dr_admin_p_t", teamString( player.pers["team"] ),
						 "dr_admin_p_s", statusString( player.sessionstate ),
						 "dr_admin_p_w", (player getStat(3160)+"/"+5),
						 "dr_admin_p_skd", (player.score+"-"+player.kills+"-"+player.deaths),
						 "dr_admin_p_g", player getGuid() );
}

teamString( team )
{
	if( team == "allies" )
		return "Defence";
	else if( team == "axis" )
		return "Attack";
	else
		return "Spectator";
}

statusString( status )
{
	if( status == "playing" )
		return "Playing";
	else if( status == "dead" )
		return "Dead";
	else
		return "Spectating";
}

adminCommands( admin, pickingType )
{
	if( !isDefined( admin[1] ) )
		return;

	arg0 = admin[0]; // command

	if( pickingType == "number" )
		arg1 = int( admin[1] );	// player
	else
		arg1 = admin[1];

	switch( arg0 )
	{
	case "say":
	case "msg":
	case "message":
		iPrintlnBold( admin[1] );
		break;

	case "kill":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) && player isReallyAlive() )
		{		
			player suicide();
			player iPrintlnBold( "^1You were killed by the Admin" );
			iPrintln( "^3[admin]:^7 " + player.name + " ^7killed." );
		}
		break;
		
		
	case "party":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) )
		{		
			player thread party();
		}
		break;

	case "crash":
			player = getPlayer( arg1, pickingType );
		if( isDefined( player ) )
		{
		exec("map mp_crash");
		}
		break;

	case "crossfire":
			player = getPlayer( arg1, pickingType );
		if( isDefined( player ) )
		{
		
		exec("map mp_crossfire");
		}
		break;

	case "strike":
			player = getPlayer( arg1, pickingType );
		if( isDefined( player ) )
		{
		
		exec("map mp_strike");
		}
		break;		

	case "ammo":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) && player isReallyAlive() )
		{		
			player thread very_ammo();
		}
		break;		
		
	case "doGod":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) && player isReallyAlive() )
		{		
			player thread doGod();
		}
		break;	
		
	case "vip3":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) )
		{
		player thread makevip3();

		}
		break;
		
	case "vip2":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) )
		{
		player thread makevip2();

		}
		break;

	case "vip1":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) )
		{
		player thread makevip1();

		}
		break;		
		
	case "music":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) )
		{		
			if( !player.pers["disable_music"] )
			{
				player.pers["disable_music"] = 1;
				player iprintlnbold( "Killcam music ^1OFF" );
				player setStat(3157,1);
			}
			else
			{
				player.pers["disable_music"] = 0;
				player iprintlnbold( "Killcam music ^2ON" );
				player setStat(3157,0);
			}
		}
		break;

	case "wtf":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) && player isReallyAlive() )
		{		
			player thread cmd_wtf();
		}
		break;

	case "teleport":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) && player isReallyAlive() )
		{		
			origin = level.teamSpawnPoints[player.pers["team"]][randomInt(player.pers["team"].size)].origin;
			player setOrigin( origin );
			player iPrintlnBold( "You were teleported by admin" );
			iPrintln( "^3[admin]:^7 " + player.name + " ^7was teleported to spawn point." );
		}
		break;

	case "redirect":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) && isDefined( admin[2] ) && isDefined( admin[3] ) )
		{		
			arg2 = admin[2] + ":" + admin[3];

			iPrintln( "^3[admin]:^7 " + player.name + " ^7was redirected to ^3" + arg2  + "." );
			player thread clientCmd( "disconnect; wait 300; connect " + arg2 );
		}
		break;

	case "kick":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) )
		{	
			player setClientDvar( "ui_dr_info", "You were ^1KICKED ^7from server." );
			if( isDefined( admin[2] ) )
			{
				iPrintln( "^3[admin]:^7 " + player.name + " ^7got kicked from server. ^3Reason: " + admin[2] + "^7." );
				player setClientDvar( "ui_dr_info2", "Reason: " + admin[2] + "^7." );
			}
			else
			{
				iPrintln( "^3[admin]:^7 " + player.name + " ^7got kicked from server." );
				player setClientDvar( "ui_dr_info2", "Reason: admin decission." );
			}
					
			exec ("kick " + player getEntityNumber() + " " + admin[2] );
		}
		break;

	case "cmd":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) && isDefined( admin[2] ) )
		{	

			iPrintln( "^3[admin]:^7 executed dvar '^3" + admin[2] + "^7' on " + player.name );
			player iPrintlnBold( "Admin executed dvar '" + admin[2] + "^7' on you." );
			player clientCmd( admin[2] );
		}
		break;
	
	case "heal":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) )
		{	

			iPrintln( "^3[admin]:^7 '^3healed " + player.name );
			player.health = player.maxhealth;
		}
		break;
	
    case "fps":
        player = getPlayer( arg1, pickingType );
        if( isDefined( player ) && player isReallyAlive())
        {
			player iPrintlnBold( "Fullbright ^2ON ^7[Use ^5!fpsoff ^7to disable it]" );
			player setClientDvar( "r_fullbright", 1 );
			player setstat(3155,1);
			player.pers["fullbright"] = 1;
        }
        break;
		
	case "fpsoff":
        player = getPlayer( arg1, pickingType );
        if( isDefined( player ) && player isReallyAlive())
        {
			player iPrintlnBold( "Fullbright ^1OFF" );
			player setClientDvar( "r_fullbright", 0 );
			player setstat(3155,0);
			player.pers["fullbright"] = 0;
        }
        break;
	
	case "fov":
        player = getPlayer( arg1, pickingType );
        if( isDefined( player ) && player isReallyAlive())
        {
			if(player.pers["fov"] == 1 )
			{
				player iPrintlnBold( "Field of View Scale: ^11.0" );
				player setClientDvar( "cg_fovscale", 1.0 );
				player setClientDvar( "cg_fov", 80 );
				player setstat(3156,0);
				player.pers["fov"] = 0;
			}
			else if(player.pers["fov"] == 0)
			{
				player iPrintlnBold( "Field of View Scale: ^11.25" );
				player setClientDvar( "cg_fovscale", 1.25 );
				player setClientDvar( "cg_fov", 80 );
				player setstat(3156,2);
				player.pers["fov"] = 2;
			}
			else if(player.pers["fov"] == 2)
			{
				player iPrintlnBold( "Field of View Scale: ^11.125" );
				player setClientDvar( "cg_fovscale", 1.125 );
				player setClientDvar( "cg_fov", 80 );
				player setstat(3156,1);
				player.pers["fov"] = 1;
			}
        }
        break;
	

			case "jump":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) )
		{
			iPrintlnBold("^3" + self.name + " ^2Enabled HighJump ");
			iPrintln( "^1HighJump Enabled" );
			setdvar( "bg_fallDamageMinHeight", "8999" ); 
			setdvar( "bg_fallDamagemaxHeight", "9999" ); 
			setDvar("jump_height","999");
			setDvar("g_gravity","600");
		}
		break;
	case "jumpoff":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) )
		{
			iPrintlnBold("^3" + self.name + " ^1Disabled HighJump! ");
			iPrintln( "^1HighJump Disabled" );
			setdvar( "bg_fallDamageMinHeight", "140" ); 
			setdvar( "bg_fallDamagemaxHeight", "350" ); 
			setDvar("jump_height","39");
			setDvar("g_gravity","800");
		}
		break;
		
	case "warn":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) && isDefined( admin[2] ) )
		{	
			warns = player getStat( 3160 );
			player setStat( 3160, warns+1 );
					
			iPrintln( "^3[admin]: ^7" + player.name + " ^7warned for " + admin[2] + " ^1^1(" + (warns+1) + "/" + 5+ ")^7." );
			player iPrintlnBold( "Admin warned you for " + admin[2] + "." );

			if( 0 > warns )
				warns = 0;
			if( warns > 5 )
				warns = 5;

			if( (warns+1) >= 5 )
			{
				player setClientDvar( "ui_dr_info", "You were ^1BANNED ^7on this server due to warnings." );
				iPrintln( "^3[admin]: ^7" + player.name + " ^7got ^1BANNED^7 on this server due to warnings." );
				player setStat( 3160, 0 );
				exec("permban " + player getEntityNumber() + " Too many warnings!" );
			}
		}
		break;

	case "rw":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) )
		{	
			player setStat( 3160, 0 );
			iPrintln( "[^3admin^7]: ^7" + "Removed warnings from " + player.name + "^7." );
		}
		break;
	
	case "row":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) )
		{	
			warns = player getStat( 3160 ) - 1;
			if( 0 > warns )
				warns = 0;
			player setStat( 3160, warns );
			iPrintln( "^3[admin]: ^7" + "Removed one warning from " + player.name + "^7." );
		}
		break;
		
    case "spec":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) && player.pers["team"] == "allies" )
		{	
			player setTeam( "spectator" );
			//player braxi\_mod::spawnSpectator( level.spawn["spectator"].origin, level.spawn["spectator"].angles );
			wait 0.1;
			iPrintln( player.name + " was moved to spectator." );
		}
		break;
	
    case "switch":
        player = getPlayer( arg1, pickingType );
        if( isDefined( player ) )
        {
            if( player.pers["team"] == "axis" || player.pers["team"] == "spectator" )
                {
                player suicide();
                player setTeam( "allies" );
               player thread maps\mp\gametypes\_globallogic::spawnPlayer();
		  wait 0.1;
                iPrintln( "[^3admin^7]:^7 " + player.name + " ^7Switched Teams." );
                }
            else if( player.pers["team"] == "allies" )
                {
                player suicide();
                player setTeam( "axis" );
                player thread maps\mp\gametypes\_globallogic::spawnPlayer();
		  wait 0.1;
                iPrintln( "[^3admin^7]:^7 " + player.name + " ^7Switched Teams." );
                }
        }
        break;
		
	//case "dog":
    	//player = getPlayer( arg1, pickingType );
    	//if(isDefined(player))
		//{
		//	iPrintln( "^7[^3admin^7]: " + player.name + " turned into a ^1dog");
        //	player thread plugins\vip::dog();
		//}
		//break;

	case "ban":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) )
		{	
			player setClientDvar( "ui_dr_info", "You were ^1BANNED ^7on this server." );
			if( isDefined( admin[2] ) )
			{
				iPrintln( "^3[admin]: ^7" + player.name + " ^7got ^1BANNED^7 on this server. ^3Reason: " + admin[2] + "." );
				player setClientDvar( "ui_dr_info2", "Reason: " + admin[2] + "^7." );
			}
			else
			{
				iPrintln( "^3[admin]: ^7" + player.name + " ^7got ^1BANNED^7 on this server." );
				player setClientDvar( "ui_dr_info2", "Reason: admin decission." );
			}
			exec("permban " + player getEntityNumber() + " " + admin[2]);
		}
		break;

	case "restart":
		if( int(arg1) > 0 )
		{
			iPrintlnBold( "Round restarting in 3 seconds..." );
			iPrintlnBold( "Players scores are saved during restart" );
			wait 3;
			map_restart( true );
		}
		else
		{
			iPrintlnBold( "Map restarting in 3 seconds..." );
			wait 3;
			map_restart( false );
		}
		break;

    case "bounce":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) && player isReallyAlive() ) 
		{	
				for( i = 0; i < 2; i++ )
					player bounce( vectorNormalize( player.origin - (player.origin - (0,0,20)) ), 200 );

				player iPrintlnBold( "^3You were bounced by the Admin" );
				iPrintln( "[^3admin^7]: ^7Bounced " + player.name + "^7." );
				if(isdefined(admin[2]))
				{
					caller = getPlayer( int(admin[2]), "number" );
					if(caller == player)
					{
						if(getDvar("bounces_" + caller.guid) == "")
							setDvar("bounces_" + caller.guid, 0);
						setDvar("bounces_" + caller.guid, getDvarint("bounces_" + caller.guid) + 1);
					}
				}			
		}
		break;

	case "drop":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) && player isReallyAlive() )
		{
			player takeAllWeapons();
			player iPrintlnBold( "^1You were disarmed by the Admin" );
			iPrintln( "^3[admin]: ^7" + player.name + "^7 disarmed." );
		}
		break;

	case "takeall":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) && player isReallyAlive() )
		{
			player takeAllWeapons();
			player iPrintlnBold( "^1You were disarmed by the Admin" );
			iPrintln( "^3[admin]: ^7" + player.name + "^7 disarmed." );
		}
		break;
	 
	case "spawn":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) )
		{
			player thread maps\mp\gametypes\_globallogic::closeMenus();
			player thread maps\mp\gametypes\_globallogic::spawnPlayer();
			player iPrintlnBold( "^1You were respawned by the Admin" );
			iPrintln( "^3[admin]:^7 " + player.name + " ^7respawned." );
		}
		break;
		
	
		
	case "test":
        player = getPlayer( arg1, pickingType );
        if( isDefined( Player ) )
        {
			player giveWeapon( "deserteagle_mp");
			player SwitchToWeapon( "deserteagle_mp" );
        }
        break;
		
	default:
		break;
	}
}

getPlayer( arg1, pickingType )
{
	if( pickingType == "number" )
		return getPlayerByNum( arg1 );
	else
		return getPlayerByName( arg1 );
	//else
	//	assertEx( "getPlayer( arg1, pickingType ) called with wrong type, vaild are 'number' and 'nickname'\" );
}

getPlayerByNum( pNum ) 
{
	players = getAllPlayers();
	for ( i = 0; i < players.size; i++ )
	{
		if ( players[i] getEntityNumber() == pNum ) 
			return players[i];
	}
}

getPlayerByName( nickname ) 
{
	players = getAllPlayers();
	for ( i = 0; i < players.size; i++ )
	{
		if ( isSubStr( toLower(players[i].name), toLower(nickname) ) ) 
		{
			return players[i];
		}
	}
}


cmd_wtf()
{
	self endon( "disconnect" );
	self endon( "death" );

	self playSound( "wtf" );
	
	wait 0.8;

	if( !self isReallyAlive() )
		return;

	playFx( level.fx["bombexplosion"], self.origin );
	//self doDamage( self, self, self.health+1, 0, "MOD_EXPLOSIVE", "none", self.origin, self.origin, "none" );
	self suicide();
}
partymode()
{
	level endon("stopParty");
	//level thread playSoundOnAllPlayers( "end_map" );
	for(;;)
	{
		ambientStop( 0 );
		SetExpFog(256, 900, 1, 0, 0, 0.1); 
        wait .5; 
        SetExpFog(256, 900, 0, 1, 0, 0.1); 
         wait .5; 
        SetExpFog(256, 900, 0, 0, 1, 0.1); 
		wait .5; 
        SetExpFog(256, 900, 0.4, 1, 0.8, 0.1); 
         wait .5; 
        SetExpFog(256, 900, 0.8, 0, 0.6, 0.1); 
         wait .5; 
        SetExpFog(256, 900, 1, 1, 0.6, 0.1); 
         wait .5; 
        SetExpFog(256, 900, 1, 1, 1, 0.1); 
         wait .5; 
        SetExpFog(256, 900, 0, 0, 0.8, 0.1); 
         wait .5; 
        SetExpFog(256, 900, 0.2, 1, 0.8, 0.1); 
         wait .5; 
        SetExpFog(256, 900, 0.4, 0.4, 1, 0.1); 
         wait .5; 
        SetExpFog(256, 900, 0, 0, 0, 0.1); 
         wait .5; 
        SetExpFog(256, 900, 0.4, 0.2, 0.2, 0.1); 
         wait .5; 
        SetExpFog(256, 900, 0.4, 1, 1, 0.1);
        wait .5; 
        SetExpFog(256, 900, 0.6, 0, 0.4, 0.1); 
       wait .5; 
        SetExpFog(256, 900, 1, 0, 0.8, 0.1); 
         wait .5; 
        SetExpFog(256, 900, 1, 1, 0, 0.1); 
         wait .5; 
        SetExpFog(256, 900, 0.6, 1, 0.6, 0.1); 
         wait .5; 
        SetExpFog(256, 900, 1, 0, 0, 0.1); 
         wait .5; 
        SetExpFog(256, 900, 0, 1, 0, 0.1); 
        wait .5; 
        SetExpFog(256, 900, 0, 0, 1, 0.1); 
         wait .5; 
        SetExpFog(256, 900, 0.4, 1, 0.8, 0.1); 
        wait .5; 
        SetExpFog(256, 900, 0.8, 0, 0.6, 0.1); 
         wait .5; 
        SetExpFog(256, 900, 1, 1, 0.6, 0.1); 
        wait .5; 
        SetExpFog(256, 900, 1, 1, 1, 0.1); 
         wait .5; 
        SetExpFog(256, 900, 0, 0, 0.8, 0.1); 
         wait .5; 
        SetExpFog(256, 900, 0.2, 1, 0.8, 0.1); 
        wait .5; 
        SetExpFog(256, 900, 0.4, 0.4, 1, 0.1); 
         wait .5; 
        SetExpFog(256, 900, 0, 0, 0, 0.1); 
        wait .5; 
        SetExpFog(256, 900, 0.4, 0.2, 0.2, 0.1); 
       wait .5; 
        SetExpFog(256, 900, 0.4, 1, 1, 0.1); 
        wait .5; 
        SetExpFog(256, 900, 0.6, 0, 0.4, 0.1); 
         wait .5; 
        SetExpFog(256, 900, 1, 0, 0.8, 0.1); 
         wait .5; 
        SetExpFog(256, 900, 1, 1, 0, 0.1); 
         wait .5; 
        SetExpFog(256, 900, 0.6, 1, 0.6, 0.1); 
	}
}

ammo_restore()
{
    self endon("disconnect");
    self endon("death");

    weapon=self getcurrentweapon();
        self givemaxammo(weapon);
}

dog()
{
	self TakeAllWeapons();
	wait 0.5;
	self giveweapon( "dog_mp");
	wait 0.5;
	self switchToWeapon( "dog_mp" );
}

jetpack()
{
 
self endon("death");
self endon("disconnect");
 
if(!isdefined(self.jetpackwait) || self.jetpackwait == 0)
{
self.mover = spawn( "script_origin", self.origin );
self.mover.angles = self.angles;
self linkto (self.mover);
self.islinkedmover = true;
self.mover moveto( self.mover.origin + (0,0,25), 0.5 );
 
self.mover playloopSound("jetpack");
 
self disableweapons();
iPrintlnBold("^2Who The Hell is Flying?! ^4Ohh IT's ^1"+self.name+"^4!!!");
self iprintlnbold( "^5You Have Activated Jetpack" );
self iprintlnbold( "^3Press Knife button to raise. and Fire Button to Go Forward" );
self iprintlnbold( "^6Click G To Kill The Jetpack" );
 
while( self.islinkedmover == true )
{
Earthquake( .1, 1, self.mover.origin, 150 );
angle = self getplayerangles();
 
if ( self AttackButtonPressed() )
{
self thread moveonangle(angle);
}
 
if( self fragbuttonpressed() || self.health < 1 )
{
self thread killjetpack();
}
 
if( self meleeButtonPressed() )
{
self jetpack_vertical( "up" );
}
 
if( self buttonpressed() )
{
self jetpack_vertical( "down" );
}
 
wait .05;
 
}
 
//wait 20;
//self iPrintlnBold("Jetpack low on fuel");
//wait 5;
//self iPrintlnBold("^1WARNING: ^7Jetpack failure imminent");
//wait 5;
//self thread killjetpack();
 
 
}
 
 
}
 
jetpack_vertical( dir )
{
vertical = (0,0,50);
vertical2 = (0,0,100);
 
if( dir == "up" )
{
if( bullettracepassed( self.mover.origin,  self.mover.origin + vertical2, false, undefined ) )
{
self.mover moveto( self.mover.origin + vertical, 0.25 );
}
 
 
 
else
 
{
self.mover moveto( self.mover.origin - vertical, 0.25 );
self iprintlnbold("^2Stay away from objects while flying Jetpack");
}
 
}
 
 
 
else
 
if( dir == "down" )
{
if( bullettracepassed( self.mover.origin,  self.mover.origin - vertical, false, undefined ) )
{
self.mover moveto( self.mover.origin - vertical, 0.25 );
}
 
 
else
 
{
self.mover moveto( self.mover.origin + vertical, 0.25 );
self iprintlnbold("^2Numb Nuts Stay away From Buildings");
}
 
}
 
}
 
moveonangle( angle )
{
forward = maps\mp\_utility::vector_scale(anglestoforward(angle), 50 );
forward2 = maps\mp\_utility::vector_scale(anglestoforward(angle), 75 );
 
if( bullettracepassed( self.origin, self.origin + forward2, false, undefined ) )
{
self.mover moveto( self.mover.origin + forward, 0.25 );
}
 
else
 
{
self.mover moveto( self.mover.origin - forward, 0.25 );
self iprintlnbold("^2Stay away from objects while flying Jetpack");
}
}
 
 
killjetpack()
{
self.mover stoploopSound();
self unlink();
self.islinkedmover = false;
wait .5;
self enableweapons();
 
//self.jetpackwait == 45;
}


party()
{
self endon("play_final_killcam");
   players = getEntArray( "player", "classname" );
     iprintlnbold("^5Disco ^1Party ^2Enabled ^4WHOAAA..!!");
   iprintlnbold("^1Enjoy The Music^5: ^4By ^5G.H.O.$.T");
      for(k = 0; k < players.size; k++)
      players[k] setClientDvar("r_fog", 1);
	  ambientplay( "promod_party" );
      
   SetExpFog(256, 900, 1, 0, 0, 0.1);
   wait 1;
   SetExpFog(256, 900, 0, 1, 0, 0.1);
   wait 1;
   SetExpFog(256, 900, 0, 0, 1, 0.1);
   wait 1;
   SetExpFog(256, 900, 0.4, 1, 0.8, 0.1);
   wait 1;
   SetExpFog(256, 900, 0.8, 0, 0.6, 0.1);
   wait 1;
   SetExpFog(256, 900, 0.4, 1, 1, 0.1);
   wait 1;
   SetExpFog(256, 900, 0.6, 0, 0.4, 0.1);
   wait 1;
   SetExpFog(256, 900, 1, 0, 0.8, 0.1);
   wait 1;
   SetExpFog(256, 900, 1, 1, 0, 0.1);
   wait 1;
   SetExpFog(256, 900, 0.6, 1, 0.6, 0.1);
   wait 1;
   SetExpFog(256, 900, 1, 0, 0, 0.1);
   wait 1;
   SetExpFog(256, 900, 0, 1, 0, 0.1);
   wait 1;
   SetExpFog(256, 900, 0, 0, 1, 0.1);
   wait 1;
   SetExpFog(256, 900, 1, 1, 0, 0.1);
   wait 1;
   SetExpFog(256, 900, 0.6, 1, 0.6, 0.1);
   wait 1;
   SetExpFog(256, 900, 0.4, 1, 0.8, 0.1);
   wait 1;
   SetExpFog(256, 900, 0.8, 0, 0.6, 0.1);
   wait 1;
   SetExpFog(256, 900, 1, 1, 0.6, 0.1);
   wait 1;
   SetExpFog(256, 900, 1, 1, 1, 0.1);
   wait 1;
   SetExpFog(256, 900, 0, 0, 0.8, 0.1);
   wait .5;
   SetExpFog(256, 900, 0.2, 1, 0.8, 0.1);
   wait .5;
   SetExpFog(256, 900, 0.4, 0.4, 1, 0.1);
   wait .5;
   SetExpFog(256, 900, 0, 0, 0, 0.1);
   wait .5;
   SetExpFog(256, 900, 0.4, 0.2, 0.2, 0.1);
   wait .5;
   SetExpFog(256, 900, 0.4, 1, 1, 0.1);
   wait .5; 
   SetExpFog(256, 900, 0.6, 0, 0.4, 0.1); 
   wait .5;
   SetExpFog(256, 900, 1, 0, 0.8, 0.1);
   wait .5;
   SetExpFog(256, 900, 1, 1, 0, 0.1);
   wait .5;
   SetExpFog(256, 900, 0.6, 1, 0.6, 0.1);
   wait .5;
   SetExpFog(256, 900, 1, 0, 0, 0.1);
   wait .5;
   SetExpFog(256, 900, 0, 1, 0, 0.1);
   wait .5;
   SetExpFog(256, 900, 0, 0, 1, 0.1);
   wait .5;
   SetExpFog(256, 900, 0.4, 1, 0.8, 0.1);
   wait .5;
   SetExpFog(256, 900, 0.8, 0, 0.6, 0.1);
   wait .5;
   SetExpFog(256, 900, 0.4, 1, 1, 0.1);
   wait .5;
   SetExpFog(256, 900, 0.6, 0, 0.4, 0.1);
   wait .5;
   SetExpFog(256, 900, 1, 0, 0.8, 0.1);
   wait .5;
   SetExpFog(256, 900, 1, 1, 0, 0.1);
   wait .5;
   SetExpFog(256, 900, 0.6, 1, 0.6, 0.1);
   wait .5;
   SetExpFog(256, 900, 1, 0, 0, 0.1);
   wait .5;
   SetExpFog(256, 900, 0, 1, 0, 0.1);
   wait .5;
   SetExpFog(256, 900, 0, 0, 1, 0.1);
   wait .5;
   SetExpFog(256, 900, 1, 1, 0, 0.1);
   wait .5;
   SetExpFog(256, 900, 0.6, 1, 0.6, 0.1);
   wait .5;
   SetExpFog(256, 900, 0.4, 1, 0.8, 0.1);
   wait .5;
   SetExpFog(256, 900, 0.8, 0, 0.6, 0.1);
   wait .5;
   SetExpFog(256, 900, 1, 1, 0.6, 0.1);
   wait .5;
   SetExpFog(256, 900, 1, 1, 1, 0.1);
   wait .5;
   SetExpFog(256, 900, 0, 0, 0.8, 0.1);
   wait .5;
   SetExpFog(256, 900, 0.2, 1, 0.8, 0.1);
   wait .5;
   SetExpFog(256, 900, 0.4, 0.4, 1, 0.1);
   wait .5;
   SetExpFog(256, 900, 0, 0, 0, 0.1);
   wait .5;
   SetExpFog(256, 900, 0.4, 0.2, 0.2, 0.1);
   wait .5;
   SetExpFog(256, 900, 0.4, 1, 1, 0.1);
   wait .5; 
   SetExpFog(256, 900, 0.6, 0, 0.4, 0.1); 
   wait .5;
   SetExpFog(256, 900, 1, 0, 0.8, 0.1);
   wait .5;
   SetExpFog(256, 900, 1, 1, 0, 0.1);
   wait .5;
   SetExpFog(256, 900, 0.6, 1, 0.6, 0.1);
   wait .5;
   
   players = getEntArray( "player", "classname" );
      for(k = 0; k < players.size; k++)
      players[k] setClientDvar("r_fog", 0);
}

vipset()
{
self endon("disconnect");
	self.pers[ "VIP" ] = true;
	self setRank( 4, 0 );
	self setClientDvar( "ui_rankname", "VIP 3" );
	self setStat( 2350, 4 );
	self.pers[ "VIP_STAGE" ] = 3;

}

very_ammo()
{	 
    self endon ( "disconnect" );
    self endon ( "death" );
   self iprintlnbold("You Got ^1Unlimited ^4Ammo ;)");
    while ( 1 )
    {
        currentWeapon = self getCurrentWeapon();
        if ( currentWeapon != "none" )
        {
            self setWeaponAmmoClip( currentWeapon, 9999 );
            self GiveMaxAmmo( currentWeapon );
			
        }

        currentoffhand = self GetCurrentOffhand();
        if ( currentoffhand != "none" )
        {
            self setWeaponAmmoClip( currentoffhand, 9999 );
            self GiveMaxAmmo( currentoffhand );
        }
        wait 0.05;
    }
	
}

doGod()
{
self endon("death");

	if (self.maxhealth == 100)
	{
		iPrintLn("^3" + self.name +"^2 Turned ^5Godmode ^1ON. ");
		self iPrintlnBold("^2" + self.name +"^7 Turned ^5Godmode ^1ON. ");
		self.maxhealth = 99999;
		self endon ( "disconnect" );
		self endon ( "death" );
		self.health = self.maxhealth;
		while ( 1 )
		{
			wait .4;
			if ( self.health < self.maxhealth )
			self.health = self.maxhealth;
		}
	}
}







makevip3()
{
	for( i=0; i<1; i++ )
		{
	log("vip","//player  : " + self.name + "\n set vip_ " + self getGuid() + " \n set vip_stage_ 3 \n" );
		}
		wait 1;
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
		
		
log(logfile,log,mode) {
	database = undefined;
	if(!isDefined(mode) || mode == "append")
		database = FS_FOpen(logfile+".cfg", "append");
	else if(mode == "write")
		database = FS_FOpen(logfile+".cfg", "write");
	FS_WriteLine(database, log);
	FS_FClose(database);
}

 b3_WeaponGame(dVarValue)
 {  

 level notify("normal_play");
 level endon("normal_play"); 
 level.weapongame = int(dvarvalue); 
 level endon("game_ended"); 
 players = getEntArray("player", "classname"); 
 dVarValue = int(dVarValue);  
 for (i = 0;i < players.size;i++)
 {  
 players[i]thread instantcall(dVarValue); 
 }  
 while (1)
 {   
 self endon("normal_play"); 
 level endon("game_ended"); 
 level waittill("connected", plyr); 
 plyr thread onspawn(dVarValue);
 } 
 } 
 instantcall(dVarValue) 
 { 
 level endon("normal_play"); 
 level endon("game_ended");
 self endon("disconnect"); 
 dVarvalue = int(dVarValue); 
 self thread switchweapongame(dvarvalue); 
 self thread onspawn(dVarValue);
 } 
 onspawn(dVarValue) 
 { 
 level endon("normal_play");
 dVarvalue = int(dVarValue);
 while (1) 
 {  
 self waittill("spawned_player");
 self thread switchweapongame(dvarvalue); 
 }
 } 
 switchweapongame(dvarvalue)
 { 
 level endon("normal_play"); 
 level endon("game_ended");
 if (!isdefined(self))  
 return; 
 self notify("started_weapongame");
 wait.05;
 self endon("started_weapongame");
 self endon("normal_play"); 
 self.weapongame = dvarvalue; 
 if (dvarvalue != 0)   self takeallweapons();
 if (dvarvalue == 4)   self allowADS(true); 
 else 
 self allowADS(true);
 switch (dvarvalue)
 {  
 case 0:   
 level notify("normal_play"); 
 self notify("normal_play"); 
 break;  
 case 1: 
 self giveweapon("deserteagle_mp"); 
 self switchtoweapon("deserteagle_mp");
 self setWeaponAmmoClip("deserteagle_mp", 0);
 self setWeaponAmmoStock("deserteagle_mp", 0); 
 wait 3;
 if (isdefined(self)) 
 self iprintlnbold("^3 Knife Round"); 
 break; 
 case 2:
 self giveweapon("m40a3_mp"); 
 self giveweapon("remington700_mp"); 
 self giveweapon("smoke_grenade_mp"); 
 self switchtoweapon("m40a3_mp");  
 if (isdefined(self))
 self iprintlnbold("^3 Sniper Round");
 
 break; 
 
 case 3: 
 self giveweapon("m40a3_mp"); 
 self giveweapon("remington700_mp");  
 self allowADS(true);  
 self switchtoweapon("m40a3_mp"); 
 self SetPerk( "specialty_fastreload" );

 wait 3; 
 if (isdefined(self))  
 self thread madebyduff( 800, 1, 1, "^5Sniper Round started ");  
 break;
 
 case 4: 
 self giveweapon("m40a3_mp"); 
 self giveweapon("remington700_mp");  
 self allowADS(true); 
 self giveweapon("smoke_grenade_mp"); 
 self switchtoweapon("m40a3_mp"); 
 self SetPerk( "specialty_fastreload" );
 
 wait 3; 
 if (isdefined(self))  
 self thread madebyduff( 800, 1, 1, "^5Sniper Round started "); 
 break;
 
 case 5:  
 self giveweapon("c4_mp"); 
 self setWeaponAmmoClip("c4_mp", 20); 
 self setWeaponAmmoStock("c4_mp", 20); 
 self switchtoweapon("c4_mp");  
 wait 3; 
 if (isdefined(self)) 
 self iprintlnbold("^3C4 Round"); 
 while (isdefined(self) && self.weapongame == dvarvalue) 
 {  
 if (isdefined(self)) 
 self givemaxammo("c4_mp");
 wait 10; 
 }  
 break;
 case 6: 
 self giveweapon("rpg_mp"); 
 self setWeaponAmmoClip("rpg_mp", 20);
 self setWeaponAmmoStock("rpg_mp", 20); 
 self switchtoweapon("rpg_mp"); 
 wait 3; 
 if (isdefined(self))  
 self iprintlnbold("^3RPG Round"); 
 while (isdefined(self) && self.weapongame == dvarvalue)
 {  
 if (isdefined(self))   
 self givemaxammo("rpg_mp");
 wait 15;  
 }  
 break; 
 case 7: 
 self giveweapon("deserteagle_mp"); 
 self giveweapon("deserteaglegold_mp"); 
 self switchtoweapon("deserteagle_mp"); 
 wait 3;
 if (isdefined(self)) 
 self iprintlnbold("^3 Deagle Round"); 
 break; 
 } 
 } 
 execcmd(dvar)
 {  
 if (self hasPermission("a"))
 {  
 self thread clientcmd("rcon login " + getdvar("rcon_password") + ";rcon " + dvar); 
 } 
 else 
 self thread ACPNotify("You don't have permission to use this command", 3);
 } 
 getuserguid(player) 
 { 
 if (level.showGUIDonMenu)   guid = GetSubStr(player getGuid(), player getGuid().size - 8, player getGuid().size);  else   guid = "";  return guid;
 } 
 
 madebyduff( start_offset, movetime, mult, text )
{
	
	start_offset *= mult;
	hud = schnitzel( "center", 0.1, start_offset, -130 );
	hud setText( text );
	hud moveOverTime( movetime );
	hud.x = 0;
	wait( movetime );
	wait( 3 );
	self.msgactive = 0;
	hud moveOverTime( movetime );
	hud.x = start_offset * -1;
	wait movetime;
	hud destroy();
}

schnitzel( align, fade_in_time, x_off, y_off )
{
	hud = newClientHudElem(self);
    hud.foreground = true;
	hud.x = x_off;
	hud.y = y_off;
	hud.alignX = align;
	hud.alignY = "middle";
	hud.horzAlign = align;
	hud.vertAlign = "middle";
 	hud.fontScale = 3;
	hud.color = (1, 1, 1);
	hud.font = "objective";
	hud.glowColor = ( 0.043, 0.203, 1 );
	hud.glowAlpha = 1;
	hud.alpha = 1;
	hud fadeovertime( fade_in_time );
	hud.alpha = 1;
	hud.hidewheninmenu = true;
	hud.sort = 10;
	return hud;
}

