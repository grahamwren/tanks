import React from 'react';

export default function Player(props) {
  const { name, position } = props;

  const colors = new Map();
  colors.set('blue', 0);
  colors.set('dark', 0);
  colors.set('green', 0);
  colors.set('red', 0);
  colors.set('sand', 0);

  let tankColor = window.localStorage.getItem(name);

  if (tankColor == null) {
    for (let i = 0; i < window.localStorage.length; i += 1) {
      const color = window.localStorage.getItem(window.localStorage.key(i));
      colors.set(color, colors.get(color) + 1);
    }

    let lowestCount = [null, Infinity];

    colors.forEach((val, key) => {
      if (val < lowestCount[1]) {
        lowestCount = [key, val];
      }
    });

    window.localStorage.setItem(name, lowestCount[0]);
    [tankColor] = lowestCount;
  }

  return (
    <img
      key={name}
      src={`/images/tank_${tankColor}.png`}
      alt=""
      style={{
        position: 'absolute',
        left: position.x,
        bottom: position.y,
        marginLeft: '-23px',
        marginBottom: '-21px',
        transform: `rotate(${position.shoot_angle}deg)`,
      }}
    />
  );
}
