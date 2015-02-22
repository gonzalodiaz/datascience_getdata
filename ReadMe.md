## Getting and Cleaning Data Project

### Get the script and getting it running
```R
$ git clone git@github.com:gonzalodiaz/datascience_getdata.git
$ cd datascience_getdata
$ pwd # copy the output of this command
$ r
> setwd("the output of the pwd command")
> source("run_analysis.R")
> dataSet <- run_analysis()
```

### Script details 
The script takes care of the required dependencies of the project. As well
of downloading the required data set from the web.

We get 2 different output from running the script:    
1. Under folder `data` you will get a file called `result_step_4.txt`
with the results of the tidy data, without applying summarizations.  
2. Under folder `data` you will get a file called `result_step_5.txt`    
with the results of the tidy data, applying summarizations.   
3. The script returns the tidy data set with the summarizations applied, so you
can store it into a variable.   

#### Read back the generated files
Once you have ran the `run_analysis()` script, you will be able to read back
the datasets into memory. Using the method `get_tidy_data_set`.
```R
ds <- get_tidy_data_set() # return the non-summarised data set
ds_sum <- get_tidy_data_set(summarised=TRUE) # return the summarised data set
``` 

### The CodeBook
Please review the [CodeBook.md](./CodeBook.md) file for a full reference of the
tidy data.


