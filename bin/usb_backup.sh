#!/usr/bin/env bash
set -euo pipefail
cd
# -p, -o and -g don't work well with FAT32, therefore -a shouldn't be used
# --modify-windows is needed because FAT32 handles timestamps differently
rsync --itemize-changes -rltDR --modify-window=1 --include-from=.backup_small.txt . /run/media/erik/ERIK/backup/
cd -
