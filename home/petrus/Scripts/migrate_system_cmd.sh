#!/bin/bash

#1.boot from live CD, part the new HDD, mount original HDD and new HDD
#2.migrate rootfs
#NOTE: This will flush the console, and you can't see the error.
#NOTE: -a = archive mode, -v = -vebose, -h = -human-readable, -P = same as --partial --progress, -H = --hard-links, -A = --acls, -X = --xattrs, -x = --one-file-system.
# --partial 默认情况下，如果传输中断，rsync将删除任何部分传输的文件。在某些情况下，更需要保留部分传输的文件。使用 --partial选项告诉rsync保留部分文件，这应该使文件的其余部分的后续传输更快; --process 显示传输进度
#FIXME: option -q will suppress non-error messages, maybe conflict with -P
rsync -avhPHAXx --exclude={/dev/*,/proc/*,/sys/*,/tmp/*,/run/*,/mnt/*,/media/*,/lost+found} old_disk new_disk
#3.migrate the boot partition
rsync -avhPHAXx --exclude={/lost+found} old_boot new_boot
#NOTE: diff -r src_dir dest_dir, may help check the file consistence

#4.mount necessary system partition and chroot in new HDD
mount --types proc /proc /mnt/new_rootfs/proc
mount --rbind /sys /mnt/new_rootfs/sys
mount --make-rslave /mnt/new_rootfs/sys
mount --rbind /dev /mnt/new_rootfs/dev
mount --make-rslave /mnt/new_rootfs/dev

chroot /mnt/new_disk /bin/bash
source /etc/profile
export PS1="(chroot) $PS1"

#5.install grub and make new grub config file
grub-install --recheck /dev/sdX
grub-mkconfig -o /boot/grub/grub.cfg
