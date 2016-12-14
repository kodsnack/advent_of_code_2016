var favNum = 1364;

console.log(shortestPath(31, 39, []));
console.log(reach(1, 1, 0, []).length);

function isOdd(x, y) {
  var sum = (x*x) + (3*x) + (2*x*y) + y + (y*y) + favNum;
  return ones((sum >>> 0).toString(2)) % 2 == 1;
}

function ones(str) {
  var one = 0;
  for(char of str) {
    if (char === "1") {
      one++;
    }
  }
  return one;
}

function shortestPath(x, y, visited) {
  var point = x + "," + y;

  if(isOdd(x, y) || visited.indexOf(point) != -1 || x < 0 || y < 0 || x > 100 || y > 100) {
    return Number.MAX_VALUE;
  } else if (x == 1 && y == 1) {
    return 0;
  }

  visited.push(point);

  var left = shortestPath(x-1, y, visited.slice());
  var right = shortestPath(x+1, y, visited.slice());
  var up = shortestPath(x, y-1, visited.slice());
  var down = shortestPath(x, y+1, visited.slice());

  return 1 + Math.min(left, right, up, down);
}

function merge(a1, a2) {
  for(var point of a1) {
    if(a2.indexOf(point) == -1) {
      a2.push(point);
    }
  }
  return a2;
}

function reach(x, y, i, visited) {
  var point = x + "," + y;

  if(isOdd(x, y) || visited.indexOf(point) != -1 || x < 0 || y < 0) {
    return [];
  } else if (i > 50) {
    return visited;
  }

  i++;
  visited.push(point);

  var left = reach(x-1, y, i, visited.slice());
  var right = reach(x+1, y, i, visited.slice());
  var up = reach(x, y-1, i, visited.slice());
  var down = reach(x, y+1, i, visited.slice());

  return merge(visited, merge(left, merge(right, (merge(up, down)))));
}
