
##################################################
## Title: make-teams-data
## Description: process the NBA2018 data with selected variables
## Input: nba2018.csv
## Output: nba2018-teams.csv
##################################################

dat = read.csv("/Users/Cora/Desktop/133/Workout1/data/nba2018.csv")
levels(dat$experience) = c(levels(dat$experience), '0')
dat$experience[dat$experience == 'R'] = '0'
dat = transform(dat, experience = as.integer(dat$experience))
dat$salary = dat$salary/1000000
levels(dat$position)[levels(dat$position)=='C'] <- 'center'
levels(dat$position)[levels(dat$position)=='PF'] <- 'power_fwd'
levels(dat$position)[levels(dat$position)=='PG'] <- 'point_guard'
levels(dat$position)[levels(dat$position)=='SF'] <- 'small_fwd'
levels(dat$position)[levels(dat$position)=='SG'] <- 'shoot_guard'

library("dplyr")

missed_fg = dat$field_goals - dat$field_goals_atts
missed_ft = dat$points1_atts - dat$points1
rebounds = dat$off_rebounds + dat$def_rebounds
efficiency = (dat$points + rebounds + dat$assists + dat$steals + dat$blocks + dat$blocks - missed_fg - missed_ft - dat$turnovers)/ dat$games 
dat = mutate(dat,missed_fg, missed_ft, rebounds, efficiency)
sink("Desktop/133/Workout1/output/efficiency-summary.txt",append = TRUE)
summary(efficiency)

##Create data frame teams
aggregate(dat$experience, by = list(team = dat$team), FUN = sum)
new_df = aggregate(.~team, dat, sum)
teams = new_df[ , c("team", "experience", "salary", "points3", "points2", "points", "off_rebounds", "def_rebounds",
                  "assists", "steals", "blocks", "turnovers", "fouls", "efficiency")]
sink("Desktop/133/Workout1/data/teams-summary.txt")
summary(teams)
write.csv(teams, file = "Desktop/133/Workout1//data/nba2018-teams.csv")




