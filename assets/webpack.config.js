const path = require("path");
const glob = require("glob");
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const UglifyJsPlugin = require("uglifyjs-webpack-plugin");
const OptimizeCSSAssetsPlugin = require("optimize-css-assets-webpack-plugin");
const CopyWebpackPlugin = require("copy-webpack-plugin");

module.exports = (_env, _options) => ({
  optimization: {
    minimizer: [
      new UglifyJsPlugin({cache: true, parallel: true, sourceMap: false}),
      new OptimizeCSSAssetsPlugin({})
    ]
  },
  entry: './js/app.ts',

  module: {
    rules: [
      {
        test: /\.tsx?$/,
        use: 'ts-loader',
        exclude: /node_modules/,
        // exclude: /node_modules\/(?!(react-chartjs-2)\/).*/,
      },

      {
        test: /\.[s]?css$/,
        use: [
          MiniCssExtractPlugin.loader,
          'css-loader',
          'sass-loader',
        ],
      }
    ]
  },

  resolve: {
    extensions: [".ts", ".tsx", ".js"]
  },
  output: {
    filename: "app.js",
    path: path.resolve(__dirname, "../priv/static/js")
  },

  devtool: "source-map",
  plugins: [
    new MiniCssExtractPlugin({filename: "../css/app.css"}),
    new CopyWebpackPlugin({
      patterns: [
        {from: "static/", to: "../"}
      ]
    })
  ]
});
