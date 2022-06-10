const { webpackConfig, merge } = require('shakapacker');
const Dotenv = require('dotenv-webpack');

const options = {
  plugins: [
    new Dotenv()
  ],
  module: {
    rules: [
      {
        test: /\.erb$/,
        enforce: "pre",
        loader: "rails-erb-loader"
      }
    ]
  }
}

module.exports = merge({}, webpackConfig, options)
