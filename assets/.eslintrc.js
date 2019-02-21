const path = require('path')
module.exports = {
    'extends': 'airbnb',
    'parser': 'babel-eslint',
    'globals': {
        'window': true,
        'document': true
    },
    'settings': {
        'import/resolver': {
            'webpack': {
                'config': path.join(__dirname, 'webpack.config.js')
            }
        }
    },
    'rules': {
        'comma-dangle': 0,
        'no-console': 0,
        'react/prop-types': 0,
        'no-unused-vars': [2, {'args': 'after-used', 'argsIgnorePattern': '^_'}]
    }
}