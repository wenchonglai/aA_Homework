import React, { useRef } from 'react'
import ReactDOM from 'react-dom'

export default function Calculator(props){
  let [currVal, setCurrVal] = React.useState(0);
  let input1 = React.useRef(undefined);
  let input2 = React.useRef(undefined);
  
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
      case 'clear': {
        input1.current.value = '';
        input2.current.value = '';
      }; break;
    }
  }

  return (
    <div className="calculator">
      <h1>{currVal}</h1>
      <form onClick={handleClick}>
        <input type="text" ref={input1} name="input1" val=""/>
        <input type="text" ref={input2} name="input2"/>

        <input type="submit" value="clear"/>

        <br/>

        {['+', '-', '*', '/'].map( symb => 
          <input type="submit" value={symb} key={symb}/>
        )}
      </form>
    </div>
  )
}