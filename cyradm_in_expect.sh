#!/usr/bin/expect -f

# execute command
spawn -noecho cyradm -u cyrus localhost

# log in
log_user 0
expect "*assword: " {send "secret\r"}

# make mailbox
expect "*» " {send "cm user.[lindex $argv 0] \n"}
log_user 1

# log out
expect "*» " {log_user 0; send "exit\n"}
expect eof