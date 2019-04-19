function printHand(hand) 


hand = hand(logical(hand(:,1)),:);


for ii = 1:size(hand,1)
    
    cardVal = outputCard(hand(ii,:)); 
    fprintf('%s \n',cardVal);
end
