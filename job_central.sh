#!/bin/bash

#####
# DESCRIPTION: Given a list of orientations labels and their respective angles (in rads) it edits and submits one array-job for each of the orientations. Each array-job will run 98 impact parameters. The impact parameter grid is specified in the "submit_array_job.sh" script. This script's task is to submit the complete orientation in an array-job.  
#
#####

#
# User Section
#

#declaring the directories
#specify orientation!!

declare -a orientations=( "7.88-7.33-7.88" "0.00-0.00-0.00" "1.22-0.88-1.88")
#        1        2   
alphas=( 5.918321479  0.0  3.142175)

betas=( 1.047197551   0.0   0.2832982)

gammas=( 5.918321479  0.0  9.828398232)
#
# End User Section
#

# Check if at least the dimension of the arrays match
orientation_number="${#orientations[@]}"

[ "$orientation_number" -ne "${#alphas[@]}" ] && echo "orientations and alphas arrays have different sizes." && exit 1
[ "$orientation_number" -ne "${#betas[@]}"  ] && echo "orientations and betas arrays have different sizes."  && exit 1
[ "$orientation_number" -ne "${#gammas[@]}" ] && echo "orientations and gammas arrays have different sizes." && exit 1

# These are the tokens to be replaced in the input.gait by their appropriate values
ALPHA_TOKEN=__ALPHA__
BETA_TOKEN=__BETA__
GAMMA_TOKEN=__GAMMA__
ORIENTATION_TOKEN=__ORIEN__

# Setup directory
setup_dir=$PWD                     #Path to where the script is running
template_dir=$setup_dir/template   #Path to template files: input.gait and submit_array_job.sh
traj_dir=$setup_dir/trajs          #where trajectories will be put 

i=0 # array index used to get the alpha, beta and gamma values and to number the submitted orientation 



for n in ${orientations[@]}; do

    # Get the orientation's directory
    dir=$traj_dir/$n
    
      # Get angles for this orientation
    alpha="${alphas[$i]}"
    beta="${betas[$i]}"
    gamma="${gammas[$i]}"

    # Create dir tree (if needed) and enter dir
    [ ! -d $dir ] && mkdir -p $dir
    cd $dir

    date=$(date +"%d-%b-%Y  %H:%M")
   echo -e "\n\n alpha = $alpha   beta = $beta  gamma = $gamma       $date" >> Euler_angles.txt  #taking record of the values of the Euler angles used for the calculation

   #editing input.gait for the orientation angles
    sed -e "s|$ALPHA_TOKEN|$alpha|g" -e "s|$BETA_TOKEN|$beta|g" -e "s|$GAMMA_TOKEN|$gamma|g" $template_dir/input.gait > input.gait
    [ $? -ne 0 ] && exit

    # Edit the submit_array_jobs.sh script
    sed "s|$ORIENTATION_TOKEN|$i|g" $template_dir/submit_array_jobs.sh > submit_array_jobs.sh
    [ $? -ne 0 ] && exit 1

    #Copy the restart script for resubmission.
    cp $template_dir/restart.gait .
    [ $? -ne 0 ] && exit 1

    #Copy the resubmission script for resubmission.
    cp $template_dir/submit.sh .
    [ $? -ne 0 ] && exit 1

    # Submits array of jobs (one job for each impact parameter) to the queue
    sbatch submit_array_jobs.sh
    [ $? -ne 0 ] && exit 1

    echo "#####################################################"
    # update index
    i=$((i+1))

done
