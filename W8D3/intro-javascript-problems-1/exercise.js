function mysteryScoping1() {
  var x = 'out of block';
  if (true) {
    var x = 'in block';   
    console.log(x);       
  }
  console.log(x);         
}
//  in block
//  out of block

function mysteryScoping2() {
  const x = 'out of block';
  if (true) {
    const x = 'in block';  
    console.log(x);
  }
  console.log(x);
}
//  in block
//  out of block

function mysteryScoping3() {
  let x = 'out of block';
  if (true) {
    var x = 'in block';  
    console.log(x);
  }
  console.log(x);
}
//  error; var declaration cannot be in a nested scope if const/let declaration of the same variable is in the outer scope

function mysteryScoping4() {
  let x = 'out of block';
  if (true) {
    let x = 'in block';  
    console.log(x);
  }
  console.log(x);
}

//  in block
//  out of block

function mysteryScoping5() {
  let x = 'out of block';
  if (true) {
    let x = 'in block';  
    console.log(x);
  }
  let x = 'out of block again';
  console.log(x);
}
//  error; there cannot be more than one let/const declarations within the same scope

const madLib = (v, adj, n) =>
  `We shall ${v.toUpperCase()} the ${adj.toUpperCase()} ${n.toUpperCase()}.`;

const isSubstring = (searchString, subString) => {
  let l1 = searchString.length;
  let l2 = subString.length;

  for (let i = 0, iMax = l1 - l2; i < iMax; i += 1){
    if (searchString.substr(i, l2) === subString) return true;
  }

  return false;
};

const fizzBuzz = (array) => array.filter((el) => (el % 3 === 0) ^ (el % 5 === 0))

const isPrime = (n) => {
  if (n > 2 && n % 2 === 0) return false;
  if (n === 2) return true;

  for (let i = 3, iMax = n ** 0.5 | 0; i <= iMax; i += 2)
    if (n % i == 0)
      return false
  
  return n > 2 && (n === (n | 0)) ? true : false;
}

const sumOfNPrimes = (n) => {
  if (n <= 0) return 0;

  for (let sum = 2, count = 1, num = 3; ; num += 2){
    if (count === n) return sum;

    if (isPrime(num)){
      count += 1;
      sum += num;
    }
  }
}