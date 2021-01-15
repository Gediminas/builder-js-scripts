const fs = require('fs');
const path = require('path');
const child_process = require('child_process');

const asleep = ms => new Promise(resolve => setTimeout(resolve, ms));

const exec = (file, args, options) => {
  // if (options) {
  //   console.log('options =', JSON.stringify(options));
  // }

  try {
    console.log('>>', file, args.join(' '));
    child_process.execFileSync(file, args, options);
    return true;
  } catch (e) {
    console.error(e.toString());
    return false;
  }
};

const ensureDir = (dir) => {
    if (typeof dir !== 'string') {
        console.error('BAD DIR:', dir);
        return dir;
    }
    return path
        .resolve(dir)
        .split(path.sep)
        .reduce((acc, cur) => {
            if (cur.includes(':')) {
                return cur; // disk on windows
            }
            const currentPath = path.normalize(acc + path.sep + cur);
            try {
                fs.statSync(currentPath);
            } catch (e) {
                if (e.code === 'ENOENT') {
                    console.log(`Creating folder ${currentPath}`);
                    fs.mkdirSync(currentPath);
                } else {
                    console.error(`Cannot create folder ${dir}`, e);
                }
            }
            return currentPath;
        }, '');
};

module.exports = {
  asleep,
  exec,
  ensureDir,
};
