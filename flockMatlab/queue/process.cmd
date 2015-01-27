###############
universe = vanilla


###################################################
# 1.  Edit these 2 lines to run your Matlab program. 
###################################################

MatlabProgram          = Independent
MatlabProgramArguments = 10 data.$(CLUSTER).$(PROCESS).mat
###################################################

###################################################
# 2.  Edit the last line in this file 
#
#              queue N
#
#     to run N instances of this program.
###################################################

###################################################
# 3 . Edit these lines if appropriate
###################################################
transfer_input_files = indir/

# Tell Condor how many CPUs (cores), how much memory (MB) and how much 
# disk space (KB) each job will need:
request_cpus = 1
request_memory = 1000
request_disk = 1000000
###################################################


###################################################
# 4. Most of the rest of this file does not need editing
###################################################

executable = ../chtcUtils/chtcjobwrapper 
arguments =  --type Matlab --version R2013b --cmdtorun $(MatlabProgram) --unique $(CLUSTER).$(PROCESS) -- $(MatlabProgramArguments) 


output = outdir/process.$(CLUSTER).$(PROCESS).out
error  = queue/error/process.$(CLUSTER).$(PROCESS).err
log  = queue/log/process.$(CLUSTER).log

#################################################################

should_transfer_files = YES
when_to_transfer_output = ON_EXIT

#################################################################
##  This section is for submitting from a CHTC submit node!
#################################################################
# By default, your job will be submitted to the CHTC's HTCondor 
# Pool only, which is good for jobs that are each less than 24 hours.
#
# If your jobs are less than 4 hours long, "flock" them additionally to 
# other HTCondor pools on campus by uncommenting the below line:
#+WantFlocking = true

#
# If your jobs are less than ~2 hours long, "glide" them to the national
# Open Science Grid (OSG) for access to even more computers and the
# fastest overall throughput. Uncomment the below line:
#+WantGlidein = true

#################################################################
##  This section is for submitting from a Math submit node!
#################################################################
+WantFlocking = TRUE
requirements = (OpSysMajorVer =?= 6)  && (TARGET.COLLECTOR_HOST_STRING=="cm.chtc.wisc.edu")
###################################################

# Release a job from being on hold hold after 5 minutes (300 seconds), up to 4 times,
# as long as the executable could be started, the input files and initial directory
# were accessible and the user log could be created. This will help your jobs to retry
# if they happen to fail due to a computer issue (not an issue with your job)
periodic_release = (JobStatus == 5) && ((CurrentTime - EnteredCurrentStatus) > 300) && (JobRunCount < 5) && (HoldReasonCode != 6) && (HoldReasonCode != 14) && (HoldReasonCode != 22)

# If you want your jobs to go on hold because they are
# running longer then expected,  uncomment this line and
# change from 24 hours to desired limit:
#periodic_hold = (JobStatus == 2) && ((CurrentTime - EnteredCurrentStatus) > (60 * 60 * 24))

# We don't want email about our jobs.
notification = never

###################################################
## This must be the last line
queue 2
