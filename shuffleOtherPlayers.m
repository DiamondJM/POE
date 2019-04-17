function hands = shuffleOtherPlayers(hands,jj,playerRanOut)



cardCounts = cellfun(@(x) sum(logical(x(:,1))),hands);


deckRemaining = cat(1,hands{:}); 
cardInds = buffer(1:52,13);

myInds = cardInds(:,jj); 
deckRemaining(myInds,:) = [];
deckRemaining(deckRemaining(:,1) == 0,:) = [];

deckRemaining = deckRemaining(randperm(size(deckRemaining,1)),:);


for ii = find(1:4 ~= jj)
    hand = zeros(13,2); 
    
    restrictedSuit = find(playerRanOut(ii,:));
    if isempty(restrictedSuit)
        availableCards = deckRemaining; 
    else
        availableCards = ~ismember(deckRemaining(:,2),restrictedSuit);
        availableCards = deckRemaining(availableCards,:);
    end
    
    
    while cardCounts(ii) > size(availableCards,1)
        % Other players have exhausted the available cards, while this
        % player has a restriction they dont. 
        % Let's grab one of theirs. 
        
        nonNeededCards = find(ismember(deckRemaining(:,2),restrictedSuit));
        nonNeededCards = nonNeededCards(randi([1 length(nonNeededCards)]));
        nonNeededCard = deckRemaining(nonNeededCards,:);
        
        exchangePlayer = find(~playerRanOut(:,nonNeededCard(2)) & (1:4 ~= jj)' & (1:4 < ii)');
        exchangePlayer = exchangePlayer(randi([1 length(exchangePlayer)]));
        % This player can take our card. 
        
        % Can we take its card? 
    
        neededCards = hands{exchangePlayer};
        neededCards = find(~ismember(neededCards(:,2),restrictedSuit) & neededCards(:,1) ~= 0);
        if isempty(neededCards); continue; end
        % So now we have a card from that player that we can take. 
        
        neededCards = neededCards(randi([1 length(neededCards)]));
        neededCard = hands{exchangePlayer}(neededCards,:);
        
        hands{exchangePlayer}(neededCards,:) = nonNeededCard;
        deckRemaining(nonNeededCards,:) = neededCard;
        
        availableCards = ~ismember(deckRemaining(:,2),restrictedSuit);
        availableCards = deckRemaining(availableCards,:);
    end
        
        
    availableCards = availableCards(1:cardCounts(ii),:);
    hand(1:cardCounts(ii),:) = availableCards;
    hands{ii} = hand; 
    
    deckRemaining = deckRemaining(~ismember(deckRemaining,availableCards,'rows'),:);
end



end