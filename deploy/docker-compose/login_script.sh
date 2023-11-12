#!/bin/sh

sleep 60


green_echo() {
  echo -e "\e[32m$1\e[0m"
}


red_echo() {
  echo -e "\e[31m$1\e[0m"
}




login_url="http://edge-router/login"
login_response=$(curl -s -X POST -d "username=your_username" -d "password=your_password" -w "%{http_code}" "$login_url")


status_code="${login_response: -3}"
response_body="${login_response:0:${#login_response}-3}"

if [ "$status_code" -eq 200 ] && [ -n "$response_body" ]; then
  green_echo "Test Case 1: Login Successful"
else
  red_echo "Test Case 1: Login Failed"
fi


categories_url="http://edge-router/catalogue"
categories_response=$(curl -s -w "%{http_code}" "$categories_url")


status_code="${categories_response: -3}"
response_body="${categories_response:0:${#categories_response}-3}"

echo "$response_body"

if [ "$status_code" -eq 200 ] && [ -n "$response_body" ]; then
  green_echo "Test Case 2: Get catalogue Successful"
else
  red_echo "Test Case 2: Get catalogue Failed"
fi
categories_url="http://edge-router/catalogue?tag=sport"
categories_response=$(curl -s -w "%{http_code}" "$categories_url")


status_code="${categories_response: -3}"
response_body="${categories_response:0:${#categories_response}-3}"

echo "$response_body"

if [ "$status_code" -eq 200 ] && [ -n "$response_body" ]; then
  green_echo "Test Case 3: Get catalogue Successful"
else
  red_echo "Test Case 3: Get catalogue Failed"
fi


customers_url="http://edge-router/customers"
customers_response=$(curl -s -w "%{http_code}" "$customers_url")


status_code="${customers_response: -3}"
response_body="${customers_response:0:${#customers_response}-3}"

echo "$response_body"

if [ "$status_code" -eq 200 ] && [ -n "$response_body" ]; then
  green_echo "Test Case 4: Get Customers Successful"
else
  red_echo "Test Case 4: Get Customers Failed"
fi
