function children = generateChildren(myStruct,legalMoves)

deck = myStruct.deck; 
trick = myStruct.trick; 
turn = find(trick(:,1) == 0,1); 
trump = myStruct.trump;

children = struct;
children.trick = [];
children.wonHand = [];
children.deck = [];
children.chosenMove = [];
children.trump = [];
% children.children = [];
children.fullWins = [];

children = repmat(children,1,size(legalMoves,1));

for ii = 1:size(legalMoves,1)
    
    chosenMove = legalMoves(ii,:);
    tempTrick = trick; 
    tempDeck = deck; 
    
    tempTrick(turn,:) = chosenMove; 
    tempDeck(ismember(deck,chosenMove,'rows'),:) = zeros(1,2);
    
    
    children(ii).chosenMove = chosenMove; 
    children(ii).deck = tempDeck; 
    children(ii).trick = tempTrick;
    % Importantly, this is necessary for passing the trick down. 
    % Regardless of whether or not we want to pass it up. 
    % We also need to pass the deck down. 
    children(ii).trump = trump;
end

% myStruct.children = children; 
    