### Getting and Cleaning Data - Course Project - Augusy 2014

# run_analysis.R will perform the following steps on the 'Human Activity Recognition Using 
# Smartphones Datase':
        # 1. Merges the training and the test sets to create one data set.
        # 2. Extracts only the measurements on the mean and standard deviation for each 
        #       measurement.
        # 3. Uses descriptive activity names to name the activities in the data set.
        # 4. Appropriately labels the data set with descriptive variable names. 
        # 5. Creates a second, independent tidy data set with the average of each variable for each 
        #       activity and each subject. 


#___________________________________________________________________________________________

#### BEFORE YOU BEGIN!

# Manually set the working directory to the location of the 'UCI HAR Dataset' folder 

# Code will point to folders and files within the 'UCI HAR Dataset' folder


# UCI HAR Dataset
        # test
                # subject_test.txt
                # X_test.txt
                # y_test.txt
        # train
                # subject_train.txt
                # X_train.txt
                # y_train.txt

#___________________________________________________________________________________________

#### 1. Merges the training and the test sets to create one data set.

        
# data folder dir location
        dirData <- paste(getwd(), "/", sep="") # user to manually set to 'UCI HAR Dataset'     
        
# test data dir
        dirTest <- paste(dirData, "test/", sep="")

# train data dir
        dirTrain <- paste(dirData, "train/", sep="")

# Set the data dir
#        setwd(dirData)


### Import files

# Read in X_test.txt
        # Test set data from 30% of the volunteers
        filepath <- paste(dirTest, "X_test.txt", sep="")
        X_test <- read.table(filepath, stringsAsFactors=FALSE) # no conversion to factors
                
# Read in X_train.txt
        # Train set data from 70% of the volunteers
        filepath <- paste(dirTrain, "X_train.txt", sep="")
        X_train <- read.table(filepath, stringsAsFactors=FALSE)  # no conversion to factors        

# Merge X_train with X_test
        dataX <- rbind(X_train, X_test)

        # dataX data frame is produced, with X_test and X_train merged (dimensions 
        # [10299 561]).

        
#___________________________________________________________________________________________

#### 2. Extracts only the measurements on the mean and standard deviation for each 
#### measurement.

        
### Criteria for selecting mean and standard deviation measurements       
        # Out Of the 561 measurements, only measurements with substring 'mean()' and 
        # 'std()' are selected. 
        
        
# Read in features.txt
        # List of all features
        filepath <- paste(dirData, "features.txt", sep="")
        features <- read.table(filepath, stringsAsFactors=FALSE)

# Transpose features anticlockwise
        featuresTranspose <- t(features) # features is transposed for merging
        featuresT <- featuresTranspose[2, ] # subset row with headers only
                
# Apply features headers to dataX
        colnames(dataX) <- featuresT

        # dataX is merged in the following manner:                

                # TOP:    features (as column names)
                # MIDDLE: X_train
                # BOTTOM: X_test
        
        
# Get column number of measurement with mean or std        
        colMean <- grep('mean\\(\\)', features[ ,2]) # col numbers with mean() 
        colStd <- grep('std\\(\\)', features[ ,2]) # col numbers with std()
        colKeep <- unique(c(colMean, colStd)) # concatenate column numbers
        colKeep <- sort(as.numeric(colKeep)) # sorted columns to keep
        
# Subset merged data by indexing with columns numbers to keep (with mean and std)
        dataXf <- dataX[ , colKeep]

        # dataXf data frame is produced with 66 measurements (dimensions [10299 66]).
        

#___________________________________________________________________________________________

#### 3. Uses descriptive activity names to name the activities in the data set.


### Merge subject ID from subject_train.txt
        
# Read in subject_test.txt
        # Row identifiers of the subject who performed the activity for test set
        filepath <- paste(dirTest, "subject_test.txt", sep="")
        subject_test <- read.table(filepath, stringsAsFactors=FALSE)
        
# Read in subject_train.txt
        # Row identifiers of the subject who performed the activity for train set
        filepath <- paste(dirTrain, "subject_train.txt", sep="")
        subject_train <- read.table(filepath, stringsAsFactors=FALSE)
        
# Merge subject_train with subject_test
        subject <- rbind(subject_train, subject_test)
        
        
### Label column/row names from activity_labels.txt

# Read in y_test.txt (activities)
        # Activity labels for text set
        filepath <- paste(dirTest, "y_test.txt", sep="")
        y_test <- read.table(filepath, stringsAsFactors=FALSE)
        
# Read in y_train.txt (activities)        
        # Activity labels for train set
        filepath <- paste(dirTrain, "y_train.txt", sep="")
        y_train <- read.table(filepath, stringsAsFactors=FALSE)        

# Merge y_train with y_test
        y <- rbind(y_train, y_test)

        
### Merge subject and y to the left of dataXf (merged X_test and X-train)        
        dataXfsy <- cbind(cbind(subject, y), dataXf)  

        
# Include column names for subject and activity 
        colnames(dataXfsy)[1] <- "subject"
        colnames(dataXfsy)[2] <- "activity"
        
        # dataXfsy is merged in the following manner:                        
        
                # "subject"                     "activity"        features
                # subject_train/subject_test    y_train/y_test    X_train/X_test..........       
                # subject_train/subject_test    y_train/y_test    X_train/X_test..........
                # subject_train/subject_test    y_train/y_test    X_train/X_test..........        
        
        
## Subset each activity number (y_train, y_test) and apply labels (activity_labels)


# Read in activity_labels.txt       
        filepath <- paste(dirData, "activity_labels.txt", sep="")
        activity_labels <- read.table(filepath, stringsAsFactors=FALSE)
        
# Apply WALKING actvity label     
        dataXfsy$activity[dataXfsy$activity == "1"] <- activity_labels[1,2]        

# Apply WALKING_UPSTAIRS actvity label   
        dataXfsy$activity[dataXfsy$activity == "2"] <- activity_labels[2,2]        

# Apply WALKING_DOWNSTAIRS actvity label        
        dataXfsy$activity[dataXfsy$activity == "3"] <- activity_labels[3,2]
                
# Apply SITTING actvity label        
        dataXfsy$activity[dataXfsy$activity == "4"] <- activity_labels[4,2]
        
# Apply STANDING actvity label        
        dataXfsy$activity[dataXfsy$activity == "5"] <- activity_labels[5,2]
        
# Apply LAYING actvity label        
        dataXfsy$activity[dataXfsy$activity == "6"] <- activity_labels[6,2]
        
        
#___________________________________________________________________________________________

#### 4. Appropriately labels the data set with descriptive variable names. 
        

### Rationale for descriptive variable names        
        
        # NAME             FEATURE DESCRIPTION
        # ------------------------------------------------------------
        # 'time'                Time domain signal
        # 'freq'                Frequency domain signal
        # 'BodyAcceleration'    Body acceleration signals
        # 'BodyGyroscope'       Body gyroscope (angular velocity) signal
        # 'GravityAcceleration' Gravity acceleration signals
        # 'Jerk'                Jerk signals
        # 'Magnitude'           Magnitude of three dimensional signals
        # '-X'                  Axial signal in x direction
        # '-Y'                  Axial signal in y direction
        # '-Z'                  Axial signal in z direction
        # 'Mean'                Mean estimation of variables
        # 'Std'                 Standard deviation estimation of variables                 
        # ____________________________________________________________
        
                
# Steps for descriptive variable name changes
        colnames(dataXfsy) <- sub("\\(\\)", "", names(dataXfsy)) # remove '()'        
        colnames(dataXfsy) <- sub("std", "sd", names(dataXfsy)) # hide the 't'
        colnames(dataXfsy) <- sub("t", "time", names(dataXfsy)) # time
        colnames(dataXfsy) <- sub("f", "freq", names(dataXfsy)) # freq                
        colnames(dataXfsy) <- sub("BodyBody", "Body", names(dataXfsy)) # correct 'BobyBody'
        colnames(dataXfsy) <- sub("Acc", "Acceleration", names(dataXfsy)) # Acceleration
        colnames(dataXfsy) <- sub("Gyro", "Gyroscope", names(dataXfsy)) # Gyroscope
        colnames(dataXfsy) <- sub("Mag", "Magnitude", names(dataXfsy)) # Magnitude
        colnames(dataXfsy) <- sub("mean", "-Mean", names(dataXfsy))    # Mean     
        colnames(dataXfsy) <- sub("sd", "-Std", names(dataXfsy)) # Std        
        colnames(dataXfsy) <- sub("-", "", names(dataXfsy)) # remove '-'
        colnames(dataXfsy)[1] <- "subject" # reapply subject name
        colnames(dataXfsy)[2] <- "activity" # reapply activity name
        
                
#___________________________________________________________________________________________

#### 5. Creates a second, independent tidy data set with the average of each 
#### variable for each activity and each subject. 

        
# Load reshape2 library for melt and cast functions        
        library(reshape2)        

        # Melt to long-format data, using subject and variable as id variables        
        dataLong <- melt(dataXfsy, id = c("subject", "activity"))

        # cast to wide-format data, using subject and activity as id variables          
        dataTidy <- dcast(dataLong, subject + activity ~ variable, mean)
        
        
        # Write the tidy dataset to current working directory
        write.table(dataTidy, 'dataTidy.txt', row.name=FALSE) # as space delimited text file
        

# LOCATION OF SAVED 'dataTidy.txt'         
        # 'dataTidy.txt' will be saved in the current working directory ('UCI HAR Dataset' 
        # folder)        
        
        
# OPENING 'dataTidy.txt'              
        # To open dataTidy.txt with Excel, delimit with space         

        # To upload dataTidy.txt into R, use read.table(yourPathHere) using the path to the
        # location of 'dataTidy.txt'
