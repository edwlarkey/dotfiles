```
bin/git-prompt
```

Was taken from
https://github.com/josuah/config/blob/master/.local/bin/git-prompt

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


# Requirements

For bspwm:

* [bspwm](http://github.com/baskerville/bspwm)
* [sxhkd](http://github.com/baskerville/sxhkd)
* [demnu2](https://bitbucket.org/melek/dmenu2)
* [dunst](http://github.com/knopwob/dunst)
* [dzen](http://github.com/robm/dzen)
* [xtitle](http://github.com/baskerville/xtitle)
* [clock](http://github.com/baskerville/sutils)

Get them from the repositories or the AUR
