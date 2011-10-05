#!/bin/sh
# Very simple build script

kernelBaseName="2.6.35-odelay_cm-kernel"

for kernel in GB-HAVS-AXI-128-CFS GB-HAVS-128-CFS GB-SVS-AXI-128-CFS GB-SVS-128-CFS 

do
    echo "************************************"
    echo "***** Make $kernel ...."
    echo "************************************"
    make ARCH=arm CROSS_COMPILE=$CCOMPILER defconfig $kernel"_defconfig"
    make ARCH=arm CROSS_COMPILE=$CCOMPILER menuconfig
    if [ ! $? -eq 0 ]
    then
	exit
    fi

   make ARCH=arm CROSS_COMPILE=$CCOMPILER -j4 _XXCFLAGS="-march=armv7-a -mfpu=neon -mfloat-abi=softfp -mtune=cortex-a8 -fomit-frame-pointer -fno-math-errno -fno-signed-zeros -fno-tree-vectorize -O3 -Ofast --strip-unneeded"
    if [ ! $? -eq 0 ]
    then
	exit
    fi
   cp .config arch/arm/configs/$kernel"_defconfig"
   ZipBuilder/builder.sh
   cp ZipBuilder/update_signed.zip ~/Dropbox/$kernelBaseName-$kernel.zip

done

make ARCH=arm CROSS_COMPILE=$CCOMPILER clean
make ARCH=arm CROSS_COMPILE=$CCOMPILER mrproper

rm ZipBuilder/update_signed.zip
rm ZipBuilder/update.zip
rm ZipBuilder/kernel/zImage
rm -r ZipBuilder/system/lib/modules/*


