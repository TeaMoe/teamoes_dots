#!/bin/bash

DOTS_HOME=$HOME/.teamoes_dots
GITHUB_REPO=git://github.com/TeaMoe/teamoes_dots.git
VIMRC=$HOME/.vimrc
VIM_PACKAGE="vim-gnome"
VIMFILES=$DOTS_HOME/vimfiles

if [ $1 == "-nox"]; then
    VIM_PACKAGE="vim-nox"
fi

if [ ! -d $DOTS_HOME ]; then
    echo "creating directory $DOTS_HOME .."
    mkdir -p $DOTS_HOME
else
    echo "$DOTS_HOME already exists.."
fi

if [ ! which git ]; then
    echo "git ist not installed.. installing git-core.."
    sudo aptitude install git-core
else

scho "cloning $GITHUB_REPO to $DOTS_HOME .."
git clone $GITHUB_REPO $DOTS_HOME
cd $DOTS_HOME
git submodule init
git submodule update

if [ ! which vim ]; then
    echo "vim is not installed.. installing $VIM_PACKAGE.."
    sudo aptitude install $VIM_PACKAGE
fi

if [ -f $VIMRC ]; then
    echo "$VIMRC exists.. renaming to $VIMRC.old"
    mv $VIMRC $VIMRC.old
elif [ -L $VIMRC ]; then
    echo "$VIMRC exists and is a symbolic link.. removing.."
    rm $VIMRC
fi

echo "creating symbolic link $VIMRC .."
ln -s $VIMFILES $VIMRC


