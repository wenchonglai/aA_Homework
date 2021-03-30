export const fetchSearchGiphys = (...keywords) => (
  $.ajax({
    url: `http://api.giphy.com/v1/gifs/search?q=${keywords.join('+')}&api_key=EawPH4eYdOBfLW1LuEinQZ0M1eRIMWRA&limit=2`
  })
);

// fetchSearchGiphys('cute', 'bunny').then(res => console.log(res));