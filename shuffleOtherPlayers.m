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
        % We've ran into a 'pickle', of sorts, in which we've arrived at a
        % sub-maximal cardinality matching on the bipartite
        % graph between people and cards. 
        
        % What we can do is dump 
        
        exchangePlayer = find((1:4 ~= jj)' & (1:4 < ii)');
        exchangePlayer = exchangePlayer(randi([1 length(exchangePlayer)])); 
        exchangeHand = hands{exchangePlayer};
        
        unwantedCardInd = find(ismember(deckRemaining(:,2),restrictedSuit));
        unwantedCardInd = unwantedCardInd(randi([1 length(unwantedCardInd)])); 
        unwantedCard = deckRemaining(unwantedCardInd,:);
        
        % Can the other player take it? 
        theirRestriction = find(playerRanOut(exchangePlayer,:));
        if ~isempty(theirRestriction) && ismember(unwantedCard(2),theirRestriction); continue; end
        % Yes. 

        % Does the other player have anything? 
        if sum(exchangeHand(:,1)) == 0; continue; end
        
        % Can we take any of their cards? 
        canTakeInd = logical(exchangeHand(:,1));
        if any(~ismember(exchangeHand(canTakeInd,2),restrictedSuit))
            canTakeInd = canTakeInd & ~ismember(exchangeHand(:,2),restrictedSuit);
            % In this case, yes. We can. We should be done after ths. 
        end
        % Else: no.
        % No.
        % Let's settle for swapping the card anyway. Then we'll
        % hopefully find success on the next iteration.
        

        canTakeInd = find(canTakeInd);
        canTakeInd = canTakeInd(randi([1 length(canTakeInd)]));
        canTakeCard = exchangeHand(canTakeInd,:);
        
        
        deckRemaining(unwantedCardInd,:) = canTakeCard;
        exchangeHand(canTakeInd,:) = unwantedCard;
        hands{exchangePlayer} = exchangeHand; 
        
        % And we should be done.
        
        availableCards = ~ismember(deckRemaining(:,2),restrictedSuit);
        availableCards = deckRemaining(availableCards,:);
        
        % Interestingly, note that, only in a subset of these iterations of
        % the while loop, will deckRemaining even change. 
        % But this is a parsimonious, player-agnostic way of facilitating
        % endless random shuffles. 
        % We can call it a LAS VEGAS algorithm. 
        
    end
        
    availableCards = availableCards(1:cardCounts(ii),:);
    hand(1:cardCounts(ii),:) = availableCards;
    hands{ii} = hand; 
    
    deckRemaining = deckRemaining(~ismember(deckRemaining,availableCards,'rows'),:);
end

ccNew = cellfun(@(x) sum(logical(x(:,1))),hands);
assert(isequal(cardCounts,ccNew));

for ii = find(1:4 ~= jj)
    restrictedSuit = find(playerRanOut(ii,:));
    illegalCard = ismember(hands{ii}(:,2),restrictedSuit);
    assert(sum(illegalCard) == 0); 
end





end