if [[ $# == 0 ]]; then
    mount --types proc /proc /mnt/gentoo/proc
    mount --rbind /sys /mnt/gentoo/sys
    mount --make-rslave /mnt/gentoo/sys
    mount --rbind /dev /mnt/gentoo/dev
    mount --make-rslave /mnt/gentoo/dev

    test -L /dev/shm && rm /dev/shm && mkdir /dev/shm
    mount --types tmpfs --options nosuid,nodev,noexec shm /dev/shm
    chmod 1777 /dev/shm
elif [[ $# == 1 ]]; then
    if [[ $1 == 'chroot' ]]; then
        chroot /mnt/gentoo /bin/bash
        source /etc/profile
        export PS1="(chroot) $PS1"
    fi

    if [[ $1 == 'umount' ]]; then
        umount -l /mnt/gentoo/dev{/shm,/pts,}
        umount -R /mnt/gentoo
    fi
fi

