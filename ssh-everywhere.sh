#/bin/bash
# ssh-everywhere.sh
HOSTS=""
for i in $HOSTS
do
  tmux splitw "ssh $i"
  tmux select-layout tiled
done
tmux set-window-option synchronize-panes on

#Now start the whole thing:

tmux new 'exec sh ssh-everywhere.sh'

#points to remember

#Here is a list of a few basic tmux commands:

 #   Ctrl+b " - split pane horizontally.
  #  Ctrl+b % - split pane vertically.
  #  Ctrl+b arrow key - switch pane.
   # Hold Ctrl+b, don't release it and hold one of the arrow keys - resize pane.
   # Ctrl+b c - (c)reate a new window.
   # Ctrl+b n - move to the (n)ext window.
   # Ctrl+b p - move to the (p)revious window.

