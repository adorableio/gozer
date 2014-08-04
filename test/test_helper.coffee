chai = require('chai')
chaiAsPromised = require('chai-as-promised')
chai.use(chaiAsPromised)

global.expect = chai.expect
global.context = global.describe
