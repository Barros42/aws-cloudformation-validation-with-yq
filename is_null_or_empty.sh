#!/bin/bash

VARIABLE=$1
VARIABLE_SIZE=${#VARIABLE}

if [ "$VARIABLE" == "null" ];
then 
    echo "TRUE"; exit
fi

if [ "$VARIABLE" == "" ];
then 
    echo "TRUE"; exit
fi

if [ "$VARIABLE_SIZE" == "0" ];
then 
    echo "TRUE"; exit
fi

echo "FALSE"