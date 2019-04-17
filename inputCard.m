function cardVal = inputCard(card)


conversionCard = {'2',1;...
    '3',2;...
    '4',3;...
    '5',4;...
    '6',5;...
    '7',6;...
    '8',7;...
    '9',8;...
    '10',9;...
    'j',10;...
    'q',11;...;
    'k',12;...;
    'a',13};

% Spade 1
% Club 2
% Diamond 3
% Heart 4


conversionSuit = {'s',1;...
    'c',2;...
    'd',3;...
    'h',4;};

cardVal = zeros(1,2);

if nargin == 0
    card = input('Please provide card. \nFormat n s (Number Suit) \n','s');
end
card = strsplit(card);

while length(card) ~= 2
    fprintf('Incorrect input. \n');
    
    card = input('Please provide card. \nFormat ns (Number Suit) \n','s');
    card = strsplit(card);
end

cNumber = card{1};
suit = card{2};

while ~any(strcmpi(conversionCard(:,1),cNumber)) || ~any(strcmpi(conversionSuit(:,1),suit)) 
    fprintf('Incorrect input. \n');
    
    card = input('Please provide card. \nFormat ns (Number Suit) \n','s');
    card = strsplit(card);
    
    cNumber = card{1};
    suit = card{2};

end
cNumber = conversionCard{strcmpi(conversionCard(:,1),cNumber),2};
suit = conversionSuit{strcmpi(conversionSuit(:,1),suit),2};

cardVal(1) = cNumber;
cardVal(2) = suit;

end