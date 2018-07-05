# NAME

Clean::On::Exit perl package following KISS principles and provides you simply one function: clean_on_exit  (aka wipe_on_exit)

# SYNOPSIS

```
clean_on_exit('/long', 'file', 'path');
clean_on_exit(sub { say 'wiping out some trash...' });

# and yes, you can do so:
open my $fhWorkFile, '>', clean_on_exit('', 'my', 'work', 'file', 'path');

# and just so:
clean_on_exit(sub { print "@_\n" }, qw/Hello, my foo and bar!/)->() 
# ...so "Hello, my foo and bar!" will be printed twice: right at the moment
# of calling clean_on_exit and when program exits too.
```

# WARN

This module will affect your %SIG and install handlers for INT and TERM (saving old ones and chaining with them)
on first clean_on_exit call
