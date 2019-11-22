ARG version=2.4.4

FROM gradiant/spark:$version-alpine

# ADDING SPARKR SUPPORT
RUN apk add --no-cache R R-dev
ENV R_HOME /usr/lib/R
