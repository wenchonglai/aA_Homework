import React from 'react';

import GiphysIndex from './giphys_index';

export default (props) => {
  const [keywords, useKeywords] = React.useState([]);

  const handleChange = (e) => {
    useKeywords(e.currentTarget.value.split(' '));
  }

  const handleSubmit = (e) => {
    props.fetchSearchGiphys(keywords);
  }

  return (
    <form>
      <input
        type="text"
        value={keywords.join(' ')}
        onChange={handleChange}
      />
      <button onSubmit={handleSubmit}>Submit</button>
    </form>
  )
}