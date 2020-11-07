#!/bin/bash

pass="✅ PASS"
fail="❌ FAIL"

### ADDRESS TEST
echo "Given request to address 1"
response=$(curl localhost:8010/addresses/1 --silent -H "x-schibsted-tenant: motos")

echo -n " > Should return address with id 1: "
test $(echo $response | jq .id) == '"1"' && echo $pass || echo $fail

echo -n " > Should return address with postalCode: "
test $(echo $response | jq .postalCode) == '"08830"' && echo $pass || echo $fail

### CUSTOMER TEST
echo "Given request to customer 1"
response=$(curl localhost:8020/customers/1 --silent -H "x-schibsted-tenant: motos")

echo -n " > Should return customer with id 1: "
test $(echo $response | jq .id) == '"1"' && echo $pass || echo $fail

echo -n " > Should return customer with name: "
test $(echo $response | jq .name) == '"customer1"' && echo $pass || echo $fail

echo -n " > Should return customer with 3 orders: "
test $(echo $response | jq '.orders | length') -eq 3 && echo $pass || echo $fail


### ORDER TEST
function assertOrderWithIdAndAmount {
    id=$1
    amount=$2

    echo "Given request to order $id"
    response=$(curl localhost:8030/orders/$id --silent -H "x-schibsted-tenant: motos")

    echo -n " > Should return order with id $id: "
    test $(echo $response | jq .id) == "\"$id\"" && echo $pass || echo $fail

    echo -n " > Should return order with amount: "
    test $(echo $response | jq .totalAmount) == $amount && echo $pass || echo $fail

}

assertOrderWithIdAndAmount "1" 100
assertOrderWithIdAndAmount "2" 69.99
assertOrderWithIdAndAmount "3" 12.5

### AUTOMOTIVE

echo "Given request to coches makes"
response=$(curl localhost:8011/api/makes --silent)

echo -n " > Should return 2 makes: "
test $(echo $response | jq '.items | length') == 2 && echo $pass || echo $fail

echo "Given request to motos makes"
response=$(curl localhost:8012/api/makes --silent)

echo -n " > Should return 2 makes: "
test $(echo $response | jq '.items | length') == 2 && echo $pass || echo $fail