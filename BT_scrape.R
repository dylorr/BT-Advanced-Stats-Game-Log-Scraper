
library(rvest)


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
finaldata <- data.frame(matrix(data2, ncol=length(cols[1:33]), byrow=TRUE)) # leavs out the colspan
names(finaldata) <- cols[1:33]

#add game_id col for easy filtering
#finaldata <- cbind(pbp_loc_all, game_id_bt = pbp_loc_all$game_id)

