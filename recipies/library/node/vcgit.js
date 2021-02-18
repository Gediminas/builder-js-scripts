require('colors');
const _path  = require('path');
const _fs    = require('fs');
const { exec } = require('./sys.js');

exports.GetClean = (repo, dir, branch) => {
  console.log('# GIT::GetClean'.brightCyan);

  // console.log(`@sub GetClean(${repo}, ${dir}, ${branch})`);

  const resolved_dir    = _path.resolve(dir);
  const resolved_branch = (branch === undefined) ? 'master' : branch;
  const git_check_path = _path.resolve(dir + '/.git/refs/heads');
  const opts = {};

  console.log('Getting:'.magenta);
  console.log(`repo:   ${repo}`.magenta);
  console.log(`dest:   ${resolved_dir}`.magenta);
  console.log(`branch: ${resolved_branch}`.magenta);

  if (_fs.existsSync(git_check_path)) {
    console.log('Repo exists. Updating...'.brightYellow);
    opts.cwd = dir;
    exec('git', ['fetch', '--all'], opts);
    exec('git', ['reset', '--hard', `origin/${branch}`], opts);
    exec('git', ['clean', '-fdx'], opts);
    exec('git', ['pull'], opts);
  }
  else {
    console.log('Repo does not exist. Cloning...'.brightYellow);
    exec('git', ['clone', '--progress', '--recursive', '-b', branch, repo, dir], opts);
  }

  // console.log(`  :: result : ${ret}`);
  // console.log('@end');
  return true;
};
