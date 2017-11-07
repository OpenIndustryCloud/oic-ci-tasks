# Go Test 

This tasks will run a go unitest for a specific app. 

# Inputs
## function-src

This tasks requires a resource "function-src" which shall be a GitHub repository containing the code for the function

## task-src

This input is the repo with the definition of all CI tasks 

# params

In case the function is not at the root of the folder it is possible to specify a subfolder. 

# Behavior

The script will run a ```go test``` on the 
