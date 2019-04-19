function printPulledCard(pullCard)


axes; 
axisSize = 1 / (13 + 2);
set(gca,'Position',[.9 .6 axisSize .4]);

imshow(sprintf('cardImages/%s.png',outputCard(pullCard)),'Border','Tight','InitialMagnification','Fit')

xlabel('Trump card');