const path = require('path');
const sys = require('./sys.js');

const get_temp = (script) => {
  const temp = path.resolve('../_working', script, '2021-01-14_23-20-00');
  sys.ensureDir(temp);
  return temp;
};

module.exports = {
  get_temp,
};
