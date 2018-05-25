# Intro

This is my install scripts and config files for development, with ways to work in Windows or Linux. It sets up oh-my-zsh and my themes, most used programs, etc.

On Windows, there are scripts to install the environment in your preferred shell, be it babun, cygwin64, or WSL.

## Prerequisites

### Windows

* You need to have your preferred program (babun, cygwin64, WSL) installed already.
  * **If using WSL, you need to name your user the same as your windows user folder (`C:/Users/<username>`)**. If you want to use these scripts and already have a WSL user, back up your files and reinstall Ubuntu/etc on Windows.
*

# Install

Git should be installed.
Clone this repo wherever your store your code projects. Run `git clone https://github.com/jordandrako/dev-env.git`

### Windows

1.  If you're using CMDER and want my configs there, copy the contents of the cmder directory to your cmder install location, merging the config folder. Then in CMDER open settings, click "Import..." then find the ConEmu.xml file in your config folder. Save settings.
1.  Launch your shell program, and navigate to the dev-env directory.
1.  Instal NVM separately: [NVM](https://github.com/creationix/nvm#install-script).
1.  Install oh-my-zsh separately: [Oh-My-Zsh](https://github.com/robbyrussell/oh-my-zsh#basic-installation)
1.  Run `chmod +x install.sh && ./install.sh`. This script will check for your system and if oh-my-zsh and nvm are installed. Then it'll copy config files from the home directory to your home directory, ask to: 1) configure git user settings, 2) install my most used global npm packages, and 3) ask if you want to copy windows ssh keys to your shell user.
1.  If you want to copy your existing windows SSH keys/config later, run `./copy-ssh.sh`.

## Other considerations

* I use VSCode as my text editor.
* I use [Cmder as my terminal emulator](http://cmder.net/) since it's the most customizable and themeable solution I've found to date. My config files are in the [cmder](cmder) folder. [Hyper](https://hyper.is) is also a good option but has some problems on windows still. My config Hyper is [here](https://gist.github.com/jordandrako/b9507122e6db8adb6362eb5cdf147b7f).
  * If you want to use Cmder (w/ cmd) as your VSCode integrated terminal, use these settings (changing the paths to where your cmder is installed):

```json
"terminal.integrated.shell.windows": "C:\\cmder\\Cmder.exe",
"terminal.integrated.shellArgs.windows": [
  "/k",
  "C:\\cmder\\vscode-integratedterm.bat"
],
```
