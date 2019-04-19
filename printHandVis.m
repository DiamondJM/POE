function printHandVis(hand)



hand = hand(logical(hand(:,1)),:);

numCards = size(hand,1); 
axisSize = 1 / (numCards + 2);

fprintf('Printing hand. \n');

axes; 
set(gca,'Position',[.05 .1 axisSize .4]);

for ii = 1:size(hand,1)
    currentPos = get(gca,'Position');
    if ii > 1
        currentPos(1) = currentPos(1) + currentPos(3) * 1.08;
        axes;
        set(gca,'Position',currentPos);
    end
    
    imshow(sprintf('cardImages/%s.png',outputCard(hand(ii,:))),'Border','Tight','InitialMagnification','Fit')
    xlabel(num2str(ii));
end
