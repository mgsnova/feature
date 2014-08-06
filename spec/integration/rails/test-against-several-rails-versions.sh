#!/bin/bash

set -e

for rails_version in 3 4; do
  RAILS_VERSION=$rails_version ./test-against-specific-rails-version.sh
done
