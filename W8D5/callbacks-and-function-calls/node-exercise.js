let readline = require("readline");

let reader = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

// reader.question("Would you like some tea?", (answer) => {
//   if (answer === 'yes'){
//     console.log("one moment");
//   } else {
//     console.log("okay");
//   }

//   reader.close();
// });

function teaAndBiscuits(){
  let first, second;

  reader.question("Would you like some tea?", (answer) => {
    first = answer;

    reader.question("Would you like some biscuit?", (answer) => {
      second = answer;

      console.log(`so you${first === 'yes' ? '' : " don't"} want tea and${second === 'yes' ? '' : " don't"} want biscuit.`);

      reader.close();
    });
  });
  
}

// teaAndBiscuits();

async function _tAndB(){
  let first, second;

  first = await new Promise( res => {
    reader.question("Would you like some tea?", (answer) => {
      res(answer);
    })
  });

  second = await new Promise( res => {
    reader.question("Would you like some coffee?", (answer) => {
      res(answer);
    })
  });

  console.log(`so you${first === 'yes' ? '' : " don't"} want tea and${second === 'yes' ? '' : " don't"} want biscuit.`);

  reader.close();
}

_tAndB();