function printHand(hand) 

for ii = 1:size(hand,1)
    
    cardVal = outputCard(hand(ii,:)); 
    fprintf('%s \n',cardVal);
end
