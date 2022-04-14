#!/bin/bash

FILE="infra.yaml"
RESOURCE_KEYS_AWS=$(yq '.Resources | keys' $FILE | grep -o '^[^#]*' | sed -e "s/- //g")
ERRORS=0

for KEY in ${RESOURCE_KEYS_AWS[@]}
do
  YQ_KEY=".Resources.${KEY}"
  YQ_TYPE_KEY="${YQ_KEY}.Type"
  RESOURCE_TYPE=$(yq $YQ_TYPE_KEY $FILE)

  case $RESOURCE_TYPE in
  "AWS::S3::Bucket")
    sh validate_bucket.sh $YQ_KEY $FILE
    ERRORS=$((ERRORS+$?))
  ;;
  *) printf "Tipo de Recurso não validado";;
  esac
done

if (($ERRORS > 0));
then
  printf "\n@ Erro! Arquivo do CloudFormation não está de acordo com as regras de Governança @\n\n"
  exit 1
else
  printf "\n@ Sucesso! Arquivo de CloudFormation é válido de acordo com as regras de Governança@\n\n"
  exit 0
fi