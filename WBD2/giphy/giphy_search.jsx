import React from 'react';
import ReactDOM from 'react-dom';
import configureStore from './store/store';
import Root from './components/root';
import * as APIUtil from './util/api_util'
import * as GiphyActions from './actions/giphy_actions'

document.addEventListener('DOMContentLoaded', () => {
  const store = configureStore();
  window.store = store
  window.fetchSearchGiphys = GiphyActions.fetchSearchGiphys;
  

  ReactDOM.render(<div></div>, document.getElementById('root'));
});