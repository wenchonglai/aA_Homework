export default function setLocation(city, jobs){
  return {type: 'SWITCH_LOCATION', city, jobs};
}