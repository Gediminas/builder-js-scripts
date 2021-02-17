const _path  = require('path');
const _fs    = require('fs');
const { exec } = require('./sys.js');

// const _log = require('./log.js');
// _log.start();

exports.getclean_repo = (repo, dir, branch) => {
  console.log('* git_ex -> getclean_repo');


  const git_check_path = _path.resolve(dir + '/.git/refs/heads');

  const opts = {
    stdio : 'inherit',
    stderr: 'inherit',
  };
  // const opts = {};

  console.error('======    THIS IS ERROR    =======', opts);
  console.warn('======    THIS IS WARN     =======');
  console.debug('======    THIS IS DEBUG    =======');
  console.info('======    THIS IS INFO      =======');

  if (_fs.existsSync(git_check_path)) {
    console.warn('Repo exists. Updating...');
    opts.cwd = dir;
    exec('git', ['fetch', '--all'], opts);
    exec('git', ['reset', '--hard', `origin/${branch}`], opts);
    exec('git', ['clean', '-fdx'], opts);
    exec('git', ['pull'], opts);
  } else {
    console.warn('Repo does not exist. Cloning...');
    // FIXME: git clone sends progress to stderr
    exec('git', ['clone', '--progress', '--recursive', '-b', branch, repo, dir], opts);
    // exec('git', ['clone', '--quiet', '--recursive', '-b', branch, repo, dir], opts);
  }
  return true;
};

exports.getclean = (repo, dir, branch) => {
  // console.log(`@sub GetClean(${repo}, ${dir}, ${branch})`);
  console.log('* git_ex -> getclean');

  const resolved_dir    = _path.resolve(dir);
  const resolved_branch = (branch === undefined) ? 'master' : branch;

  console.log(`repo   = ${repo}`);
  console.log(`dir    = ${resolved_dir}`);
  console.log(`branch = ${resolved_branch}`);

  const ret = exports.getclean_repo(repo, resolved_dir, resolved_branch);

  // console.log(`  :: result : ${ret}`);
  // console.log('@end');
  return ret;
};
