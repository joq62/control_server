%%%-------------------------------------------------------------------
%%% @author c50 <joq62@c50>
%%% @copyright (C) 2024, c50
%%% @doc
%%%
%%% @end
%%% Created : 27 Oct 2024 by c50 <joq62@c50>
%%%-------------------------------------------------------------------
-module(lib_control_server).

%% API
-export([
	 connect_controllers/0,
	 get_active_applications/0,
	 applications_to_start/0,
	 applications_to_stop/0,
	 install_missing_applications/0,
	 uninstall_depricated_applicaions/0
	]).

%%%===================================================================
%%% API
%%%===================================================================
%%--------------------------------------------------------------------
%% @doc
%% 
%% @end
%%--------------------------------------------------------------------
install_missing_applications()->
    
    case application_server:applications_to_start() of
	[]->
	    {ok,[]};
	MissingApplications ->
	    [application_server:uninstall(File)||File<-MissingApplications],
	    R=[application_server:install(File)||File<-MissingApplications],
	    [net_adm:ping(N)||{ok,N}<-R],
	    R
    end.
%%--------------------------------------------------------------------
%% @doc
%% 
%% @end
%%--------------------------------------------------------------------
uninstall_depricated_applicaions()->
    
    case application_server:applications_to_stop() of
	[]->
	    {ok,[]};
	DepricatedApplications ->
	    [application_server:uninstall(File)||File<-DepricatedApplications]
    end.
%%--------------------------------------------------------------------
%% @doc
%% 
%% @end
%%--------------------------------------------------------------------
applications_to_start()->
    application_server:applications_to_start().
%%--------------------------------------------------------------------
%% @doc
%% 
%% @end
%%--------------------------------------------------------------------
applications_to_stop()->
    application_server:applications_to_stop().
     
%%--------------------------------------------------------------------
%% @doc
%% 
%% @end
%%--------------------------------------------------------------------
get_active_applications()->
    {ok,ActiveApplications}=application_server:get_active_applications(),
    {ok,ActiveApplications}.
 
%%--------------------------------------------------------------------
%% @doc
%% 
%% @end
%%--------------------------------------------------------------------
connect_controllers()->
    {ok,HostNodes}=host_server:get_host_nodes(),
    PingResult=[{net_adm:ping(N),N}||N<-HostNodes],
    Connected=[N||{pong,N}<-PingResult],
    NotConnected=[N||{pang,N}<-PingResult],
    {ok,Connected,NotConnected}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
