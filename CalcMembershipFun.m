function Fu = CalcMembershipFun(A, H, type)
    % 計算歸屬函數的參數
    b = sum(A.*H(A))./sum(H(A));
    reg = A(H(A)>0);    c = b + max(abs(b-max(reg)), abs(b-min(reg)));
    a = 2*b-c;
    
    % 計算歸屬函數
    x = (1:256);
    if type == 'S'
        Fu = zeros(256, 1);
        ind = ((x >= a) & (x <= b));	Fu(ind) = 2*(((x(ind)-a)./(c-a)).^2);
        ind = ((x >= b) & (x <= c));	Fu(ind) = 1 - 2*(((x(ind)-c)./(c-a)).^2);
        ind = (x>=c);                   Fu(ind) = 1;
    elseif type == 'Z'
        Fu = ones(256, 1);
        ind = ((x >= a) & (x <= b));	Fu(ind) = 1 - 2*(((x(ind)-a)./(c-a)).^2);
        ind = ((x >= b) & (x <= c));	Fu(ind) = 2*(((x(ind)-c)./(c-a)).^2);
        ind = (x>=c);                   Fu(ind) = 0;
    else
        error('CalcMembershipFun: parameter is error.');
    end
end