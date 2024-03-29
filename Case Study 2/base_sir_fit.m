
% Here is an example that reads in infection and fatalities from STL City
% and loads them into a new matrix covidstlcity_full
% In addition to this, you have other matrices for the other two regions in question

COVID_STLcity = zeros(594,2);
COVID_STLcity = COVID_MO([585:1178], [3:4]);
STL_population = populations_MO{2, 2};

covidstlcity_full = double(table2array(COVID_STLcity(:,[1:2])))./STL_population;
for i = 1:594
    covidstlcity_full(i, 1) = 1 - covidstlcity_full(i, 1);
end

% Stores day-to-day changes of cases and deaths in STLcity region in
% columns 1 and 2, respectively, of COVID_STLcity_dayChanges.
COVID_STLcity_dayChanges = zeros(594, 2);

for i = 2:594
    COVID_STLcity_dayChanges(i, 1) = (COVID_STLcity{i, 1} - COVID_STLcity{i-1, 1}) / STL_population;
    COVID_STLcity_dayChanges(i, 2) = (COVID_STLcity{i, 2} - COVID_STLcity{i-1, 2}) / STL_population;
end



COVID_JEFFERSONcity = zeros(584,2);
COVID_JEFFERSONcity = COVID_MO([1:584], [3:4]);
JEFFERSON_population = populations_MO{1, 2};

covidjeffersoncity_full = double(table2array(COVID_JEFFERSONcity(:,[1:2])))./JEFFERSON_population;

% Stores day-to-day changes of cases and deaths in JEFFERSONcity region in
% columns 1 and 2, respectively, of COVID_JEFFERSONcity_dayChanges.
COVID_JEFFERSONcity_dayChanges = zeros(584, 2);

for i = 2:584
    COVID_JEFFERSONcity_dayChanges(i, 1) = (COVID_JEFFERSONcity{i, 1} - COVID_JEFFERSONcity{i-1, 1}) / JEFFERSON_population;
    COVID_JEFFERSONcity_dayChanges(i, 2) = (COVID_JEFFERSONcity{i, 2} - COVID_JEFFERSONcity{i-1, 2}) / JEFFERSON_population;
end


COVID_SPRINGFIELDcity = zeros(589,2);
COVID_SPRINGFIELDcity = COVID_MO([1179:1767], [3:4]);
SPRINGFIELD_population = populations_MO{3, 2};

covidspringfieldcity_full = double(table2array(COVID_SPRINGFIELDcity(:,[1:2])))./SPRINGFIELD_population;


% Stores day-to-day changes of cases and deaths in SPRINGFIELDcity region in
% columns 1 and 2, respectively, of COVID_SPRINGFIELDcity_dayChanges.
COVID_SPRINGFIELDcity_dayChanges = zeros(589, 2);

for i = 2:589
    COVID_SPRINGFIELDcity_dayChanges(i, 1) = (COVID_SPRINGFIELDcity{i, 1} - COVID_SPRINGFIELDcity{i-1, 1}) / SPRINGFIELD_population;
    COVID_SPRINGFIELDcity_dayChanges(i, 2) = (COVID_SPRINGFIELDcity{i, 2} - COVID_SPRINGFIELDcity{i-1, 2}) / SPRINGFIELD_population;
end



coviddata = covidstlcity_full; % TO SPECIFY
t = 594; % TO SPECIFY

% The following line creates an 'anonymous' function that will return the cost (i.e., the model fitting error) given a set
% of parameters.  There are some technical reasons for setting this up in this way.
% Feel free to peruse the MATLAB help at
% https://www.mathworks.com/help/optim/ug/fmincon.html
% and see the sectiono on 'passing extra arguments'
% Basically, 'sirafun' is being set as the function siroutput (which you
% will be designing) but with t and coviddata specified.
sirafun= @(x)siroutput(x,t,coviddata);

%% set up rate and initial condition constraints
% Set A and b to impose a parameter inequality constraint of the form A*x < b
% Note that this is imposed element-wise
% If you don't want such a constraint, keep these matrices empty.
A = [];
b = [];

%% set up some fixed constraints
% Set Af and bf to impose a parameter constraint of the form Af*x = bf
% Hint: For example, the sum of the initial conditions should be
% constrained
% If you don't want such a constraint, keep these matrices empty.
Af = [0 0 0 1 1 1 1];
bf = 1;

%% set up upper and lower bound constraints
% Set upper and lower bounds on the parameters
% lb < x < ub
% here, the inequality is imposed element-wise
% If you don't want such a constraint, keep these matrices empty.
ub = [1 1 1 1 1 1 1]';
lb = [0 0 0 0 0 0 0]';

% Specify some initial parameters for the optimizer to start from
x0 = [.05; .01; .10; (STL_population - 1)/STL_population; 1/STL_population; 0; 0]; 

% This is the key line that tries to opimize your model parameters in order to
% fit the data
% note tath you 
x = fmincon(sirafun,x0,A,b,Af,bf,lb,ub)

%plot(Y);
%legend('S',L','I','R','D');
%xlabel('Time')

Y_fit = siroutput_full(x,t);

figure(1);

% Make some plots that illustrate your findings.
% TO ADD