function playerIdentity = retrievePlayerIdentity(playerName)
    playerIdentity = input(sprintf('Press 1 if %s is a computer. 0 if human. ',playerName),'s');
    while ~any(ismember(playerIdentity,{'1','0'}))
        fprintf('Incorrect input. \n')
        playerIdentity = input(sprintf('Press 1 if %s is a computer. 0 if human. ',playerName),'s');
    end
    
    playerIdentity = logical(str2double(playerIdentity)); 
    
end