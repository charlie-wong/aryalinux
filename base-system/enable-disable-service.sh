#!/bin/bash

action_name="$1"
service_name="$2"

systemctl $action_name $service_name
