# library to use commands like fread or grepl(manage data.tables package)
library("data.table")
# library to use commands like melt (reformat or reshape data)
library("reshape2")
# library to use commands like substr or str_split_fixed(arrange and modify strings)
library("stringr")
# library to use and format the codebook (Knit, markdownToHTML)
library("knitr")
library("markdown")

# set the folder "UCI HAR Dataset" as the input path. List the files
pathIn <- file.path("./UCI HAR Dataset")
list.files(pathIn, recursive=TRUE)

# read the descriptive activity names to name the activities in the data set
actlabels <- fread(file.path(pathIn,"activity_labels.txt"))

# load column (variable) names. to extracts measurements on the mean and sd
# read the file with descriptive variable names.
varnames <- fread(file.path(pathIn,"features.txt"))

# We must keep only the 66 columns with -mean() and -std() in the label. 
varnames <- varnames[grepl("(-mean\\(\\))|(-std\\(\\))", V2, perl = T)]
# get rid of "()" in the labes of columns (data.table syntax)
varnames[, V2:=gsub("\\(\\)", "", V2)]
# replace in the labesls "-" with "."
varnames[, V2:=gsub("-", ".", V2)]

# make a function, which reads and processes data from a subset
# Reads data files for a data set, labels data set, filters out and merges all
ReadAndMerge <- function(data.set = "train") {

	# read subject IDs for each observation and label 2nd column
	SubData <- fread(file.path(pathIn,sprintf("%s/subject_%s.txt", data.set, data.set)))
	setnames(SubData, names(SubData), c("Subject"))

	# read Activities IDs 
	ActData <- fread(file.path(pathIn,sprintf("%s/y_%s.txt", data.set, data.set)))
	# replace activity IDs with descriptive activity labels.
	ActData <- factor(ActData$V1, actlabels$V1, actlabels$V2, ordered = T)
	# convert to data.table just to keep using the same syntax everywhere
	ActData <- as.data.table(ActData)
	# set 2nd column name.
	setnames(ActData, names(ActData), c("Activity"))

	# read data for subset
	DatData <- read.table(file.path(pathIn,sprintf("%s/X_%s.txt", data.set, data.set)))
	# convert to data.table to keep using the same syntax everywhere
	DatData <- as.data.table(DatData)
	# let's get rid of unneeded columns
	cols <- names(DatData)[varnames$V1]
	DatData <- DatData[, cols, with=F]
	# finally set column names
	setnames(DatData, names(DatData), varnames$V2)

	# then, we are ready to merge everything using cbind, convert to data.table
	# and return the resulting data.table
	as.data.table(cbind(ActData, SubData, DatData))

}

# load the files to get both datasets
train.datast <- ReadAndMerge("train")
test.datast <- ReadAndMerge("test")

# let's rbind them.
complete.data <- rbind(train.datast, test.datast)

# sort the data.table by index Activity and Subject
setkey(complete.data, Activity, Subject)

# now group our data.table by Activity, Subject and calculate an average 
# for each of columns within a group.
# .(Activity, Subject) is data.table's package shortcut for list(Activity, Subject)
# .SD is data.table's package shortcut for subset of data for all the columns in the groups
comptidydata <- complete.data[, lapply(.SD, mean), by = .(Activity, Subject)]
# comptidydata is the dataset in format Short and wide

shrink.data <- melt(comptidydata, 1:2, 3:68)
# shrink.data is the dataset in format narrow and long
# for this format we need to split "variable" column into 3 columns for Signal, 
# Axis and Feature.
# The split pattern is a reqular expression, so the dot has to be escaped.
segment <- str_split_fixed(shrink.data$variable, "\\.", 3)
segment <- as.data.frame(segment)
setnames(segment, names(segment), c("Signal", "Feature", "Axis"))
shrink.data <- cbind(shrink.data,segment)

# drop "variable" column
shrink.data[, variable := NULL]

# Now, our Signals,Axis groups have exactly two measures(mean and std), 
# We should unmelt them to two separate in Mean and Std columns.
sd <- shrink.data[Feature=="std", value]
shrink.data <- shrink.data[Feature=="mean"]
shrink.data[, Std:=sd]
# rename "value" to "Mean"
setnames(shrink.data, c("value"), c("Mean"))
# drop Feature column
shrink.data[, Feature := NULL]

# 1) Unit of measurement (t denoting "time" and f denoting "frequency")
shrink.data[, Unit:=ifelse(substr(Signal, 1, 1) == "t", "time", "freq")]
# head(shrink.data)
# 2) Originator - Body or Gravity
shrink.data[, Originator:=ifelse(substr(Signal, 2, 5) == "Body", "Body", "Gravity")]
# head(shrink.data)
# 3) Device - Accelerator or Gyroscope
shrink.data[, Device:=ifelse(grepl("Gyro", Signal, fixed = T), "Gyro", "Acc")]
# head(shrink.data)
# 4) Jerk - TRUE or FALSE for if it's a Jerk signal
shrink.data[, Jerk:=ifelse(grepl("Jerk", Signal, fixed = T), T, F)]
# head(shrink.data)
# 5) Magnitude - TRUE or FALSE for if it's a measure of a magnitude of the signal
shrink.data[, Magnitude:=ifelse(grepl("Mag", Signal, fixed = T), T, F)]
# head(shrink.data)

# let's drop the Signal column and reorder the columns
shrink.data[, Signal := NULL]
setcolorder(shrink.data, neworder = c("Activity",
                                  "Subject",
                                  "Unit",
                                  "Device",
                                  "Originator",
                                  "Jerk",
                                  "Magnitude",
                                  "Axis",
                                  "Mean",
                                  "Std"))

#make codebook.
knit("makeCodebook.Rmd", output="codebook.md", encoding="ISO8859-1", quiet=TRUE)
markdownToHTML("codebook.md", "codebook.html")