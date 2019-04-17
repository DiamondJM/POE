function hands = deckToHands(deck)

cardInds = buffer(1:52,13);

hands = cell(1,4); 

for ii = 1:size(cardInds,2) 
    hands{ii} = deck(cardInds(:,ii),:);
end

end