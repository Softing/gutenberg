#!/bin/sh

find . -type d | xargs chmod -v 755
find . -type f | xargs chmod -v 644
find . -type f -name \*.pl | xargs chmod -v 755
find . -type f -name \*.sh | xargs chmod -v 755