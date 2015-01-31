require('coffee-script');

exports.config = {
  directConnect: true,
  seleniumAddress: 'http://localhost:4444/wd/hub',
  seleniumArgs: [],
  specs: [
    '../test-e2e/**/*-e2e.{js,coffee}'
  ],
  capabilities: {
    'browserName': 'chrome'
  },
  jasmineNodeOpts: {
    onComplete: null,
//    isVerbose: false,
//    showColors: true,
    includeStackTrace: true
  }
};
