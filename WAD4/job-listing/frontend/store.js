
import {createStore} from 'redux'
import reducer from './reducer.js'

let store = createStore(reducer);

export default store;