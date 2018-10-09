#!/bin/bash

VERSION=2.3.2
docker build --build-arg VERSION=$VERSION -t spark:$VERSION .
