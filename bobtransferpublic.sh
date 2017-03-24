#!/bin/sh

rsync -acv --exclude .git --exclude '*~' ./ jenny@purplefrog.com:public_html/SburbStory/

