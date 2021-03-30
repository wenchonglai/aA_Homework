import React from 'react';
import ReactDOM from 'react-dom';
import configureStore from './store/store';
import Root from './components/root';
import * as APIUtil from './util/api_util'
import * as GiphyActions from './actions/giphy_actions'

document.addEventListener('DOMContentLoaded', () => {
  const store = configureStore();

  ReactDOM.render(<Root />, document.getElementById('root'));
});