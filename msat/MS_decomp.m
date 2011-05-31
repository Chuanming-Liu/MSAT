function [ varargout ] = MS_decomp( C )
%
%  Apply a decomposition of the elasticity tensor C, after: 
%     Browaeys and Chevrot (GJI, v159, 667-678, 2004)
%
%  Assumes that C is in its optimal orientation for decomposition
%
%  [Ciso] = CIJ_brow_chev_decomp(C)
%     Isotropic projection of the elastic tensor.
%
%  [Ciso,Chex] = CIJ_brow_chev_decomp(C)
%     Isotropic, and hexagonal parts of the elastic tensor
%
%  [Ciso,Chex,Ctet,Cort,Cmon,Ctri] = CIJ_brow_chev_decomp(C)
%     All parts of the elastic tensor
%   
   i=nargout ;
   
   if (nargout==6), i=5;, end
   
   for i=1:5
	   [X]=C2X(C) ;
	   M=Projector(i) ;
	   XH = M*X ;
	   CH = X2C(XH) ;
	   varargout{i} = CH ;
      C=C-CH ;
   end

   if (nargout==6), varargout{6} = CH;, end
   

return

function M=Projector(order)
switch order 
case 1 % isotropic
   M = zeros(21,21) ;
   M(1:9,1:9) = [ ...
      3/15 3/15 3/15 sqrt(2)/15 sqrt(2)/15 sqrt(2)/15 2/15 2/15 2/15 ; ... 
      3/15 3/15 3/15 sqrt(2)/15 sqrt(2)/15 sqrt(2)/15 2/15 2/15 2/15 ; ... 
      3/15 3/15 3/15 sqrt(2)/15 sqrt(2)/15 sqrt(2)/15 2/15 2/15 2/15 ; ... 
      sqrt(2)/15 sqrt(2)/15 sqrt(2)/15 4/15 4/15 4/15 -sqrt(2)/15 -sqrt(2)/15 -sqrt(2)/15 ; ... 
      sqrt(2)/15 sqrt(2)/15 sqrt(2)/15 4/15 4/15 4/15 -sqrt(2)/15 -sqrt(2)/15 -sqrt(2)/15 ; ... 
      sqrt(2)/15 sqrt(2)/15 sqrt(2)/15 4/15 4/15 4/15 -sqrt(2)/15 -sqrt(2)/15 -sqrt(2)/15 ; ... 
      2/15 2/15 2/15 -sqrt(2)/15 -sqrt(2)/15 -sqrt(2)/15 1/5 1/5 1/5 ; ... 
      2/15 2/15 2/15 -sqrt(2)/15 -sqrt(2)/15 -sqrt(2)/15 1/5 1/5 1/5 ; ... 
      2/15 2/15 2/15 -sqrt(2)/15 -sqrt(2)/15 -sqrt(2)/15 1/5 1/5 1/5 ; ... 
   ] ;
case 2 % hexagonal
   M = zeros(21,21) ;
   M(1:9,1:9) = [...
      3/8 3/8 0 0 0 1./(4.*sqrt(2)) 0 0 1/4                            ; ...
      3/8 3/8 0 0 0 1./(4.*sqrt(2)) 0 0 1/4                            ; ...
      0 0 1 0 0 0 0 0 0                                                ; ...
      0 0 0 1/2 1/2 0 0 0 0                                            ; ...
      0 0 0 1/2 1/2 0 0 0 0                                            ; ...
      1./(4.*sqrt(2)) 1./(4.*sqrt(2)) 0 0 0 3/4 0 0 -1./(2.*sqrt(2))   ; ...
      0 0 0 0 0 0 1/2 1/2 0                                            ; ...
      0 0 0 0 0 0 1/2 1/2 0                                            ; ...
      1/4 1/4 0 0 0 -1./(2.*sqrt(2)) 0 0 1/2                           ; ...
   ] ;
case 3 % tetragonal
   M = zeros(21,21) ;
   M(1:9,1:9) = [...
      1/2 1/2 0 0 0 0 0 0 0  ; ...
      1/2 1/2 0 0 0 0 0 0 0  ; ...
      0 0 1 0 0 0 0 0 0      ; ...
      0 0 0 1/2 1/2 0 0 0 0  ; ...
      0 0 0 1/2 1/2 0 0 0 0  ; ...
      0 0 0 0 0 1 0 0 0      ; ...
      0 0 0 0 0 0 1/2 1/2 0  ; ...
      0 0 0 0 0 0 1/2 1/2 0  ; ...
      0 0 0 0 0 0 0 0 1      ; ...
   ] ;
case 4 % orthorhombic
   M = zeros(21,21) ;
   for jj=1:9
      M(jj,jj)=1;
   end
case 5 % monoclinic
   M = eye(21,21) ;
   for jj=[10, 11, 13, 14, 16, 17, 19, 20]
      M(jj,jj)=0;
   end
otherwise
   error('Unsupported symmetry class')
end
return


function [X]=C2X(C)
%  after Browaeys and Chevrot (GJI, 2004)
	X = zeros(21,1) ;
	
	X(1)  = C(1,1) ;
	X(2)  = C(2,2) ;
	X(3)  = C(3,3) ;
	X(4)  = sqrt(2).*C(2,3) ;
	X(5)  = sqrt(2).*C(1,3) ;
	X(6)  = sqrt(2).*C(1,2) ;
	X(7)  = 2.*C(4,4) ;
	X(8)  = 2.*C(5,5) ;
	X(9)  = 2.*C(6,6) ;
	X(10) = 2.*C(1,4) ;
	X(11) = 2.*C(2,5) ;
	X(12) = 2.*C(3,6) ;
	X(13) = 2.*C(3,4) ;
	X(14) = 2.*C(1,5) ;
	X(15) = 2.*C(2,6) ;
	X(16) = 2.*C(2,4) ;
	X(17) = 2.*C(3,5) ;
	X(18) = 2.*C(1,6) ;
	X(19) = 2.*sqrt(2).*C(5,6) ;
	X(20) = 2.*sqrt(2).*C(4,6) ;
	X(21) = 2.*sqrt(2).*C(4,5) ;
	
return

function [C]=X2C(X)
%  after Browaeys and Chevrot (GJI, 2004)
	C = zeros(6,6) ;
	
	C(1,1) = X(1);
	C(2,2) = X(2);
	C(3,3) = X(3);
	C(2,3) = 1./(sqrt(2)).*X(4);
	C(1,3) = 1./(sqrt(2)).*X(5);
	C(1,2) = 1./(sqrt(2)).*X(6);
	C(4,4) = 1./(2).*X(7);
	C(5,5) = 1./(2).*X(8);
	C(6,6) = 1./(2).*X(9);
	C(1,4) = 1./(2).*X(10);
	C(2,5) = 1./(2).*X(11);
	C(3,6) = 1./(2).*X(12);
	C(3,4) = 1./(2).*X(13);
	C(1,5) = 1./(2).*X(14);
	C(2,6) = 1./(2).*X(15);
	C(2,4) = 1./(2).*X(16);
	C(3,5) = 1./(2).*X(17);
	C(1,6) = 1./(2).*X(18);
	C(5,6) = 1./(2.*sqrt(2)).*X(19);
	C(4,6) = 1./(2.*sqrt(2)).*X(20);
	C(4,5) = 1./(2.*sqrt(2)).*X(21);
	
	for i=1:6
		for j=i:6
			C(j,i) = C(i,j) ;
		end
	end		
	
return
