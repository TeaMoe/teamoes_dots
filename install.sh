#!/bin/bash

DOTS_HOME=$HOME/.teamoes_dots
GITHUB_REPO=git://github.com/TeaMoe/teamoes_dots.git
VIMRC=$HOME/.vimrc
VIM_PACKAGE="vim-gnome"
VIMFILES=$DOTS_HOME/vimfiles
DOT_VIM=$HOME/.vim
ZSHRC=$HOME/.zshrc
ZSHFILES=$HOME/.oh-my-zsh
ZSH_PACKAGE="zsh"
ZSH_GIT_FUNCTIONS=$HOME/zsh-git/functions

if [ "$1" = "-nox" ]; then
    VIM_PACKAGE="vim-nox"
fi

if [ ! -d $DOTS_HOME ]; then
    echo "creating directory $DOTS_HOME .."
    mkdir -p $DOTS_HOME
else
    echo "$DOTS_HOME already exists.."
fi

if [ ! `which git` ]; then
    echo "git ist not installed.. installing git-core.."
    sudo aptitude install git-core gitk
fi

echo "cloning $GITHUB_REPO to $DOTS_HOME .."
git clone $GITHUB_REPO $DOTS_HOME
cd $DOTS_HOME
git submodule init
git submodule update
cd vimfiles
git submodule init
git submodule update

if [ ! `which vim` ]; then
    echo "vim is not installed.. installing $VIM_PACKAGE.."
    sudo aptitude install $VIM_PACKAGE
fi

if [ -L $VIMRC ]; then
    echo "$VIMRC exists and is a symbolic link.. removing.."
    rm $VIMRC
elif [ -f $VIMRC ]; then
    echo "$VIMRC exists.. renaming to $VIMRC.old"
    mv $VIMRC $VIMRC.old
fi

if [ -L $DOT_VIM ]; then
    echo "$DOT_VIM exists and is a symbolic link.. removing.."
    rm $DOT_VIM
elif [ -d $DOT_VIM ]; then
    echo "$DOT_VIM exists.. renaming to $DOT_VIM.old"
    mv $DOT_VIM $DOT_VIM.old
fi

echo "creating symbolic link $VIMRC .."
ln -s $VIMFILES $HOME/.vim
ln -s $VIMFILES/vimrc $VIMRC

if [ ! `which zsh` ]; then
    echo "zsh is not installed.. installing $ZSH_PACKAGE.."
    sudo aptitude install $ZSH_PACKAGE
fi

if [ -L $ZSHRC ]; then
    echo "$ZSHRC exists and is a symbolic link.. removing.."
    rm $ZSHRC
elif [ -f $ZSHRC ]; then
    echo "$ZSHRC exists.. renaming to $ZSHRC.old"
    mv $ZSHRC $ZSHRC.old
fi

if [ -L $ZSHFILES ]; then
    echo "$ZSHFILES exists and is a symbolic link.. removing.."
    rm $ZSHFILES
elif [ -d $ZSHFILES ]; then
    echo "$ZSHFILES exists.. renaming to $ZSHFILES.old"
    mv $ZSHFILES $ZSHFILES.old
fi

echo "creating symbolic link $ZSHRC .."
ln -s $DOTS_HOME/oh-my-zsh $ZSHFILES

echo "Using the Oh My Zsh template file and adding it to ~/.zshrc"
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc

echo "Copying your current PATH and adding it to the end of ~/.zshrc for you."
echo "export PATH=$PATH" >> ~/.zshrc

ln -s $ZSH_GIT_FUNCTIONS/zgitinit $ZSHFILES/functions/
ln -s $ZSH_GIT_FUNCTIONS/prompt_wunjo_setup $ZSHFILES/custom/

echo "Time to change your default shell to zsh!"
chsh -s /usr/bin/zsh

echo "Hooray! Oh My Zsh has been installed."
/usr/bin/zsh
source ~/.zshrc


