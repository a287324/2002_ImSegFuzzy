function IF = CalcIF(A, H, type)
    % 計算歸屬函數
    Ua = CalcMembershipFun(A, H, type);
    % 計算Index of fuzziness
    Ua_crisp = Ua > 0.5;
    N = length(find(Ua > 0));
    IF = (2./N)*sum(abs(Ua-Ua_crisp));
end