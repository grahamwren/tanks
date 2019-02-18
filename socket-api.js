// to make a move, send a effect message
let channel = {};
let effectPayload = {};
channel.push('effect', effectPayload);

let effectPayloadSchema = {
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

let userViewSchema = {
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
