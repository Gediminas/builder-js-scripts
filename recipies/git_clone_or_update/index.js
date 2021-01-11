const git_ex = require('../_tools/js/git_ex.js');

console.log('GIT CLONE OR UPDATE')
git_ex.getclean('git@gitlab.com:gdsx/play_cpp.git', '../_repo');
