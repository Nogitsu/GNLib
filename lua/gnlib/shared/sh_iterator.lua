
--- @title:
--- 	GNLib.IterateChars: <function> Iterate throug characters of a string
--- @note:
--- 	You should use it in a for-loop
--- @params:
--- 	txt: <string> Text to iterate
--- @return:
--- 	closure: <function> Function used to iterate
--- @example:
--- 	#prompt: Iterate each character through "GNLib <3"
--- 	#code: for c in GNLib.IterateChars( "GNLib <3" ) do\n\tprint( c )\nend
--- 	#output: https://cdn.discordapp.com/attachments/638822462431166495/670653540485693442/unknown.png
function GNLib.IterateChars( txt )
	return txt:gmatch( "." )
end

--- @title:
--- 	GNLib.IterateWords: <function> Iterate throug words of a string
--- @note:
--- 	You should use it in a for-loop
--- @params:
--- 	txt: <string> Text to iterate
--- @return:
--- 	closure: <function> Function used to iterate
--- @example:
--- 	#prompt: Iterate each word through "GNLib <3"
--- 	#code: for w in GNLib.IterateWords( "GNLib <3" ) do\n\tprint( w )\nend
--- 	#output: https://cdn.discordapp.com/attachments/638822462431166495/670654107702394910/unknown.png
function GNLib.IterateWords( txt )
	return txt:gmatch( "[^% ]+" ) 
end

--- @title:
--- 	GNLib.IterateLines: <function> Iterate throug lines of a string
--- @note:
--- 	You should use it in a for-loop
--- @params:
--- 	txt: <string> Text to iterate
--- @return:
--- 	closure: <function> Function used to iterate
--- @example:
--- 	#prompt: Iterate each line through "GNLib <3"
--- 	#code: for l in GNLib.IterateLines( "GNLib <3\\nBetter than Anything\\n:kappa:" ) do\n\tprint( l )\nend
--- 	#output: https://cdn.discordapp.com/attachments/638822462431166495/670654870382182440/unknown.png
function GNLib.IterateLines( txt )
	return txt:gmatch( "[^\n]+" )
end

