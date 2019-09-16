for vmid in $(vim-cmd vmsvc/getallvms | cut -d ‘ ‘ -f 1); do
	vim-cmd vmsvc/snapshot.create $vmid ‘Initial’ ‘Initial’ 1 0
done
