#!/bin/bash

BASE_URL="http://localhost:3000"
USERNAME="admin"
PASSWORD="123456"
USER_ID=25

echo "== LOGIN =="

LOGIN_RESPONSE=$(curl -s -X POST $BASE_URL/api/v1/login \
  -H "Content-Type: application/json" \
  -d "{
    \"username\": \"$USERNAME\",
    \"password\": \"$PASSWORD\"
  }")

echo $LOGIN_RESPONSE

TOKEN=$(echo $LOGIN_RESPONSE | jq -r '.data.token')


echo "TOKEN = $TOKEN"

if [ "$TOKEN" = "null" ]; then
  echo "❌ login failed"
  exit 1
fi

echo "== DELETE USER =="

curl -X DELETE $BASE_URL/api/v1/users/$USER_ID \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json"

echo ""
echo "✅ done"
