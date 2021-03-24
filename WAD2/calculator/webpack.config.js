module.exports = {
  entry: './src/index.js',
  output: {
    filename: 'main.js'
  },
  devtool: 'source-map',
  module: {
    rules: [{
      test: [/\.jsx?$/],
      exclude: [/(node_module)/, /test\.js$/],
      loader: 'babel-loader',
      options: {
        presets: ["@babel/preset-env", "@babel/preset-react"]
      }
    }]
  },
  resolve: {
    extensions: ['.js', '.jsx', '*']
  }

}