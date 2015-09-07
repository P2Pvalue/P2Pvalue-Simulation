var adjacencyList = {};
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

  var csv = [];
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

      csv[x] = [dat.main[0].data[x].y, dat.comp[0].data[x].y];

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
  
  var csvText = "";
  csv.forEach(function(d){
    csvText += d[0] + ", " + d[1] + "\n";
  });

  console.log(csvText);
  document.getElementById('contributors-data').setAttribute('href', 'data:application/csv;charset=utf-8,'+encodeURI(csvText));
//  console.log(JSON.stringify(roleChanges));

  roleChanges.forEach(function(v){
    if (v.roleChange.prev){
      console.log(v);
    }
  });

  console.log(dat);
  console.log(weeks);

  return dat;
};

var updateAdjacencyList = function(nodes, adjacencyList){
  for(var userKey1 in nodes){
    if (nodes.hasOwnProperty(userKey1)){

      if (!adjacencyList[userKey1]){
        adjacencyList[userKey1] = {};
      }

      for(var userKey2 in nodes){
        if (Math.random() < 0.5 && nodes.hasOwnProperty(userKey2) && userKey2!==userKey1){

          if (!adjacencyList[userKey2]){
            adjacencyList[userKey2] = {};
          }

          adjacencyList[userKey1][userKey2] = 
            (adjacencyList[userKey1][userKey2] || 0) + 1;
          adjacencyList[userKey2][userKey1] = adjacencyList[userKey1][userKey2];

        }
      }
    }
  }
};

var repoContribs = function(user, repo){

  requestHandle(
    'https://api.github.com/repos/' + user + '/' + repo +'/stats/contributors',
    function(data){
      var myChart = document.getElementById('myChart');
      
      document.getElementById('contributors-data').removeAttribute('href');
      document.getElementById('friends-data').removeAttribute('href');
      // clear previous plotted data
      while (myChart.firstChild) {
        myChart.removeChild(myChart.firstChild);
      }
      contributorsData = data;
      myChart = new xChart('bar', processContribsData(data), '#myChart');

    });
};

var repoEvents = function(user, repo) {
  var involvedInIssue = {};
  requestHandle(
    'https://api.github.com/repos/' + user + '/' + repo + '/issues/events',
    function(data) {
      data.forEach(function(d){
        if (d.issue && !involvedInIssue[d.issue.url]){
          involvedInIssue[d.issue.url] = {};
        }
        // there are corrupted data without actors, for instance when user mention an user that do not exists
        if(d.actor !== null){
          involvedInIssue[d.issue.url][d.actor.login] = true;
        }
      });

      for (var issueKey in involvedInIssue){
        if (involvedInIssue.hasOwnProperty(issueKey)){
          updateAdjacencyList(involvedInIssue[issueKey], adjacencyList);
        }
      }

      console.log(adjacencyList);

      numFriends = [];
      for (var k in adjacencyList){
        if (adjacencyList.hasOwnProperty(k)){
          console.log(Object.keys(adjacencyList[k]).length, adjacencyList[k]);
          numFriends.push(Object.keys(adjacencyList[k]).length);
        }
      }
      sortedFriendsNumbers = numFriends.sort(function(a, b){
        return b - a;
      });

      document.getElementById('friends-data')
        .setAttribute('href', 'data:application/csv;charset=utf-8,'+encodeURI(sortedFriendsNumbers.toString()));
      console.log(sortedFriendsNumbers.toString());

    }); 

};

var repoFriends = function(user, repo) {
  var involvedInIssue = {};
//  console.log('contributors', contributorsData, repo);

  var handler = function(login) {
    return function(data){
     // console.log(JSON.stringify(data));
      data[0].items.forEach(function(d){
        if (!involvedInIssue[d.url]){
          involvedInIssue[d.url] = {};
        }
        involvedInIssue[d.url][login] = true;
      });
    };
  };


  contributorsData.forEach(function(contrib){

    requestHandle(
      'https://api.github.com/search/issues' +
        '?q=involves:' + contrib.author.login + '+repo:' + user + '/' + repo + '&sort=created&order=asc',
      handler(contrib.author.login));
  });

  for (var issueKey in involvedInIssue){
    if (involvedInIssue.hasOwnProperty(issueKey)){
      updateAdjacencyList(involvedInIssue[issueKey], adjacencyList);
    }
  }

//  console.log(adjacencyList);
};

// Expects the URL of the get request and a function to proccess the received data
// Parsing link headers, source: https://gist.github.com/niallo/3109252
function parse_link_header(header) {
  if (header.length === 0) {
    throw new Error("input must not be of zero length");
  }

  // Split parts by comma
  var parts = header.split(',');
  var links = {};
  // Parse each part into a named link
  for(var i=0; i<parts.length; i++) {
    var section = parts[i].split(';');
    if (section.length !== 2) {
      throw new Error("section could not be split on ';'");
    }
    var url = section[0].replace(/<(.*)>/, '$1').trim();
    var name = section[1].replace(/rel="(.*)"/, '$1').trim();
    links[name] = url;
  }
  return links;
}

var requestHandle = function(url, callback){

  var request = new XMLHttpRequest();
  var responseData = [];
  var numResponses = 0;
  function iterateResponsePages() {
    numResponses = 1;
    responseData = responseData.concat(JSON.parse(this.responseText));
    'https://api.github.com/repositories/2776635/issues/events?per_page=100&access_token=26d3476d9b2ea397664ac201271e7b32a3c23a87&page=110'
    var header = this.getResponseHeader('Link');
//    console.log(header);
    if (header && header !== null) {
      var parsedLink = parse_link_header(header);
      if (parsedLink.last){
        var lastPage = parsedLink.last.split('&page=')[1];
        console.log('LAST!', lastPage);

        for (var i = 2; i <= lastPage; i++){
          var r = new XMLHttpRequest();
          r.onload = function(){
            responseData = responseData.concat(JSON.parse(this.responseText));
            numResponses +=1;
            if (numResponses == lastPage){
              console.log('FOO!!!');
              callback(responseData);
            }
          };
          r.open('get', parsedLink.last.split('&page=')[0] + '&page=' + i, true);
          r.send();
        }
      } else {
//        console.log(parsedLink, responseData);
//        callback(responseData);
      }
    } else {
//      console.log(responseData);
      callback(responseData);
    }
  };

  request.onload = iterateResponsePages;

  var oauthToken = document.getElementById('oauthtoken').value;

  url += (url.indexOf('?') < 0)? '?':'&';
  url += 'per_page=100';
  if (oauthToken){
    url += '&access_token=' + oauthToken;
  }

  request.open('get', url, false);

  request.send();

};

var loadProcessData = function(){

  var githubUrlString =  document.getElementById('githubrepo').value;
  // expecting string of the form https://github.com/:user/:repo/
  var splitted = githubUrlString.split('/');
  var user = splitted[3];
  var repo = splitted[4];

  repoContribs(user, repo);
  repoEvents(user, repo);
//  repoFriends(user, repo);
};
