%% 21. Mixed integer/discrete problems
%{
Many problems are inherently discrete. I won't get into that class
of problems at all. However there are also problems of mixed class.
Here one or more of the variables in the optimization are limited
to a discrete set of values, while the rest live in a continuous
domain. There are mixed solvers available, both on Matlab central
and from other sources.

What do you do when there are only a few possible discrete states
to investigate? Probably best here is to simply fix the discrete
variables at each possible state, then solve for the continuous
variables. Then choose the solution which is best overall.
%}

%% 22. Understanding how they work
%{
While I will not even try to give a full description of how any
optimizer works, a little bit of understanding is worth a tremendous
amount when there are problems. True understanding can only come
from study in some depth of an algorithm. I can't offer that here.

Instead, I'll try to show the broad differences between some of the
methods, and suggest when one might use one method over another.

Previously in this text I've referred to optimizers as tools that
operate on a black box, or compared them to a blindfolded individual
on a hillside. These are useful analogies but these analogies don't
really tell enough to visualize how the tools work. We'll start
talking about the method used in fminsearch, since it may well
be one of the tools which is used most often.

Fminsearch is a Nelder/Mead polytope algorithm. Some call it a
simplex method, but this may confuse things with linear programming.
It works by evaluating the objective function over a polytope of
points in the parameter space. In 2-dimensions, this will be a
triangle, in n-dimensions, the polytope (or simplex) will be
composed of n+1 points. The basic algorithm is simple. Compare
these n+1 points, and choose the WORST one to delete. Replace this
bad point with its reflection through the remaining points in
the polytope. You can visualize this method as flopping a triangle
around the parameter space until it finds the optimum. Where
appropriate, the polytope can shrink or grow in size.

I'll note that this basic Nelder/Mead code is simple, it requires
no gradient information at all, and can even survive an occasional
slope or function discontinuity. The downside of a polytope method
is how slowly it will converge, especially for higher dimensional
problems. I will happily use fminsearch for 2 or 3 variable problems,
especially if its something I will need to use infrequently. I will
rarely if ever consider fminsearch for more than 5 or 6 variables.
(Feel free to disagree. You may have more patience than I do.)

The other point to remember about a polytope method is the stopping
criterion. These methods are generally allowed to terminate when
all the function values over the polytope have the same value
within the function tolerance. (I have also seen the standard
deviation of the function values over the polytope used to compare
to the function tolerance.)

We can contrast the polytope algorithm to the more traditional
Newton-like family of methods, combined with a line search. These
methods include many of the optimizers in the optimization toolbox,
such as fminunc, lsqcurvefit, fsolve, etc. Whereas a polytope method
lays down a polytope on the objective function surface, then moves
the polytope around, these line-search methods attempt to be more
intelligent in their operation. The basic idea is to form a locally
linear approximation to the problem at hand, then solve the linearized
problem exactly. This determines a direction to search along, plus
a predicted step length in that direction from your current point
in the parameter space. (I already discussed line searches in section
9.) This is why these tools require a gradient (or Jacobian as
appropriate) of the objective. This derivative information is used
to compute the necessary locally linear approximation.

The other feature of interest about these methods is how they "learn"
about the surface in question. The very first iteration taken might
typically be a steepest descent step. After the first iteration, the
optimizer can gradually form an adaptive approximation to the local
Hessian matrix of the objective. This, in effect tells the optimizer
what the local curvature of the surface looks like.

%}

%%

% As a comparison, we wll look again to the Rosenbrock function.
rosen = @(X) (1-X(:,1)).^2 + 105*(X(:,2)-X(:,1).^2).^2;
% first, generate a contour surface
[xc,yc] = meshgrid(-7:.05:7);
zc = rosen([xc(:),yc(:)]);
zc = reshape(zc,size(xc));

close all
contour(xc,yc,zc,[.1 1 4 16 64 256 1024 4096])
hold on

% now do an optimization using optimplot to plot the points
opts = optimset('fminsearch');
opts.OutputFcn = @optimplot;
opts.Display = 'iter';

Xfinal = fminsearch(rosen,[-6,4],opts);
hold off

%%

% try the same optimization using fminunc

close
contour(xc,yc,zc,[.1 1 4 16 64 256 1024 4096])
hold on

% now do an optimization using optimplot to plot the points
opts = optimset('fminunc');
opts.OutputFcn = @optimplot;
opts.Display = 'iter';

Xfinal = fminunc(rosen,[-6,4],opts);
hold off

% Note the difference between these two optimizers. Its most obvious
% at the start, when fminsearch started out with a relatively large
% simplex, which more slowly flopped down to the valley than did
% fminunc. Fminsearch also clearly overshoots the valley at first,
% then recovers. Also note that when it did hit the bottom of the
% valley, fminunc was able to take at least a few large initial steps,
% until the valley became too curved and too flat that it also was
% forced into short steps too.

%% 23. Wrapping an optimizer around quad
%{
Nested optimizations or nesting an integration inside an
optimization are similar problems. Both really just a problem
of managing parameter spaces. I.e., you must ensure that each
objective function or integrand sees the appropriate set of
parameters. 

In this example, I'll formulate an optimization which has an
integration at its heart. 
%}

%%

% Choose some simple function to integrate. 
% 
%   z = (coef(1)^2)*x^2 + (coef(2)^2)*x^4
%
% I picked this one since its integral over the
% interval [-1 1] is clearly minimized at coef = [0,0].
K = @(x,coef) coef(1).^2*x.^2 + coef(2).^2*x.^4;

% As far as the integration is concerned, coef is a constant
% vector. It is invariant. And the optimization really does
% not want to understand what x is, as far as the optimizer
% is concerned, its objective is a function of only the
% parameters in coef.

% We can integrate K easily enough (for a given set of
% coefficients (coef) via
coef = [2 3];
quad(K,-1,1,1e-13,[],coef)

% We could also have embedded coef directly into the
% anonymous function K, as I do below.

%%

% As always, I like to make sure that any objective function
% produces results that I'd expect. Here we know what to
% expect, but it never hurts to test our knowledge. I'll
% change the function K this time to embed coef inside it.

% If we try it at [0 0], we see the expected result, i.e., 0.
coef = [0 0];
K = @(x) coef(1).^2*x.^2 + coef(2).^2*x.^4;
quad(K,-1,1,1e-13)

%%

% I used a tight integration tolerance because we will
% put this inside an optimizer, and we want to minimize
% any later problems with the gradient estimation.

% Now, can we minimize this integral? Thats easy enough.
% Here is an objective function, to be used with a
% minimizer. As far as the optimizer is concerned, obj is
% a function only of coef.
obj = @(coef) quad(@(x) coef(1).^2*x.^2+coef(2).^2*x.^4,-1,1,1e-13);

% Call fminsearch, or fminunc
fminsearch(obj,[2 3],optimset('disp','iter'))

%%

% or
fminunc(obj,[2 3],optimset('disp','iter','largescale','off'))

% Both will return a solution near [0 0].

%% 24. Graphical tools for understanding sets of nonlinear equations
%{
Pick some simple set of nonlinear equations. Perhaps this pair
will do as well as any others.

  x*y^3 = 2

  y-x^2 = 1

We will look for solutions in the first quadrant of the x-y plane,
so x>=0 and y>=0.
%}

%%

% Now consider each equation independently from the other. In the x-y
% plane, these equations can be thought of as implicit functions, thus
% ezplot can come to our rescue.
close all
ezplot('x*y.^3 - 2',[0 5])
hold on
ezplot('y - x.^2 - 1',[0 5])
hold off
grid on
title 'Graphical (ezplot) solution to a nonlinear system of equations'
xlabel 'x'
ylabel 'y'

% The intersection of the two curves is our solution, zooming in
% will find it quite nicely.

%%

% An alternative approach is to think of the problem in terms of
% level sets. Given a function of several variables, z(x,y), a
% level set of that function is the set of (x,y) pairs such that
% z is constant at a given level.

% In Matlab, there is a nice tool for viewing level sets: contour.
% See how it allows us to solve our system of equations graphically.

% Form a lattice over the region of interest in the x-y plane
[x,y] = meshgrid(0:.1:5);

% Build our functions on that lattice. Be careful to use .*, .^ and
% ./ as appropriate.
z1 = x.*y.^3;
z2 = y - x.^2;

% Display the level sets 
contour(x,y,z1,[2 2],'r')
hold on
contour(x,y,z2,[1 1],'g')
hold off
grid on
title 'Graphical (contour) solution to a nonlinear system of equations'
xlabel 'x'
ylabel 'y'

%% 25. Optimizing non-smooth or stochastic functions
%{
A property of the tools in the optimization toolbox is they
all assume that their objective function is a continuous,
differentiable function of its parameters. (With the exception
of bintprog.)

If your function does not have this property, then look
elsewhere for optimization. One place might be the Genetic
Algorithms and Direct Search toolbox.

http://www.mathworks.com/products/gads/description4.html

Simulated annealing is another tool for these problems. You
will find a few options on the file exchange.

%}

%% 26. Linear equality constraints
%{
This section is designed to help the reader understand how one
solves linear least squares problems subject to linear equality
constraints. Its written for the reader who wants to understand
how to solve this problem in terms of liner algebra. (Some may
ask where do these problems arise: i.e., linear least squares with
many variables and possibly many linear constraints. Spline models
are a common example, functions of one or several dimensions.
Under some circumstances there may also be linear inequality
constraints.) 

We'll start off with a simple example. Assume a model of

  y = a + b*x1 + c*x2

with the simple equality constraint

  c - b = 1

How would we solve this problem on paper? (Yes, lsqlin solves
these problems in its sleep. We'll do it the hard way instead.)
Simplest is to eliminate one of the unknowns using the constraint.
Replace c with 1+b in the model. 

  c = 1 + b

So

  y = a + b*x1 + (1+b)*x2

Rearrange terms to get this

  (y - x2) = a + b*(x1+x2)

Estimate the unknowns (a,b), then recover c once b is known.

A point to note is I suggested we eliminate C in the model.
As easily, we could have eliminated b, but we could not have
ch0osen to eliminate a, because a did not enter into our
constraint at all. Another thing to think about is if the
constraint had some coefficients with values very near zero.
Elinimation of those variables would then cause significant
instabilities in the computations. Its similar to the reason
why pivoting is useful in the solution of systems of equations.

Lets try it on some data:

%}

%%

n = 500;
x1 = rand(n,1);
x2 = rand(n,1);
% yes, I know that these coefficients do not actually satisfy the
% constraint above. They are close though.
y = 1 + 2*x1 + pi*x2 + randn(n,1)/5;

% solve the reduced problem above
ab = [ones(n,1), x1+x2]\(y - x2)

% recover c
c = 1 + ab(2)
% Note that the coefficients were originally (1,2,pi) but
% application of the constraint c - b = 1 

%%

% Had we never applied any constraint, the (1,2,pi) values will be
% closer than for the constrained solution. This is easy to verify.
[ones(n,1),x1,x2]\y

%%

% We may use lsqlin to verify our constrained solution
lsqlin([ones(n,1),x1,x2],y,[],[],[0 -1 1],1,[],[],[],optimset('largescale','off'))
% As expected, the two constrained solutions agree.

%%

% The real question in this section is not how to solve a linearly
% constrained problem, but how to solve it programmatically, and
% how to solve it for possibly multiple constraints. 

% Start with a completely random least squares problem.
n = 20; % number of data points
p = 7;  % number of parameters to estimate
A = rand(n,p);
% Even generate random coefficients for our ground truth.
coef0 = 1 + randn(p,1)

y = A*coef0 + randn(n,1);

% Finally, choose some totally random constraints
m = 3;  % The number of constraints in the model
C = randn(m,p);
D = C*coef0;

%%

% Again, compute the simple (unconstrained) linear regression
% estimates for this model
coef1 = A\y

% verify that the unconstrained model fails to satisfy the
% constraints, but that the original (ground truth) coefficients
% do satisfy them. D-C*coef should be zero.
[D-C*coef0,D-C*coef1]

%%

% How does one solve the constrained problem? There are at least
% two ways to do so (if we choose not to resort to lsqlin.) For
% those devotees of pinv and the singular value distribution,
% one such approach would involve a splitting of the solution to
% A*x = y into two components: x = x_u + x_c. Here x_c must lie
% in the row space of the matrix C, while x_u lies in its null
% space. The only flaw with this approach is it will fail for
% sparse constraint matrices, since it would rely on the singular
% value decomposition.
%
% I'll discuss an approach that is based on the qr factorization
% of our constraint matrix C. It is also nicely numerically stable,
% and it offers the potential for use on large sparse constraint
% matrices.

[Q,R,E]= qr(C,0)

% First, we will ignore the case where C is rank deficient (high
% quality numerical code would not ignore that case, and the QR
% allows us to identify and deal with that event. It is merely a
% distraction in this discussion however.)
%
% We transform the constraint system C*x = D by left multiplying
% by the inverse of Q, i.e., its transpose. Thus, with the pivoting
% applied to x, the constraints become
%
%  R*x(E) = Q'*D
%
% In effect, we wanted to compute the Q-less QR factorization,
% with pivoting.
%
% Why did we need pivoting? As I suggested above, numerical
% instabilities may result otherwise. 
% 
% We will reduce the constraints further by splitting it into
% two fragments. Assuming that C had fewer rows than columns,
% then R can be broken into two pieces:
% 
%  R = [R_c, R_u]

R_c = R(:,1:m);
R_u = R(:,(m+1):end);

% Here R_c is an mxm, upper triangular matrix, with non-zero
% diagonals. The non-zero diagonals are ensured by the use of
% pivoting. In effect, column pivoting provides the means by 
% which we choose those variables to eliminate from the regression
% model.
%
% The pivoting operation has effectively split x into two pieces
% x_c and x_u. The variables x_c will correspond to the first m
% pivots identified in the vector E.
%
% This split can be mirrored by breaking the matrices into pieces
%
%  R_c*x_c + R_u*X_u = Q'*D
% 
% We will use this version of our constraint system to eliminate
% the variables x_c from the least squares problem. Break A into
% pieces also, mirroring the qr pivoting:

A_c = A(:,E(1:m));
A_u = A(:,E((m+1):end));

%%

% So the least squares problem, split in terms of the variable
% as we have reordered them is:
%
%  A_c*x_c + A_u*x_u = y
%
% We can now eliminate the appropriate variables from the linear
% least squares.
%
%  A_c*inv(R_c)*(Q'*D - R_u*x_u) + A_u*x_u = y
%
% Expand and combine terms. Remember, we will not use inv()
% in the actual code, but instead use \. The \ operator, when
% applied to an upper triangular matrix, is very efficient
% compared to inv().
%
%  (A_u - A_c*R_c\R_u) * x_u = y - A-c*R_c\(Q'*D)

x_u = (A_u - A_c*(R_c\R_u)) \ (y - A_c*(R_c\(Q'*D)))

%%

% Finally, we recover x_c from the constraint equations
x_c = R_c\(Q'*D - R_u*x_u)

%%

% And we put it all together in the unpivoted solution vector x:
xfinal = zeros(p,1);
xfinal(E(1:m)) = x_c;
xfinal(E((m+1):end)) = x_u

%%

% Were we successful? How does this result compare to lsqlin?
% The two are identical (as usual, only to within floating
% point precision irregularities.)
lsqlin(A,y,[],[],C,D,[],[],[],optimset('largescale','off'))

%%

% Verify that the equality constraints are satisfied to within
% floating point tolerances.
C*xfinal - D


%% 27. Sums of squares surfaces and the geometry of a regression
%{
I'll admit in advance that this section has no tips or tricks
to look for. But it does have some pretty pictures, and I hope
it leads into the next two sections, where I talk about confidence
limits and error estimates for parameters.

Consider the very simple (linear) regression model:

  y = a0 + a1*x + error.

The sum of squares surface as a function of the parameters
(a0,a1) will have ellipsoidal contours. Theory tells us this,
but its always nice to back up theory with an example. Then
I'll look at what happens in a nonlinear regression.

%}

%% 

% A simple linear model
n = 20;
x = randn(n,1);
y = 1 + x + randn(n,1);
close
figure
plot(x,y,'o')
title 'Linear data with noise'
xlabel 'x'
ylabel 'y'

%%

% linear regression estimates
M = [ones(n,1),x];
a0a1 = M\y

% look at various possible values for a0 & a1
v = -1:.1:3;
nv = length(v);
[a0,a1] = meshgrid(v);
a0=a0(:)';
a1=a1(:)';
m = length(a0);

SS = sum(((ones(n,1)*a0 + x*a1) - repmat(y,1,m)).^2,1);
SS = reshape(SS,nv,nv);

surf(v,v,SS)
title 'Sum of squares error surface'
xlabel 'a0'
ylabel 'a1'
figure
contour(v,v,SS)
hold on
plot(a0a1(1),a0a1(2),'rx')
plot([[-1;3],[1;1]],[[1;1],[-1;3]],'g-')
hold off
title 'Linear model: Sum of squares (elliptical) error contours'
xlabel 'a0'
ylabel 'a1'
axis equal
axis square
grid on

% Note: the min SSE will occur roughly at (1,1), as indicated
% by the green crossed lines. The linear regression estimates
% are marked by the 'x'.

% As predicted, the contours are elliptical.

%%

% next, we will do the same analysis for a nonlinear model
% with two parameters:
%
%   y = a0*exp(a1*x.^2) + error
%
% First, we will look at the error surface

% A simple nonlinear model
n = 20;
x = linspace(-1.5,1.5,n)';
y = 1*exp(1*x.^2) + randn(n,1);
figure
plot(x,y,'o')
title 'Nonlinear data with noise'
xlabel 'x'
ylabel 'y'

%%

% Nonlinear regression estimates. Use pleas for this one.
a1_start = 2;
[a1,a0] = pleas({@(a1,xdata) exp(a1*xdata.^2)},a1_start,x,y)
a0a1 = [a0,a1];

%%

% look at various possible values for a0 & a1
v = .5:.01:1.5;
nv = length(v);
[a0,a1] = meshgrid(v);
a0=a0(:)';
a1=a1(:)';
m = length(a0);

SS = sum((((ones(n,1)*a0).*exp(x.^2*a1)) - repmat(y,1,m)).^2,1);
SS = reshape(SS,nv,nv);
minSS = min(SS(:));

surf(v,v,SS)
title 'Nonlinear model: Sum of squares error surface'
xlabel 'a0'
ylabel 'a1'

figure
contour(v,v,SS,minSS + (0:.25:2))
hold on
plot(a0a1(1),a0a1(2),'rx')
plot([[-1;3],[1;1]],[[1;1],[-1;3]],'g-')
hold off
title 'Nonlinear model: Sum of squares error contours'
xlabel 'a0'
ylabel 'a1'
axis equal
axis square
grid on

% Note: This time, the sums of squares surface is not as
% neatly elliptical. 

%% 28. Confidence limits on a regression model
%{
There are various things that people think of when the phrase
"confidence limits" arises.

- We can ask for confidence limits on the regression parameters
themselves. This is useful to decide if a model term is statistically
significant, if not, we may choose to drop it from a model.

- We can ask for confidence limits on the model predictions (yhat)

These goals are related of course. They are obtained from the
parameter covariance matrix from the regression. (The reference to
look at here is again Draper and Smith.)

If our regression problem is to solve for x, such that A*x = y,
then we can compute the covariance matrix of the parameter vector
x by the simple

  V_x = inv(A'*A)*s2

where s2 is the error variance. Typically the error variance is
unknown, so we would use a measure of it from the residuals.

  s2 = sum((y-yhat).^2)/(n-p);

Here n is the number of data points, and p the number of parameters
to be estimated. This presumes little or no lack of fit in the model.
Of course, significant lack of fit would invalidate any confidence
limits of this form.

Often only the diagonal of the covariance matrix is used. This
provides simple variance estimates for each parameter, assuming
independence between the parameters. Large (in absolute value)
off-diagonal terms in the covariance matrix will indicate highly
correlated parameters.

In the event that only the diagonal of the covariance matrix is
required, we can compute it without an explicit inverse of A'*A,
and in way that is both computationally efficient and as well
conditioned as possible. Thus if one solves for the solution to
A*x=y using a qr factorization as 

  x = R\(Q*y)

then recognize that 

  inv(A'*A) = inv(R'*R) = inv(R)*inv(R') = inv(R)*inv(R)'

If we have already computed R, this will be more stable
numerically. If A is sparse, the savings will be more dramatic.
There is one more step to take however. Since we really want
only the diagonal of this matrix, we can get it as:

  diag(inv(A'*A)) = sum(inv(R).^2,2)
%}

%%

% Compare the two approaches on a random matrix.
A=rand(10,3);

diag(inv(A'*A))

[Q,R]=qr(A,0);
sum(inv(R).^2,2)

% Note that both gave the same result.

%%

% As a test, run 1000 regressions on random data, compare how
% many sets of 95% confidence intervals actually contained the
% true slope coefficient.

m = 1000;  % # of runs to verify confidence intervals
n = 100;   % # of data points
% ci will contain the upper and lower limits on the slope
% parameter in columns 1 and 2 respectively.
ci = zeros(m,2);
p = 2;
for i=1:m
  x = randn(n,1);
  y = 1+2*x + randn(n,1);

  % solve using \
  M = [ones(n,1),x];
  coef = M\y;
  
  % the residual vector
  res = M*coef - y;
  
  % yes, I'll even be lazy and use inv. M is well conditioned
  % so there is no fear of numerical problems, and there are
  % only 2 coefficients to estimate so there is no time issue.
  s2 = sum(res.^2)/(n-p);
  
  sigma = s2*diag(inv(M'*M))';
  
  % a quick excursion into the statistics toolbox to get
  % the critical value from tinv for 95% limits:
  % tinv(.975,100)
  % ans =
  %    1.9840
  ci(i,:) = coef(2) + 1.984*sqrt(sigma(2))*[-1 1];
end

% finally, how many of these slope confidence intervals
% actually contained the true value (2). In a simulation
% with 1000 events, we expect to see roughly 950 cases where
% the bounds contained 2.
sum((2>=ci(:,1)) & (2<=ci(:,2)))

% 950 may not have been too bad a prediction after all.

%%

% Given a complete covariance matrix estimate, we can also compute
% uncertainties around any linear combination of the parameters.
% Since a linear regression model is linear in the parameters,
% confidence limits on the predictions of the model at some point
% or set of points are easily enough obtained, since the prediction
% at any point is merely a linear combination of the parameters.

% An example of confidence limits around the curve on a linear
% regression is simple enough to do.
n = 10;
x = sort(rand(n,1))*2-1;
y = 1 + 2*x + 3*x.^2 + randn(n,1);

M = [ones(n,1),x,x.^2];
coef = M\y;

% Covariance matrix of the parameters
yhat = M*coef;
s2 = sum((y - yhat).^2)/(n-3);
sigma = s2*inv(M'*M)

% Predictions at a set of equally spaced points in [0,1].
x0 = linspace(-1,1,101)';
M0 = [ones(101,1),x0,x0.^2];
y0 = M0*coef;
V = diag(M0*sigma*M0');

% Use a (2-sided) t-statistic for the intervals at a 95% level
% tinv(.975,100)
% ans =
%    1.9840
tcrit = 1.9840;
close all
plot(x,y,'ro')
hold on
plot(x0,y0,'b-')
plot(x0,[y0-tcrit*V,y0+tcrit*V],'g-')
hold off

%% 

% Equality constraints are easily dealt with, since they can be
% removed from the problem (see section 25.) However, active
% inequality constraints are a problem! For a confidence limit,
% one cannot assume that an active inequality constraint was truly
% an equality constraint, since it is permissible to fall any tiny
% amount inside the constraint.
% 
% If you have this problem, you may wish to consider the jackknife
% or bootstrap procedures.

%% 29. Confidence limits on the parameters in a nonlinear regression
%{
A nonlinear regression is not too different from a linear one. Yes,
it is nonlinear. The (approximate) covariance matrix of the parameters 
is normally derived from a first order Taylor series. Thus, of J is
the (nxp) Jacobian matrix at the optimum, where n is the number of
data points, and p the number of parameters to estimate, the
covariance matrix is just

  S = s2*inv(J'*J)

where s2 is the error variance. See section 27 for a description
of how one may avoid some of the problem with inv and forming J'*J,
especially if you only wish to compute the diagonals of this matrix.

What you do not want to use here is the approximate Hessian matrix
returned by an optimizer. These matrices tend to be formed from
updates. As such, they are often only approximations to the true
Hessian at the optimum, at the very least lagging behind a few
iterations. Since they are also built from rank 1 updates to the
Hessian, they may lack the proper behavior in some dimensions.
(For example, a lucky starting value may allow an optimization
to converge in only one iteration. This would also update the
returned Hessian approximation in only 1 dimension, so probably a
terrible estimate of the true Hessian at that point.)

%}

%% 30. Quadprog example, unrounding a curve
%{
A nice, I'll even claim elegant, example of the use of quadprog
is the problem of unrounding a vector. Code for this in the form of
a function can be found on the file exchange as unround.m

http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=8719&objectType=FILE

Consider a vector composed of some smooth function evaluated
at consecutive (equally spaced) values of its independent variable.
Then the function values are rounded to the nearest integer. Can
we recover the original smooth function values? Clearly we cannot
do so exactly for an arbitrary function, but we can attempt to find
the smoothest set of function values that are consistent with the
given rounded set.

We will treat each element of the set as an unknown, so a vector
of length n will have n unknowns to solve for.
%}

%% 

% A simple function of x
n=101;
x = linspace(0,1,n);
v0 = (10*x.^2);
% rounded vector
vr = round(v0);
close
plot(x,v0,'r-',x,vr,'bo')
title 'Base functional form, with rounding'
xlabel 'x'
ylabel 'y'

%%

% bound constraints. since vr is composed of all integers, then
% the origin, unrounded values must lie within simple bounds
% from our rounded set.
LB = vr - 0.5;
UB = vr + 0.5;

% sparse system representing smoothness. Consider any row of S.
% When multiplied by the vector of unknowns, it computes a
% second order finite difference of the vector around some point.
% This, by itself cannot be used in quadprog, because S is not
% an appropriate quadratic form.
S = spdiags(repmat([1 -2 1],n-2,1),[0 1 2],n-2,n);

% H is positive semi-definite. Quadprog will be happy.
H = S'*S;
f = zeros(n,1);

% Solve the quadratic programming problem. Make sure we use the
% largescale solver. Note that we have carefully constructed
% H to be sparse. The largescale solver will allow simple bound
% constraints. As important as the constraints, when LargeScale
% is 'on', quadprog can handle quite large problems, numbering
% into many thousands of variables. Note that I have supplied H
% as a sparse matrix. It is tightly banded.
options = optimset('quadprog');
options.LargeScale = 'on';
options.Display = 'final';

vur = quadprog(H,f,[],[],[],[],LB,UB,[],options);

plot(x,v0,'r-',x,vr,'bo',x,vur,'k--')
legend('Base curve','Rounded data','Un-rounded curve','Location','NorthWest')
xlabel 'x'
ylabel 'y'

% Clearly the two curves overlay quite nicely, only at the ends
% do they deviate from each other significantly. That deviation
% is related to the behavior of a natural spline, despite the
% fact that we never explicitly defined a spline model. In effect,
% we minimized the approximate integral of the square of the second
% derivative of our function. It is this integral from which cubic
% splines are derived.

%% 31. R^2
%{
R^2 is a measure of the goodness of fit of a regression model. What
does it mean? We can write R^2 in terms of the vectors y (our data)
and yhat (our model predictions) as

  R^2 = 1 - ( norm(yhat-y) / norm(y-mean(y)) )^2

Intuitively, we might describe the term "norm(y-mean(y))" as the 
total information content of our data. Likewise, the term "norm(yhat-y)"
is the amount of signal that remains after removing the predictions
of our model. So when the model describes the data perfectly, this
ratio will be zero. Squared and subtracted from 1, a perfect fit will
yield an R^2 == 1.

At the other end of the spectrum, a fit that describes the data no
better than does the mean will yield a zero value for R^2. It also
suggests that a model with no mean term can produce a negative
value for R^2. The implication in the event of a negative R^2 is the
model is a poorer predictor of the data than would be a simple mean.

Finally, note that the formula above is not specific to a linear
regression model. R^2 may apply as well to a nonlinear regression
model.

When do we use R^2? In the words of Draper & Smith, R^2 is the first
thing they might look at when perusing the output of a regression
analysis. It is also clearly not the only thing they look at. My point
is that R^2 is only one measure of a model. There is no critical value
of R^2 such that a model is acceptable. The following pair of examples
may help to illustrate this point.

%}

%% 

% This curve fit will yield an R^2 of roughly 0.975 from my tests.
% Is it a poor model? It depends upon how much you need to fit the
% subtle curvature in that data.

n=25;
x = sort(rand(n,1));
y = exp(x/2)+randn(size(x))/30;
M = [ones(n,1),x];

coef = M\y;

yhat = M*coef;
Rsqr = 1 - (norm(yhat-y)/norm(y-mean(y))).^2
close
plot(x,y,'bo',x,yhat,'r-')
title 'R^2 is approximately 0.975'
xlabel x
ylabel y

% Was the linear model chosen adequate? It depends on your data and
% your needs. My personal opinion of the data in this example is
% that if I really needed to know the amount of curvature in this
% functional relationship, then I needed better data or much more
% data.

%%

% How about this data? It yields roughly the same value of R^2 as did
% the data with a linear model above.

n = 25;
x = linspace(0,1,n)';
y = x + ((x-.5).^2)*0.6;
M = [ones(n,1),x];

coef = M\y;

yhat = M*coef;
Rsqr = 1 - (norm(yhat-y)/norm(y-mean(y))).^2

plot(x,y,'bo',x,yhat,'r-')
title 'R^2 is approximately 0.975'
xlabel x
ylabel y

% Is there any doubt that there is lack of fit in this model? You
% may decide that a linear model is not adequate here. That is a
% decision that you must make based on your goals for a model.

%%

%{
To sum up, the intrepid modeler should look at various statistics
about their model, not just R^2. They should look at plots of the
model, plots of residuals in various forms. They should consider
if lack of fit is present. They should filter all of this information
based on their needs and goals for the final model and their knowledge
of the system being modeled.
%}

%% 32. Estimation of the parameters of an implicit function
%{
How can we estimate the parameters for implicit functions, one
simple example might be:

  y = a*(y - b*x)^2

The simplistic approach is to formulate this as a direct least
squares problem for lsqnonlin. 

  y - a*(y - b*x)^2 = 0

Choose values of a and b that drive this expresion towards zero
for each data point (x,y).

What could be wrong? The problem is the presumption is of additive
(normal) error on y. The value of y that is used inside the parens
is the "measured" value. Its the true value, plus any error and
lack of fit.

We will find that if we do try to use lsqnonlin in the way described,
we should expect poor results - possibly non-convergence, especially
is there are large residuals or your starting values are poor.

%}

%%

% Lets start by building ourselves an implicit function that we
% can deal with easily.
%
%   y = (y-2*x)^2

% build it from specified values of y
n = 20;
y = 0.5+5*rand(1,n);

% I chose this functional form since I could still find points
% on the curve itself easily.
x = (y - sqrt(y))/2;

% sort it on x for plotting purposes
[x,tags]=sort(x);
y=y(tags);

% Now, lets add some error into the mix. Not too large of
% an error.
err = randn(1,n)/10;

% Added to y
ye = y + err;

% plot the data
close
plot(x,y,'-',x,ye,'o')

%%

% We need to solve for the model now. In this case I'll
% presume the model to be
%
% y = a*(y - b*x)^2
%
% We wish to estimate a and b. Of course, the true values
% are [1, 2] for a and b respectively.

% First of all, can we just throw lsqnonlin at this implicit
% function as described above?

fun = @(ab) ye-ab(1)*(ye-ab(2)*x).^2;

options = optimset('lsqnonlin');
options.Display = 'iter';
abstart = [1.5 1.5];
lsqnonlin(fun,abstart,[],[],options)

% Recall that the true values of a and b were [1,2], so it
% did work, although not terribly well. Can we do better? 

%%

% Our data as we know it to be is (x,ye). A good test before
% we really start is to see if we can predict the error in y,
% given values of a and b. From my random data, here is the
% first point.

[x(1),y(1),err(1),ye(1)]

% First, lets see if we can solve for err(1), given the true
% values of a and b.
a = 1;
b = 2;
fun = @(e1) (ye(1)-e1 - a*((ye(1)-e1) - b*x(1)).^2)

estart = .1;
e = fzero(fun,estart)

%%

% This worked nicely. We were able to find the first additive
% error to y, given the true values of the parameters.
%
% Had we chosen different nominal values for a and b, e would have
% been different. I'll try it.
a = 1.5;
b = 1.5;
fun = @(e1) (ye(1)-e1 - a*((ye(1)-e1) - b*x(1)).^2)

estart = .1;
e = fzero(fun,estart)

%%

% We are now ready to put this all into the domain of lsqnonlin.
% I won't be able to do this with an anonymous function directly.
% I've supplied the function below:

% ========================================================
% function epred = implicit_obj(ab,x,ye)
% a = ab(1);
% b = ab(2);
% n = length(ye);
% epred = zeros(1,n);
% estart = .1;
% for i = 1:n
%   fun = @(ei) (ye(i)-ei - a*((ye(i)-ei) - b*x(i)).^2);
%   epred(i) = fzero(fun,estart);
% end
% ========================================================

% Having gone this far, I ALWAYS like to evaluate the objective function
% that lsqnonlin will see, especially when its something complicated.
% Does it make sense? Try it for a couple of parameter sets.

epred=implicit_obj([1.5 1.5],x,ye)

epred=implicit_obj([3 1],x,ye)

%%

% Time to call lsqnonlin now. I'll pass in the vectors x and ye
% via an anonymous call, although there are many ways to do it.

% As always, I use 'iter' for the Display parameter to lsqnonlin,
% at least the first time I call it.
options = optimset('lsqnonlin');
options.Display = 'iter';

ab_start = [1.5 1.5];
ab_est = lsqnonlin(@(ab) implicit_obj(ab,x,ye),ab_start,[],[],options)

% These parameter estimates are clearly much better than our
% earlier attempt was able to achieve.


%% 33. Robust fitting schemes
%{
Certainly a very good tool for robust fitting is robustfit from the
statistics toolbox. I'll try only to give an idea of how such a scheme
works. There are two simple approaches. 

- Iteratively re-weighted least squares
- Nonlinear residual transformations

The first of these, iteratively reweighted least squares, is quite
simple. We solve a series of weighted least squares problems, where
at each iteration we compute the weights from the residuals to our
previous fit. Data points with large residuals get a low weight.
This method presumes that points with large residuals are outliers,
so they are given little weight.

%}

%%

% Consider the simple problem 

n = 100; 
x = 2*rand(n,1) - 1; 
y0 = exp(x); 
 
% make some noise with a non-gaussian distribution 
noise = randn(n,1)/2; 
noise = sign(noise).*abs(noise).^4; 
 
y = y0 + noise; 

% We can wee tht the data is mostly very low noise, but there
% are some serious outliers.
close all
plot(x,y0,'ro',x,y,'b+') 

%%

% Fit this curve with a fourth order polynomial model, of the form
% 
%   y = a1+a2*x+a3*x^2+a4*x^3+a5*x^4 
% 
% using this fitting scheme. 
%
% As a baseline, use polyfit with no weights.
polyfit(x,y0,4) 

% Remember that the Taylor series for exp(x) would have had its
% first few terms as
[1/24 1/6 1/2 1 1]

% So polyfit did reasonably well in its estimate of the truncated
% Taylor series.

%%
 
% Note how poorly polyfit does on the noisy data. 
polyfit(x,y,4)

%%

% How would an iteratively reweighted scheme work?

% initial weights
weights = ones(n,1);

% We will use lscov to solve the weighted regressions
A = [x.^4,x.^3,x.^2,x,ones(size(x))];
% be lazy and just iterate a few times
for i = 1:5
  poly = lscov(A,y,weights)'
  
  % residuals at the current step
  resid = polyval(poly,x) - y;
  
  % find the maximum residual to scale the problem
  maxr = max(abs(resid));
  
  % compute the weights for the next iteration. I'll
  % just pick a shape that dies off to zero for larger
  % values. There are many shapes to choose from.
  weights = exp(-(3*resid/maxr).^2);
end

% This was much closer to our fit with no noise

%%

% An alternative is to transform the residuals so as to use a general
% nonlinear optimization scheme, such as fminsearch. I'll transform
% the residuals using a nonlinear transformation that will downweight
% the outliers, then form the sum of squares of the result.

% The transformation function
Wfun = @(R) erf(R);

% fminsearch objective
obj = @(c) sum(Wfun(y-polyval(c,x)).^2); 

% Again, this estimation was less sensitive to the very non-normal
% noise structure of our data than the simple linear least squares.
poly = fminsearch(obj,[1 1 1 1 1]) 


%% 34. Homotopies
%{
Homotopies are an alternative solution for solving hard nonlinear
problems. This book was a good reference as I recall, though it
appears to be out of print. 

Garcia and Zangwill, "Pathways to Solutions, Fixed Points and
Equilibria", Prentice Hall 

Think of a homotopy as a continuous transformation from a simple
problem that you know how to solve to a hard problem that you cannot
solve. For example, suppose we did not know how to solve for x, given
a value of y0 here: 

  y0 = exp(x) 

Yes, I'm sure that with only a few hours of work I can figure out how
to use logs. But lets pretend for the moment that this is really a
hard problem. I'll formulate the homotopy as 

  H(x,t) = (y0 - exp(x))*t + (y0 - (1+x))*(1-t) 

So when t = 0, the problem reduces to 

  H(x,0) = y0 - (1+x) 

This is a problem that we know the root of very well. I used a first 
order Taylor series approximation to the exponential function. So the
root for t=0 is simple to find. It occurs at 

  x = y0 - 1 

As we move from t=0 to t=1, the problem deforms continuously into 
the more nonlinear one of our goal. At each step, the starting value 
comes from our last step. If we take reasonably small steps, each 
successive problem is quickly solved, even if we did not know of a
good starting value for the hard problem initially. 

Lets try it out for our problem, in a rather brute force way. 
%}

%%

% Define the homotopy function
H = @(x,t,y0) (y0-exp(x))*t + (y0-(1+x))*(1-t);

y0 = 5; 
 
% We hope to converge to the solution at
% 
% log(5) == 1.6094379124341 

format long g
x_t_initial = 0; 
for t = 0:.1:1 
  x_t = fzero(@(x) H(x,t,y0),x_t_initial); 
  disp([t,x_t_initial,x_t])
  x_t_initial = x_t; 
end 
 
% The final step got us where we wanted to go. Note that each
% individual step was an easy problem to solve. In fact, the first
% step at t=0 had a purely linear objective function. 
log(5)

%%

% Look at how the homotopic family of functions deforms from our
% simple linear one to the more nonlinear one at the end.
close all
figure
for t = 0:.1:1
  fplot(@(x) H(x,t,y0),[0,4])
  hold on
end
grid on
hold off

%%

% This was admittedly a very crude example. You can even formulate
% a homotopy solution that generates the multiple solutions to problem. 
%
% Consider the problem
% 
%  sin(x) - x/5 = 0
%
% We wish to find all solutions to this problem. Formulate a homotopy
% function as 
% 
%  H(x,t) = (sin(x) - x/5) - (1-t)*(sin(x0)-x0/5)
%
% Where x0 is our starting point. Choose x0 = -6.
%
% Note that at (x,t) = (x0,0), that H is trivially zero. Also, at
% t = 1, H(x,t) is zero if x is a solution to our original problem.
%
% We could also have used a different homotopy.
%
%  H(x,t) = t*(sin(x) - x/5) - (1-t)*(x-x0)

x0 = -10;
H = @(x,t) (sin(x) - x/5) - (1-t).*(sin(x0)-x0/5);

% Generate a grid in (x,t)
[x,t] = meshgrid(-10:.1:10,0:.01:1);

% The solutions to sin(x) - x/5 will occur along a path (x(p),t(p))
% whenever t = 1. Solve for that path using a contour plot.
contour(x,t,H(x,t),[0 0])
grid on
xlabel 'x(p)'
ylabel 't(p)'

%%

% One can also formulate a differential equation to be solved
% for the homotopy path.
% 
% H = @(x,t) (sin(x) - x/5) - (1-t).*(sin(x0)-x0/5);

x0 = -10;

% The Jacobian matrix
dHdx = @(x,t) cos(x) - 1/5;
dHdt = @(x,t) sin(x0) - x0/5;

% Basic differential equations (see Garcia & Zangwill)
fun = @(p,xt) [dHdt(xt(1),xt(2));-dHdx(xt(1),xt(2))];

% Solve using an ode solver
solution = ode15s(fun,[0,6],[x0;0]);

% This curve is the same as that generated by the contour plot above.
% Note that we can find the roots of our original function by
% interpolating this curve to find where it crosses t==1.
plot(solution.y(1,:),solution.y(2,:))
hold on
plot([min(solution.y(1,:)),max(solution.y(1,:))],[1 1],'r-')
hold off
grid on

% These examples are just a start on how one can use homotopies to
% solve problems.

%% 35. Orthogonal polynomial regression
%{

Orthogonal polynomials are often used in mathematical modelling.
Can they be used for regression models? (Of course.) Are they of
value? (Of course.) This section will concentrate on one narrow
aspect of these polynomials - orthogonality.

Consider the first few Legendre orthogonal polynomials. We can
find a list of them in books like Abramowitz and Stegun, "Handbook
of Mathematical functions", Table 22.9.

P0(x) = 1
P1(x) = x
P2(x) = 3/2*x.^2 - 1/2
P3(x) = 5/2*x.^3 - 3/2*x
P4(x) = 4.375*x.^4 - 3.75*x.^2 + 3/8
P5(x) = 7.875*x.^5 - 8.75*x.^3 + 1.875*x
...

These polynomials have the property that over the interval [-1,1],
they are orthogonal. Thus, the integral over that interval of
the product of two such polynomials Pi and Pj will be zero
whenever i and j are not equal. Whenever i == j, the corresponding
integral will evaluate to 1.

However, the mere use of orthogonal polynomials on discrete data
will not generally result in orthogonality in the linear algebra.
For example ...

%}

% We can ortho-normalize the polynomials above by multiplying
% the i'th polynomial by sqrt((2*i+1)/2)

P0 = @(x) ones(size(x))*sqrt(1/2);
P1 = @(x) x*sqrt(3/2);
P2 = @(x) (3/2*x.^2 - 1/2)*sqrt(5/2);
P3 = @(x) (5/2*x.^3 - 3/2*x)*sqrt(7/2);
P4 = @(x) (3/8 - 3.75*x.^2 + 4.375*x.^4)*sqrt(9/2);
P5 = @(x) (1.875*x - 8.75*x.^3 + 7.875*x.^5)*sqrt(11/2);

% Thus if we integrate over the proper domain, this one should
% return zero (to within the tolerance set by quad):
quad(@(x) P1(x).*P4(x),-1,1)

%%

% But this integral should return unity:
quad(@(x) P3(x).*P3(x),-1,1)

%%

% Now, lets look at what will happen in a regression context.
% Consider an equally spaced vector of points
x0 = (-1:.001:1)';

% Do these polynomials behave as orthogonal functions when
% evaluated over a discrete set of points? NO.
A = [P0(x0),P1(x0),P2(x0),P3(x0),P4(x0),P5(x0)];

% Note that the matrix A'*A should be a multiple of an identity
% matrix if the polynomials are orthogonal on discrete data. Here we
% see that A'*A is close to an identity matrix.
A'*A

%%

% An interesting thing to try is this same operation on a carefully
% selected set of points (see Engels, "Numerical Quadrature and Cubature",
% Academic Press, 1980, Table 2.4.3, page 58.)
x = [0.16790618421480394; 0.52876178305787999;...
     0.60101865538023807; 0.91158930772843447];
x = [-x;0;x];

A = [P0(x),P1(x),P2(x),P3(x),P4(x),P5(x)];

% This time, A'*A has all (essentially) zero off-diagonal terms,
% reflecting the use of a set of quadrature nodes for the sample points.
A'*A

% The point to take from this excursion is that orthogonal polyomials
% are not always orthogonal when sampled at dscrete points.


%% 36. Potential topics to be added or expanded in the (near) future
%{
I've realized I may never finish writing this document. There
will always be segments I'd like to add, expound upon, clarify.
So periodically I will repost my current version of the doc,
with the expectation that I will add the pieces below as the
muse strikes me. My current planned additions are:

- Scaling problems - identifying and fixing them

- More discussion on singular matrix warnings

- Multi-criteria optimization

- Using output functions

- List of references

- Jackknife/Bootstrap examples for confidence intervals on a
regression

%}

close all



