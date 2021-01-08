const asleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

(async function () {
  console.log('SHORT step 1/5')
  await asleep(500);

  console.log('SHORT step 2/5')
  await asleep(500);

  console.log('@sub SHORT step 3/5 GROUP')
    console.log('step SHORT 3a/5')
    await asleep(500);
  console.log('@end')

  console.log('@sub SHORT step 4/5 GROUP')
    console.log('step SHORT 4a/5')
    await asleep(500);
    console.log('step SHORT 4b/5')
    await asleep(500);
  console.log('@end')
})();
