```
bin/git-prompt
```

Was taken from
https://github.com/josuah/etc/blob/4da46f6f89131a5fcbaf5ae760ef7a8e8c392b92/.local/bin/git-prompt

# Install

Everything will be configured for you when you run

```
./setup
```

# Configuration

Most things are configured they way I like them already, but it is nice to be
able to keep some local modifications for things like umask and ENV variables
that are specific to different servers separate.

Misc changes to zsh and vim are kept in `~/.local.zsh` and `~/.local.vimrc` and
they are sourced last.


# Colors

`touch ~/dark` and reload vim and tmux config to switch to a dark theme
