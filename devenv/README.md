# Devenv

A Developer Environment (or devenv for short) is a workspace for developers to make changes without breaking anything in a live environment. 

In order to foster contribution for the Netdata Agent and it's various collectors, we created an image that is a devenv on it'own, a fully containerized environment where it has everything a developer needs to develop improvements on the Netdata Agent itself or it's collectors. 

# Instructions 

- Clone this repository 
- `cd` into the *devenv/docker* directory
- run `docker build -t netdata_devenv:latest` and `docker run -p 19999:19999 devenv`
  