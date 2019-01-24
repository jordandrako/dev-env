# Intro

This is my install scripts and config files for development, with ways to work in Windows or Linux. It sets up zsh w/ antibody, most used programs, etc.

On Windows, there are scripts to install the environment in cygwin or WSL (Windows Subsytem for Linux).

## Prerequisites

### Windows

- Git & NPM.
- You need to have your preferred program (cygwin, WSL) installed already.
  - If using WSL, you should name your user the same as your windows user folder (`C:/Users/<username>`). Otherwise, pass that as an argument to the install script.
- Install zsh (`apt (or apt-cyg) install zsh`)
- [Optional] For WSL, install N separately [install n](https://github.com/tj/n#installation). The script will ask to install n first (installs to ~/.bin/n).
- **Recommended:** If using WSL, use [WLinux](https://www.microsoft.com/en-us/p/wlinux/9nv1gv1pxz6p) instead of the standard Ubuntu install in order to easily use the Linux Desktop or GUI apps.

# Install

Clone this repo wherever your store your code projects. Run `git clone https://github.com/jordandrako/dev-env.git`

### Windows

1.  (Re)Launch your desired shell program, and navigate to the cloned dev-env directory.
2.  Run `./install.sh`.
    - If your unix username isn't the same as your Windows **user folder** then pass that as an argument: `install.sh MyUserName`.
    - This script will check for your system version and give appropriate install sequence. It will copy over the appropriate config files (backing up existing versions), then ask to:
      1. (WSL and WLinux) run wlinux_setup
      2. (WSL) set up GUI libs
      3. copy .gitconfig and configure git user settings
      4. install my most used global npm packages
      5. ask if you want to copy windows ssh keys to your shell user.
    - If you want to copy your existing windows SSH keys/config later, run `./copy-ssh.sh '/path/to/.ssh'`.
3.  If you're using CMDER and want my configs there, copy the contents of the cmder directory to your cmder install location, merging the config folder. Then in CMDER open settings, click "Import..." then find the ConEmu.xml file in your cmder config folder. Save settings.

## Other considerations

- I use [VSCode](https://code.visualstudio.com) as my text editor.
- I use [Terminus](https://github.com/Eugeny/terminus) as my windows terminal emulator.
- If you want to use Cmder (w/ cmd) as your VSCode integrated terminal, use these settings (changing the paths to where your cmder is installed):
  ```json
  "terminal.integrated.shell.windows": "C:\\Windows\\System32\\cmd.exe",
  "terminal.integrated.shellArgs.windows": [
    "/C",
    "C:\\cmder\\integratedterm.bat"
  ],
  ```
- I have also written a shell chooser script you can run in the cmder directory so you can easily switch between different shells when use a terminal emulator that doesn't support switching your shell.
  - There is a cmder alias set up to run this script called `shell`.
  - if You want to use the shellchooser script by default instead of the integratedterm script above, use this setting:
    ```json
    "terminal.integrated.shellArgs.windows": [
      "/C",
      "C:\\cmder\\shellchooser.bat"
    ],
    ```
- If using WLinux and x410, there are some great tutorials for using Linux desktop and GUI apps directly in windows over here: https://token2shell.com/howto/x410/
