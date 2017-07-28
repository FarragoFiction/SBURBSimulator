#!/bin/sh
rsync -rcv --exclude .git --exclude '*~' --chmod=Dugo+x,ugo+r ./ jenny@purplefrog.com:public_html/SburbStory/images/ #
