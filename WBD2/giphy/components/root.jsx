import React from 'react';
import { Provider } from 'react-redux';

import GiphysSearchContainer from './giphys_search_container';

export default (store) => (
  <Provider store={store}>
    <GiphysSearchContainer />
  </Provider>
);
