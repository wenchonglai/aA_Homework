import { connect } from 'react-redux';
import GiphysSearch from './giphys_search';
import { fetchSearchGiphys } from '../actions/giphy_actions';

const mapStateToProps = ({giphys}) => {
  return {
    giphys
  };
};

const mapDispatchToProps = (dispatch) => {
  return {
    fetchSearchGiphys: (...keywords) => dispatch(fetchSearchGiphys(...keywords))
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(GiphysSearch);