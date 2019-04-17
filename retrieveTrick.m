function retrieveTrick(myStruct)

fprintf('Trumps are %d. \n \n',myStruct.trump);

while true
    disp(myStruct.chosenMove);
    if isempty(myStruct.children); return; end
    myStruct = myStruct.children;
    % if isempty(myStruct.children); return; end
end
end
