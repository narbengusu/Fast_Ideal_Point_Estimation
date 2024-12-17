
# Ideal Point Estimation for MovieLens Data Documentation 

## Files & Documents:

Old_Versions: The old versions of the emIRT estimation codes. Some parameters have been updated. It explores both the 1m and 10m datasets. The file also includes the old estimation outputs.  TLDR; A toy and exploratory version of the final code. (Not very important).

MovieLens-1m: The MovieLens 1 million dataset. Includes both csv and dat files for ratings, users and movies. Downloaded from the MovieLens website in the dat format and then converted to csv manually.

Pre-Process.ipynb : (See Below) The initial processing of the movie-lens data to be used in emIRT and SoftImpute codes. 

1M-Clean-Data: The output data files of the Pre-Processing are stored here. 

softImpute.R: (See Below) In this file Hastie's SoftImpute software is used to generate recommendations.

emIRT_final.R: (See Below) In this file Imai's emIRT software is used to generate recommendations.

Final-Estimations: The estimation outputs of both emIRT and SoftImpute. 

Results Exploration- Clean.ipynb:  (See Below) The Jupyter notebook that is used to plot results, analyze and compare the estimations of both softwares. 

bengu_thesis.pdf: The final writing based on this project. 

## Data Files

#### Movie Lens 10 Million

Initially the rating data that is made publicly available by movie lens is used. 10000054 ratings to 10681 movies by 71567 users. Each user has at least 20 ratings. 
#### Movie Lens 1 Million

This is the dataset used through out the main project because it also offers user demographics. 1,000,209 anonymous ratings of approximately 3,900 movies made by 6,040 MovieLens users who joined MovieLens in 2000. For ratings, user id, movie id, timestamp and rating score is provided. For movies, the movie id, title and the genre types are provided. Lastly for users, user id, gender, occupation (categorical), age (categorical) and zipcode is provided.

## Code Files

### 1.  Pre-Process.ipynb

In this file, firstly the number of rows in each data file and their types are examined. 

**Filtering:**
To be able to generate reasonable recommendations, sufficient data is needed for both users and movies. Therefore, firstly users with less than 50 reviews are filtered out. Then, among the remaining data points, movies with less than 50 reviews are filtered out. In the original data, 4247 users have more than 50 reviews 2499 movies have more than 50 reviews. In the remaining data, there are 918946 lines. 

**Binarizing the output variable:**
The emIRT software requires binary output variable. However, original ratings is integer numeric from 1 to 5. Firstly, to introduce some user-effects all the ratings are normalized for the user: For each user i, the rating for movie j is now  $$y^*_{i,j} = y_{i,j} - \mu_{i}$$

Then, we set a threshold for the normalized y. Here we choose 0. So, if a movie received a better-than average score from a user, we say that the user liked the movie. 

**Train-Test Split:**
To accurately assess the performance of recommendation systems, a test data set is needed. However, subsampling by users or movies is not an option here. Data regarding each user and movie is necessary to be able to generate recommendations for the movie and the user. Therefore, we need to take a random portion of the ratings and assign them as a test. In this way, we would keep some data about each user and each movie, allowing us to make recommendations for those. Applying this logic, 10% of non-missing ratings are randomly chosen as test data.


The training dataset is saved in a wide format, as this is needed for the emIRT and SoftImpute software. The test data is saved in the original format.

### 2. emIRT_final.R

The wide format of the 1M binarized ratings data is loaded. 

Using the political science library pscl, a roll-call matrix is created. This object type is necessary for the emIRT-binary. 

Some of the default priors are changed: the mean priors for movie effect, movie discrimination, and user ideal point estimates are by default is set to 0. The variance for the user ideal points is 1. By default, the variance for the movie discrimination was 25, this is changed to 1. The motivation behind this is to create a similar scale between the discrimination and ideal point estimates. The variance prior of the movie effect is left as 25. 

em-IRT binary model, known as binIRT is run. 

The ouput files are saved. 

### 3. softImpute.R

### 4. Results Exploration- Clean.ipynb











