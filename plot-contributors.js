var processData = function(data){
  var weeks = [];
  var total = [];
  var dat = {
    "xScale": "ordinal",
    "yScale": "linear",
    "type": "line-dotted",
    "main": [{
      "type": "line-dotted",
      "data": []
    }],
    "comp": [{
      "type": "line-dotted",
      "data": []
    }],
  };
  d = JSON.parse(data);
  d.forEach(
    function(cont){
      var i = 0;
      cont.weeks.forEach(function() {
        var currentWeek = weeks[i] || 
          function() {
            (weeks[i] = {contribs: []});
            return weeks[i];
          }();

        currentWeek[cont.author.id]  = 
          ((i>0)? weeks[i-1][cont.author.id] : 0) + 
          cont.weeks[i].c;
        
        if (typeof total[i] === 'undefined'){
            total[i] = 0;
        }

        total[i] = total[i] + cont.weeks[i].c;

        currentWeek.contribs.push( currentWeek[cont.author.id]);
        i += 1;
      });
    });

  var x = 0;
  var weekContrib = 0;
  weeks.forEach(function(w){
    w.contribs.sort(function(a, b){
      return b - a;
    });
    var subTotal = 0;
    dat.main[0].data.push({x: x, y: 0});
    dat.comp[0].data.push({x: x, y: 0});

    weekContrib += total[x];
    w.contribs.forEach(function(c){

      if (subTotal < 0.90 * weekContrib){
        dat.main[0].data[x].y += 1;
      }
      else if (c > 0) {
        dat.comp[0].data[x].y += 1;
      }
      subTotal += c;
    });
    x += 1;
  });

  return dat;
};

var loadRepo = function(){
  var githubUrlString =  document.getElementById('githubrepo').value;
  // expecting string of the form https://github.com/:user/:repo/
  var splitted = githubUrlString.split('/');
  var user = splitted[3];
  var repo = splitted[4];

  var request = new XMLHttpRequest();

  request.onload = function() {
    var response = this.responseText;
    var myChart = document.getElementById('myChart');
    while (myChart.firstChild) {
      myChart.removeChild(myChart.firstChild);
    }
    myChart = new xChart('bar', processData(response), '#myChart');
  };
  
  request.open('get', 'https://api.github.com/repos/' + user + '/' + repo +'/stats/contributors', true);

  request.send();
};
