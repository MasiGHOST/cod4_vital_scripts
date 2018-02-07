//circle strattime :D

#include maps\mp\gametypes\_hud_util;
main()
{
if(game["promod_timeout_called"])
{
thread promod\timeout::main();
return;
}
thread stratTime();
level waittill("strat_over");
players=getentarray("player","classname");
for(i=0;i<players.size;i++)
{
player=players[i];
classType=player.pers["class"];
if((player.pers["team"]=="allies"||player.pers["team"]=="axis")&&player.sessionstate=="playing"&&isDefined(player.pers["class"]))
{
if(isDefined(game["PROMOD_KNIFEROUND"])&&!game["PROMOD_KNIFEROUND"]||!isDefined(game["PROMOD_KNIFEROUND"])){if(level.hardcoreMode&&getDvarInt("weap_allow_frag_grenade"))player giveWeapon("frag_grenade_short_mp");
else 
if(getDvarInt("weap_allow_frag_grenade"))player giveWeapon("frag_grenade_mp");
if(player.pers[classType]["loadout_grenade"]=="flash_grenade"&&getDvarInt("weap_allow_flash_grenade"))
{
player setOffhandSecondaryClass("flash");
player giveWeapon("flash_grenade_mp");
}
else if(player.pers[classType]["loadout_grenade"]=="smoke_grenade"&&getDvarInt("weap_allow_smoke_grenade"))
{
player setOffhandSecondaryClass("smoke");
player giveWeapon("smoke_grenade_mp");
}
player maps\mp\gametypes\_class::sidearmWeapon();
player maps\mp\gametypes\_class::primaryWeapon();
}
else player thread maps\mp\gametypes\_globallogic::removeWeapons();
player allowsprint(true);
player setMoveSpeedScale(1.0-0.05*int(isDefined(player.curClass)&&player.curClass=="assault")*int(isDefined(game["PROMOD_KNIFEROUND"])&&!game["PROMOD_KNIFEROUND"]||!isDefined(game["PROMOD_KNIFEROUND"])));
player allowjump(true);
} }
UpdateClientNames();
if(game["promod_timeout_called"])
{
thread promod\timeout::main();
return;
} }
stratTime()
{
thread stratTimer2();
level.strat_over=false;
strat_time_left=game["PROMOD_STRATTIME"]+level.prematchPeriod*int(getDvarInt("promod_allow_strattime")&&isDefined(game["CUSTOM_MODE"])&&game["CUSTOM_MODE"]&&level.gametype=="sd");
while(!level.strat_over){players=getentarray("player","classname");
for(i=0;i<players.size;i++) {
player=players[i];
if((player.pers["team"]=="allies"||player.pers["team"]=="axis")&&!isDefined(player.pers["class"]))player.statusicon="hud_status_dead";
}
wait 0.25;
strat_time_left-=0.25;
if(strat_time_left<=0||game["promod_timeout_called"])
level.strat_over=true;
}
level notify("strat_over");
}
stratTimer2() {
		time = 5;
	    visionSetNaked("mpIntro", 0);
	    matchStartText = addTextHud( level, 0, 0, 1, "center", "middle", "center", "middle", 1.4, 1001 );
	    matchStartText.font = "objective";
	    matchStartText setText(game["strings"]["match_starting_in"]);
		matchStartText.color = (0.172, 0.781, 1);
		matchStartTimer = [];
	    for(i=0;i<6;i++) {
		    matchStartTimer[i] = addTextHud( level, 0, 0, 1, "center", "middle", "center", "middle", 1.4, 1001 );
		    matchStartTimer[i].font = "objective";
		    matchStartTimer[i].degree = i*-40;
		    matchStartTimer[i] setValue(time - i);
		  	matchStartTimer[i] thread animate_circle_number(i*-40 + (40 * time),time);
		}
	   	for(i=0;i<time*5;i++) {
	   		players = getAllPlayers();
			for(k=0;k<players.size;k++) {
				players[k] setPlayerSpeed(0);
				//players[k] setClientDvar("cg_drawgun",0);
			}
	   		wait 0.5;
	   	}
	    visionSetNaked(getDvar("mapname"), 1);
	    matchStartText thread fadeOut(.5);
	    for(i=0;i<matchStartTimer.size;i++)
	    	matchStartTimer[i] thread fadeOut(.5);
	   	players = getAllPlayers();
		for(k=0;k<players.size;k++) {
			players[k] setPlayerSpeed();
			players[k] enableWeapons();
			//players[k] setClientDvar("cg_drawgun",1);
		}    
	}
	//level notify("clock_over");
	//level.instrattime = false;
animate_circle_number(degree, time) {
	w = 1 / getDvarInt("sv_fps");
	degree_step = (self.degree - degree) * (w/time) *-1;
	if( degree > self.degree ) 
		degree_step = (degree-self.degree) * (w/time);
	for(i=self.degree;isDefined(self);i+=degree_step) {
		if(i < 15 && i > -15)
			self.color = (0.172, 0.781, 1);
		else
			self.color = (1,1,1);
		self MoveOverTime(w);
		self.x = sin(i)*85;
		self.y = cos(i)*85;
		wait w;
	}
}
tratTimer()
{
matchStartText=createServerFontString("objective",1.5);
matchStartText setPoint("CENTER","CENTER",0,-60);
matchStartText.sort=1001;
if(isDefined(game["PROMOD_KNIFEROUND"])&&game["PROMOD_KNIFEROUND"])matchStartText setText("Knife Round");
else matchStartText setText("Empieza En^1.^0.^1.");
matchStartText.foreground=false;
matchStartText.hidewheninmenu=false;
matchStartTimer=createServerTimer("objective",1.4);
matchStartTimer setPoint("CENTER","CENTER",0,-45);
matchStartTimer setTimer(game["PROMOD_STRATTIME"]+level.prematchPeriod*int(getDvarInt("promod_allow_strattime")&&isDefined(game["CUSTOM_MODE"])&&game["CUSTOM_MODE"]&&level.gametype=="sd"));
matchStartTimer.sort=1001;
matchStartTimer.foreground=false;
matchStartTimer.hideWhenInMenu=false;
level waittill("strat_over");
if(isDefined(matchStartText))matchStartText destroy();
if(isDefined(matchStartTimer))matchStartTimer destroy();
}

addTextHud( who, x, y, alpha, alignX, alignY, horiz, vert, fontScale, sort ) {
	if( isPlayer( who ) )
		hud = newClientHudElem( who );
	else
		hud = newHudElem();

	hud.x = x;
	hud.y = y;
	hud.alpha = alpha;
	hud.sort = sort;
	hud.alignX = alignX;
	hud.alignY = alignY;
	if(isdefined(vert))
		hud.vertAlign = vert;
	if(isdefined(horiz))
		hud.horzAlign = horiz;		
	if(fontScale != 0)
		hud.fontScale = fontScale;
	hud.foreground = 1;
	hud.archived = 0;
	return hud;
}
addTextBackground( who,text, x, y, alpha, alignX, alignY, horiz, vert, font, sort ) {
	if( isPlayer( who ) )
		hud = newClientHudElem( who );
	else
		hud = newHudElem();
	hud.x = x;
	hud.y = y;
	hud.sort = sort;
	hud.alignX = alignX;
	hud.alignY = alignY;
	if(isdefined(vert))
		hud.vertAlign = vert;
	if(isdefined(horiz))
		hud.horzAlign = horiz;			
	hud.glowcolor = (0, 0.402 ,1);
	hud SetShader("line_vertical",int(tolower(text).size * 4.65 * font),50);
	hud.glowalpha = .6;

	text = addTextHud( who, x, y, alpha, alignX, alignY, horiz, vert, font, sort + 1 );
	text.background = hud;
	return text;
}
fadeOut(time) {
	if(!isDefined(self)) return;
	self fadeOverTime(time);
	self.alpha = 0;
	wait time;
	if(!isDefined(self)) return;
	self destroy();
}
fadeIn(time) {
	alpha = self.alpha;
	self.alpha = 0;
	self fadeOverTime(time);
	self.alpha = alpha;
}
setPlayerSpeed(speed) {
	if(!isDefined(speed) && isDefined(self.pers) && isDefined(self.pers["primaryWeapon"])) {
		switch ( tablelookup( "mp/statstable.csv", 4, self.pers["primaryWeapon"], 2 ) )
		{
			case "weapon_sniper":
				self setMoveSpeedScale( 0.95 );
				break;
			case "weapon_lmg":
				self setMoveSpeedScale( 0.875 );
				break;
			case "weapon_smg":
				self setMoveSpeedScale( 1.0 );
				break;
			case "weapon_shotgun":
				self setMoveSpeedScale( 1.0 );
				break;
			default:
				self setMoveSpeedScale( 1.0 );
				break;
		}
		self allowJump(true);
	}
	else if(isDefined(speed)) {
		self setMoveSpeedScale(speed);
		if(!speed)
			self allowJump(false);
	}
	else {
		self setMoveSpeedScale(1);
		self allowJump(true);
	}
}
getAllPlayers() {
	return getEntArray( "player", "classname" );
}