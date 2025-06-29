# payment-system-01

## Prerequisite

- Java 17
- Maven
- Docker
- GNU Make
- WSL (if using Windows)

## Setup
- Repositories
    - payment-system-01: https://github.com/ericdaniel6166/payment-system-01
    - payment-service-01: https://github.com/ericdaniel6166/payment-service-01
    - sales-channel-service-01: https://github.com/ericdaniel6166/sales-channel-service-01
    - channel-sync-service-01: https://github.com/ericdaniel6166/channel-sync-service-01
- Make sure microservice repositories at directory as below

```bash
.
├── payment-system-01
├── payment-service-01
├── sales-channel-service-01
└── channel-sync-service-01
```

## Running the app

```bash
## Docker Hub login
docker login -u <username> ## ex: docker login -u john

```

## Other Commands

```bash

## Builds all modules
make maven-install

## Builds docker images
make docker-build

## Builds docker images
make docker-tag USER=<username> ## ex: make docker-tag USER=john

## Pushes docker images to Docker Hub
make docker-push USER=<username> ## ex: make docker-push USER=john

```

## Delete/clean the app

```bash
make docker-image-rm
```

