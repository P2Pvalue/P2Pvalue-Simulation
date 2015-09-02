var processContribsData = function(contributorsData){

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
    }]
  };

  var roleChanges = [];

  contributorsData.forEach(
    function(cont){
      // week index
      var i = 0;
      cont.weeks.forEach(function() {

        // currentWeek saves the contributor number of contributions until that week
        var currentWeek = weeks[i] ||
          (function() {
            weeks[i] = {contribs: []};
            return weeks[i];
          })();

        currentWeek[cont.author.id]  =
          {
            num : ((i>0)? weeks[i-1][cont.author.id].num : 0) +
              cont.weeks[i].c
          };

        if (typeof total[i] === 'undefined'){
          total[i] = 0;
        }

        total[i] = total[i] + cont.weeks[i].c;

        currentWeek.contribs.push({author: cont.author.id, num: currentWeek[cont.author.id].num});
        i += 1;
      });
    });

  // week index
  var x = 0;

  // total contributions until x week in each iteration
  var weekContrib = 0;

  weeks.forEach(function(w){

    w.contribs.sort(function(a, b){
      return b.num - a.num;
    });

    var subTotal = 0;
    dat.main[0].data.push({x: x, y: 0});
    dat.comp[0].data.push({x: x, y: 0});

    weekContrib += total[x];

    w.contribs.forEach(function(c){

      if (subTotal < 0.90 * weekContrib){
        dat.main[0].data[x].y += 1;

        weeks[x][c.author].role = '1(core)';
      }
      else {
        if (c.num > 0) {
          dat.comp[0].data[x].y += 1;
        }
        weeks[x][c.author].role = '9(contributor)';
      }

      var currentRole = weeks[x][c.author].role;
      var previousRole;

      if (x>0){
        previousRole = weeks[x-1][c.author].role;
      }

      if (previousRole != currentRole) {
        roleChanges.push(
          {
            contributor: c.author,
            weekIndex: x,
            roleChange:
            {
              prev: previousRole,
              curr: currentRole
            }
          }
        );
      }

      subTotal += c.num;
    });
    x += 1;
  });

  console.log(JSON.stringify(roleChanges));

  roleChanges.forEach(function(v){
    if (v.roleChange.prev){
      console.log(v);
    }
  });

  return dat;
};

var repoContribs = function(user, repo){

  requestHandle(
    'https://api.github.com/repos/' + user + '/' + repo +'/stats/contributors',
    function(data){
      var myChart = document.getElementById('myChart');

      // clear previous plotted data
      while (myChart.firstChild) {
        myChart.removeChild(myChart.firstChild);
      }

      myChart = new xChart('bar', processContribsData(data), '#myChart');

    });
};

// Expects the URL of the get request and a function to proccess the received data
var requestHandle = function(url, callback){

  var request = new XMLHttpRequest();

  request.onload = function(){
    var data = JSON.parse(this.responseText);
    callback(data);
  };

  var oauthToken = document.getElementById('oauthtoken').value;

  if (oauthToken){
    url += '?access_token=' + oauthToken;
  }

  request.open('get', url, true);

  request.send();
  
};

var loadProcessData = function(){

  var githubUrlString =  document.getElementById('githubrepo').value;
  // expecting string of the form https://github.com/:user/:repo/
  var splitted = githubUrlString.split('/');
  var user = splitted[3];
  var repo = splitted[4];

  repoContribs(user, repo);
};
