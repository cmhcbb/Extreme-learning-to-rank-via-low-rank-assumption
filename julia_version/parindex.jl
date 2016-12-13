function parindex(train)
	n=size(train,1)
	tmp=train[1,1]
	parindex=Int.([])
	append!(parindex,0)
	for i=1:n
		if tmp!=train[i,1]
			append!(parindex,i-1)
			tmp=train[i,1]
		end
	end
	append!(parindex,n)
	#parindex_int = Int.(parindex)
	return parindex
end
	
