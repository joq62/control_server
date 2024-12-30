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
-define(Appl,"control").
-define(Dir,"control").


-define(LogFilePath,"logs/connect/log.logs/file.1").


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
    ok=test_0(),
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

test_0()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME,?LINE}]),
  
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
    ok=application:start(control_server),
    pong=control_server:ping(),
    
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
