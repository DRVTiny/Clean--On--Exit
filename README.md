# NAME
Clean::On::Exit perl package following KISS principles and provides you simply function clean_on_exit  

# SYNOPSIS

```
clean_on_exit("/long", "file", "path");
clean_on_exit(sub { say "wiping out some trash..." });
```

# WARN
This module will affect your %SIG and install handlers for INT and TERM (saving old ones and chaining with them) on first clean_on_exit call
