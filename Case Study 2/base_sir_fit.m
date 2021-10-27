
% Here is an example that reads in infection and fatalities from STL City
% and loads them into a new matrix covidstlcity_full
% In addition to this, you have other matrices for the other two regions in question

COVID_STLcity = zeros(594,2);
COVID_STLcity = COVID_MO([585:1178], [3:4]);
STL_population = populations_MO{2, 2} / 1000;

covidstlcity_full = double(table2array(COVID_STLcity(:,[1:2])))./STL_population;


COVID_JEFFERSONcity = zeros(584,2);
COVID_JEFFERSONcity = COVID_MO([1:584], [3:4]);
JEFFERSON_population = populations_MO{1, 2} / 1000;

covidstlcity_full = double(table2array(COVID_JEFFERSONcity(:,[1:2])))./JEFFERSON_population;


COVID_SPRINGFIELDcity = zeros(589,2);
COVID_SPRINGFIELDcity = COVID_MO([1179:1767], [3:4]);
SPRINGFIELD_population = populations_MO{3, 2} / 1000;

covidstlcity_full = double(table2array(COVID_SPRINGFIELDcity(:,[1:2])))./SPRINGFIELD_population;

coviddata = ; % TO SPECIFY
t = ; % TO SPECIFY

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
Af = [];
bf = [];

%% set up upper and lower bound constraints
% Set upper and lower bounds on the parameters
% lb < x < ub
% here, the inequality is imposed element-wise
% If you don't want such a constraint, keep these matrices empty.
ub = []';
lb = []';

% Specify some initial parameters for the optimizer to start from
x0 = []; 

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