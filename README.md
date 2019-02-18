# Tanks

## Socket API
To make a move, send an effect over the channel.
```js
effectPayloadSchema = {
  type: 'object',
  properties: {
    move: {
      type: 'string',
      enum: ['up', 'down', 'left', 'right']
    },
    rotate: {
      type: 'string',
      enum: ['right', 'left']
    },
    shoot: {
      type: 'boolean'
    }
  }
};

channel
  .push('effect', effectPayload)
  .receive('ack', payload => console.log('effect ack\'d', payload))
  .receive('failed', payload => console.log('effect failed', payload));
```

Whenever a user makes a move, a new user view is pushed to each user in the game
```js
userViewSchema = {
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

channel.on('view_update', userView => console.log('got new view', userView));
```