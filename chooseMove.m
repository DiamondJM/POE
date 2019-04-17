function myStruct = chooseMove(myStruct)

trick = myStruct.trick;
trump = myStruct.trump;

legalMoves = genLegalMoves(myStruct);
lmWeighted = scoreTrick(legalMoves,trump,trick);
% deck = myStruct.deck;


% How many moves through are we?
if all(trick(:,1) == 0); turn = 1;
else; turn = find(logical(trick(:,1)),1,'last') + 1;
end
% cardInds = buffer(1:52,13);
% hand = deck(cardInds(:,turn),:);

wonHand = false;

if turn == 4
    trickWeighted = scoreTrick(trick,trump);

    if trickWeighted(2) == max(trickWeighted)
        % Teammate has won
        wonHand = true;
        
        [~,ind] = min(lmWeighted);
        chosenMove = legalMoves(ind,:);
        fullWins = true(1,length(lmWeighted));
        
    else
        % We haven't won yet.
        % We have a chance.
        if any(lmWeighted > max(trickWeighted))
            wonHand = true;
            % [~,ind] = max(lmWeighted);
            % chosenMove = legalMoves(ind,:);
            
            fullWins = lmWeighted > max(trickWeighted);
            
            wonInds = find(fullWins);
            if length(wonInds) > 1
                [~,ind] = min(lmWeighted(wonInds));
                wonInds = wonInds(ind);
            end
            chosenMove = legalMoves(wonInds,:);
            
        else
            [~,ind] = min(lmWeighted);
            chosenMove = legalMoves(ind,:);
            
            fullWins = false(1,length(lmWeighted));
        end
    end
    
    % So we've come with our legal move. Now let's pack up?
    % deck(ismember(deck,chosenMove,'rows'),:) = zeros(1,2);
    
    myStruct.wonHand = wonHand;
    myStruct.chosenMove = chosenMove;
    
    myStruct.fullWins = fullWins;
    % myStruct.deck = deck;
    % trick(turn,:) = chosenMove;
    % myStruct.trick = trick;
    
    
else
    listChildren = generateChildren(myStruct,legalMoves);
    
    for ii = 1:length(listChildren)
        listChildren(ii) = chooseMove(listChildren(ii));
    end
    
    wonHand = double(~[listChildren.wonHand]);
    wonInds = find(wonHand == max(wonHand));
    if length(wonInds) > 1
        [~,ind] = min(lmWeighted(wonInds));
        wonInds = wonInds(ind);
    end
    
    chosenMove = legalMoves(wonInds,:);
    
    myStruct.chosenMove = chosenMove;
    myStruct.wonHand = wonHand(wonInds);
    
    % trick = listChildren(wonInds).trick;
    % myStruct.trick = trick;
    % This is necessary if we'd like to pull back up trick results. 
    % Note that these results are populated in the generateChildren
    % routine. 
    
    myStruct.fullWins = wonHand;
    
end

end



