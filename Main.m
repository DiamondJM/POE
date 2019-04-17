%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% POE by Josh Diamond 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is a Whist engine which can support anywhere from 0 to 4 computer
% players. 


% Below, use the compPlayers field to determine the number and order of
% computer players. 
% You will be prompted to choose whether or not to randomize the hands. 
% Randomizing the hands is good for playing test matches, usually with four
% computer players. 
% If you're using a real deck, dealt to the players, do not randomize the
% hand. 
% If you are not randomizing the hand, recall that the player in order 4
% must have 12 cards. That is, the card which is pulled is pulled from that
% player's hand. You'll be prompted to provide the pulled card. 

% If prompted, provide all cards in the format 'n s', or number suit. 
% So, a 3 of spades is '3 s'. An ace of diamonds is 'a d'. 

fprintf('Welcome to');
type POE.txt
fprintf('a fully functional Whist engine. \n');
type whistText.txt;



%% Set up the game 

clearvars

deckFull = zeros(52,2);

playerNames = {'1','2','3','4'};
% compPlayers = [false true true true]; 
compPlayers = true(1,4);
randomize = input('Randomize computer hands? ');

gameResults = table(0,0);
gameResults.Properties.VariableNames = {sprintf('Players_%s_%s',playerNames{1},playerNames{3}),sprintf('Players_%s_%s',playerNames{2},playerNames{4})};

playersToTable = [1 2 1 2];

cardInds = buffer(1:52,13);
suitInds = buffer(1:52,4);
cardCounter = 1;

for ii = 1:size(suitInds,2)
    deckFull(suitInds(:,ii),1) = ii;
    deckFull(suitInds(:,ii),2) = 1:4;
end

if randomize
    pullCard = deckFull(randi([1 size(deckFull,1)]),:);
else
    fprintf('Which card to pull? \n');
    pullCard = inputCard;
end
fprintf('%s was pulled. \n',outputCard(pullCard));
trump = pullCard(2); 

hands = cell(1,4);
deckRemaining = deckFull;
deckRemaining(ismember(deckRemaining,pullCard,'rows'),:) = [];

for ii = find(compPlayers)
    if ii == 4; sizeVal = 12; else; sizeVal = 13; end
    
    if randomize
        randInds = randperm(size(deckRemaining,1));
        randInds = randInds(1:sizeVal);
        % In this case, let's just grant that the card was pulled from the last
        % computer's hand.
        hands{ii} = zeros(13,2);
        hands{ii}(1:sizeVal,:) = deckRemaining(randInds,:);
    else
        fprintf('Input hand for computer player %s. \n\n',playerNames{ii});
        hands{ii} = inputHand(sizeVal);
    end 
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

while sum(logical(deck(:,1))) >= 4
    trick = zeros(4,2);
    
    for jj = 1:size(trick,1)        
        fprintf('Player %s to play. \n',playerNames{jj});
        
        hands = deckToHands(deck); 
        currentComp = compPlayers(jj);
        
        if ~currentComp
            %%%%%%%%
            % Human move 
            %%%%%%%%
            
            [currentMove, hands] = humanMove(hands,compPlayers,jj);
            deck = cat(1,hands{:});
            
        else
            %%%%%%%%
            % Computer move 
            %%%%%%%%            
            
            myStruct = struct;
            myStruct.trick = trick;
            myStruct.trump = trump;
            myStruct.deck = deck; 
            
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
            for ii = 1:min(5,length(inds))
                fprintf('Choice %d: play %s with %d percent of results. \n',ii,outputCard(legalMoves(inds(ii),:)),rVals(ii));
            end
            
            currentMove = legalMoves(inds(1),:);
            deck(ismember(deck,currentMove,'rows'),:) = zeros(1,2);
                        
        end
        trick(jj,:) = currentMove;
        
    end
    
    fprintf('The trick is %s, %s, %s, %s. \n',outputCard(trick(1,:)),outputCard(trick(2,:)),outputCard(trick(3,:)),outputCard(trick(4,:)));
    
    [trickWeighted, mismatchLeader] = scoreTrick(trick,trump);

    % Update restrictions on who has which card 
    playerRanOut(:,trick(1,2)) = playerRanOut(:,trick(1,2)) | mismatchLeader;
        
    %%%%%
    % Report trick results 
    %%%%%
    
    [~,winnerInd] = max(trickWeighted); 
    if winnerInd == 1 || winnerInd == 3; fprintf('Team %s and %s wins! \n',playerNames{1},playerNames{3});
    else; fprintf('Team %s and %s wins! \n',playerNames{2},playerNames{4});
    end
    
    gameResults{1,playersToTable(winnerInd)} = gameResults{1,playersToTable(winnerInd)} + 1;
    fprintf('Press any key to continue. \n');
    pause
    
    %%%%%
    % Reorder players
    %%%%%
    hands = deckToHands(deck); 
    deck = cat(1,hands{:});
    
    hands = hands([2:end 1]);
    playerNames = playerNames([2:end 1]);
    playersToTable = playersToTable([2:end 1]);
    playerRanOut = playerRanOut([2:end 1],:);
    compPlayers = compPlayers([2:end 1]);
end

%% Game summary 

if gameResults{1,1} == gameResults{1,2}; fprintf('It''s a tie! \n'); 
else
    [~,ind] = max(gameResults{1,:});
    winningPlayers = find(playersToTable == ind);
    fprintf('Players %s and %s win! \n',playerNames{winningPlayers(1)},playerNames{winningPlayers(2)});
end

