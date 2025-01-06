%%% -------------------------------------------------------------------
%%% @author  : Joq Erlang
%%% @doc: : 
%%% Created :
%%%
%%% -------------------------------------------------------------------
-module(all).       
 
-include("log.api").
-export([start/0]).


%%
-define(CheckDelay,20).
-define(NumCheck,1000).


%% Change
-define(Appl,"control_server").
-define(Dir,"control_server").
-define(LogFilePath,"logs/connect/log.logs/file.1").


-define(TestApplFile,"add_test.application").




%%
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------


%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
start()->
   
    ok=setup(),
    io:format("Test OK !!! ~p~n",[?MODULE]),
    log_loop([]),

    timer:sleep(2000),
    init:stop(),
    ok.


%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
setup()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME,?LINE}]),

    ok=application:start(log),
    pong=log:ping(),
    ok=application:start(cmn_server),
    pong=cmn_server:ping(),
    ok=application:start(service_discovery),
    pong=service_discovery:ping(),
    ok=application:start(connect),
    pong=connect:ping(),
    ok=application:start(appl_server),
    pong=appl_server:ping(),
    ok=application:start(control_server),
    pong=control_server:ping(),

    service_discovery:config_needed([?TestApplFile]),
    service_discovery:update(),
    timer:sleep(5000),
    {ok,App}=appl_server:app(?TestApplFile),
    {error,["undefined",add_test]}=client:server_pid(App),
    
    ok.


%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
-define(Needed,[net_kernel,stdlib,logger]).
api_control_test()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME,?LINE}]),
   %% setup will be done by each application
    ok=service_discovery:config_needed(?Needed),
    ok=service_discovery:update(),
    timer:sleep(100),

    %% control api offered
    {ok,[{logger,'connect@c200',_},
	 {logger,'connect@c202',_},
	 {logger,'connect@c50',_},
	 {net_kernel,'connect@c200',_},
	 {net_kernel,'connect@c202',_},
	 {net_kernel,'connect@c50',_}]
    }=service_discovery:imported(),
    {ok,[
	 {net_kernel,'connect@c200',_},
	 {net_kernel,'connect@c202',_},
	 {net_kernel,'connect@c50',_}
	]
    }=service_discovery:get_all(net_kernel),
      
    ['connect@c200',
     'connect@c202',
     'connect@c50'
    ]=connect:connect_status(),
    ok.




%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
log_loop(Strings)->    
    Info=os:cmd("cat "++?LogFilePath),
    NewStrings=string:lexemes(Info,"\n"),
    
    [io:format("~p~n",[String])||String<-NewStrings,
				 false=:=lists:member(String,Strings)],
    timer:sleep(5*1000),
    log_loop(NewStrings).
