const { webpackConfig, merge } = require('shakapacker');
const Dotenv = require('dotenv-webpack');

const options = {
  plugins: [
    new Dotenv()
  ]
}

module.exports = merge({}, webpackConfig, options)
