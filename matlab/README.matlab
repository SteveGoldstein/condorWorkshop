
To run a Matlab job on the Math execute nodes, we first compile the .m file.

We have to set up the environment on the execute node to allow the
code to execute.

To compile helloWorld.m:
   /usr/local/matlab/bin/mcc -m -R -singleCompThread -R -nodisplay -R -nojvm ./helloWorld.m

