#!/bin/bash

BUCKET_KEY=$1
CLOUDFORMATION_FILE=$2
MANDATORY_TAGS=("owner-email")
shift $#

TAG_ERRORS=0

BUCKET_HAS_TAGS=$(yq "${BUCKET_KEY}.Properties.Tags" $CLOUDFORMATION_FILE | grep -o '^[^#]*' | sed -e "s/- //g")

echo " ## Validando Bucket => ${BUCKET_KEY}"

if [[ $(sh is_null_or_empty.sh ${BUCKET_HAS_TAGS}) == "TRUE" ]];
then
    echo "ERRO :: Bucket não tem Tags"
    exit 1
fi

for MANDATORY_TAG in ${MANDATORY_TAGS[@]}
do
    echo "  @ TAG ==> ${MANDATORY_TAG}"

    TAG_VALUE=$(yq "${BUCKET_KEY}.Properties.Tags.${MANDATORY_TAG}" $CLOUDFORMATION_FILE)

    if [[ $(sh is_null_or_empty.sh ${TAG_VALUE}) == "TRUE" ]];
    then
        echo "ERRO :: Tag Vazia"
        TAG_ERRORS=$((TAG_ERRORS+1))
    fi

    if (($TAG_ERRORS > 0));
    then
        echo "ERRO :: Bucket S3 com configuração de Tag Inválida!"
        exit 1
    else
        echo "  @ Sucesso! Bucket S3 com configuração de Tag Válida!"
    fi

done