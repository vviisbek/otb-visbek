module Otb
  
  class FindSequence

  	def initialize(parser)
      @jobs_hash = parser.parse_jobs()
    end

    # a recursive method that takes initial job and it's dependency as arguments
    def isCircular initial_job, dependency
      if dependency != "" # if the job does not have a dependency we return false
        dependency_of_dependency = @jobs_hash[dependency] # saving a dependency of a current dependency
        if initial_job == dependency_of_dependency # comparing initial input job to a dependency of the dependency
          return true # if they are equal, then there is a circular dependency
        elsif dependency_of_dependency != ""
          # if they are not equal and dependency of the dependency is not an empty string, we continue checking dependencies deeper
      	  isCircular initial_job, dependency_of_dependency
        else
          # return false when dependency of the dependency is last and it is not circular
      	  return false
        end
      else 
      	return false
      end
   	end

  	def order_jobs
  	  result = "" # final sequence will be added here
  	  if @jobs_hash.length > 0 # return empty string if there are jobs in the hash
  	    @jobs_hash.each do |job, dependency| # entering a loop where we take a pair each step
  	  	  raise "Error: jobs can’t depend on themselves" if job == dependency # check if job and dependency are the same
  	  	  raise "Error: jobs have circular dependencies" if isCircular job, dependency # check if circular
          if dependency == "" && @jobs_hash.key(job) == nil 
          	# if job does not have a dependency and it is not a dependency itselg, add to the result
            result.concat(job)
          elsif dependency != "" && @jobs_hash.key(job) == nil
          	# when we find a last job in the sequence (the one that should be done after all others)
          	dependent_job_list = ""
          	while true do # find all jobs, add them to the list, reverse and add to the result
          	  dependent_job_list.concat(job)
          	  if (@jobs_hash[dependency] == "") # finishes when finds a job without dependency
          	  	dependent_job_list.concat(dependency)
          	  	result.concat(dependent_job_list.reverse!) # reversing found sequence as it is in a reversed order
          	  	break
          	  else
          	  	job = dependency
          	  	dependency = @jobs_hash[dependency]
          	  end
          	end
          end
  	    end
  	  end
  	  result
  	end

  end
end
