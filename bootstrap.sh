#!/usr/bin/env sh

endpath="$HOME/.zvimrc"

warn() {
    echo "$1" >&2
}

die() {
    warn "$1"
    exit 1
}

lnif() {
    if [ ! -e $2 ] ; then
        ln -s $1 $2
    fi
}

echo "Thanks for installing zvimrc\n"

# Backup existing .vim stuff
echo "backing up current vim config\n"
today=`date +%Y%m%d`
for i in $HOME/.vim $HOME/.vimrc $HOME/.gvimrc; do [ -e $i ] && [ ! -L $i ] && mv $i $i.$today; done


if [ ! -e $endpath/.git ]; then
    echo "cloning zvimrc\n"
    git clone --recursive -b master https://github.com/zhaolong/zvimrc.git $endpath
else
    echo "updating zvimrc\n"
    cd $endpath && git pull
fi


echo "setting up symlinks"
lnif $endpath/.vimrc $HOME/.vimrc
lnif $endpath/.vimrc.bundles $HOME/.vimrc.bundles
lnif $endpath/.vim $HOME/.vim
if [ ! -d $endpath/.vim/bundle ]; then
    mkdir -p $endpath/.vim/bundle
fi

if [ ! -e $HOME/.vim/bundle/vundle ]; then
    echo "Installing Vundle"
    git clone https://github.com/gmarik/vundle.git $HOME/.vim/bundle/vundle
fi

echo "update/install plugins using Vundle"
vim -u $endpath/.vimrc.bundles +BundleInstall! +BundleClean +qall
