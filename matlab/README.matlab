To run a Matlab job on the Math execute nodes, compile the .m file and set up the environment
on the execute node.

   To compile helloWorld.m:
      /usr/local/matlab/bin/mcc -m -R -singleCompThread -R -nodisplay -R -nojvm ./helloWorld.m

Compare this submit file to exercise 5 to see one way to set up the excute Matlab environment. 
 diff queue/hello.matlab.exercise5.submit ../exercise5/queue/hello.exercise5.submit 


