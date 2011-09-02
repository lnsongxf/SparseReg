function [maxlambda] = lsq_maxlambda(a,b,pentype,penparam)
%LSQ_MAXLAMBDA Find the max lambda such that
%       argmin 0.5*a*x^2 + b*x + pen(abs(x),lambda)
%   is nonzero
%
% INPUT
%   a: n-by-1 quadratic coefficient
%   b: n-by-1 linear coefficient
%   penname - 'enet'|'log'|'mcp'|'power'|'scad'
%   penargs - index parameter for penalty function penname; allowed range
%       enet [1,2] (1 by default), log (0,inf) (1 by default), mcp (0,inf) 
%       (1 by default), power (0,2] (1 by default), scad (2,inf) (3.7 by default)
%
% OUTPUT
%   maxlambda: max lambda such that argmin 0.5*a*x^2+b*x+pen(abs(x),lambda)
%       becomes nonzero
%
% COPYRIGHT: North Carolina State University
% AUTHOR: Hua Zhou (hua_zhou@ncsu.edu), Artin Armagan
% RELEASE DATE: ??/??/????

% check proper input arguments
[n,m] = size(a);
if (size(b,1)~=n || size(b,2)~=m)
    error('a and b have incompatible sizes');
end

pentype = upper(pentype);
if (strcmp(pentype,'ENET'))
    if (isempty(penparam))
        penparam = 1;   % lasso by default
    elseif (penparam<1 || penparam>2)
        error('index parameter for ENET penalty should be in [1,2]');
    end
elseif (strcmp(pentype,'LOG'))
    if (isempty(penparam))
        penparam = 1;
    elseif (penparam<0)
        error('index parameter for LOG penalty should be nonnegative');
    end
elseif (strcmp(pentype,'MCP'))
    if (isempty(penparam))
        penparam = 1;   % lasso by default
    elseif (penparam<=0)
        error('index parameter for MCP penalty should be positive');
    end
elseif (strcmp(pentype,'POWER'))
    if (isempty(penparam))
        penparam = 1;   % lasso by default
    elseif (penparam<=0 || penparam>2)
        error('index parameter for POWER penalty should be in (0,2]');
    end
elseif (strcmp(pentype,'SCAD'))
    if (isempty(penparam))
        penparam = 3.7;
    elseif (penparam<=2)
        error('index parameter for SCAD penalty should be larger than 2');
    end
else
    error('penalty type not recogonized. ENET|LOG|MCP|POWER|SCAD accepted');
end

% call the mex function
maxlambda = lsqmaxlambda(a,b,pentype,penparam);

end