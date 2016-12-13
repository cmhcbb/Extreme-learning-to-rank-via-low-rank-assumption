function Ulinesearch(U,V,gradf,loss,A,C,m)
	eta=1e-14
	initout=0.5*vecnorm(U)+C*loss*loss
	tempout=initout
	while initout<=tempout
		eta=eta/2
		println(eta)
		newu=U-eta*gradf
		newloss=0
		for i=1:m
			ux=U'*X*A[i]
			newloss+=sum(max(0,1-V[:,i]'*ux))
		end
		tempout=0.5*vecnorm(newu)+C*newloss*newloss
		if (eta<1e-16)
			return 1e-16
		end
	end
	return eta
end
