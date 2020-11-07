#!/bin/bash

totalTests=0
failingTests=0

function assertEquals {
    current=$1
    expected=$2
    totalTests=$((totalTests+1))
    if [ $current = $expected ]
    then
        echo "✅ PASS"
    else
        echo "❌ FAIL"
        echo "$expected expected but was $current"
        failingTests=$((failingTests+1))
    fi
}

function waitForServer {
    port=$1
    maxTries=100
    numTries=0

    echo "Waiting for healthy server on port $1..."
    while [ "$(curl -s -o /dev/null -w "%{http_code}\n" http://localhost:$1/health)" != "200" ] ; do   
        sleep 0.1

        numTries=$((numTries+1))
        if [ $numTries -eq $maxTries ]
        then
            echo "Skipping after $numTries retries"
            exit 1
        fi
    done
    echo "Healthy server avilable at port $1"
}

### ADDRESS TEST
function addressesTest {
    ADDRESS_PORT=8010
    waitForServer $ADDRESS_PORT
    echo "Given request to address 1"
    response=$(curl localhost:$ADDRESS_PORT/addresses/1 --silent -H "x-schibsted-tenant: motos")

    echo -n " > Should return address with id 1: "
    assertEquals $(echo $response | jq .id) '"1"'

    echo -n " > Should return address with postalCode: "
    assertEquals $(echo $response | jq .postalCode) '"08830"'
}


### CUSTOMER TEST
function customersTest {
    CUSTOMER_PORT=8020
    waitForServer $CUSTOMER_PORT
    echo "Given request to customer 1"
    response=$(curl localhost:$CUSTOMER_PORT/customers/1 --silent -H "x-schibsted-tenant: motos")

    echo -n " > Should return customer with id 1: "
    assertEquals $(echo $response | jq .id) '"1"'

    echo -n " > Should return customer with name: "
    assertEquals $(echo $response | jq .name) '"customer1"'

    echo -n " > Should return customer with 3 orders: "
    assertEquals $(echo $response | jq '.orders | length') 3
}

### ORDER TEST
function assertOrderWithIdAndAmount {
    id=$1
    amount=$2
    port=$3

    echo "Given request to order $id"
    response=$(curl localhost:$port/orders/$id --silent -H "x-schibsted-tenant: motos")

    echo -n " > Should return order with id $id: "
    assertEquals $(echo $response | jq .id) "\"$id\""

    echo -n " > Should return order with amount: "
    assertEquals $(echo $response | jq .totalAmount) $amount

}

function ordersTest {
    ORDERS_PORT=8030
    waitForServer $ORDERS_PORT

    assertOrderWithIdAndAmount "1" 100 $ORDERS_PORT
    assertOrderWithIdAndAmount "2" 69.99 $ORDERS_PORT
    assertOrderWithIdAndAmount "3" 12.5 $ORDERS_PORT
}


### AUTOMOTIVE
function automotiveTest {
    COCHES_PORT=8011
    MOTOS_PORT=8012

    waitForServer $COCHES_PORT
    echo "Given request to coches makes"
    response=$(curl localhost:$COCHES_PORT/api/makes --silent)

    echo -n " > Should return 2 makes: "
    assertEquals $(echo $response | jq '.items | length') 2

    waitForServer $MOTOS_PORT
    echo "Given request to motos makes"
    response=$(curl localhost:$MOTOS_PORT/api/makes --silent)

    echo -n " > Should return 2 makes: "
    assertEquals $(echo $response | jq '.items | length') 2
}

# Run tests
addressesTest
customersTest
ordersTest
automotiveTest

if (( failingTests == 0 ))
then
    echo "All tests passed: $totalTests"
    exit 0
else
    echo "Some tests failed: $failingTests / $totalTests"
    exit 1
fi