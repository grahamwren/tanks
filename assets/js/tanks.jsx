import React from 'react';
import ReactDOM from 'react-dom';

export default function tanks_init(root, channel) {
  ReactDOM.render(<Tanks channel={channel} />, root);
}

const m = {
    ArrowRight: (channel, cb) => channel.push('move', { direction: 'right' }).receive('ok', cb),
    ArrowLeft: (channel, cb) => channel.push('move', { direction: 'left' }).receive('ok', cb),
    ArrowUp: (channel, cb) => channel.push('move', { direction: 'up' }).receive('ok', cb),
    ArrowDown: (channel, cb) => channel.push('move', { direction: 'down' }).receive('ok', cb),
    a: (channel, cb) => channel.push('turn', { direction: 'left' }).receive('ok', cb),
    d:  (channel, cb)=> channel.push('turn', { direction: 'right' }).receive('ok', cb),
    ' ': (channel, cb) => channel.push('shoot').receive('ok', cb)
}
class Tanks extends React.Component {
    constructor(props) {
        super(props)
        this.channel = props.channel
        this.state = {}

        this.channel
            .join()
            .receive('ok', this.gotView.bind(this))
            .receive('error', resp => { console.log('Unable to join', resp); })
        
        this.channel.on('view_update', this.gotView.bind(this))
    }

    componentDidMount() {
        document.addEventListener('keydown', (e) => (m[e.key] || (()=>{}))(this.channel, this.gotView.bind(this)))
    }

    gotView(view) {
        console.log('View:', view)
        this.setState(view.game)
    }

    render() {
        return <div>Hello World!</div>
    }
}