// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import $ from 'jquery';
// eslint-disable-next-line no-unused-vars
import css from '../css/app.scss';

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
import socket from './socket';
import tanks from './tanks';

$(() => {
  const root = document.getElementById('root');
  if (root) {
    const channel = socket.channel(`game_session:${window.gameName}`, {});
    tanks(root, channel);
  }
});
