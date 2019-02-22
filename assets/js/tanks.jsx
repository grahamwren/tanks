import React from 'react';
import ReactDOM from 'react-dom';

import Player from './player';

export default function tanks(root, channel) {
  ReactDOM.render(<Tanks channel={channel} />, root);
}

const m = {
  ArrowRight: (channel, cb) => channel.push('move', { direction: 'right' }).receive('ok', cb),
  ArrowLeft: (channel, cb) => channel.push('move', { direction: 'left' }).receive('ok', cb),
  ArrowUp: (channel, cb) => channel.push('move', { direction: 'up' }).receive('ok', cb),
  ArrowDown: (channel, cb) => channel.push('move', { direction: 'down' }).receive('ok', cb),
  a: (channel, cb) => channel.push('turn', { direction: 'left' }).receive('ok', cb),
  d: (channel, cb) => channel.push('turn', { direction: 'right' }).receive('ok', cb),
  ' ': (channel, cb) => channel.push('shoot').receive('ok', cb)
};

class Tanks extends React.Component {
  constructor(props) {
    super(props);
    this.channel = props.channel;
    this.state = {
      gameView: {
        positions: []
      }
    };

    this.channel
      .join()
      .receive('ok', this.gotView.bind(this))
      .receive('error', (resp) => { console.log('Unable to join', resp); });

    this.channel.on('view_update', this.gotView.bind(this));
  }

  componentDidMount() {
    document.addEventListener('keydown', e => (m[e.key] || (() => {}))(this.channel, this.gotView.bind(this)));
  }

  gotView(gameView) {
    console.log('View:', gameView);
    const newState = { ...this.state, gameView };
    this.setState(newState);
  }

  render() {
    const { gameView } = this.state;

    return (
      <div
        style={{
          width: '400px',
          height: '400px',
          position: 'relative',
          margin: '0 auto'
        }}
        className="rounded border"
      >
        { gameView.positions.map(position => Player(position)) }
      </div>
    );
  }
}
