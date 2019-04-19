function [currentMove, hands] = humanMove(hands,compPlayers,jj)

cardCounts = cellfun(@(x) sum(logical(x(:,1))),hands);



%% Pull human move of available cards 

hand = cat(1,hands{~compPlayers});

currentMove = inputCard; 

while ~ismember(currentMove,hand,'rows')
    fprintf('Incorrect input. \n'); 
    
    currentMove = inputCard; 
    
end

%% Fix hands

deck = cat(1,hands{:});
deck(ismember(deck,currentMove,'rows'),:) = zeros(1,2);
hands = deckToHands(deck);

% Let's ensure that this move was drawn from the appropriate hand. 

ccNew = cellfun(@(x) sum(logical(x(:,1))),hands);


drawnFrom = find(cardCounts ~= ccNew);

if drawnFrom ~= jj 
    % Must switch cards. 
    inJJ = find(hands{jj}(:,1),1);
    notInDrawnFrom = find(hands{drawnFrom}(:,1) == 0,1);
    
    hands{drawnFrom}(notInDrawnFrom,:) = hands{jj}(inJJ,:);
    hands{jj}(inJJ,:) = zeros(1,2); 
    
end





end