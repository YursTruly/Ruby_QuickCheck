

module RQC

	class QC
		extend RDL
		
		spec :qc do
			dsl do
				spec :constrain do |x|
					#Set generation constraints
				end
				
				spec :check do |y|
					#Set post conditions to check
				end
				
				post_cond do
					#Push all data to qc and check stuff
				end
				
			end
		end
	end
end