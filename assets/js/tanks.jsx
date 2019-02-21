import React from 'react';
import ReactDOM from 'react-dom';

export default function tanks_init(root, channel) {
  ReactDOM.render(<Tanks channel={channel} />, root);
}

class Tanks extends React.Component {
    constructor(props) {
        super(props)
        this.state = {}
    }

    render() {
        return <div>Hello World!</div>
    }
}