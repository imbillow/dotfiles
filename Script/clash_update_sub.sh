#!/usr/bin/env bash

clash_dir=$HOME/.config/clash
clash_path=$clash_dir/config.yml
backup_dir=$clash_dir/config.d

test ! -d $backup_dir && mkdir $backup_dir
test -f $clash_path && mv $clash_path  $backup_dir/config_$(date +"%d_%m_%Y_%M_%S").yml
wget $CLASH_SUB -O $clash_path

exit 0
