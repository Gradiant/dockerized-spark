#!/bin/bash

VERSION=2.4.0
docker build --build-arg version=$VERSION -t gradiant/spark:$VERSION .
docker build --build-arg version=$VERSION -t gradiant/spark:$VERSION-python -f Dockerfile.python .
docker build --build-arg version=$VERSION -t gradiant/spark:$VERSION-R -f Dockerfile.R .
