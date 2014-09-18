#!/usr/bin/env ruby
# encoding: UTF-8
#
# This program sets up this dotfiles repository.
#
# I dedicate this to my wonderful wife, Natasha. Thanks for all of your
# support.
#
# Usage: setup [options]
#      -c, --clone                   Clone repo to ~/
#      -n, --name NAME               Set location for git. home||work
#      -e, --email EMAIL             Set location for git. home||work
#          --no-ycm                  Don't run the YouCompleteMe install script
#          --mac                     If this is a mac. Homebrew install stuff.
#
#
#
# optparse to parse options passed
require 'optparse'
require 'open3'
require 'English'

# Colors!!!
class String
def black;          "\033[30m#{self}\033[0m" end
def red;            "\033[31m#{self}\033[0m" end
def green;          "\033[32m#{self}\033[0m" end
def brown;          "\033[33m#{self}\033[0m" end
def blue;           "\033[34m#{self}\033[0m" end
def magenta;        "\033[35m#{self}\033[0m" end
def cyan;           "\033[36m#{self}\033[0m" end
def gray;           "\033[37m#{self}\033[0m" end
def bg_black;       "\033[40m#{self}\033[0m" end
def bg_red;         "\033[41m#{self}\033[0m" end
def bg_green;       "\033[42m#{self}\033[0m" end
def bg_brown;       "\033[43m#{self}\033[0m" end
def bg_blue;        "\033[44m#{self}\033[0m" end
def bg_magenta;     "\033[45m#{self}\033[0m" end
def bg_cyan;        "\033[46m#{self}\033[0m" end
def bg_gray;        "\033[47m#{self}\033[0m" end
def bold;           "\033[1m#{self}\033[22m" end
def reverse_color;  "\033[7m#{self}\033[27m" end
end

# Setup git config with correct info based on location
#
# location - String - Either 'home' or 'work'
#
# Puts success and error messages.
def setup_git(name, email)
    git_username = name
    git_email = email

  # Set username
  command = "git config --global user.name '#{git_username}'"
  puts ("Setting git username as: #{git_username}").cyan
  stdout_str, stderr_str, status = Open3.capture3(command)
  unless status.exitstatus == 0
    puts "There was a problem running '#{command}'".red
    puts stderr_str
    exit 1
  end

  # Set email
  command = "git config --global user.email '#{git_email}'"
  puts "Setting git email as: #{git_email}".cyan
  stdout_str, stderr_str, status = Open3.capture3(command)
  unless status.exitstatus == 0
    puts "There was a problem running '#{command}'".red
    puts stderr_str
    exit 1
  end

  # Set editor
  command = "git config --global core.editor vim"
  puts "Setting git editor as: vim".cyan
  stdout_str, stderr_str, status = Open3.capture3(command)
  unless status.exitstatus == 0
    puts "There was a problem running '#{command}'".red
    puts stderr_str
    exit 1
  end
  puts "\u2713 Setup Git".green
end

# Clone dotfiles repository into ~/
def clone_dotfiles
  command = "git clone http://github.com/edwlarkey/dotfiles.git $HOME/dotfiles"
  puts "Cloning dotfiles repo".cyan
  stdout_str, stderr_str, status = Open3.capture3(command)
  unless status.exitstatus == 0
    puts "There was a problem running '#{command}'".red
    puts stderr_str
    exit 1
  end
  puts "\u2713 Clone dotfiles".green
end

def pull_submodules
  command = "cd $HOME/dotfiles && git submodule init && git submodule update"
  puts "Pulling down dotfiles submodules".cyan
  stdout_str, stderr_str, status = Open3.capture3(command)
  unless status.exitstatus == 0
    puts "There was a problem running '#{command}'".red
    puts stderr_str
    exit 1
  end
  puts "\u2713 Get Submodules".green
end

def link_files_dirs
  # vimrc
  command = "ln -nfs $HOME/dotfiles/vim/vimrc $HOME/.vimrc"
  puts "Linking vimrc".cyan
  stdout_str, stderr_str, status = Open3.capture3(command)
  unless status.exitstatus == 0
    puts "There was a problem running '#{command}'".red
    puts stderr_str
    exit 1
  end

  # vim
  command = "ln -nfs $HOME/dotfiles/vim $HOME/.vim"
  puts "Linking vim".cyan
  stdout_str, stderr_str, status = Open3.capture3(command)
  unless status.exitstatus == 0
    puts "There was a problem running '#{command}'".red
    puts stderr_str
    exit 1
  end

  # bin
  command = "ln -nfs $HOME/dotfiles/bin $HOME/bin"
  puts "Linking bin".cyan
  stdout_str, stderr_str, status = Open3.capture3(command)
  unless status.exitstatus == 0
    puts "There was a problem running '#{command}'".red
    puts stderr_str
    exit 1
  end

  # mutt
  command = "ln -nfs $HOME/dotfiles/mutt $HOME/.mutt"
  puts "Linking mutt".cyan
  stdout_str, stderr_str, status = Open3.capture3(command)
  unless status.exitstatus == 0
    puts "There was a problem running '#{command}'".red
    puts stderr_str
    exit 1
  end

  # zprezto
  command = "ln -nfs $HOME/dotfiles/zsh/prezto $HOME/.zprezto"
  puts "Linking zprezto".cyan
  stdout_str, stderr_str, status = Open3.capture3(command)
  unless status.exitstatus == 0
    puts "There was a problem running '#{command}'".red
    puts stderr_str
    exit 1
  end

  # zlogin
  command = "ln -nfs $HOME/dotfiles/zsh/prezto-custom/zlogin $HOME/.zlogin"
  puts "Linking zlogin".cyan
  stdout_str, stderr_str, status = Open3.capture3(command)
  unless status.exitstatus == 0
    puts "There was a problem running '#{command}'".red
    puts stderr_str
    exit 1
  end

  # zlogout
  command = "ln -nfs $HOME/dotfiles/zsh/prezto-custom/zlogout $HOME/.zlogout"
  puts "Linking zlogout".cyan
  stdout_str, stderr_str, status = Open3.capture3(command)
  unless status.exitstatus == 0
    puts "There was a problem running '#{command}'".red
    puts stderr_str
    exit 1
  end

  # zpreztorc
  command = "ln -nfs $HOME/dotfiles/zsh/prezto-custom/zpreztorc $HOME/.zpreztorc"
  puts "Linking zpreztorc".cyan
  stdout_str, stderr_str, status = Open3.capture3(command)
  unless status.exitstatus == 0
    puts "There was a problem running '#{command}'".red
    puts stderr_str
    exit 1
  end

  # zprofile
  command = "ln -nfs $HOME/dotfiles/zsh/prezto-custom/zprofile $HOME/.zprofile"
  puts "Linking zprofile".cyan
  stdout_str, stderr_str, status = Open3.capture3(command)
  unless status.exitstatus == 0
    puts "There was a problem running '#{command}'".red
    puts stderr_str
    exit 1
  end

  # zshrc
  command = "ln -nfs $HOME/dotfiles/zsh/prezto-custom/zshrc $HOME/.zshrc"
  puts "Linking zshrc".cyan
  stdout_str, stderr_str, status = Open3.capture3(command)
  unless status.exitstatus == 0
    puts "There was a problem running '#{command}'".red
    puts stderr_str
    exit 1
  end

  # zshenv
  command = "ln -nfs $HOME/dotfiles/zsh/prezto-custom/zshenv $HOME/.zshenv"
  puts "Linking zshenv".cyan
  stdout_str, stderr_str, status = Open3.capture3(command)
  unless status.exitstatus == 0
    puts "There was a problem running '#{command}'".red
    puts stderr_str
    exit 1
  end

  puts "\u2713 Link files and directories".green
end

def make_dirs
  home = Dir.home

  puts "Making sure directory ~/.vim-backup exists".cyan
  Dir.mkdir(home, ".vim-backup") unless File.exists?(home + "/.vim-backup")

  puts "Making sure directory ~/.vim-swap exists".cyan
  Dir.mkdir(home, ".vim-swap") unless File.exists?(home + "/.vim-swap")

  puts "Making sure directory ~/.vim-undo exists".cyan
  Dir.mkdir(home, ".vim-undo") unless File.exists?(home + "/.vim-undo")

  puts "Making sure directory ~/git exists".cyan
  Dir.mkdir(home, "git") unless File.exists?(home + "/git")

  puts "\u2713 Make directories".green
end

def change_shell
  command = "chsh -s /bin/zsh"
  puts "Changing shell to zsh".cyan
  stdout_str, stderr_str, status = Open3.capture3(command)
  unless status.exitstatus == 0
    puts "There was a problem running '#{command}'".red
    puts stderr_str
    exit 1
  end
  puts "\u2713 Change shell to zsh".green
end

def install_vim_plugins
  command = "vim +PluginInstall +qall"
  puts "Installing vim plugins with Vundle".cyan
  puts "This could take up to 2 minutes!".magenta
  stdout_str, stderr_str, status = Open3.capture3(command)
  unless status.exitstatus == 0
    puts "There was a problem running '#{command}'".red
    puts stderr_str
    exit 1
  end
  puts "\u2713 Install vim plugins".green
end

def install_youcompleteme
  command = "bash $HOME/.vim/bundle/YouCompleteMe/install.sh"
  puts "Installing YouCompleteMe".cyan
  stdout_str, stderr_str, status = Open3.capture3(command)
  unless status.exitstatus == 0
    puts "There was a problem running '#{command}'".red
    puts stderr_str
    exit 1
  end
  puts stdout_str.magenta
  puts "\u2713 Run vim plugin install scripts".green
end

def install_homebrew
  command = %Q|ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"|
  puts "Installing Homebrew".cyan
  puts "This could take a while!".magenta
  stdout_str, stderr_str, status = Open3.capture3(command)
  unless status.exitstatus == 0
    puts "There was a problem running '#{command}'".red
    puts stderr_str
    exit 1
  end
  puts "\u2713 Install Homebrew".green
end

def update_homebrew
  command = %Q|brew update|
  puts "Updating Homebrew".cyan
  stdout_str, stderr_str, status = Open3.capture3(command)
  unless status.exitstatus == 0
    puts "There was a problem running '#{command}'".red
    puts stderr_str
    exit 1
  end
  puts "\u2713 Update Homebrew".green
end

def install_with_homebrew(app)
  command = %Q|brew install #{app}|
  puts "Installing #{app}".cyan
  stdout_str, stderr_str, status = Open3.capture3(command)
  unless status.exitstatus == 0
    puts "There was a problem running '#{command}'".red
    puts stderr_str
    exit 1
  end
  puts "\u2713 Install #{app}".green
end

def tap_homebrewcask
  command = %Q|brew tap phinze/homebrew-cask|
  puts "Tapping homebrew-cask".cyan
  stdout_str, stderr_str, status = Open3.capture3(command)
  unless status.exitstatus == 0
    puts "There was a problem running '#{command}'".red
    puts stderr_str
    exit 1
  end
  puts "\u2713 Install Homebrew".green
end

def install_brewcask
  command = %Q|brew install brew-cask|
  puts "Tapping homebrew-cask".cyan
  stdout_str, stderr_str, status = Open3.capture3(command)
  unless status.exitstatus == 0
    puts "There was a problem running '#{command}'".red
    puts stderr_str
    exit 1
  end
  puts "\u2713 Install Homebrew".green
end

options = {}
option_parser = OptionParser.new do |opts|
  # Clone switch
  opts.on("-c","--clone", "Clone repo to ~/") do
    options[:clone] = true
  end
  # home git information
  opts.on("-e", "--email EMAIL", "Email for git") do |email|
    options[:email] = email
  end
  opts.on("-n", "--name NAME", "Name for git") do |name|
    options[:name] = name
  end
  opts.on("--no-ycm", "Don't run the YouCompleteMe install script") do
    options[:noycm] = true
  end
  opts.on("--mac", "If this is a mac. Homebrew install stuff.") do
    options[:mac] = true
  end
end

option_parser.parse!

if options[:clone].nil?
  unless options[:mac]
    install_homebrew
    tap_homebrewcask
    update_homebrew
    install_brewcask
    install_with_homebrew("vim")
    install_with_homebrew("git")
    install_with_homebrew("zsh")
  end
  setup_git(options[:name].to_s, options[:email].to_s)
  pull_submodules
  change_shell
  link_files_dirs
  make_dirs
  install_vim_plugins
  unless options[:noycm]
    install_youcompleteme
  end
else
  unless options[:mac]
    install_homebrew
    tap_homebrewcask
    update_homebrew
    install_brewcask
    install_with_homebrew("vim")
    install_with_homebrew("git")
    install_with_homebrew("zsh")
  end
  setup_git(options[:name].to_s, options[:email].to_s)
  clone_dotfiles
  pull_submodules
  change_shell
  link_files_dirs
  make_dirs
  install_vim_plugins
  unless options[:noycm]
    install_youcompleteme
  end
end

