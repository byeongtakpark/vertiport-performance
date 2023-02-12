function U = utility(Coef, TravelCost, TravelTime)
  y = Coef*[1 TravelCost TravelTime]';
  U = exp(y);
end
