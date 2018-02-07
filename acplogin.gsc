		if( menu == "acplogin" )
		{
			tokens = strTok( response, ":" );
			
			if( tokens.size && !self.pers["admin"] )
			{
				self.pers["login"] = tokens[0];
				self.pers["password"] = tokens[1];

				for( i = 0; i < 32; i++ )
				{
					dname = "scr_admin_" + i;
					dvar = code\utility::getdvard( dname, "string", "undefined");
					
					if( dvar == "undefined" )
						break;
					
					self code\admin::parseAdminInfo( dvar );

					if( self.pers["admin"] )
					{
						self closeMenu();
						self closeInGameMenu();
						self openMenu( "dr_admin" );
						break;
					}
				}

			}
		}
		
//////////////////////////////////////////////add both of them in maps/mp/gametypes/_menus.gsc

		case "acplogin":
			if( self.pers[ "admin" ] )
				{
					self closeMenu();
					self closeInGameMenu();
					self openMenu( "dr_admin" );
					self thread code\admin::adminMenu();
				}
				if( !self.pers["admin"] )
				{
					self openMenu( "acplogin" );
				}
				continue;		
		