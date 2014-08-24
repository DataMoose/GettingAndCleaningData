###Getting and cleaning data course assignment - August 2014
###Human Activity Recognition Using Smartphones Dataset (Version 1.0)


The 'run_analysis.R' R programming code organises the 'Human Activity Recognition Using Smartphones Dataset' [1] to prepare tidy data as a space delimited text file 'dataTidy.txt'.



__Original dataset__

Original dataset may be downloaded at https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Please refer to the README.txt within the zip file for details of the dataset. 

The 'UCI HAR Dataset' folder in the zip file contains the 'test' and 'train' folder with associated datasets. 

The 'UCI HAR Dataset' folder contains the following files:

- activity_labels.txt: Links the class labels with their activity name.

- features.txt: List of all features.

- features_info.txt: Shows information about the variables used on the feature vector.

- README.txt

The 'test' folder contains the following files:

- 'subject_test.txt': Each row identifies the subject who performed the activity for each window sample for the test dataset.

- 'X_test.txt': Test set.

- 'y_test.txt': Test labels.

The 'train' folder contains the following files:

- 'subject_train.txt': Each row identifies the subject who performed the activity for each window sample for the train dataset. 

- 'X_train.txt': Training set.

- 'y_train.txt': Training labels.

Prior to running 'run_analysis.R' code, the 'UCI HAR Dataset' folder should be stored on a local drive with no modification of the folders and files.



__Overview of 'run_analysis.R' data transformations__

'run_analysis.R' will perform the following steps:

1. Merges the training and the test sets to create one data set.

2. Extracts only the measurements on the mean and standard deviation for each measurement.

3. Uses descriptive activity names to name the activities in the data set.

4. Appropriately labels the data set with descriptive variable names. 

5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

Further details on these sections may be found on the Coursera 'Getting and Cleaning Data' discussion thread 'David's Course Project FAQ' at https://class.coursera.org/getdata-006/forum/thread?thread_id=43



__BEFORE YOU BEGIN!__

- Manually set the working directory to the location of the 'UCI HAR Dataset' folder. 

- run_analysis.R code will point to folders and files within the 'UCI HAR Dataset' folder.




__1. Merges the training and the test sets to create one data set__

- Location of test data, train data and working directory established.

- 'X_test.txt' and 'X_train.txt' are imported.

- X_train and X_test data is merged.

- dataX data frame is produced, with X_test and X_train merged (with 10,299 rows and 561 columns).



__2. Extracts only the measurements on the mean and standard deviation for each measurement__

- Out of the 561 columns of measurements, only the measurements pertaining the mean and standard deviation are extracted. 

- The criteria for selecting mean and standard deviation measurements are names those 'features.txt' file names with substring 'mean()' and 'std()'.

- 'features.txt' is imported

- features headers are applied to dataX

- dataX is merged with features as columns names, X_train in the middle and X_text on the bottom.

- Indexing merged data (dataX) with column numbers of measurements with mean or std, dataXf data frame is produced with 66 measurements (with 10,299 rows and 66 columns).


		
__3. Uses descriptive activity names to name the activities in the data set__

- 'subject_test.txt' and 'subject_train.txt' data is imported (contains row identifiers of the subject who performed the activity for test/train set).			

- subject_train and subject_test data is merged.

- 'y_test.txt' and 'y_train.txt' data is imported (activities).

- y_train and y_test data is merged.        

- subject data and y_train/y_test data is merged to the left of dataXf (merged X_test and X_train).		

- Each activity number (y_train, y_test) is subsetted and activity labels are applied as listed in 'activity_labels.txt' (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING).


		
__4. Appropriately labels the data set with descriptive variable names__

- Descriptive variable names are applied to data frame dataXfsy.

- Rationale for descriptive variable names: Please refer to 'Codebook.md' for a detailed description of the descriptive variable names. The following summarises the names used:

* 'time': Time domain signal

* 'freq': Frequency domain signal

* 'BodyAcceleration': Body acceleration signals

* 'BodyGyroscope': Body gyroscope (angular velocity) signal	

* 'GravityAcceleration': Gravity acceleration signals

* 'Jerk': Jerk signals

* 'Magnitude': Magnitude of three dimensional signals

* '-X': Axial signal in x direction

* '-Y': Axial signal in y direction

* '-Z': Axial signal in z direction

* 'Mean': Mean estimation of variables

* 'Std': Standard deviation estimation of variables                 
	


__5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject__

- reshape2 library is loaded for melt and cast functions.        

- melt function is used to reshape data to long-format, using subject and variable as id variables.        

- cast function is used to reshape data to wide-format, using subject and activity as id variables.          

- The tidy dataset is written to current working directory as 'dataTidy.txt'. 

- Dimensions of dataTidy are 180 rows and 68 columns. Each row indicates the subject identifier and activity label. Each column describes the signal measurement variables relating to either mean or standard deviation.         



__Location of saved 'dataTidy.txt'__         

- After running 'run_analysis.R', 'dataTidy.txt' will be saved in the current working directory ('UCI HAR Dataset' folder).    
                
__Opening 'dataTidy.txt'__

- To upload dataTidy.txt into R, use read.table(yourPathHere) using the path to the location of 'dataTidy.txt'.

- To open dataTidy.txt with Excel, delimit with space.




__License:__
Use of the original dataset in publications must be acknowledged by referencing the following publication: 

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.

Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.