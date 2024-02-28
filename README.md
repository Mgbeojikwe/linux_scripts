This script submit input files needed for the simulation. it achieves it objective using the steps

step1 : user supplies the orientation and the Euler angles(alpha, beta, and gamma) as arrays

step 2: script checks if the four arrays are of equal length. if false, then the script is terminated

step 3 : iterate through "orientations" array

step 4: In the traj directory, create a directory bearing the orientation, as a name.


step 5: with the aid of integre index, get the values of the Euler angles (alpha, beta, and gamma) that correpsonds to the orientation.

step 6 : with the help of the sed operation replace certain texts in "template/input.gait" and write the resulting to file "input.gait" and form the file in the orientaiot's directory

step 7: Just as step 5, modify a copy of  "template/submit_array_jobs.sh" and write the resulting to "submit_array_jobs.sh" in the orientation's directory

step 8 : repeat steps 4 to 7 for the next oreintation iter


N:B: For simplicty, submitt_array.sh and other referenced files were not attached to this repository
