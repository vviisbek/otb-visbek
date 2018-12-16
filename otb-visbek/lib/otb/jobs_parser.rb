
module Otb
  class Parser
  
    def initialize(input)
      @jobs = input
    end
  
    # a method that uses regular expression to find a pattern in the input string and converts it into a hash
    # the pattern is: any char from a to z, whitespace, an arrow, whitespace, and again a char from a to z
    # if the job does not have a dependency an empty string is put as it's value
    def parse_jobs
      @jobs.scan(/([a-z]) => ([a-z]|)/).inject({}) do |jobs_hash, pair|
        jobs_hash[pair.first] = pair.last.empty? ? '' : pair.last
        jobs_hash
      end
    end
  
  end
end