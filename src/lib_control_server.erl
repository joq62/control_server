%%%-------------------------------------------------------------------
%%% @author c50 <joq62@c50>
%%% @copyright (C) 2025, c50
%%% @doc
%%%
%%% @end
%%% Created :  6 Jan 2025 by c50 <joq62@c50>
%%%-------------------------------------------------------------------
-module(lib_control_server).

%% API
-export([
	 is_wanted_state/0,
	 update/0
	]).

%%%===================================================================
%%% API
%%%===================================================================
    
%%--------------------------------------------------------------------
%% @doc
%% 
%% @end
%%--------------------------------------------------------------------
update()->
    case is_wanted_state() of
	{true,[]}->
	    ok;
	{false,MissingApplicationSpecFiles} ->
	    {ok,update(MissingApplicationSpecFiles,[])}
    end.

update([],Acc)->
    Acc;
update([ApplicationSpecFile|T],Acc)->
    NewAcc=case appl_server:clone_build_release(ApplicationSpecFile) of
	       {error,Reason}->
		   [{error,Reason}|Acc];
	       ok ->
		   case appl_server:start_release(ApplicationSpecFile) of
		       {error,Reason}->
			   [{error,Reason}|Acc];
		       {ok,ApplNode} ->
			   case net_kernel:connect_node(ApplNode) of
			       false->
				   [{error,["Failed to connect",ApplNode,ApplicationSpecFile]}|Acc];
			       true->
				   [{ok,ApplicationSpecFile,ApplNode}|Acc]
			   end
		   end
	   end,
    update(T,NewAcc).
			   


    
%%--------------------------------------------------------------------
%% @doc
%% 
%% @end
%%--------------------------------------------------------------------
is_wanted_state()->
    {ok,WantedApplicationSpecFiles}=appl_server:wanted_applications(),
    {ok,ActiveApplicationSpecFiles}=appl_server:active_applications(),
    SortedActiveApplicationSpecFiles=lists:sort(ActiveApplicationSpecFiles),
    SortedWantedApplicationSpecFiles=lists:sort(WantedApplicationSpecFiles),
    Missing=[ApplicationSpecFile||ApplicationSpecFile<-SortedWantedApplicationSpecFiles,
				  false=:=lists:member(ApplicationSpecFile,SortedActiveApplicationSpecFiles)],
    io:format("Missing ~p~n",[{Missing,?MODULE,?FUNCTION_NAME,?LINE}]),
    

    case Missing of
	[]->
	    {true,[]};
	Missing ->
	    {false,Missing}
    end.
%%%===================================================================
%%% Internal functions
%%%===================================================================
