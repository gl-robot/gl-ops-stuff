#!/bin/bash

export backup_dir=${GL_PGBACKUP_DIR:-$(pwd)}
export user=${GL_PGUSER:-"postgres"}
export db=${GL_PGDATABASE:-"postgres"}


if ! pg_dump -U postgres postgres -f ${backup_dir}/pg_backup-$(date +"%Y-%m-%dT%H-%M-%SZ").sql 2> err.tmp; then
  echo "$(date +'%D')      Can't backup database due to:"
  cat ./err.tmp
  rm ./err.tmp
else
  echo "$(date +'%D')      Backup was successfully completed and located in ${backup_dir}"
fi

