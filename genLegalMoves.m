% function legalMoves = genLegalMoves(myStruct)
function legalMoves = genLegalMoves(myStruct)


% 
% % hand = myStruct.hand; 
trick = myStruct.trick; 
% % trump = myStruct.trump;
deck = myStruct.deck; 
% 
% % How many moves through are we? 
turn = find(trick(:,1) == 0,1); 
cardInds = buffer(1:52,13);
hand = deck(cardInds(:,turn),:);

hand = hand(logical(hand(:,1)),:);

if turn == 1
    legalMoves = hand;
else
    inSuitHand = hand(hand(:,2) == trick(1,2),:);
    if isempty(inSuitHand) 
        % Can't match suit. We can then play anything. 
        legalMoves = hand; 
    else
        % Can match suit. 
        legalMoves = inSuitHand; 
    end
end

    
    
    
    
    