#!/bin/bash

yum install -y httpd
service httpd start

# in reality this would involve
# cloning the app and starting the
# Rails server, either with pure
# scripting or by invoking another
# tool like Chef
