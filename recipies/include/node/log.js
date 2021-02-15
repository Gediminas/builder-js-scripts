const colors = require('colors');
const moment = require('moment');
const fs = require('fs');
const path = require('path');

const get_date_time = () => moment().format('Y-MM-DD HH:mm:ss');

const colorize = (args, color, prefix) => {
  const nargs = [];
  nargs.push(get_date_time());
  if (prefix) {
    nargs.push(`${prefix}:`);
  }
  // if (color) {
  //   for (const arg of args) {
  //     if (typeof arg !== 'string') {
  //       if (prefix) {
  //         nargs.push(color(`${prefix}:`));
  //         prefix = null;
  //       }
  //       nargs.push(color(arg));
  //     } else {
  //       if (prefix) {
  //         nargs.push(color(`${prefix}: ${arg}`));
  //         prefix = null;
  //       } else {
  //         nargs.push(color(arg));
  //       }
  //     }
  //   }
  // } else {
    for (const arg of args) {
      nargs.push(arg);
    }
  // }
  return nargs;
};

const log = (args) => console.log(args);

// const html_start = '<body style="background-color: #222222">\n';

log.start = () => {
  console.orig     = console.log;
  const orig_log   = console.log;
  const orig_warn  = console.warn;
  const orig_error = console.error;
  const orig_info  = console.info;
  // const orig_dir   = console.dir;
  // const orig_debug = console.debug;


  console.log = (...args) => {
    const colored_args = colorize(args);
    orig_log.apply(this, colored_args);
  };

  console.debug = (...args) => {
    const colored_args = colorize(args, colors.magenta, 'DEBUG');
    orig_log.apply(this, colored_args);
  };

  console.warn = (...args) => {
    const colored_args = colorize(args, colors.black.bgBrightYellow, 'WARNING');
    orig_warn.apply(this, colored_args);
  };

  console.error = (...args) => {
    const colored_args = colorize(args, colors.bgRed, 'ERROR');
    orig_error.apply(this, colored_args);
  };

  console.info = (...args) => {
    const colored_args = colorize(args, colors.bgRed, 'ERROR');
    orig_info.apply(this, colored_args);
  };

  // console.dir = (...args) => {
  //   const colored_args = colorize(args, colors.bgRed, 'ERROR');
  //   orig_dir.apply(this, colored_args);
  // };

  console.note = (...args) => {
    const colored_args = colorize(args, colors.brightYellow);
    orig_log.apply(this, colored_args);
  };

  console.ok = (...args) => {
    const colored_args = colorize(args, colors.bgGreen);
    orig_log.apply(this, colored_args);
  };
  console.network = (...args) => {
    const colored_args = colorize(args, colors.bgBrightBlue);
    orig_log.apply(this, colored_args);
  };
  console.network2 = (...args) => {
    const colored_args = colorize(args, colors.bgBlue);
    orig_log.apply(this, colored_args);
  };
  console.network3 = (...args) => {
    const colored_args = colorize(args, colors.bgMagenta);
    orig_log.apply(this, colored_args);
  };
  console.network_debug = (...args) => {
    const colored_args = colorize(args, colors.bgBlue);
    orig_log.apply(this, colored_args);
  };

  console.event = (...args) => {
    const colored_args = colorize(args, colors.brightCyan);
    orig_log.apply(this, colored_args);
  };
};

module.exports = log;
