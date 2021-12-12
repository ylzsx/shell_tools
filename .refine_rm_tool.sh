#!/bin/bash
# 该脚本只需要执行一次即可
build_dir=~/.trash
if [ ! -d "$build_dir" ]; then
	mkdir $build_dir
fi
tools=~/tools
if [ ! -d "$tools" ]; then
	mkdir $tools
fi

recoverfile="$tools/recoverfile.sh"
trash="$tools/trash.sh"
cleartrash="$tools/cleartrash.sh"
showtrash="$tools/showtrash.sh"

echo "mv -i $build_dir/\$@ ./" > $recoverfile
echo "mv \$@ $build_dir" > $trash
echo "read -r -p \"Are you sure to clear ? [Y/n]\" confirm
case \$confirm in
	[yY][eE][sS]|[yY])
		/bin/rm -rf $build_dir/*;
		find $build_dir -type f -name .\* -exec /bin/rm {} \\; 
		;;
	[nN][oO]|[nN])
		;;
	*)
		echo \"Invalid input...\"
		exit
		;;
esac" > $cleartrash
echo "ls \$@ $build_dir" > $showtrash

chmod +x $recoverfile
chmod +x $trash
chmod +x $cleartrash
chmod +x $showtrash
