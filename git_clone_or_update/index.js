const git = require('../_tools/js/vc_git.js');

(async function () {
  console.log('GIT CLONE OR UPDATE')
  git.getclean('git@gitlab.com:gdsx/play_cpp.git', '_repo');
})();

