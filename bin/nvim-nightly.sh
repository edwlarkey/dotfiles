curl -L -o ~/tmp/nvim-macos.tar.gz https://github.com/neovim/neovim/releases/download/nightly/nvim-macos.tar.gz
xattr -c ~/tmp/nvim-macos.tar.gz
tar xzvf ~/tmp/nvim-macos.tar.gz --directory ~/tmp
ln -nsf ~/tmp/nvim-macos/bin/nvim ~/bin/nvim
rm -rf ~/tmp/nvim-macos.tar.gz
