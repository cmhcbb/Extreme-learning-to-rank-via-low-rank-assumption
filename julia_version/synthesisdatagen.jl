function syngentrain(m=100,mo=100,pir=15,d=64,k=5)
	# m=100 # number of users
	# C=1  # constant control the loss function
	# mo=100 # number of movies
	# pir=15 # number of pairs
	X=randn(d,mo) # d=64 movies=100
	# k=5  # rank=5
	d=size(X,1)
	u=randn(d,k)
	v=randn(k,m)     #get the real value of u,v
	realpara=u*v
	train=zeros(1,3)
	for i=1:m
    		realw=realpara[:,i]
    		rating=X'*realw
    		samplemovies=rand(1:mo,pir,1)
    		usercol=ones(Int64,pir,1)*i;  # each user has 15 ratings
    		samplecol=samplemovies
    		ratecol=rating[samplemovies]
    		temp=[usercol samplecol ratecol]
    		train=[train;temp]
	end
	train=train[2:end,:]
	return train,X
end
