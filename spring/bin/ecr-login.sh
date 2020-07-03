#!/bin/bash
aws ecr get-login-password --profile tf-nordcloud-production | docker login --username AWS --password-stdin 958318301418.dkr.ecr.eu-west-1.amazonaws.com
