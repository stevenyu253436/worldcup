#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
# Clear existing data
echo "Clearing existing data..."
$PSQL "TRUNCATE TABLE games, teams RESTART IDENTITY CASCADE;"

# Insert unique teams into teams table
echo "Inserting unique teams..."
cat games.csv | tail -n +2 | awk -F',' '{print $3; print $4}' | sort | uniq | while read TEAM
do
  if [[ -n "$TEAM" ]]
  then
    # Insert team if not exists
    INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$TEAM') ON CONFLICT (name) DO NOTHING;")
    echo "Inserted team: $TEAM"
  fi
done

# Insert game data into games table
echo "Inserting game data..."
cat games.csv | tail -n +2 | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # Get winner_id and opponent_id
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")

  # Insert game into games table
  INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) 
  VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS);")
  echo "Inserted game: $YEAR $ROUND $WINNER vs $OPPONENT ($WINNER_GOALS-$OPPONENT_GOALS)"
done

echo "✅ Data insertion complete!"