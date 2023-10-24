#!/usr/bin/env bash

butane --files-dir /home/dhiller/.ssh bootstrap/fcos/fcos-control-plane.butane.yaml > ./bootstrap/fcos/fcos-control-plane.ign
butane --files-dir /home/dhiller/.ssh bootstrap/fcos/fcos-worker.butane.yaml > ./bootstrap/fcos/fcos-worker.ign
