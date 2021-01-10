const child_process = require('child_process');

const asleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

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

module.exports = {
  asleep,
  exec,
};
