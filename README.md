# POE
A Whist engine in MATLAB

This is a Whist engine which can support anywhere from 0 to 4 computer players. 

ALGORITHM

I use a tree structure, in which the ambient extant deck and trick are passed to a recursive routine. 
The routine is player- and depth-agnostic, such that it may choose optimal plays at any level of the trick, and regardless of whether or not it has a human teammate. 

Under the routine, if the trick is not finished, a set of legal moves are generated, which are then in turn passed again to the routine. 
In the base case, it's trivial to determine which of the available legal plays wins the trick. 
Those plays which are winning are then first negated, and then passed up the tree. Recall, of course, that, if player k + 1 is winning the trick, player k is losing. 

Outside of the main routine, I use a Monte Carlo simulation, in which, for each computer player, all extant cards not held by that computer are shuffled and redistributed to the remaining three players. 
Thus, the branching factor of the tree is equal only to the number of legal moves per players. This renders the problem computationally-feasible. 

Importantly, the reshuffling procedure retains a "memory" of the hands previously played. If a different player, in an earlier trick, failed to match the lead suit, the routine then knows that that player has run out of that lead suit. This information is retained and provided to the reshuffling routine. 
This allows the computers to simulate play, not only given knowledge of which cards have been played already, but which players have run out of which cards. 

In each round of Monte Carlo simulation, the winning status of each legal move is assessed. After each round, I reward each winning move with one point. Further, the winning move which is also the lowest (accounting for trump status and game rules) is awarded a second point. Thus, we don't solely give priority to easy wins (like the ace of trumps). After all rounds of Monte Carlo simulation are complete, I choose the card which received the most points.

INSTRUCTIONS

Everything is automated, so just press play. 
You'll be prompted to enter player names and computer status. 
You will also be prompted to choose whether or not to randomize the hands. 
Randomizing the hands is good for playing test matches, usually with four computer players. 

If you're using a real deck, dealt to the players, do not randomize the hand. 
If you are not randomizing the hand, recall that the player in order 4 must have 12 cards. That is, the card which is pulled is pulled from that player's hand. So, only 12 card will be accepted. 
You'll also be prompted to provide the pulled card. 

If prompted, provide all cards in the format 'n s', or number suit. 
So, a 3 of spades is '3 s'. An ace of diamonds is 'a d'.

# PoeSP 
PoeSP is a single-player cousin to Poe. It supports only a single human player, playing against three automated opponents, all with randomized hands. PoeSP features a visual interface, such that the human player may see real-time readouts of the hand and trick, and choose from the cards displayed on-screen.

PoeSP is available as a branch of POE. 
