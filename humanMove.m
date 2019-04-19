
function [currentMove, deck] = humanMove(myStruct)


deck = myStruct.deck; 

[legalMoves, hand] = genLegalMoves(myStruct);
hand = hand(logical(hand(:,1)),:);

printHandVis(hand)

%% Pull human move of available cards 


currentMove = input('Please provide card number. \n');
currentMove = hand(currentMove,:); 

while ~ismember(currentMove,legalMoves,'rows')
    fprintf('Illegal move provided. \n');
    currentMove = input('Please provide card number. \n');
    currentMove = hand(currentMove,:);

end




%% Fix hands

deck(ismember(deck,currentMove,'rows'),:) = zeros(1,2);


end