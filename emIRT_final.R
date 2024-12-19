##upload data
main_dir <- getwd()
setwd("1M-Clean-Data")
data <- read.csv("1M_binary_wide_df.csv", row.names = 1)
setwd(main_dir)

matrixdata = as.matrix(data)

library(pscl)
rc_data = rollcall(matrixdata,
                   yea=1, nay=-1, missing=0, notInLegis=9,
                   legis.names=NULL, vote.names=NULL,
                   legis.data=NULL, vote.data=NULL,
                   desc=NULL, source=NULL)

library(emIRT)
rc <- convertRC(rc_data)
p <- makePriors(rc$n, rc$m, 1)

## Changing Variance
p$beta$sigma[2, 2] = 1 #changing the variance of the multiplicative part to 1

s <- getStarts(rc$n, rc$m, 1)

lout <- binIRT(.rc = rc,
               .starts = s,
               .priors = p,
               .control = {
                 list(threads = 1,
                      verbose = FALSE,
                      thresh = 1e-6
                 )
               }
)

user_ideal = lout$means$x
user_id = row.names(data)
user_data = data.frame(user_ideal, user_id)

movie_difficulty = lout$means$beta[,1] #The intercepts for movies
movie_discrimination = lout$means$beta[,2] #The multiplicative coefficient for movie (beta)
movie_id = colnames(data)
movie_data = data.frame(movie_id, movie_difficulty, movie_discrimination)

setwd("Final-Estimations")

write.csv(user_data, "User-Ideal-Points.csv", row.names=FALSE)
write.csv(movie_data, "Movie-Ideal-Points.csv", row.names=FALSE)
