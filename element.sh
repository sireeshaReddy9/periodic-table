#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]; then
  echo "Please provide an element as an argument."
  exit
fi

INPUT=$1
if [[ $INPUT =~ ^[0-9]+$ ]]; then
  QUERY="e.atomic_number = $INPUT"
else
  QUERY="e.symbol = '$INPUT' OR e.name = '$INPUT'"
fi
ss


RESULT=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements e LEFT JOIN properties p ON e.atomic_number=p.atomic_number LEFT JOIN types t ON p.type_id = t.type_id WHERE $QUERY;")


if [[ -z $RESULT ]]; then
  echo "I could not find that element in the database."
else
  IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING BOILING <<< "$RESULT"
  # trim spaces
  ATOMIC_NUMBER=$(echo $ATOMIC_NUMBER | xargs)
  NAME=$(echo $NAME | xargs)
  SYMBOL=$(echo $SYMBOL | xargs)
  TYPE=$(echo $TYPE | xargs)
  MASS=$(echo $MASS | xargs)
  MELTING=$(echo $MELTING | xargs)
  BOILING=$(echo $BOILING | xargs)

  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
fi
