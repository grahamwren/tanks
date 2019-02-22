// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import $ from 'jquery';
// eslint-disable-next-line no-unused-vars
import css from '../css/app.css';

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in 'webpack.config.js'.
//
// Import dependencies
//
import 'phoenix_html';
import 'bootstrap';

// Import local files
//
// Local files can be imported directly using relative paths, for example:
import tanks from './tanks';

$(() => {
  const root = document.getElementById('root');
  if (root) {
    tanks(root);
  }
});
