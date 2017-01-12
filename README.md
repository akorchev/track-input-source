# track-input-source

This tiny program tracks macOS input source per application. Created it after I got really tired of typing "нпм старт" in terminal after switching from a Skype chat window.

## Instructions

1. Make sure you have XCode command line tools installed.
2. Clone the repo
3. Run `gcc -framework AppKit -framework Carbon -framework Foundation -o track-input-source main.m` to build the program.
4. Run `./track-input-source &`. 
5. To quit click the "Quit" status bar item (!!)
