#!/bin/sh

#  Laravel-dbRefresh.sh
#  kTools
#
#  Created by sMac on 27/12/2016.
#  Copyright © 2016 Sunnyface.com. All rights reserved.

LPATH="$1"
cd $LPATH
php artisan migrate:refresh
php artisan db:seed
