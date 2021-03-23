import React from 'react'
import ReactDOM from 'react-dom'

export default function Calculator(props){
  let [currVal, setCurrVal] = React.useState(0);
  
  function handleClick(e){
    e.preventDefault();

    let formData = new FormData(e.currentTarget);

    let val1 = Number( formData.get('input1') ) || 0;
    let val2 = Number( formData.get('input2') ) || 0;
    
    switch (e.target.value){
      case '+': setCurrVal(val1 + val2); break;
      case '-': setCurrVal(val1 - val2); break;
      case '*': setCurrVal(val1 * val2); break;
      case '/': setCurrVal(val1 / val2); break;
      case 'clear': setCurrVal(5); break;
    }
  }

  return (
    <div className="calculator">
      <h1>{currVal}</h1>
      <form onClick={handleClick}>
        <input type="text" name="input1"/>
        <input type="text" name="input2"/>

        <input type="submit" value="clear"/>

        <br/>

        <input type="submit" value="+"/>
        <input type="submit" value="-"/>
        <input type="submit" value="*"/>
        <input type="submit" value="/"/>
      </form>
    </div>
  )
}