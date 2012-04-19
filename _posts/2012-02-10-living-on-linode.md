---
layout: post
title: "Living on Linode"
---

I'm tired of having multiple computers to juggle. I have a 27" iMac at
work, my personal 13" MacBook Air, a 15" MacBook Pro I have as a backup
computer, and a PC I use primarly for gaming, but occasionaly for code.
Keeping the environments in sync, managing which projects are where, and
just keeping momentum between computers is too much. I don't want to
worry about if I have pushed my work from my Air to github so I can work
on it from my iMac.

Then one day I got a billing email from Linode, for a node I set up a
few months ago for a demo in a workshop. I had pretty much forgotten
about it, but decided maybe I can migrate my development life to this
server, and just live on my VPS.

I've recently switched to vim, and most of my work is done in vim and
the terminal, and of course a web browser. I decided I would set up my
Linode machine to be my primary development machine, and I would work
over ssh.

## tmux, fuck yeah!

The key that makes this whole experiment possible, and even adventageous
to local development is tmux, the terminal multiplexex. tmux allows me
to split one ssh session into multiple windows and split panes. I can
have vim open, next to a terminal session running my server, and another
session for ad-hoc commands.

The killer feature of tmux for me is that it will maintain sessions that
I disconnect from. If my ssh connection drops or I close my laptop lid to
go to work, I can reconnect to my session and pick up where I left off,
from any computer!

tmux also allows for multiple sessions. Each session can have a bunch of
windows (think tabs), and each window can have a bunch of panes arranged
in it. I keep one session for work, with each window in that session
devoted to a particular project. I keep another session for personal
projects, another for system tasks. This means I have a clear separation
of tasks. I am either in work mode, personal mode, etc... I can detatch
from one session and connect to another very easy.

I even made a zsh function to connect or create a session by name
easily. This `workon` function takes a session name, and either attaches
it, or creates it if it does not exist. It also has tab completion for
the session names!

    workon() {
      exist=$(tmux ls | cut -d ":" -f 1 | grep "^$1$")
      if [[ -n $exist ]]; then
        print Attaching to session $1
        tmux attach-session -t $1
      else
        print Creating session $1
        tmux new -s $1
      fi
    }
    _workon () { compadd `tmux ls | cut -d ":" -f 1`}
    compdef _workon workon


I can now type `workon work` as soon as I log into my server, and it
will attach my tmux session named `work`. My vim is how I left it, my
panes are arranged to my liking, my servers are still running. It's like
I never left.

## AeroFS



## Two Local Apps Only!

Now that my coding is all done over ssh on my server, I want to minimize
the amount I rely on my physical machines. I have habitually had a
dozen applications on my computer at any given time: TextMate, Terminal,
Propane (for campfire chat), and others. I didn't need them, I'm just
bad about closing things (I am working on keeping my browser tab count
under 10).

I think I can live and work on **2** apps: Chrome and iTerm. I've even
quit Finder! Since all my dev work is done on ssh with iTerm, I can do
everything else in the browser. Music, mail, and campfire are all
within the capabilities of my browser.

Obviously, I will have to open another app here or there, and I'm ok
with it. If I need to crack open Photoshop or System Preference, that's 
fine by me.

## Becoming Hardware Independent

The biggest benefit I hope to gain is to be hardware independent.
Hardware fails at innoportune time, and provisioning a new machine is a
pain in the butt. If I have a deadline or a presentation, I don't want
to worry about what happens if I drop my computer in a lake. I can just
connect to my server, and continue life as usual.

Obviously working on a server has risks of availability outages. I will
see how big of a problem this turns out to be. In the last 9 months I
have had a week of downtime on my Air when the keyboard shorted out, but
the Linode has been up and running the whole time. I am of course also
backing up my server regularly, and any important info is also in a git
repo on another computer or server somewhere else in the world.

I've been running this experiment for about a week, and it's very
liberating. I planned to stick with it at least through the end of
February, but given the results so far I think this may be my new
normal.


_P.S. I wrote this whole post on my server via SSH_
