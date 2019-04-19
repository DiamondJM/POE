
function oneZero = retrieveOneZero
    oneZero = input('','s');
    while ~any(ismember(oneZero,{'1','0'}))
        fprintf('Incorrect input. \n')
        oneZero = input('','s');
    end
    
    oneZero = logical(str2double(oneZero)); 
    
end