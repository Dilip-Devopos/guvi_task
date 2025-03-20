#!/bin/bash

########################################
# Write a shell script to check the status code of the given website
########################################

url="https://www.guvi.in/"

response=$(curl -s -w "%{http_code}" -o /dev/null "$url")

http_code="$response"

echo "status code: $http_code"

if [ $http_code -eq 200 ]
then
    echo "Success , we are able to login the guvi.in website"
else
    echo "Failed , something went wrong while login the guvi.in website"
fi