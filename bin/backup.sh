#!/bin/bash
cd
# p, -o and -g don't work well with FAT32, therefore -a shouldn't be used
# --modify-windows is needed because FAT32 handles timestamps differently
rsync --itemize-changes -rltDR --modify-window=1 --include-from=.backup.txt . /run/media/erik/INTENSO/earth_backup/
cd -
