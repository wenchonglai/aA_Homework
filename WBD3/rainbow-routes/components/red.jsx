import React from 'react';
import { Route, NavLink } from 'react-router-dom';
import Orange from './orange';
import Yellow from './yellow';

class Red extends React.Component {
  render() {
    return(
      <div>
        <h2 className="red"></h2>
        <NavLink to='/red/orange'>Orange</NavLink>
        <NavLink to='/red/yellow'>Yellow</NavLink>

        <Route path='/red/orange' component={Orange}></Route>
        <Route path='/red/yellow' component={Yellow}></Route>
      </div>
    );
  }
};

export default Red;
