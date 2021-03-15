document.addEventListener("DOMContentLoaded", function(){
  let canvas = document.getElementById('mycanvas');
  canvas.height = canvas.width = 500;
  let ctx = canvas.getContext('2d');

  ctx.fillStyle='#ff7fbf';
  ctx.fillRect(20,20, 480, 480);

  ctx.fillStyle='#dfefff';
  ctx.strokeStyle='#bfdfff';
  ctx.lineWidth = 4;
  ctx.beginPath();
  ctx.arc(250, 250, 150, 0, Math.PI * 2);
  ctx.fill();
  ctx.stroke();

  ctx.fillStyle='#ffdf00';
  ctx.strokeStyle='#df7f00';
  ctx.beginPath();

  ctx.moveTo(250, 150);
  ctx.lineTo(250+87, 300);
  ctx.lineTo(250-87, 300);
  ctx.lineTo(250, 150);
  ctx.fill();
  ctx.stroke();

});
