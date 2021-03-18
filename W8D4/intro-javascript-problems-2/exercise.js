function titleize(names, callback){
  names
    .map(name => `Mx. ${name} Jingleheimer Schmidt`)
    .forEach(x => callback(x))
}

// titleize(["Mary", "Brian", "Leo"], x => {console.log(x)});

function Elephant(name, height, ...tricks){
  this._name = name;
  this._height = height;
  this._tricks = tricks;
}

Object.defineProperties(Elephant.prototype, {
  name: {
    get: function(){ return this._name },
    set: function(val){ return this._name = val; }
  },
  height: {
    get: function(){ return this._height },
    set: function(val){ return this._height = val; }
  },
  trumpet: {
    value: function(){ console.log(`${this.name} the elephant goes 'phrRRRRRRRRRRR!!!!!!!!'`) }
  },
  grow: {
    value: function(){ return this.height += 12; }
  },
  addTricks: {
    value: function(...tricks){ this._tricks.push(...tricks); }
  },
  play: {
    value: function(){
      trick = this._tricks[(Math.random() * this._tricks.length) | 0];
      console.log(`${this.name} is ${trick}`);
    }
  }
});

// elephant = new Elephant('Dobby', 120, 'eating rice');

// console.log(elephant.name, elephant.height);

// elephant.trumpet();

// elephant.grow();

// elephant.play();

// console.log(elephant.height);

// elephant.addTricks('pretending not to be an elephant', 'not jumping');

// elephant.play();

// elephant.play();

let ellie = new Elephant("Ellie", 185, ["giving human friends a ride", "playing hide and seek"]);
let charlie = new Elephant("Charlie", 200, ["painting pictures", "spraying water for a slip and slide"]);
let kate = new Elephant("Kate", 234, ["writing letters", "stealing peanuts"]);
let micah = new Elephant("Micah", 143, ["trotting", "playing tic tac toe", "doing elephant ballet"]);

let herd = [ellie, charlie, kate, micah];

Elephant.paradeHelper = function(elephant){
  console.log(`${elephant.name} is trotting by!`);
}

herd.forEach(elephant => Elephant.paradeHelper(elephant))

function dinerBreakfast(){
  foods = ['cheesy scrambled eggs'];
  joinSentence = () => `I'd like ${foods.join(' and ')} please.`

  console.log(joinSentence());

  return function(food){
    if (food !== undefined) foods.push(food);

    console.log(joinSentence());
  }

}

let bfastOrder = dinerBreakfast();

bfastOrder("chocolate chip pancakes");
bfastOrder("grits");