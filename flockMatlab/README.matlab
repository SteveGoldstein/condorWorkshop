The machines in another pool may or may not have the right matlab version, or they may not have Matlab!
You have to pack up your matlab environment and take it with you.

Here, we accomplish that by using CHTC's job wrapper.  Read about this at:
	chtc.cs.wisc.edu


The job wrapper writes many log files.  The script

    chtcUtils/cleanupCHTCverbosity.pl

will move those files to a chtcOutput/ subdirectory and move the Matlab stdout files to the outdir/ subdirectory.
