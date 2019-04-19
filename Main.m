%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% POE by Josh Diamond 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is a single-player Whist engine. 
% You and an automated opponent will challenge two other 
% automated opponents. 

% Everything is automated, so just press play. 
% Use numeric inputs to select particular cards. 

\\fprintf('Welcome to');
type POE.txt
fprintf('a fully functional Whist engine. \n');
type whistText.txt;

%% Set up the game 

clearvars

compPlayers = true(1,4);

playerNames = cell(1,4);
playerOrder = randi([1 4]);
playerNames{playerOrder} = 'You';
fprintf('You are starting in slot %d. \n',playerOrder);
compPlayers(playerOrder) = false;
teammate = mod(playerOrder + 2 - 1, 4) + 1;
playerNames{teammate} = 'Teammate';
lowestPlayer = min(teammate,playerOrder); 
if lowestPlayer == 1; playerNames([2 4]) = {'Opponent 1','Opponent 2'}; 
else; playerNames([1 3]) = {'Opponent 1','Opponent 2'}; 
end

deckFull = zeros(52,2);

gameResults = table(0,0);
if lowestPlayer == 1; gameResults.Properties.VariableNames = {'You_Teammate','Opponents'};
else; gameResults.Properties.VariableNames = {'Opponents','You_Teammate'};
end

playersToTable = [1 2 1 2];

cardInds = buffer(1:52,13);
suitInds = buffer(1:52,4);
cardCounter = 1;

for ii = 1:size(suitInds,2)
    deckFull(suitInds(:,ii),1) = ii;
    deckFull(suitInds(:,ii),2) = 1:4;
end

pullCard = deckFull(randi([1 size(deckFull,1)]),:);
printPulledCard(pullCard);


fprintf('%s was pulled. \n',outputCard(pullCard));
trump = pullCard(2);

hands = cell(1,4);
deckRemaining = deckFull;
deckRemaining(ismember(deckRemaining,pullCard,'rows'),:) = [];

for ii = find(compPlayers)
    if ii == 4; sizeVal = 12; else; sizeVal = 13; end
    
    randInds = randperm(size(deckRemaining,1));
    randInds = randInds(1:sizeVal);
    % In this case, let's just grant that the card was pulled from the last
    % computer's hand.
    hands{ii} = zeros(13,2);
    hands{ii}(1:sizeVal,:) = deckRemaining(randInds,:);
    
    deckRemaining = deckRemaining(~ismember(deckRemaining,hands{ii},'rows'),:);
    
end

for ii = find(~compPlayers)
    
    if ii == 4; sizeVal = 12; else; sizeVal = 13; end
    
    randInds = randperm(size(deckRemaining,1));
    randInds = randInds(1:sizeVal);
    hands{ii} = zeros(13,2);
    hands{ii}(1:sizeVal,:) = deckRemaining(randInds,:);
    
    deckRemaining = deckRemaining(~ismember(deckRemaining,hands{ii},'rows'),:);
end



%% Let's start a game


numMTC = 100;

deck = cat(1,hands{:});

playerRanOut = false(4); 
startIndex = 0;
% Columns cards
% Rows players

masterResults = zeros(3,0); 

while sum(logical(deck(:,1))) >= 4
    trick = zeros(4,2);
    
    clf;
    printPulledCard(pullCard);
    for jj = 1:size(trick,1)        
        fprintf('%s to play. \n',playerNames{jj});
        
        hands = deckToHands(deck); 
        currentComp = compPlayers(jj);
        
        myStruct = struct;
        myStruct.trick = trick;
        myStruct.trump = trump;
        myStruct.deck = deck;
        
        if ~currentComp
            %%%%%%%%
            % Human move 
            %%%%%%%%
            
            [currentMove, deck] = humanMove(myStruct);
            
        else
            %%%%%%%%
            % Computer move 
            %%%%%%%%            
            legalMoves = genLegalMoves(myStruct);
            
            resultsMTC = zeros(1,size(legalMoves,1));
            
            for ii = 1:numMTC
                handsShuf = shuffleOtherPlayers(hands,jj,playerRanOut);
                
                deckShuf = cat(1,handsShuf{:});
                myStruct.deck = deckShuf;
                                
                
                myStruct = chooseMove(myStruct);
                
                [~,memberInd] = ismember(myStruct.chosenMove,legalMoves,'rows');
                resultsMTC(memberInd) = resultsMTC(memberInd) + 1;
                resultsMTC = resultsMTC + myStruct.fullWins;
            end
            
            resultsMTC = round(resultsMTC / sum(resultsMTC) * 100);
            
            [rVals,inds] = sort(resultsMTC,'descend'); 
%             for ii = 1:min(5,length(inds))
%             % for ii = 1:length(inds)
%                 fprintf('Choice %d: play %s with %d percent of results. \n',ii,outputCard(legalMoves(inds(ii),:)),rVals(ii));
%             end
            
            currentMove = legalMoves(inds(1),:);
            deck(ismember(deck,currentMove,'rows'),:) = zeros(1,2);
                        
        end
        trick(jj,:) = currentMove;
        printTrickVis(trick,playerNames); drawnow
    end
    
    fprintf('The trick is %s, %s, %s, %s. \n',outputCard(trick(1,:)),outputCard(trick(2,:)),outputCard(trick(3,:)),outputCard(trick(4,:)));
    
    [trickWeighted, mismatchLeader] = scoreTrick(trick,trump);

    % Update restrictions on who has which card 
    playerRanOut(:,trick(1,2)) = playerRanOut(:,trick(1,2)) | mismatchLeader;
        
    %%%%%
    % Report trick results 
    %%%%%
    
    [~,winnerInd] = max(trickWeighted); 
    if winnerInd > 2; winnerInd = winnerInd - 2; end
    if ~compPlayers(winnerInd) || ~compPlayers(winnerInd + 2); fprintf('You and teammate win the trick! \n');
    else; fprintf('Opponents win the trick. \n');
    end
    
    gameResults{1,playersToTable(winnerInd)} = gameResults{1,playersToTable(winnerInd)} + 1;
    fprintf('Press any key to continue. \n');
    pause
    
    %%%%%
    % Reorder players
    %%%%%
    hands = deckToHands(deck); 
    hands = hands([2:end 1]);
    
    deck = cat(1,hands{:});
    
    playerNames = playerNames([2:end 1]);
    playersToTable = playersToTable([2:end 1]);
    playerRanOut = playerRanOut([2:end 1],:);
    compPlayers = compPlayers([2:end 1]);
end

%% Game summary 

if gameResults{1,1} == gameResults{1,2}; fprintf('It''s a tie! \n'); 
else
    [~,ind] = max(gameResults{1,:});
    [~,indLoss] = min(gameResults{1,:});
    winningPlayers = find(playersToTable == ind);
    fprintf('%s and %s win the game! %d to %d. \n',playerNames{winningPlayers(1)},playerNames{winningPlayers(2)},gameResults{1,ind},gameResults{1,indLoss});
end

