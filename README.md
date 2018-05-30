# Intro

This is my install scripts and config files for development, with ways to work in Windows or Linux. It sets up oh-my-zsh and my themes, most used programs, etc.

On Windows, there are scripts to install the environment in your preferred shell, be it babun, cygwin64, or WSL (Windows Subsytem for Linux, aka Bash on Ubuntu on Windows (these scripts assume you have the latest version of windows installed, not tested on versions before the Fall Creators Update)).

## Prerequisites

### Windows

* You need to have your preferred program (babun, cygwin64, WSL) installed already.
  * If using WSL, you should name your user the same as your windows user folder (`C:/Users/<username>`). Otherwise, pass that as an argument to the install script.
* For WSL, install NVM separately: [NVM](https://github.com/creationix/nvm#install-script).
* Install zsh (`apt (or apt-cyg) install zsh`) and oh-my-zsh separately: [Oh-My-Zsh](https://github.com/robbyrussell/oh-my-zsh#basic-installation)

# Install

Git should be installed.
Clone this repo wherever your store your code projects. Run `git clone https://github.com/jordandrako/dev-env.git`

### Windows

1.  (Re)Launch your desired shell program, and navigate to the cloned dev-env directory.
1.  Run `chmod +x install.sh && ./install.sh`.
    * If your unix username isn't the same as your Windows **user folder** then pass that as an argument: `install.sh MyUserName`.
    * This script will check for your system version and if oh-my-zsh and nvm are installed. Then ask to: 1) configure git user settings, 2) install my most used global npm packages, and 3) ask if you want to copy windows ssh keys to your shell user.
    * If you want to copy your existing windows SSH keys/config later, run `./copy-ssh.sh '/path/to/.ssh'`.
1.  If you're using CMDER and want my configs there, copy the contents of the cmder directory to your cmder install location, merging the config folder. Then in CMDER open settings, click "Import..." then find the ConEmu.xml file in your cmder config folder. Save settings.

## Other considerations

* I use VSCode as my text editor.
* I use [Cmder as my terminal emulator](http://cmder.net/) since it's the most customizable and themeable solution I've found to date. My config files are in the [cmder](cmder) folder. [Hyper](https://hyper.is) is also a good option but has some problems on windows still. My Hyper config is [here](https://gist.github.com/jordandrako/b9507122e6db8adb6362eb5cdf147b7f).
  * If you want to use Cmder (w/ cmd) as your VSCode integrated terminal, use these settings (changing the paths to where your cmder is installed):

```json
"terminal.integrated.shell.windows": "C:\\cmder\\Cmder.exe",
"terminal.integrated.shellArgs.windows": [
  "/k",
  "C:\\cmder\\vscode-integratedterm.bat"
],
```
