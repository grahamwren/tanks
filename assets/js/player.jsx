import React, {Fragment} from 'react';

const tankRotate = {
  up: 90,
  right: 180,
  down: 270,
  left: 0
};

export default function Player(props) {
  const {name, position, health, direction} = props;

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
    <div key={name}>
      <img
        src={health <= 0 ? '/images/explosion.png' : `/images/tank_${tankColor}.png`}
        alt=""
        style={{
          width: '42px',
          height: '42px',
          position: 'absolute',
          left: position.x,
          bottom: position.y,
          marginLeft: '-21px',
          marginBottom: '-21px',
          transform: `rotate(${tankRotate[direction]}deg)`,
        }}
      />
      {health > 0 &&
       <Fragment>
         <img
           src={`/images/tank_${tankColor}_barrel.png`}
           alt=""
           style={{
             position: 'absolute',
             left: position.x,
             bottom: position.y,
             paddingLeft: '30px',
             marginLeft: '-30px',
             marginBottom: '-8px',
             transform: `rotate(${-position.shoot_angle}deg)`,
             zIndex: 1
           }}
         />
         <div
           className="card text-center text-nowrap"
           style={{
             position: 'absolute',
             left: position.x,
             bottom: position.y - 50,
             padding: 0,
             marginLeft: '-40px',
             width: '80px'
           }}
         >
           {name}
         </div>
         <div
           className="text-center text-nowrap"
           style={{
             position: 'absolute',
             left: position.x,
             bottom: position.y + 25,
             padding: 0,
             marginLeft: '-50px',
             width: '100px'
           }}
         >
           Health:
           {' '}
           {health}
         </div>
       </Fragment>}
    </div>
  );
}
