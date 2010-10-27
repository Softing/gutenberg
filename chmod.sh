#!/bin/sh

find . -type d | xargs chmod 755
find . -type f | xargs chmod 644
find . -type f -name \*.pl | xargs chmod 755
find . -type f -name \*.sh | xargs chmod 755