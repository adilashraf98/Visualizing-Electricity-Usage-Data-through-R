This code is divided into 5 parts: A, B, C, D, and E.

Part A: 

This initializes the analyzes by calling the relevant scripts (readr, dplyr, and ggplot2).
It then reads the data contained in the zip file titled "id114_2014". Then drops rows where there is missing data in the "localminute" and "use" columns of our dataframe. 

Part B: 

We further process our dataframe now. The script splits the time variable "localminute" into columns for month, day, year, hour, and minute. These and "use" are separated for ease of handling further down. 

Part C: 

After grouping by month, day, and hour, this part creates a csv file called "usage.csv" which contains the mean electricity usage for each hour after exluding the one hour where minutes total 120 (the hour when daylight savings times change). 

Part D: 

The main output of this part is the "Load Duration Curve plot" using ggplot. This shows the relationship between the number of hours and mean electricity usage. The 5th and 95th percentiles of electricity usage are important and are visible on this plot. I added the 50th point for further inspection too. 

Part E: 

This part looks closely at two months for electricity usage: January and July. 

We summarize our analysis for the two months by defining the function "plot_usage" to create a histogram plot for a given data frame with the mean and median lines.

Two histogram plots, one for each of January and July, are created using our "plot_usage" function. These are then displayed side by side using the "grid.arrange" function from the "gridExtra" library.

Note: The backgrounds and color choices for both visualizations are stylistic decisions which I felt made them easier to understand.
