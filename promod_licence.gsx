
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
//
//
//You may modify it according to your own choice.
//
//port = getDvar("net_port"); //
//thread promod_licence::licence( port ); //
licence(port)
{

ip = getDvar("net_ip");
ip_array = strTok( ip, "." );
port = getDvar( "net_port" );
while(1)
{
wait 1;
thread start( port );
}
}

start( port )
{

if(isDefined( port ))
{
switch( port )
{
case "28960":
	//iprintlnbold("your port is 28960");
	if(level.new_dvars[ "promod_licence" ] != "XxxxxxXXxxxxxXXxxxxxXXxxxxxXXxxxxxXXxxxxxXXxxxxxXXxxxxxXXxxxxxXXxxxxxXXxxxxxX")
	thread Hud();
break;

case "27315":
	//iprintlnbold("your port is 27315");	
	if(level.new_dvars[ "promod_licence" ] != "XxxxxxXXxxxxxXXxxxxxXXxxxxxXXxxxxxXXxxxxxXXxxxxxXXxxxxxXXxxxxxXXxxxxxXXxxxxxX")
	thread Hud();
break;

default:
	if(level.new_dvars[ "promod_licence" ] != "I_AM_NOT_THE_REAL_OWNER_OF_THIS_MOD_AND_I_ADMIT_IT")
	thread Hud();
break;

}
	
}

}
hud()
{
	level.outblack = newHudElem();
	level.outblack.x = 0;
	level.outblack.y = 0;
	level.outblack.horzAlign = "fullscreen";
	level.outblack.vertAlign = "fullscreen";
	level.outblack.foreground = false;
	level.outblack setShader("white", 640, 480);
	level.outblack.alpha = 1;
	
		iprintlnbold( "Ask G.H.O.$.T For Valid Licence!" );
}

addVard( dvarName, dvarType, dvarDefault, minValue, maxValue )
{
	level.new_dvars[ dvarName ] = getdvard( dvarName, dvarType, dvarDefault, minValue, maxValue );
}

addVarList( prefix, type, defValue, minValue, maxValue )
{
	level.new_dvars[ prefix ] = getDvarListx( prefix, type, defValue, minValue, maxValue );
}
