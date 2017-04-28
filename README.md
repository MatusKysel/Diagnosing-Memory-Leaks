# Diagnosing-Memory-Leaks
Basic script for memory leak diagnosis with ETW and WPA. It's mostly based on [article](http://blogs.microsoft.co.il/sasha/2014/12/02/diagnosing-native-memory-leaks-etw-wpa/).
## Usage
To execute script use syntax like this:
```
heap_diagnosis.bat C:\dummy.exe -P test -no-remote
```
Then "Press any key to continue . . ." will show up in command line, but do not press anything until you correctly exit executable! 
