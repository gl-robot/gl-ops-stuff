#!/bin/bash

export backup_dir=${GL_BACKUP_DIR:-$(pwd)}
export images_dir=${GL_IMAGES_DIR:-"images"}
export path_to_images=${GL_PATH_TO_IMAGES:-"/srv/app"}

if ! tar -zcvf ${backup_dir}/backup-$(date +"%Y-%m-%dT%H-%M-%SZ").tar.gz -C ${path_to_images} ${images_dir} > /dev/null 2> err.tmp; then
  echo "$(date +'%D')      Can't backup images due to: "
  cat ./err.tmp
  rm ./err.tmp
else 
  echo "$(date +'%D')      Backup was successfully completed and located in ${backup_dir}"
fi
