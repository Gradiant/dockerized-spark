ARG version
FROM gradiant/spark:$version

# ADDING SPARKR SUPPORT
RUN apk add --no-cache R R-dev
ENV R_HOME /usr/lib/R
