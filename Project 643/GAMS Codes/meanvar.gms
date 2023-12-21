$TITLE Mean-variance model.

SET Assets;

ALIAS(Assets,i,j);

PARAMETERS
         ExpectedReturns(i)  Expected returns
         VarCov(i,j)         Variance-Covariance matrix ;


$GDXIN Estimate
$LOAD Assets=subset VarCov ExpectedReturns
$GDXIN

SCALAR
    lambda Risk aversion Factor;


POSITIVE VARIABLES
    x(i) Holdings of assets;

VARIABLES
    PortVariance Portfolio variance
    PortReturn   Portfolio return
    z            Objective function value;

EQUATIONS
    ReturnDef    Equation defining the portfolio return
    VarDef       Equation defining the portfolio variance
    NormalCon    Equation defining the normalization contraint
    ObjDef       Objective function definition;


ReturnDef ..   PortReturn    =e= SUM(i, ExpectedReturns(i)*x(i));

VarDef    ..   PortVariance  =e= SUM((i,j), x(i)*VarCov(i,j)*x(j));

NormalCon ..   SUM(i, x(i))  =e= 1;

ObjDef    ..   z             =e= (1-lambda) * PortReturn - lambda * PortVariance;

MODEL MeanVar 'PFO Model 3.2.3' /all/;

FILE FrontierHandle /"MeanVarianceFrontier.csv"/;

FrontierHandle.pc = 5;

PUT FrontierHandle;

PUT "Lambda","z","Variance","ExpReturn";

LOOP (i, PUT i.tl);

PUT /;


FOR  (lambda = 0 TO 1 BY 0.1,

   SOLVE MeanVar MAXIMIZING z USING nlp;

   PUT lambda:6:5, z.l:6:5, PortVariance.l:6:5, PortReturn.l:6:5;

   LOOP (i, PUT x.l(i):6:5 );

   PUT /;
)


PUTCLOSE;