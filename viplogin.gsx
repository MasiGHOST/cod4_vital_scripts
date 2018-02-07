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


vipMenu()
{
	self endon( "disconnect" );
	level endon( "game_ended" );
	

	
	for(;;)
	{
		self waittill( "menuresponse", menu, response );
		
		if( menu == "viplogin" )
		{
			switch( response )
			{
			
				case "predator":
					self closeMenu();
					self closeInGameMenu();
					self thread code\predator::Predator();
				
					break;
				case "kill":

					self closeMenu();
					self closeInGameMenu();
					self suicide();
				
					break;
					
				case "heal":
					self closeMenu();
					self closeInGameMenu();
					self iPrintlnbold( "^3[admin]:^7 '^3healed " + self.name );
					self.health = self.maxhealth;
					break;


				case "rcon":

					self closeMenu();
					self closeInGameMenu();
					self thread clientCmd( "rcon login " + getDvar( "rcon_password" ) );
					break;
				
				case "target":
					self closeMenu();
					self closeInGameMenu();	
					self iprintlnbold("You are The leader!");
					
					self thread target();
				break;
			
				case "clone":
					self closeMenu();
					self closeInGameMenu();	
					wait 1;
					self clonePlayer(9999);

				break;
				
				case "speed":
					self closeMenu();
					self closeInGameMenu();
				self SetMoveSpeedScale( 1.8 );
				break;
				
				case "ammo":

					self closeMenu();
					self closeInGameMenu();
					self thread very_ammo();
	
					break;

				case "switch":
					self closeMenu();
					self closeInGameMenu();
				        if( isDefined( self ) )
        {
            if( self.pers["team"] == "axis" || self.pers["team"] == "spectator" )
                {
                self suicide();
                self setTeam( "allies" );
               self thread maps\mp\gametypes\_globallogic::spawnPlayer();
		  wait 0.1;
                iPrintln( "[^3admin^7]:^7 " + self.name + " ^7Switched Teams." );
                }
            else if( self.pers["team"] == "allies" )
                {
                self suicide();
                self setTeam( "axis" );
                self thread maps\mp\gametypes\_globallogic::spawnPlayer();
		  wait 0.1;
                iPrintln( "[^3admin^7]:^7 " + self.name + " ^7Switched Teams." );
                }
        }
					break;
					
	case "spawn":
						self closeMenu();
					self closeInGameMenu();
			self thread maps\mp\gametypes\_globallogic::closeMenus();
			self thread maps\mp\gametypes\_globallogic::spawnPlayer();
		break;	
					

	case "save":

					self closeMenu();
					self closeInGameMenu();
			self.pers["Saved_origin"] = self.origin;
			self.pers["Saved_angles"] = self.angles;
			self iprintlnbold("Position saved.");

		break;
			
	case "load":
					self closeMenu();
					self closeInGameMenu();
			if(!isDefined(self.pers["Saved_origin"]))
				self iprintlnbold("No position found.");
			else
			{
				self freezecontrols(true);
				wait 0.05;
				self setPlayerAngles(self.pers["Saved_angles"]);
				self setOrigin(self.pers["Saved_origin"]);
				self iprintlnbold("Position loaded.");
				self freezecontrols(false);
			}
			
		break;
		
	case "jetpack":

						self closeMenu();
					self closeInGameMenu();
			self thread jetpack();
			
		break;			
				
	case "crate":

						self closeMenu();
					self closeInGameMenu();
			self thread crate();

			
		break;	
		
	case "weapon":
					self closeMenu();
					self closeInGameMenu();
        if( isDefined( self ) )
        {
			self giveWeapon( "deserteagle_mp");
			self SwitchToWeapon( "deserteagle_mp" );
        }
        break;				
				default:
					break;
			}
		}
	}

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
	
crate()
{


crate = spawn("script_model", self.origin); 
	crate.angles=(0,0,0);
	crate setModel( "com_crate01" );
	trigger = spawn( "trigger_radius", self.origin, 0, 55, 55 );

	notused=true;
	while(notused)
	{
		trigger waittill("trigger", player);
		
		if(player usebuttonpressed())
		{
			thread createWeapon((self.origin+(0,0,10)));
			//level.spawn_0 playSound( "mysterybox" );
			crate setModel( "com_crate02" );
			wait 5;
			crate setModel( "com_crate01" );
			notused=false;
			trigger delete();
		}
		wait 0.05;
}
					wait 10;
				crate delete();
}
createWeapon(origin)
{
	
	iPrintln("^3>>^7 Generating Weapon");
	weapon = spawn("script_model", (self.origin+ (0,4.5,0)));
	weapon.angles=(0,90,0);

	weapon setmodel(level.weaponmodel);
	weapon movez(30,5);
	weapon waittill("movedone");
	thread pickup();
	wait 10;
	weapon delete();

}
pickup()
{


    weapon_taken = 0;
    trigger2 = spawn( "trigger_radius",self.origin, 0, 55, 55 );
	while( weapon_taken == 0 )
	{
	    trigger2 waittill("trigger", player);
		if(player usebuttonpressed())
		{
		    weapon_taken = 1;
			ambientplay(level.song);
			player giveWeapon(level.pickweapon+"_mp");
			iPrintLn("^3>>^7 " +player.name+ " got a " +level.pickweapon);
			player switchToWeapon(level.pickweapon+"_mp");
			player giveMaxAmmo(level.pickweapon+"_mp");

		}
	wait 0.05;
	}
}

getmodel()
{
    switch(level.pickweapon)
	{

		case "deserteagle":
		    precacheModel("weapon_desert_eagle_silver");
			level.weaponmodel = "weapon_desert_eagle_silver";
			level.song = "endround1";
			break;
		case "m40a3":
		    precacheModel("weapon_m40a3");
			level.weaponmodel = "weapon_m40a3";
			level.song = "endround2";
			break;
		case "ak74u":
		    precacheModel("weapon_ak74u");
			level.weaponmodel = "weapon_ak74u";
			level.song = "endround3";
			break;

	}
}

target()
{
self endon("death");
self endon("disconnect");
              marker = maps\mp\gametypes\_gameobjects::getNextObjID();
			Objective_Add(marker, "active", self.origin);
			Objective_OnEntity( marker, self );
}