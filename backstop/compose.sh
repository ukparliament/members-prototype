#!/bin/sh

# Move to our app directory
cd app

# Install node dependencies
npm install

# Run backstop visual regression test
make backstop
