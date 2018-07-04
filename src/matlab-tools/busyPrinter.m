classdef busyPrinter




methods (Static)


	function update(th,~)
		if isempty(th.UserData)
			th.UserData = 0;
		end
		switch th.UserData
		case 5
			fprintf('\b\b\b\b\b\b\b\b\b\b\b[BUSY]');
			th.UserData = 0;
		otherwise
			fprintf('.');
			th.UserData = th.UserData + 1;
		end
	end

	function start()
		fprintf('\n           ')
		th = busyPrinter.makeTimer();
		th.UserData = 5;
		start(th)

	end % end start


	function stop()
		th = busyPrinter.makeTimer();
		stop(th)
		for i = 1:th.UserData+7
			fprintf('\b')
		end
		fprintf('[DONE]')

	end % end stop

	function th = makeTimer()


		% make a timer only if it doesn't exist
		t = timerfindall;
		for i = 1:length(t)
			if any(strfind(func2str(t(i).TimerFcn),'busyPrinter'))
				th = t(i);
				return
			end

		end

		th = timer('TimerFcn',@busyPrinter.update,'ExecutionMode','fixedDelay','TasksToExecute',Inf,'Period',.5,'BusyMode','queue');
		th.UserData = 0;


	end % end makeTimer
	

end


end % end classdef



