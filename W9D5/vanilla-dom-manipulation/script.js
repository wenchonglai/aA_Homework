dodocument.addEventListener("DOMContentLoaded", () => {
  // toggling restaurants

  const toggleLi = (e) => {
    const li = e.target;
    if (li.className === "visited") {
      li.className = "";
    } else {
      li.className = "visited";
    }
  };

  document.querySelectorAll("#restaurants li").forEach((li) => {
    li.addEventListener("click", toggleLi);
  });



  // adding SF places as list items

  // --- your code here!
  document.querySelectorAll("form").forEach((el) => {
    el.addEventListener("submit", (e) => {
      e.preventDefault();
      let formData = new FormData(e.currentTarget);

      let li = document.createElement('li');

      li.innerHTML = formData.get('place');
      
      document.getElementById('sf-places').appendChild(li);
    })
  });



  // adding new photos

  // --- your code here!
  let hiddenForm = document.querySelector('.photo-form-container');

  document.querySelectorAll('.photo-show-button').forEach(el => {
    el.addEventListener('click', e => {
      hiddenForm.classList.toggle('hidden');
    })
  })

  hiddenForm.addEventListener('submit', e => {
    let formData = new FormData(e.target);

    let img = document.createElement('img');
    let li = document.createElement('li');

    img.setAttribute('src', formData.get("url"));
    img.setAttribute('alt', formData.get("url"));
    
    li.appendChild(img);
    document.querySelector('.dog-photos').appendChild(li);
  })


});
