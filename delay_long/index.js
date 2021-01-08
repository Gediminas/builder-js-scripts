const asleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

(async function () {
  console.log('LONG step 1/3')
  await asleep(5000);

  console.log('LONG step 2/3')
  await asleep(5000);

  console.log('LONG step 3/3')
  await asleep(5000);
})();
