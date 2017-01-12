# track-input-source

This tiny program tracks macOS input source per application. Created it after I got really tired of typing "нпм старт" in terminal after switching from a Skype chat window.

## Instructions

1. Make sure you have XCode command line tools installed.
2. Clone the repo.
3. Run `gcc -framework AppKit -framework Carbon -framework Foundation -o track-input-source main.m` to build the program.
4. Run `./track-input-source &`. 
5. To quit click the "Quit" status bar item.

## Known limitations

1. Tracks input source per application name. Say if you have two VIM instances open (you use VIM right?) both will have the same input source after switching. Can be fixed by tracking the pid of the application but I am too lazy to do that.
2. Tracks one input source per application and not per document/open file. Say if you have two open conversations in Skype both will have the same input source after switching. I don't know if this can be fixed.
