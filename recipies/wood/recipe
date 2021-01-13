const { asleep } = require('../_lib/js/sys.js');

(async () => {
  console.log('SHORT step 1/5');
  await asleep(500);

  console.log('SHORT step 2/5');
  await asleep(500);

  console.log('@sub SHORT step 3/5 GROUP');
    console.log('step SHORT 3a/5'); // eslint-disable-line indent
    await asleep(500);              // eslint-disable-line indent
  console.log('@end');

  console.log('@sub SHORT step 4/5 GROUP');
  /* eslint-disable indent */
    console.log('step SHORT 4a/5');
    await asleep(500);
    console.log('step SHORT 4b/5');
    await asleep(500);
  /* eslint-enable */
  console.log('@end');
})();
