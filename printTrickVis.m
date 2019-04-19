function printTrickVis(trick,playerNames)

% humanPlayer = find(~compPlayers); 
% teammate = mod(humanPlayer + 2 - 1, 4) + 1;

trick = trick(logical(trick(:,1)),:);

axisSize = .18;


axes; 
set(gca,'Position',[.05 .6 axisSize .4]);

for ii = 1:size(trick,1)
    
    if ii > 1
        currentPos = get(gca,'Position');
        currentPos(1) = currentPos(1) + currentPos(3) * 1.08;
        axes;
        set(gca,'Position',currentPos);
    end
    imshow(sprintf('cardImages/%s.png',outputCard(trick(ii,:))),'Border','Tight','InitialMagnification','Fit')
    xlabel(playerNames{ii});
end
