#!/bin/bash
sleep 60

# Function to print green text
green_echo() {
  echo -e "\e[32m$1\e[0m"
}

# Function to print red text
red_echo() {
  echo -e "\e[31m$1\e[0m"
}

# Check network connectivity using ping
ping -c 1 front-end > /dev/null 2>&1
if [ $? -ne 0 ]; then
  red_echo "Network connection to front-end not available. Exiting..."
  exit 1
fi

# Continue with the script if network is available

# Define login credentials
username="your_username"
password="your_password"

# URL of the login page
login_url="http://front-end:8086/login"

# Perform the login using curl
login_response=$(curl -s -X POST \
     -d "username=$username" \
     -d "password=$password" \
     -c cookies.txt \
     -b cookies.txt \
     "$login_url")

# Check if the login was successful (you may need to adjust this based on the actual response)
if echo "$login_response" | grep -q "Login Successful"; then
    green_echo "Login successful"
else
    red_echo "Login failed"
fi

# Use the cookies in subsequent requests for authenticated pages
# For example, fetch the catalogue page
catalogue_url="http://front-end:8086/catalogue"
catalogue_response=$(curl -b cookies.txt -s -w "%{http_code}" "$catalogue_url")

# Extract HTTP status code and response body
status_code="${catalogue_response: -3}"
response_body="${catalogue_response:0:${#catalogue_response}-3}"

# Check if the status code is 200, the response body is not empty, and it contains a specific product name
if [[ "$status_code" == "200" && -n "$response_body" && "$response_body" == *"SuperSport XL"* ]]; then
  green_echo "Catalogue Page Test: Passed"
else
  red_echo "Catalogue Page Test: Failed"
fi

# Fetch the customers page
customers_url="http://front-end:8086/customers"
customers_response=$(curl -b cookies.txt -s -w "%{http_code}" "$customers_url")

# Extract HTTP status code and response body
status_code="${customers_response: -3}"
response_body="${customers_response:0:${#customers_response}-3}"

# Check if the status code is 200 and the response body is not empty
if [[ "$status_code" == "200" && -n "$response_body" ]]; then
  green_echo "Customers Page Test: Passed"
else
  red_echo "Customers Page Test: Failed"
fi

# Clean up - remove the cookies file
rm cookies.txt
