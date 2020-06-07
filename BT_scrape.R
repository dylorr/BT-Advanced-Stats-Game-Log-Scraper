
library(rvest)
library(dplyr)

#test inputs
player = 'Landers Nolley II'
year = '2019-20'
team = 'Virginia Tech'

#buld URL
base <- 'https://barttorvik.com/playerstat.php?'
year_bt <- as.numeric(substring(year, 1, 4)) + 1

#fix team name for URL
  split_team_name = strsplit(team, " ")
if (length(split_team_name[[1]]) > 1){
  words = (split_team_name[[1]])
  team_bt = ''
  for (i in 1:(length(words))){
    team_bt = paste0(team_bt,words[i], '%20')
    }
  team_bt = substr(team_bt,1,nchar(team_bt)-3)
} else {
  team_bt = split_team_name[[1]]
}

#fix player name for URL
  split_player_name = strsplit(player, " ")
if (length(split_player_name[[1]]) > 1){
  words = (split_player_name[[1]])
  player_bt = ''
  for (i in 1:(length(words))){
    player_bt = paste0(player_bt,words[i], '%20')
  }
  player_bt = substr(player_bt,1,nchar(player_bt)-3)
} else {
  player_bt = split_team_name[[1]]
}

#build scraping URL
URL<- paste0(base,'year=',year_bt, '&p=', player_bt,'&t=', team_bt)

uastring <- "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36"
#page <- read_html(URL)
page <- read_html(URL) %>% html_nodes("[class='gameLog']")

cols<- page %>%
  html_nodes("th") %>%
  html_text()

data <- page %>%
  html_nodes("td") %>%
  html_text()

#remove empty strings
data1 = data[data != ""]
#remove season summary stats appended at end of table
data2 = data1[1:(length(data1)-6)]
#create dataframe
bt_df <- data.frame(matrix(data2, ncol=length(cols[1:33]), byrow=TRUE)) # leavs out the colspan
names(bt_df) <- cols[1:33]

#add game_id col for easy filtering
bt_df <- cbind(bt_df, game_id_bt = pbp_loc_all$game_id)
#filter for only selected games. bascially a match using the user seleced pbp_loc
bt_df_filtered = bt_df %>%
  filter(game_id_bt %in% pbp_loc$game_id)

#converts column of type factor to numeric for calculation purposes
bt_df_filtered$ORtg = as.numeric(as.character(bt_df_filtered$ORtg))
bt_df_filtered$Usage = as.numeric(as.character(bt_df_filtered$Usage))
bt_df_filtered$NET = as.numeric(as.character(bt_df_filtered$NET))


#Ortg, use in dashboard KPI output
O_rtg <<- mean(bt_df_filtered$ORtg)
usage <<- mean(bt_df_filtered$Usage)
NET <<- mean(bt_df_filtered$NET)







