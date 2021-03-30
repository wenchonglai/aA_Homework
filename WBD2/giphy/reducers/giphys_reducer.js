import { RECEIVE_SEARCH_GIPHYS } from '../actions/giphy_actions';

export default (state = [], action) => {
  switch (action.type){
    case RECEIVE_SEARCH_GIPHYS: return action.giphys;
    default: return state;
  }
}