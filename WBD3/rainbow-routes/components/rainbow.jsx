import React from 'react';
import {
  Route,
  Link,
  NavLink
} from 'react-router-dom';

import Red from './red';
import Green from './green';
import Blue from './blue';
import Violet from './violet';

class Rainbow extends React.Component {
  render() {
    return (
      <div>
        <h1>Rainbow Router!</h1>
        <NavLink exact activeClassName='active only' to="/red">Red</NavLink>
        <NavLink activeClassName='active' to="/green">Green</NavLink>
        <NavLink exact activeClassName='active only' to="/blue">Blue</NavLink>
        <NavLink activeClassName='active' to="/violet">Violet</NavLink>

        <div id="rainbow">
          <Route path='/red' component={Red}></Route>
          <Route path='/green' component={Green}></Route>
          <Route path='/blue' component={Blue}></Route>
          <Route path='/violet' component={Violet}></Route>
        </div>
      </div>
    );
  }
};

export default Rainbow;
