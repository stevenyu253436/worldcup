#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=worldcup --no-align --tuples-only -c"

# Do not change code above this line. Use the PSQL variable above to query your database.

# 1. Total number of goals in all games from winning teams
echo -e "\nTotal number of goals in all games from winning teams:"
echo "$($PSQL "SELECT SUM(winner_goals) FROM games")"

# 2. Total number of goals in all games from both teams combined
echo -e "\nTotal number of goals in all games from both teams combined:"
echo "$($PSQL "SELECT SUM(winner_goals + opponent_goals) FROM games")"

# 3. Average number of goals in all games from the winning teams
echo -e "\nAverage number of goals in all games from the winning teams:"
echo "$($PSQL "SELECT AVG(winner_goals) FROM games")"

# 4. Average number of goals in all games from the winning teams rounded to two decimal places
echo -e "\nAverage number of goals in all games from the winning teams rounded to two decimal places:"
echo "$($PSQL "SELECT ROUND(AVG(winner_goals), 2) FROM games")"

# 5. Average number of goals in all games from both teams
echo -e "\nAverage number of goals in all games from both teams:"
echo "$($PSQL "SELECT AVG(winner_goals + opponent_goals) FROM games")"

# 6. Most goals scored in a single game by one team
echo -e "\nMost goals scored in a single game by one team:"
echo "$($PSQL "SELECT MAX(GREATEST(winner_goals, opponent_goals)) FROM games")"

# 7. Number of games where the winning team scored more than two goals
echo -e "\nNumber of games where the winning team scored more than two goals:"
echo "$($PSQL "SELECT COUNT(*) FROM games WHERE winner_goals > 2")"

# 8. Winner of the 2018 tournament team name
echo -e "\nWinner of the 2018 tournament team name:"
echo "$($PSQL "SELECT name FROM teams WHERE team_id = (SELECT winner_id FROM games WHERE year = 2018 AND round = 'Final')")"

# 9. List of teams who played in the 2014 'Eighth-Final' round
echo -e "\nList of teams who played in the 2014 'Eighth-Final' round:"
echo "$($PSQL "SELECT name FROM teams WHERE team_id IN (SELECT winner_id FROM games WHERE year = 2014 AND round = 'Eighth-Final') OR team_id IN (SELECT opponent_id FROM games WHERE year = 2014 AND round = 'Eighth-Final') ORDER BY name")"

# 10. List of unique winning team names in the whole data set
echo -e "\nList of unique winning team names in the whole data set:"
echo "$($PSQL "SELECT DISTINCT name FROM teams INNER JOIN games ON teams.team_id = games.winner_id ORDER BY name")"

# 11. Year and team name of all the champions
echo -e "\nYear and team name of all the champions:"
echo "$($PSQL "SELECT year, name FROM games INNER JOIN teams ON games.winner_id = teams.team_id WHERE round = 'Final' ORDER BY year")"

# 12. List of teams that start with 'Co'
echo -e "\nList of teams that start with 'Co':"
echo "$($PSQL "SELECT name FROM teams WHERE name LIKE 'Co%'")"