#!/bin/sh
rsync -rcv --exclude .git --exclude '*~' ./ jenny@purplefrog.com:public_html/SburbStoryExperimental/ #