SET Assets;

ALIAS(Assets,i,j);

PARAMETERS
         ExpectedReturns(i)  Expected returns
         VarCov(i,j)         Variance-Covariance matrix ;


$GDXIN Estimate
$LOAD Assets=subset VarCov ExpectedReturns
$GDXIN

SCALAR
    r Target Return;


POSITIVE VARIABLES
    x(i) Holdings of assets;

VARIABLES
    PortfolioVariance Portfolio variance
    PortfolioReturn   Portfolio return
    z            Objective function value;

EQUATIONS
    Return    Equation defining the portfolio return
    Var       Equation defining the portfolio variance denoting risk
    BudgetCon    Equation defining the normalization contraint
    ReturnCon    Equation defining the Target Return Constraint
    ObjDef       Objective function definition;


Return ..   PortfolioReturn    =e= SUM(i, ExpectedReturns(i)*x(i));

Var    ..   PortfolioVariance  =e= SUM((i,j), x(i)*VarCov(i,j)*x(j));

BudgetCon ..   SUM(i, x(i))  =e= 1;

ReturnCon ..   PortfolioReturn    =g= r;

ObjDef    ..   z             =e= PortfolioVariance;

MODEL PortfolioTargetRet /all/;

FILE FrontierHandle /"PortVarianceFrontier.csv"/;

FrontierHandle.pc = 5;

PUT FrontierHandle;

PUT "r","Variance","ExpReturn";

LOOP (i, PUT i.tl);

PUT /;


FOR  (r = 0 TO 0.25 BY 0.02,

   SOLVE PortfolioTargetRet MINIMIZING z USING nlp;

   PUT r:6:5, PortfolioVariance.l:6:5, PortfolioReturn.l:6:5;

   LOOP (i, PUT x.l(i):6:5 );

   PUT /;
)

PUTCLOSE;