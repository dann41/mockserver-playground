# mockserver
Play with Mockserver docker image

3 different folders, each one with its own container representing a microservice.

The idea is to be used to practice different gateway frameworks and strategies.

## How to run
To start the three containers with a single command:
```
./start-servers.sh
```

To verify everything is okay:
```
verify-servers.sh
```

To stop all servers at once:
```
./stop-servers.sh
```
