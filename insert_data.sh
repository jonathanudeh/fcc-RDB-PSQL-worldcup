#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

#program to insert data from games.csv into the worldcup database

echo $($PSQL "TRUNCATE TABLE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINGOALS OPGOALS
do
  if [[ $YEAR != 'year' || $ROUND != 'round' || $WINNER != 'winner' || $OPPONENT != 'opponent' || $WINGOALS != 'winner_goals' || $OPGOALS != 'opponent_goals' ]]
  then

    echo "$($PSQL "
    INSERT INTO teams(name) VALUES('$WINNER') ON CONFLICT(name) DO NOTHING;
    INSERT INTO teams(name) VALUES('$OPPONENT') ON CONFLICT(name) DO NOTHING;
    INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', (SELECT team_id FROM teams WHERE name = '$WINNER'), (SELECT team_id FROM teams WHERE name = '$OPPONENT'), $WINGOALS, $OPGOALS);
    ")"
    
  fi
done
