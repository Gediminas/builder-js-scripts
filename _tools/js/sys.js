const child_process = require('child_process');

const asleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

const exec = (file, args, options, comment) => {
    //const opts_line = options ? options.join(' ') : '';
    //const args_line = args ? args.join(' ') : '';
    if (comment) {
        console.log('  //', comment);
    }
    if (options) {
        console.log('  // options =', JSON.stringify(options));
    }
    console.log('  >> ', file, args.join(' '));

    try {
        child_process.execFileSync(file, args, options);
    } catch (e) {
        console.error(e.toString());
        return false;
    }
    return true;
}

module.exports = {
    asleep,
    exec,
};
