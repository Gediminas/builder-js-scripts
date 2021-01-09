let _path  = require('path');
let _fs    = require('fs');
let _child = require('child_process');

exports.getclean_repo = (repo, dir, branch) => {
  const git_check_path = _path.resolve(dir + '/.git/refs/heads');

  console.log('Git branch ['+branch+']');

  let opts = {
    stdio: 'inherit'
  };

  if (_fs.existsSync(git_check_path)) {
    opts.cwd = dir;

    console.log('Cleaning git repository (git fetch --all)');
    _child.execFileSync("git", ["fetch", "--all"], opts);

    console.log('@sub cleanup...');
        console.log('Cleaning git repository (git reset --hard origin/master)');
        _child.execFileSync("git", ["reset", "--hard", "origin/"+branch], opts);

        console.log('Cleaning git repository (git clean -f -d)');
        _child.execFileSync("git", ["clean", "-fdx"], opts);
     console.log('@end');

    console.log('Updating repo (git pull)');
    _child.execFileSync("git", ["pull"], opts);
  }
  else {
    console.log('Cloning git repository ['+repo+'] to ['+dir+']');
    try {
      // FIXME: git clone sends progress to stderr
      //_child.execFileSync("git", ["clone", "--progress", "--recursive", "-b", branch, repo, dir], opts);
      _child.execFileSync("git", ["clone", "--quiet", "--recursive", "-b", branch, repo, dir], opts);
    }
    catch (e) {
        console.log("EXCEPTION `FROM SCRIPT: ", e);
      return false;
    }
  }
  return true;
}

exports.getclean = (repo, dir, branch) => {
  console.log(`@sub GetClean(${repo}, ${dir}, ${branch})`);

  const resolved_dir    = _path.resolve(dir);
  const resolved_branch = (branch == undefined) ? 'master' : branch;

  console.log(`repo   : ${repo}`);
  console.log(`dir    : ${resolved_dir}`);
  console.log(`branch : ${resolved_branch}`);

  const ret = exports.getclean_repo(repo, resolved_dir, resolved_branch);

  console.log(`result : ${ret}`);

  console.log('@end');
  return ret;
}
