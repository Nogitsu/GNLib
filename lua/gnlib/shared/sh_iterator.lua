
function GNLib.IterateChars( txt )
	local i = 0
	return function()
		if i >= #txt then return end

		i = i + 1
		return txt:sub( i, i )
	end
end

function GNLib.IterateWords( txt )
	local words = {}
  	do 
    	local word = ""
    	for c in GNLib.IterateChars( txt ) do
      		if c == " " then
        		words[#words + 1] = word
        		word = ""
      		else
        		word = word .. c    
      		end
    	end
    	if #word > 0 then words[#words + 1] = word end
  	end

  	local i = 0
  	return function()
    	if i >= #words then return end

    	i = i + 1
    	return words[i]
  	end
end
