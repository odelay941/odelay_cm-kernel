#!/sbin/sh

#attempt to mount system with read/write permissions
if [ -d /system/lib/modules/ ]
then 
    #/system is already mounted, remount rw to be sure
    mount -o rw,remount /dev/block/mtdblock3 /system
else
    #/system is not mounted yet, mount read/write
    mount -o rw /dev/block/mtdblock3 /system
fi

# make symbolic links in /system/lib/modules
cd /system/lib/modules
modules=`find . -name '*.ko'`
for f in $modules
do
    ln -s $f
done
cd - > /dev/null
