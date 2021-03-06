#!/bin/bash
PSQL="psql --username=freecodecamp dbname=periodic_table -t --no-align -c"
#check if argument is passed
if [[ $# -eq 0 ]]
then
  echo "Please provide an element as an argument."
else
  #if argument is a atomic number
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    #get atomic number, symbol, name from db
    ATOMIC_NUMBER=$1
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
    NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
  else
    #if argument is a symbol or name, get atomic number, symbol, name from db
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$1' OR symbol='$1'")
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
    NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
  fi
  #if data is not in db, show message
  if [[ -z $SYMBOL ]]
  then
    echo "I could not find that element in the database."   
  else
  #get type, atomic mass, melting and boiling points from db
    TYPE=$($PSQL "SELECT type FROM properties INNER JOIN types USING (type_id) WHERE atomic_number=$ATOMIC_NUMBER")
    ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
  #show message
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  fi
fi