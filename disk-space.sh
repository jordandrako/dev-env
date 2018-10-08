#!/usr/bin/env node

const exec = require('child_process').exec;
const style = require('ansi-styles');

const padding = "  ";
let child;

child = exec("df / -h && df /mnt/easystore -h | grep /mnt/easystore && df /media/jordan/easystore1 -h | grep /media/jordan/easystore1",
  function (error, stdout, stderr) {
    if (!error) {
      const output = stdout;
      const lines = output.split("\n");

      const disknames = ["", "System\t", "Storage\t", "External\t"];
      const mountpoints = ["", "/dev/mapper/ubuntu--vg-root", '/mnt/easystore', '/media/jordan/easystore1'];
      const mntNew = ["", "/", "Storage", "External"];

      // Console log table header "Filesystems Size Used Avail Use% Directory"
      console.log("\n" + lines[0].replace("Filesystem", "Filesystems "));

      for (let i = 1; i < lines.length - 1; i++) {
        let line = lines[i];
        const myRegexp = /([0-9]{1,3})%/g;
        const match = myRegexp.exec(line);

        const mntRe = new RegExp(mountpoints[i] + "($)?", "gi");
        line = line.replace(mntRe, mntNew[i]);
        line = padding + line;

        console.log(line);
        print_loadbar(match[1]);
      }
    }
    else {
      console.log(error);
    }
  });

function print_loadbar(percent) {
  const bar_fill = "=",
    bar_empty = style.gray.open + "=" + style.gray.close,
    endpost_l = "[",
    endpost_r = "]";

  let output = "";

  output += endpost_l;
  for (let i = 1; i <= 29; i++) {
    // 0-79 colored white
    if (percent / 2 >= i) output += (style.green.open + bar_fill + style.green.close);
    else output += bar_empty
  }
  for (let i = 30; i <= 39; i++) {
    // 80-89 colored yellow
    if (percent / 2 >= i) output += (style.yellow.open + bar_fill + style.yellow.close);
    else output += bar_empty
  }
  for (let i = 40; i <= 44; i++) {
    // 90-100 colored red
    if (percent / 2 >= i) output += (style.red.open + bar_fill + style.red.close);
    else output += bar_empty
  }
  output += endpost_r;
  console.log(padding + output);
}