#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
MAIN(){
  if [[ -z $1 ]]
  then
    echo 'Please provide an element as an argument.'
  else
    # check argument type
    if [[ $1 =~ [0-9]+ ]]
    then
      FIND_BY_NUMBER $1
    elif [[ $1 =~ ^[A-Z][a-z]?$ ]]
    then
      FIND_BY_SYMBOL $1
    else
      FIND_BY_NAME $1
    fi
  fi
}
FIND_BY_NUMBER(){
  ELEMENT=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$1")
  PRINT_ELEMENT $ELEMENT
}
FIND_BY_SYMBOL(){
  ELEMENT=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol='$1'")
  PRINT_ELEMENT $ELEMENT
}
FIND_BY_NAME(){
  ELEMENT=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE name='$1'")
  PRINT_ELEMENT $ELEMENT
}
PRINT_ELEMENT(){
  if [[ -z $1 ]]
  then
    echo I could not find that element in the database.
  else
    echo $1 | while IFS="|" read TYPE_ID ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi 
}
MAIN $1
