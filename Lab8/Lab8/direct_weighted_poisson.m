function [u,A,B,weights] = direct_weighted_poisson(p,q,mask,weights,trace,algorithm)
%	Weighted least square resolution of \nabla u = [p,q], where the 
% reconstruction domain must only be connex (not rectangular, as usually 
% assumed), and where the weights can be calculated from the data and 
% not from the unknown. 
%	Axis : 0 -- y
%	       |
%	       x
%
%	u = direct_weighted_poisson(p,q) performs the integration on the 
% whole domain, with uniform weights. p and q should be two matrices 
% with same size, u will thus be a matrix with same size. Note that, 
% apart from numerical approximations, this should result in the same 
% function u as [Simchony, Chellappa and Shao, PAMI'90] or [Harker and 
% O'Leary, CVPR'08], which also implement the 'Natural Boundary 
% Condition'.
%
%	u = direct_weighted_poisson(p,q,mask) performs the integration on 
% the domain defined by mask : mask(i,j)=1 if (i,j) is to be 
% reconstructed, 0 elsewhere. Default is mask = ones(size(p));
%	u = direct_weighted_poisson(p,q,mask,weights) where weights 
% is a matrix with same size as p and q, performs integration 
% by weighting the contribution of pixel (i,j) by weight(i,j). Default 
% is weights = ones(size(p));
%	u = direct_weighted_poisson(p,q,mask,a) uses the weights defined 
% by weights = exp(-(a*integrability)), where integrability = |p_y-q_x|
%	u = integration(p,q,mask,weights,trace) prints a trace during 
% the execution
%	u = integration(p,q,mask,weights,trace,algorithm) defines the strategy 
% for solving the linear system. algorithm can be 'LU' or 'Cholesky'. 
% Default is 'Cholesky'.
%
%	
%	Author : Yvain Queau - University of Toulouse - IRIT, UMR CNRS 5505
%	yvain.queau@enseeiht.fr
%
%	Reference : 
%	Integration d'un champ de gradient rapide et robuste aux 
% discontinuites - Application a la stereophotometrie.
%	Yvain Queau and Jean-Denis Durou
%	Reconnaissace de Formes et Intelligence Artificielle, Rouen, 2014
%	
	if(nargin<2)
		disp('estimated gradient (p,q) must be provided')
		return;
	end
	if((size(p,1)~=size(q,1))|(size(p,2)~=size(q,2)))
		disp('p and q should be the same size')
		return;
	end
	if (~exist('mask','var')|isempty(mask)) mask=ones(size(p,1),size(p,2)); end;
	if (~exist('trace','var')|isempty(trace)) trace=0; end;
	if((size(p,1)~=size(mask,1))|(size(p,2)~=size(mask,2)))
		disp('mask should be the same size as')
		return;
	end
	if (~exist('weights','var')|isempty(weights)) weights=ones(size(p,1),size(p,2)); end;
	if (~exist('algorithm','var')|isempty(algorithm)) algorithm='Cholesky'; end;
	if ((size(weights,1)==1) & (size(weights,2)==1))
		[py,px] = gradient(p);
		[qy,qx] = gradient(q);
		integrability = abs(py-qx);
		weights = max(0.01,1./(1+weights*integrability));
		
		clear py px qy qx integrability
	end
	if((size(p,1)~=size(weights,1))|(size(p,2)~=size(weights,2)))
		disp('weights should be the same size as p and q')
		return;
	end
	
	% Store CPU time
	if(trace)
		t0 = tic;
	end
	
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Calculate some usefuk masks : 								   %
	% Omega(:,:,1) == pixels in mask with down neighbor is in mask	   %
	% Omega(:,:,2) == pixels in mask with up neighbor is in mask 	   %
	% Omega(:,:,3) == pixels in mask with right neighbor is in mask	   %
	% Omega(:,:,4) == pixels in mask with left neighbor is in mask	   %
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	if(trace)		
		disp('Computing masks ...')
	end			
	Omega = zeros(size(mask,1),size(mask,2),4);
	Omega_padded = padarray(mask,[1 1],0);
	Omega(:,:,1) = Omega_padded(3:end,2:end-1).*mask;	% In mask, neigbor "under" in mask 
	Omega(:,:,2) = Omega_padded(1:end-2,2:end-1).*mask; % In mask, neigbor "over" in mask 
	Omega(:,:,3) = Omega_padded(2:end-1,3:end).*mask;	% In mask, neigbor "right" in mask 
	Omega(:,:,4) = Omega_padded(2:end-1,1:end-2).*mask; % In mask, neigbor "left" in mask 

	clear Omega_padded
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Calculate A and B such that the problem amounts to solve Au =B   %
	% A is the modified (weighted) Laplacian (5 points stencil) 	   %
	% B is the modified (weighted) Divergence of [p,q]				   %
	% Note that size(A,1)=size(A,2)=length(B)=length(find(mask>0))	   %
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	if(trace)
		disp('Computing system ...')
	end		
	indices_mask = find(mask>0);
	mapping_matrix = zeros(size(p));
	mapping_matrix(indices_mask)=1:length(indices_mask); 	% mapping_matrix(i,j) indicates the corresponding index of pixel (i,j) in the VECTOR u = u(find(mask>0))
	% Compute the system Ax = B, with size(A,1)=size(A,2)=length(B)=length(find(mask>0))
	[A,B] = calculate_system(p,q,mask,Omega,weights,mapping_matrix);
	clear Omega
	
	if(strcmp(algorithm,'LU'))
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Solution via sparse LU factorization							   %
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		if(trace)
			t1 = toc(t0);					
			disp(sprintf('time for constructing system : %04f\n',t1));
			disp('');
			disp('Solving system...');
			spparms('spumoni',0);
			t2 = tic;		
			clear t0 t1
		else
			spparms('spumoni',0)
		end
		
		u = zeros(size(mask));	
		[L_LU,U_LU,P_LU,Q_LU] = lu(A);
		u(indices_mask)=Q_LU*(U_LU\(L_LU\(P_LU*B)));
		if(trace)
			t3 = toc(t2);				
			disp(sprintf('time for solving system : %04f\n',t3));		
			clear t2 t3
		end
	elseif(strcmp(algorithm,'Cholesky'))	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Solution via Cholesky							   				   %
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		% A is rank-1 deficient (integration only up to additive constant) %
		% At least one control point must thus be specified, then one must %
		% "delete" each column corresponding to a control point and put it %
		% in B                                                             %
		% Finally the value for this points (i,j) is set to arbitrary to 0 %
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		if(trace)
			disp('Adding one control point ...')
		end	
		indice_control = indices_mask(1);
		value_control = 0;
		B = B-sum(value_control.*A(:,mapping_matrix(indice_control)),2);
		A = A(:,~ismember(1:size(A, 2), mapping_matrix(indice_control)));
		mask_integration = mask;
		mask_integration(indice_control)=0;
		clear indice_control
	
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
		% System is overconstrained ==> Solve the normal equation instead  %
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
		if(trace)
			disp('Defining normal equations ...')
		end	
		% Solve AtA x = AtB by Cholesky
		u = value_control*ones(size(p));	% Initialization for defining size	
		AtB=A'*B;
		AtA=A'*A;
		
		clear mapping_matrix value_control

		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
		% Solve system (with backslash). Since AtA is very sparse and 	   %
		% symmetric, CHOLMOD is used by default in Matlab, which should    %
		% be the fastest way to proceed
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
		if(trace)
			t1 = toc(t0);					
			disp(sprintf('time for constructing system : %04f\n',t1));
			disp(sprintf('',t1));
			disp('Solving system...');
			spparms('spumoni',0);
			t2 = tic;		
			clear t0 t1
		else
			spparms('spumoni',0)
		end
		u(find(mask_integration>0))=AtA\AtB;
		clear mask_integration
		if(trace)
			t3 = toc(t2);				
			disp(sprintf('time for solving system : %04f\n',t3));		
			clear t2 t3
		end
					
		clear AtA AtB 
	else
		disp('unknown algorithm : should be LU or Cholesky')
	end
	
	u = u-mean(u(indices_mask));
	
	%%% That's all folks ! %%%
end


function [A,B] = calculate_system(p,q,mask,Omega,weights,mapping_matrix)

	% Calculate \nabla(log(weights))
	log_ca=log(weights);	
	[Cy,Cx]=gradient(log_ca);
	
	% Calcul de div([p,q])
	[py,px]=gradient(p);
	[qy,qx]=gradient(q);

	I=[];
	J=[];
	K=[];
	B=zeros(length(find(mask==1)),1);

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Points inside \Omega : modified Poisson equation
	% Delta(u) = div(p,q)- (nabla (log(weights))) . (nabla u - [p,q])
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	[X,Y]=find(sum(Omega,3)==4);
	
	indices_centre=sub2ind(size(mask),X,Y);
	I_centre = mapping_matrix(indices_centre);
	w_centre = -4*ones(length(indices_centre),1);
	
	indices_bas=sub2ind(size(mask),X+1,Y);	
	I_bas = mapping_matrix(indices_bas);
	w_bas = 1+0.5*Cx(indices_centre);
	
	indices_haut=sub2ind(size(mask),X-1,Y);	
	I_haut = mapping_matrix(indices_haut);
	w_haut = 1-0.5*Cx(indices_centre);
	
	indices_droite=sub2ind(size(mask),X,Y+1);
	I_droite = mapping_matrix(indices_droite);
	w_droite = 1+0.5*Cy(indices_centre);
	
	indices_gauche=sub2ind(size(mask),X,Y-1);
	I_gauche = mapping_matrix(indices_gauche);
	w_gauche = 1-0.5*Cy(indices_centre);
	
	I=[I;I_centre;I_centre;I_centre;I_centre;I_centre]; % Which lines are we talking about ? 
	J=[J;I_centre;I_bas;I_haut;I_droite;I_gauche]; % Which columns ?
	K=[K;w_centre(:);w_bas(:);w_haut(:);w_droite(:);w_gauche(:)];
	
	B(I_centre)=px(indices_centre)+qy(indices_centre)+Cx(indices_centre).*p(indices_centre)+Cy(indices_centre).*q(indices_centre);
	
	clear log_ca Cx Cy px py qx qy
		
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Points in boundary : natural boundary condition
	% (\nabla u - [p,q]) \cdotp mu = 0, where mu is the outer normal
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	mu_x = zeros(size(p));
	mu_y = zeros(size(p));
	
	mu_x(find(Omega(:,:,1)>0)) = -1;
	indices_Omega2 = find(Omega(:,:,2)>0);
	mu_x(indices_Omega2) = mu_x(indices_Omega2)+1;
	mu_y(find(Omega(:,:,3)>0)) = -1;
	indices_Omega4 = find(Omega(:,:,4)>0);
	mu_y(indices_Omega4) = mu_y(indices_Omega4)+1;
	
	clear indices_Omega2 indices_Omega4
	
	[X,Y] = find(mu_x<0);	
		indices_centre=sub2ind(size(mask),X,Y);
		I_centre = mapping_matrix(indices_centre);
		w_centre = ones(length(indices_centre),1);
		I = [I;I_centre];
		J = [J;I_centre];
		K = [K;w_centre];		
		indices_bas=sub2ind(size(mask),X+1,Y);	
		I_bas = mapping_matrix(indices_bas);
		w_bas =  -ones(length(indices_centre),1);
		I = [I;I_centre];
		J = [J;I_bas];
		K = [K;w_bas];
		B(I_centre)=B(I_centre)-p(indices_centre);
	[X,Y] = find(mu_x>0);
		indices_centre=sub2ind(size(mask),X,Y);
		I_centre = mapping_matrix(indices_centre);
		w_centre = ones(length(indices_centre),1);
		I = [I;I_centre];
		J = [J;I_centre];
		K = [K;w_centre];
		indices_haut=sub2ind(size(mask),X-1,Y);	
		I_haut = mapping_matrix(indices_haut);
		w_haut = -ones(length(indices_centre),1);
		I = [I;I_centre];
		J = [J;I_haut];
		K = [K;w_haut];
		B(I_centre)=B(I_centre)+p(indices_centre);
	[X,Y] = find(mu_y<0);
		indices_centre=sub2ind(size(mask),X,Y);
		I_centre = mapping_matrix(indices_centre);
		w_centre = ones(length(indices_centre),1);;
		I = [I;I_centre];
		J = [J;I_centre];
		K = [K;w_centre];
		indices_droite=sub2ind(size(mask),X,Y+1);
		I_droite = mapping_matrix(indices_droite);
		w_droite = -ones(length(indices_centre),1);
		I = [I;I_centre];
		J = [J;I_droite];
		K = [K;w_droite];
		B(I_centre)=B(I_centre)-q(indices_centre);
	[X,Y] = find(mu_y>0);
		indices_centre=sub2ind(size(mask),X,Y);
		I_centre = mapping_matrix(indices_centre);
		w_centre = ones(length(indices_centre),1);
		I = [I;I_centre];
		J = [J;I_centre];
		K = [K;w_centre];		
		indices_gauche=sub2ind(size(mask),X,Y-1);
		I_gauche = mapping_matrix(indices_gauche);
		w_gauche = -ones(length(indices_centre),1);
		I = [I;I_centre];
		J = [J;I_gauche];
		K = [K;w_gauche];
		B(I_centre)=B(I_centre)+q(indices_centre);	
	% Construction de A : 
	A = sparse(I,J,K);	


	clear I_bas I_centre I_gauche I_droite I_haut I J K X Y 
	clear indices_bas indices_haut indices_centre indices_droite indices_gauche
	clear mu_x mu_y w_haut w_bas w_gauche w_droite w_centre w_haut
	
	
end

