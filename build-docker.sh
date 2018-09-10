#!/bin/bash

VERSION=2.3.1
docker build --build-arg VERSION=$VERSION -t spark:$VERSION .
