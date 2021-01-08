const asleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

module.exports = {
    asleep,
};
