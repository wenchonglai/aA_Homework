const initialState = {
  city: "Please Select", 
  jobs: []
};

const reducer = (state = initialState, action) => {
  Object.freeze(state);
  switch (action.type){
    case 'SWITCH_LOCATION': return Object.assign({}, state, {city: action.city, jobs: action.jobs});
    default: return state;
  }
};

export default reducer;
