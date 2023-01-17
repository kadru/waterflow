const { webpackConfig, merge } = require('shakapacker');
const Dotenv = require('dotenv-webpack');

const options = {
  plugins: [
    new Dotenv()
  ],
  resolve: {
    extensions: ['.css']
  }
}

module.exports = merge({}, webpackConfig, options)
