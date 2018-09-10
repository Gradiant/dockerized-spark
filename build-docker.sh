#!/bin/bash

VERSION=2.3.0
docker build --build-arg VERSION=$VERSION -t spark:$VERSION .
