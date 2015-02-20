# Codebook for Getting and Cleaning Data Project

This codebook was created on 2015-02-20 15:30:46.

* [Variable list and descriptions](## Variable list and descriptions)
* [Dataset structure](## Dataset structure)
* [Some data from the output](## Some data from the output)
* [Summary of variables](## Summary of variables)
* [Save data to file](## Save data to file)

## Variable list and descriptions

Variable name    | Description
-----------------|------------
Activity         | Activity name
Subject          | ID the subject who performed the activity for each window sample. Its range is from 1 to 30.
Unit             | Feature: Time domain signal or frequency domain signal (Time or Freq)
Device           | Feature: Measuring instrument (Accelerometer or Gyroscope)
Originator       | Feature: Originator for acceleration signal (Body or Gravity)
Jerk             | Feature: Jerk signal logic (True or False)
Magnitude        | Feature: Magnitude of the signals calculated using the Euclidean norm, logic(True or False)
Axis             | Feature: 3-axial signals in the X, Y and Z directions (X, Y, or Z)
Mean             | Feature: Average mean values
Std              | Feature: Average standard deviation values

## Dataset structure


```r
str(shrink.data)
```

```
## Classes 'data.table' and 'data.frame':	5940 obs. of  10 variables:
##  $ Activity  : Ord.factor w/ 6 levels "WALKING"<"WALKING_UPSTAIRS"<..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ Subject   : int  1 2 3 4 5 6 7 8 9 10 ...
##  $ Unit      : chr  "time" "time" "time" "time" ...
##  $ Device    : chr  "Acc" "Acc" "Acc" "Acc" ...
##  $ Originator: chr  "Body" "Body" "Body" "Body" ...
##  $ Jerk      : logi  FALSE FALSE FALSE FALSE FALSE FALSE ...
##  $ Magnitude : logi  FALSE FALSE FALSE FALSE FALSE FALSE ...
##  $ Axis      : Factor w/ 4 levels "","X","Y","Z": 2 2 2 2 2 2 2 2 2 2 ...
##  $ Mean      : num  0.277 0.276 0.276 0.279 0.278 ...
##  $ Std       : num  -0.284 -0.424 -0.36 -0.441 -0.294 ...
##  - attr(*, ".internal.selfref")=<externalptr>
```

## Some data from the output


```r
shrink.data
```

```
##       Activity Subject Unit Device Originator  Jerk Magnitude Axis
##    1:  WALKING       1 time    Acc       Body FALSE     FALSE    X
##    2:  WALKING       2 time    Acc       Body FALSE     FALSE    X
##    3:  WALKING       3 time    Acc       Body FALSE     FALSE    X
##    4:  WALKING       4 time    Acc       Body FALSE     FALSE    X
##    5:  WALKING       5 time    Acc       Body FALSE     FALSE    X
##   ---                                                             
## 5936:   LAYING      26 freq   Gyro       Body  TRUE      TRUE     
## 5937:   LAYING      27 freq   Gyro       Body  TRUE      TRUE     
## 5938:   LAYING      28 freq   Gyro       Body  TRUE      TRUE     
## 5939:   LAYING      29 freq   Gyro       Body  TRUE      TRUE     
## 5940:   LAYING      30 freq   Gyro       Body  TRUE      TRUE     
##             Mean        Std
##    1:  0.2773308 -0.2837403
##    2:  0.2764266 -0.4236428
##    3:  0.2755675 -0.3603567
##    4:  0.2785820 -0.4408300
##    5:  0.2778423 -0.2940985
##   ---                      
## 5936: -0.9904309 -0.9896280
## 5937: -0.9935638 -0.9935523
## 5938: -0.9718306 -0.9693198
## 5939: -0.9976174 -0.9975852
## 5940: -0.9778213 -0.9754815
```

## Summary of variables


```r
summary(shrink.data)
```

```
##                Activity      Subject         Unit          
##  WALKING           :990   Min.   : 1.0   Length:5940       
##  WALKING_UPSTAIRS  :990   1st Qu.: 8.0   Class :character  
##  WALKING_DOWNSTAIRS:990   Median :15.5   Mode  :character  
##  SITTING           :990   Mean   :15.5                     
##  STANDING          :990   3rd Qu.:23.0                     
##  LAYING            :990   Max.   :30.0                     
##     Device           Originator           Jerk         Magnitude      
##  Length:5940        Length:5940        Mode :logical   Mode :logical  
##  Class :character   Class :character   FALSE:3600      FALSE:4320     
##  Mode  :character   Mode  :character   TRUE :2340      TRUE :1620     
##                                        NA's :0         NA's :0        
##                                                                       
##                                                                       
##  Axis          Mean               Std         
##   :1620   Min.   :-0.99762   Min.   :-0.9977  
##  X:1440   1st Qu.:-0.93140   1st Qu.:-0.9714  
##  Y:1440   Median :-0.12974   Median :-0.9194  
##  Z:1440   Mean   :-0.30898   Mean   :-0.6597  
##           3rd Qu.:-0.01192   3rd Qu.:-0.3638  
##           Max.   : 0.97451   Max.   : 0.6871
```

## Save data to file

Save data table objects to a tab-delimited text file called `data.txt`.


```r
write.table(shrink.data, file = "tidydata.txt", row.names = F)
```
