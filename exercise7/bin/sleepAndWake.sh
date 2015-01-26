#!/bin/bash

/bin/sleep $1
/bin/echo $2
### Let's throw in an error so we get a non-zero exit code;

/bin/touch /not_a_directory/not_a_valid_path
exit 
