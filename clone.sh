#!/bin/sh
src=$1
shift
dest=$1
shift
options="$@"

[ ! -n "${src}" ] && echo "Invalid Source Name" && exit 1
[ ! -n "${dest}" ] && echo "Invalid Dest Name" && exit 1

datastore=/vmfs/volumes/datastore1

ls -d ${datastore}/${src} > /dev/null 2>&1 
if [ $? -ne 0 ] 
then
	echo "VM ${src} does not exist... exiting" 
	exit 2 
fi

ls -d ${datastore}/${dest} > /dev/null 2>&1 
if [ $? -eq 0 ]
then
	echo "VM ${dest} exists, must be removed first... exiting" 
	exit 2
fi

mkdir -p ${datastore}/${dest}

vmkfstools -i ${datastore}/${src}/${src}.vmdk \
${datastore}/${dest}/${dest}.vmdk -d thin

grep -v "uuid" ${datastore}/${src}/${src}.vmx | sed -e "s/${src}/${dest}/g" > ${datastore}/${dest}/${dest}.vmx 

vim-cmd solo/registervm ${datastore}/${dest}/${dest}.vmx >/dev/null
