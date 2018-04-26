# Intro
This dev environment for windows 10 allows you to use a linux like environment alongside windows programs.

Instead of the normal/old way of using cygwin, I use the new Windows Subsystem for Linux (Bash on Ubuntu on Windows) or WSL. However I still use [Cmder as my terminal emulator](http://cmder.net/) since it's the most customizable and themeable solution I've found to date.

This environment allows a lot of usability and efficiency, essentially being linux running on your windows machine with everything that comes with. The filesystem using bash might take a performance hit, but it's still better than the old windows dev days with VMs. You can read through the [install.sh](https://github.com/jordandrako/windows-dev-env/blob/master/install.sh) script. It's pretty well documented throughout.

## Prerequisites
You need to be on Windows 10 with the creators update. Insider builds are preferred; you need [insider build 16176](https://github.com/Microsoft/BashOnWindows/issues/214#issuecomment-305621415) or above to mount network drives.

# Install
1. Install WSL via PowerShell (Back up anything you've already set up in WSL if you have anything already). **Set your username for Bash the same as what appears in your C:\Users\\<username\> folder.**
``` powershell
lxrun /uninstall /full
lxrun /install
```
2. Launch bash (by either typing `bash` in powershell or launching it from the start menu) and clone this repo using `git clone https://github.com/jordandrako/windows-dev-env.git`
3. `cd` into the cloned repository.
4. Run this command to start installing. It will ask you a couple questions during the process.
``` bash
chmod +x wsl.sh && ./wsl.sh
```

5. To install my recommended fonts, open PowerShell as admin and run
``` powershell
cd C:\dev\FiraCode\distr\otf; $fonts = (New-Object -ComObject Shell.Application).Namespace(0x14); dir ./*.otf | %{ $fonts.CopyHere($_.fullname) }
```

## Other considerations
- I use VS Code as my text editor. There are some example settings in the assets folder.

- If you are on Windows insider builds, [you can lauch wsl.exe instead of bash.exe](https://github.com/Microsoft/BashOnWindows/issues/846#issuecomment-300836949). This allows you to change your default shell to zsh or something else. You'd have to update your Cmder and VSCode settings to launch wsl instead of bash.
