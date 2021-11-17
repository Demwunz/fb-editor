/**
 * FlowConnectorPath Component
 * ----------------------------------------------------
 * Description:
 * Creates elements required for arrows/lines connecting Flow Item in an overview
 *
 * Documentation:
 *
 *     - jQueryUI
 *       https://api.jqueryui.com/dialog
 *
 *     - TODO:
 *       (steven.burnell@digital.justice.gov.uk to add).
 *
 **/


const utilities = require('./utilities');
const CURVE_SPACING = 20;
const CURVE_COORDS_UP = "a10,10 0 0 0 10,-10";
const CURVE_COORDS_RIGHT = "a10,10 0 0 1 10,-10";


/* VIEW SPECIFIC COMPONENT:
 * ------------------------
 *
 * @points (Object) Points required for ConnectorPath dimensions {
 *                      lX & lY: 'from' x+y points
 *                      rX & rY: 'to' x+y points
 *                  }
 * @config (Object) Configurations {
 *                      from: id of starting item
 *                      to: 'next' value of destination item
 *                      $container: jQuery node for appending element.
 *                      space: Number to add before and after start and end points
 *                             (allows for border compensation of existing css)
 *                  }
 **/
class FlowConnectorPath {
  constructor(points, config) {
    points.xDifference = utilities.difference(points.from_x, points.to_x);
    points.yDifference = utilities.difference(points.from_y, points.to_y);

    this._config = config;
    this.points = points;
    this.type = calculateType(points);
    this.$node = buildByType.call(this);

    this.$node.addClass("FlowConnectorPath")
              .attr("height", "0")
              .attr("width", "0")
              .attr("data-from", config.from_id)
              .attr("data-to", config.to_id)
              .addClass(this.type); // TODO: Remove after development because this serves no other purpose
  }
}

function calculateType(points) {
  var sameRow = points.yDifference < 5; // 5 is to give some tolerance for a pixel here or there
                                        // (e.g. some difference calculations  came out as 2)
  var forward = points.from_x < points.to_x;
  var up = points.from_y > points.to_y;
  var type;

  if(sameRow) {
    if(forward) {
      type = "ForwardPath";
    }
    else {
      type = "BackwardPath";
    }
  }
  else {
    if(forward) {
      if(up) {
        type = "ForwardUpPath";
      }
      else {
        type = "ForwardDownPath";
      }
    }
    else {
      if(up) {
        type = "BackwardUpPath";
      }
      else {
        type = "BackwardDownPath";
      }
    }
  }
  return type;
}


function buildByType(type) {
  var points = this.points;
  var paths = "";

  switch(this.type) {
    case "BackwardPath":
         // TODO...
    case "BackwardDownPath":
         // TODO...
         break;
    case "BackwardUpPath":
         // TODO...
         break;
    case "ForwardPath":
         paths = createPathsForForwardConnector.call(this);
         break;
    case "ForwardUpPath":
         // TODO... in progress
         paths = createPathsForForwardUpConnector.call(this);
         break;
    case "ForwardUpForwardDownPath":
         // TODO... not done yet
//         createElementsForForwardUpForwardDownPath.call(this);
//         $container.append($container);
         break;
    default:
         // TODO: What will default be (forward??)
         console.log("DEFAULT: ", JSON.stringify(points).replace("\\", ""));
  }

  return createSvg(paths);
}

function createSvg(paths) {
  const SVG_TAG_OPEN = "<svg xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\">";
  const SVG_TAG_CLOSE = "</svg>";
  var svg = SVG_TAG_OPEN + paths + SVG_TAG_CLOSE;
  return $(svg)
}

function createArrowPath(x, y) {
  return "<path class=\"arrowPath\"  d=\"M " + (x - 10) + "," + (y - 5) + " v10 l 10,-5 z\"></path>";
}

function pathD(/* unlimited */) {
  var path = "M";
  for(var i=0; i<arguments.length; ++i) {
    path += (" " + arguments[i]);
  }
  return path;
}

function xy(x, y) {
  return String(x) + "," + String(y);
}

function createPathsForForwardConnector() {
  var points = this.points;
  var x = points.from_x;
  var y = (points.from_y < points.to_y ? points.from_y + points.yDifference : points.from_y - points.yDifference);
  var width = "h" + points.xDifference;
  var paths = "<path d=\"" + pathD(xy(x, y), width) + "\"></path>";
  paths += createArrowPath(x + points.xDifference, y);
  return paths;
}

function createPathsForForwardUpConnector() {
  var points = this.points;
  var vertical = "v-" + (points.yDifference - CURVE_SPACING);
  var horizontal = "h" + (points.xDifference - (CURVE_SPACING * 2));
  var paths = "<path d=\"" + pathD(xy(points.from_x, points.from_y), horizontal, CURVE_COORDS_UP, vertical, CURVE_COORDS_RIGHT) + "\"></path>";
  return paths;
}

function createElementsForForwardUpForwarDownPath() {
  var $line1 = $(STANDARD_LINE).addClass(LINE_X_CLASS);
  var $line2 = $(STANDARD_LINE).addClass(LINE_Y_CLASS);
  var $line3 = $(STANDARD_LINE).addClass(LINE_Y_CLASS);
  var $line4 = $(STANDARD_LINE).addClass(LINE_X_CLASS);
  var $curve1 = $(STANDARD_CURVE);
  var $curve2 = $(STANDARD_CURVE);
  var $curve3 = $(STANDARD_CURVE);
  var $curve4 = $(STANDARD_CURVE);

  this.$node.addClass("ForwardUpForwardDownPath")
            .append($line1)
            .append($line2)
            .append($line3)
            .append($line4)
            .append($curve1)
            .append($curve2)
            .append($curve3)
            .append($curve4);
}


// Make available for importing.
module.exports = FlowConnectorPath;
