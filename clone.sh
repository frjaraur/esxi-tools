#!/bin/sh
src=$1
shift
dest=$1
shift
options="$@"

datastore=/vmfs/volumes/datastore1

ls -d ${datastore}/${src} > /dev/null 2>&1 \
|| echo "VM ${src} does not exist... exiting" \
&& exit 2 

ls -d ${datastore}/${dest} > /dev/null 2>&1 \
&& echo "VM ${dest} exists, must be removed first... exiting" \
&& exit 2

mkdir -p ${datastore}/${dest}

vmkfstools -i ${datastore}/${src}/${src}.vmdk \
${datastore}/${dest}/${dest}.vmdk -d thin

grep -v uuid ${datastore}/${src}/${src}.vmx | sed -e "s/${src}/${dest}/g" > \
${datastore}/${dest}/${dest}.vmx 

vim-cmd solo/registervm ${datastore}/${dest}/${dest}.vmx

