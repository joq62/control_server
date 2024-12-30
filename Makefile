all:	 
	rm -rf erl_cra* rebar3_crashreport;
	rm -rf *~ */*~ */*/*~ */*/*/*~;
	rm -rf test_ebin;
	rm -rf *.beam */*.beam;
	rm -rf test.rebar;
	rm -rf logs;
	rm -rf Mnesia.*;
	rm -rf _build;
	rm -rf ebin;
	rm -rf rebar.lock;
	rm -rf *_container;
	rm -rf tar_dir;
	#INFO: Compile application
	rm -rf common_include;
	cp -r ~/erlang/common_include .
	rm -f rebar.config;
	cp  config/rebar.config .
	rebar3 compile;
	rm -rf _build;
	git status
	echo Ok there you go!
	#INFO: no_ebin_commit ENDED SUCCESSFUL
clean:
	rm -rf erl_cra* rebar3_crashreport;
	rm -rf *~ */*~ */*/*~ */*/*/*~;
	rm -rf test_ebin;
	rm -rf *.beam */*.beam;
	rm -rf test.rebar;
	rm -rf logs;
	rm -rf Mnesia.*;
	rm -rf _build;
	rm -rf ebin;
	rm -rf rebar.lock;
	rm -rf *_container;
	rm -rf tar_dir;
	#INFO: Compile application
	rm -rf common_include;
	cp -r ~/erlang/common_include .
	rm -f rebar.config;
	cp  config/rebar.config .
	rebar3 compile;
	rm -rf _build;
	rm -rf rebar.lock
#INFO: clean ENDED SUCCESSFUL
eunit: 
	rm -rf erl_cra* rebar3_crashreport;
	rm -rf *~ */*~ */*/*~ */*/*/*~;
	rm -rf test_ebin;
	rm -rf *.beam */*.beam;
	rm -rf test.rebar;
	rm -rf logs;
	rm -rf Mnesia.*;
	rm -rf _build;
	rm -rf ebin;
	rm -rf rebar.lock;
	rm -rf *_container;
#INFO: Creating eunit test code using test_ebin dir;
	mkdir test_ebin;
	rm -rf common_include;
	cp -r ~/erlang/common_include .
	rm -f rebar.config;
	cp test_config/test.rebar.config rebar.config
	erlc -I ~/erlang/common_include -o test_ebin test/*.erl;
	rebar3 compile;
	#INFO: Starts the eunit testing .................
	erl -pa test_ebin\
	 -pa _build/default/lib/cmn_server/ebin\
	 -pa _build/default/lib/log/ebin\
	 -pa _build/default/lib/service_discovery/ebin\
	 -pa _build/default/lib/connect/ebin\
	 -pa _build/default/lib/control_server/ebin\
	 -sname connect\
	 -run $(m) start\
	 -setcookie a
