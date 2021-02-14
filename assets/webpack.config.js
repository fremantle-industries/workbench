const path = require('path');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const TerserPlugin = require('terser-webpack-plugin');
const OptimizeCSSAssetsPlugin = require('optimize-css-assets-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');

module.exports = (_env, options) => {
  const devMode = options.mode !== 'production';

  return {
    mode: options.mode || 'development',

    optimization: {
      minimizer: [
        new TerserPlugin({parallel: true}),
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
      extensions: [".ts", ".tsx", ".js"],
      alias: {
        react: path.resolve(__dirname, './node_modules/react'),
        'react-dom': path.resolve(__dirname, './node_modules/react-dom')
      }
    },

    output: {
      filename: "app.js",
      path: path.resolve(__dirname, "../priv/static/js")
    },

    devtool: devMode ? 'eval-cheap-module-source-map' : undefined,
    plugins: [
      new MiniCssExtractPlugin({filename: '../css/app.css'}),
      new CopyWebpackPlugin({
        patterns: [
          {from: "static/", to: "../"}
        ]
      })
    ]
  }
};
