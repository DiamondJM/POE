function [hand, mismatchLeader] = scoreTrick(hand,trump,trick)


if nargin ==2; trick = hand; end


if logical(trick(1,1))
    mismatchLeader = (hand(:,2) ~= trick(1,2)) & logical(hand(:,2));
else
    mismatchLeader = false(size(hand,1),1);
end

trump = hand(:,2) == trump; 


scores = zeros(size(hand,1),1); 
scores(mismatchLeader) = -13; 
scores(trump) = 13; 


hand = hand(:,1) + scores; 


end