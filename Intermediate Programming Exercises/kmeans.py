#K-Means clustering implementation

import math
import pandas as pd
import numpy as np

# ====
# Define a function that computes the distance between two data points

def distance(x_y_1,x_y_2):
    squared_diff_1 = (x_y_1[0] - x_y_2[0])**2
    squared_diff_2 = (x_y_1[1] - x_y_2[1])**2
    return math.sqrt(squared_diff_1+squared_diff_2)

# ====
# Define a function that reads data in from the csv files  HINT: http://docs.python.org/2/library/csv.html
def data_read(file):
    data = pd.read_csv(file,delimiter=',', index_col=0)
    return data
    
# ====
# Write the initialisation procedure

# read in the data
data = data_read('dataBoth.csv')

# prompt the user to inout the number of clusters and the number of iterations of the algorithm
k = eval(input("How many clusters do you want?\n"))
niter = eval(input("How many iterations of the k-means algorithm do you want?\n"))

# use the pandas.DataFrame.sample function to build a data frame of sample values for the initial cluster means/centroids
centroids_df = data.sample(k)

# build a disctionary to store those centroids
temp = []
for b, l in zip(centroids_df['BirthRate(Per1000)'], centroids_df['LifeExpectancy']):
    temp.append((b,l))

centroids_dict = {}
for i in range(k):
    centroids_dict["cluster "+str(i+1)] = temp[i]
     

# ====
# Implement the k-means algorithm, using appropriate looping

for i in range(niter):
    
    clusters_list = []  #create a list that stores the final cluster for each data point
    
    for b, l in zip(data['BirthRate(Per1000)'], data['LifeExpectancy']):
        x_y = (b,l) # store each data point as a tuple
        
        dist_list = [] #create a list to store the computed distances
        # compute the distances between each data point and each cluster mean, and save to the distance list
        for cluster in centroids_dict.keys():
            dist_list.append(distance(x_y, centroids_dict[cluster]))
        
        # then for each data point, save its cluster to the cluster list
        for j in range(len(dist_list)):
            if(dist_list[j] == min(dist_list)):
                clusters_list.append("cluster "+str(j+1))
        
    data["Clusters"] = clusters_list # create a new column in the source data frame for the clusters of each data point
    
    # next, for each cluster, compute the cluster means for each data point and update the centroids dictionary with these values
    for cluster in centroids_dict.keys():
        df = data[data["Clusters"] == cluster]
        mu_x = np.mean(df['BirthRate(Per1000)'])
        mu_y = np.mean(df['LifeExpectancy'])
        centroids_dict[cluster] = (mu_x, mu_y)
     
    sq_dist_list = [] # create a list to store the squared distances between each data point and its cluster mean
    
    # for each data point, compute the squared distance between itself and its cluster mean, then add it to the list of sqaured distances
    for b, l, c in zip(data['BirthRate(Per1000)'], data['LifeExpectancy'], data['Clusters']):
        x_y = (b,l)
        
        dist = distance(x_y, centroids_dict[c])
        sq_dist_list.append(dist**2)
        
    sums_of_sq_dist = np.sum(sq_dist_list) # compute the sum of squared distances and then print it
    print("The sums of squared distances is: " + str(sums_of_sq_dist))
  

# ====
# Print out the results
for cluster in centroids_dict.keys():
        df = data[data["Clusters"] == cluster]
        print("The number of countries in " + cluster + " is: " + str(len(df)))
        print("The countries belonging to " + cluster + " are: \n")
        countries_list = list(df.index)
        for country in countries_list:
            print(country)
        mu_x = np.mean(df['BirthRate(Per1000)'])
        mu_y = np.mean(df['LifeExpectancy'])
        print("The mean life expectancy in " + cluster + " is: " + str(mu_y) + 
              " and the mean birth rate is: " + str(mu_x))
        
    
        