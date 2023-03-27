#!/bin/bash

cd /home/back 
ROCKET_ADDRESS="0.0.0.0" cargo run &

cd /home/front
yarn start
