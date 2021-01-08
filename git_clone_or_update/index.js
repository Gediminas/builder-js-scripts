const asleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

(async function () {
  console.log('GIT CLONE OR UPDATE')
  await asleep(2000);
})();
