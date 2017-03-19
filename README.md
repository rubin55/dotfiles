# dotfiles
My dotfiles repository.

    for i in `find . -type f | grep -v '.git' | grep -v emacs.d | grep -v sublime`; do x=$(echo $i | sed 's|\./||g'); cp ~/$x $i; done
