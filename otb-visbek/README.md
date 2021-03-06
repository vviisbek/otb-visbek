

First I started with the method that was hinted in the first hint of the task - implementing a method parse_jobs that accepts a single string argument and converts it into a hash where keys are the jobs and values their dependencies.

As this method also needed to be tested it was written in a separate class. Before implementing the method I also created a spec file where wrote the cases to evaluate some inputs for the parse_jobs (no jobs, jobs with or without dependencies etc).

When parse_jobs method was tested and working well I continued with the main method order_jobs that would find a jobs sequence based on the hash that was parsed from the input string. Again, I started from the spec file for Otb::FindSequence. I based all the examples on the examples given in the task explanation.

The idea for finding the result sequence was to check all pairs in the hash one by one. First I decided to check for two errors in the hash as these should be tested first anyway. 

First excpetion would be raised if the job and it's dependency are the same which means that the job depends on itself. For this I just compared them.

Second exception would be raised if the job structure has circular dependencies. To check this I implemented a separate method isCircular in the same class that accepts a job and a depency as arguments and returns True if the job structure is circular and False if not. It goes recursively dependency by dependency while keeping the initial job and checks each time to find a match. For example if we have a job structure (a => b, b => c, c => a) it will compare a to b, then a to c, and at then a to a which will return True as the structure is circular and raise the exception. If the dependency is an empty string it will stop and return False.

If the exceptions are not raised the method order_jobs continues. It follows three possible paths from here. 
	1. When job does not have a dependency job and is not a dependency for any other job itself, then add it to the result string that will be an output later
	2. When the job is a dependency job for any other job, do nothing and continue to next pair
	3. When we find a pair where the job itself is not a dependency for any other job and it has a dependency, then it is a last job in the possible sequence of jobs. So it goes into a While loop and follows all jobs dependency by dependency and saves the sequence. Then when it finishes (last job does not have a dependency) it reverses the sequence and adds it to the result.
