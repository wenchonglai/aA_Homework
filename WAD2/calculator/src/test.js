export default class PrivateClass{
  #data
  constructor(){this.#data = 0;}
  get data(){return this.#data}
  set data(val){return this.#data = val}
}