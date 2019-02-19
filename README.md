# Tanks

## Socket API
```js
// Join the socket with a userName
const socket = new Socket('/', {params: {userName: 'alex'}});
socket.connect();

// Join the channel with a game name
const channel = socket.channel('game_session:my-game');

// To subscribe to updates, add a view_update handler
// views will follow the userViewSchema below
channel.on('view_update', view => console.log('got new view', view));

// To make a move, send a command over the channel.
channel.push('move', {direction: ['left'|'right'|'up'|'down']});
channel.push('turn', {direction: ['left'|'right']});
channel.push('shoot');
channel.push('get_view');

// Whenever a user makes a move, a new user view is pushed to each user in the game
const userViewSchema = {
  type: 'object',
  properties: {
    positions: {
      type: 'array',
      items: {
        type: 'object',
        properties: {
          user_name: {
            type: 'string'
          },
          position: {
            type: 'object',
            properties: {
              x: {
                type: 'integer'
              },
              y: {
                type: 'integer'
              },
              shoot_angle: {
                type: 'integer',
                minimum: 0,
                maximum: 359
              }
            },
            required: ['x', 'y', 'shoot_angle']
          }
        },
        required: ['user_name', 'position']
      }
    }
  },
  required: ['positions']
};
```