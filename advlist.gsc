//
//
//						   /---------\   
//						  / /---------\ 
//						 / /			
//						/ /	Scripted
//						\ \		By:
//						 \ \
//						  \ \
//					     G.H.O.\=====|.T
//						    =====|\
//							   \ \
//							    \ \
//							     \ \
//							     / /
//							    / /
//						   /-------/ /
//						  /---------/
//	
//
//

init()
{
thread msg();
}

msg()
{
time = 20;
while(1)
{
exec( "say "+getDvar( "advlist_1" )); // in server.cfg add line "set advlist_1 Welcome to server!"
wait time;
exec( "say "+getDvar( "advlist_2" ));// in server.cfg add line "set advlist_2 Do not hack!"
wait time;
exec( "say "+getDvar( "advlist_3" ));
wait time;
exec( "say "+getDvar( "advlist_4" ));
wait time;
}
}
