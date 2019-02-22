import React from 'react';
import ReactDOM from 'react-dom';
import _ from 'lodash';

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

  getWinBar() {
    if (this.didILose()) {
      return <div className="winBar">
        You Lost
      </div>
    }
    if (this.didIWin()) {
      return <div className="winBar">
        You Won!
      </div>
    }
    return <div className="winBar">
      <div className="healthBar" style={{width: `${this.getMyHealth()}%`}}>Health</div>
    </div>
  }

  didILose() {
    return this.getMyHealth() <= 0;
  }

  didIWin() {
    return this.getMyHealth() > 0 && this.getAllOthersDestroyed();
  }

  getMyHealth() {
    const myUser = this.getMyUser();
    return (myUser && myUser.health) || 0;
  }

  getAllOthersDestroyed() {
    return this.state &&
           this.state.gameView &&
           this.state.gameView.positions &&
           _.reduce(
             this.state.gameView.positions,
             (acc, user) => acc && (user.health <= 0 || user.name === window.userName),
             true
           );
  }

  getMyUser() {
    return this.state &&
      this.state.gameView &&
      this.state.gameView.positions &&
      _.find(this.state.gameView.positions, user => user.name === window.userName);
  }

  render() {
    const { gameView } = this.state;

    return (
      <div className="container">
        {this.getWinBar()}
        <div
          style={{
            padding: '50px',
            margin: '0 auto',
            width: '500px',
            height: '500px',
            backgroundImage: "url('/images/tileGrass.jpeg')"
          }}
          className="rounded border"
        >
          <div
            style={{
              width: '400px',
              height: '400px',
              position: 'relative',
              margin: '0 auto',
              zIndex: 1
            }}
          >
            { gameView.positions.map(position => Player(position)) }
          </div>
        </div>
      </div>
    );
  }
}
