import React from 'react';
import ReactDOM from 'react-dom';

export default function tanks_init(root, channel) {
  ReactDOM.render(<Tanks channel={channel} />, root);
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
    }

    componentDidMount() {
        document.addEventListener('keydown', (e) => this.handleKeyDown(e))
    }

    gotView(view) {
        console.log('View:', view)
        this.setState(view.game)
    }

    handleKeyDown(e) {
        switch(e.key) {
            case 'ArrowUp':
                this.channel.push('move', { direction: 'up' }).receive('ok', this.gotView.bind(this))
            case 'ArrowDown':
                this.channel.push('move', { direction: 'down' }).receive('ok', this.gotView.bind(this))
            case 'ArrowLeft':
                this.channel.push('move', { direction: 'left' }).receive('ok', this.gotView.bind(this))
            case 'ArrowRight':
                this.channel.push('move', { direction: 'right' }).receive('ok', this.gotView.bind(this))
            case 'a':
                this.channel.push('turn', { direction: 'left' }).receive('ok', this.gotView.bind(this))
            case 'd':
                this.channel.push('turn', { direction: 'right' }).receive('ok', this.gotView.bind(this))
            case ' ':
                this.channel.push('shoot').receive('ok', this.gotView.bind(this))
        }
    }

    render() {
        return <div>Hello World!</div>
    }
}