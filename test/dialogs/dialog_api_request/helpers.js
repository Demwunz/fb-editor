const DialogApiRequest = require("../../../app/javascript/src/component_dialog_api_request.js");
const GlobalHelpers = require("../../helpers.js");

const constants = {
  CLASSNAME_COMPONENT: "DialogApiRequest",
  CLASSNAME_1: "classname1",
  CLASSNAME_2: "classname2",
  COMPONENT_ID: "soemthing-served-in-response",
  TEXT_BUTTON_OK: "This is ok button text",
  TEXT_BUTTON_CANCEL: "This is cancel button text",
  TEXT_HEADING: "General heading text",
  TEXT_CONTENT: "General content text"
}

const view = {
  text: {
    dialogs: {
      heading: constants.TEXT_HEADING,
      content: constants.TEXT_CONTENT
    }
  }
}

var $_get; // Used in overriding $.get (see below)



/* Creates a new dialog from only passing in an id and optional config.
 *
 * @response (String) HTML string used to mimic server response.
 * @done (Function) Mocha function used for triggering asynchronous action ready.
 * @config (Object) Optional config can be passed in to override the defaults.
 *
 * Returns the following object:
 *
 * {
 *   html: <html used in faked server response>
 *   $node: <jQuery enhanced node (before dialog instantiation) of the faked html server response>
 *   dialog: <ActivatedDialog instance created using faked server response>
 *  }
 *
 **/
function createDialog(response, ready, config) {
  var conf = {
    classes: constants.CLASSNAME_1 + " " + constants.CLASSNAME_2,
    buttons: [
      {
        text: constants.TEXT_BUTTON_OK,
        click: function() {
          console.log("ok clicked");
        }
      }, 
      {
        text: constants.TEXT_BUTTON_CANCEL,
        click: function() {
          console.log("cancel clicked");
        }
      }
    ]
  }

  // Include any passed config items.
  if(config) {
    for(var prop in config) {
      if(config.hasOwnProperty(prop)) {
        conf[prop] = config[prop];
      }
    }
  }

  $_get.html(response, ready); // Hijacks $.get and returns the response passed in.

  return {
    html: response,
    $node: $(response), // WARNING! Will not same as will be same element/node as dialog.$node
    dialog: new DialogApiRequest("/url/not/used/in/testing", conf)
  }
}


/* Set up the DOM to include template code for dialog
 * and anything else required.
 **/
function setupView() {
  $_get = new GlobalHelpers.jQueryGetOverride();
}


/* Reset DOM to pre setupView() state
 **/
function teardownView() {
  $_get.restore();
}


module.exports = {
  constants: constants,
  createDialog: createDialog,
  setupView: setupView,
  teardownView: teardownView,
  findButtonByText: GlobalHelpers.findButtonByText
}