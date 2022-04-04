/**
 * Activated Content Menu Component
 * ----------------------------------------------------
 * Description:
 * Enhances Activated Menu component for specific Content Property Menu.
 *
 * Documentation:
 *
 *     - jQueryUI
 *       https://api.jqueryui.com/menu
 *
 *     - TODO:
 *       (steven.burnell@digital.justice.gov.uk to add).
 *
 **/


const utilities = require('./utilities');
const safelyActivateFunction = utilities.safelyActivateFunction;
const mergeObjects = utilities.mergeObjects;
const ActivatedMenu = require('./component_activated_menu');


class ContentMenu extends ActivatedMenu {
  constructor(component, $node, config) {
    super($node, mergeObjects({
      container_classname: "ContentMenu",
      activator_text: ""
    }, config));

    $node.on("menuselect", (event,ui) => {
        this.selection(event, ui.item);
    });

    if(component.$node.length) {
      component.$node.prepend(this.activator.$node);
      component.$node.on("focus.contentmenu", () => this.activator.$node.addClass("active"));
      component.$node.on("blur.contentmenu", () => this.activator.$node.removeClass("active"));
    }

    this.container.$node.addClass("ContentMenu");
    this.component = component;
  }  

  selection(event, item) {
    var action = item.data("action");
    this.selectedItem = item;

    event.preventDefault();
    switch(action) {
      case "open":
        this.open();
      case "remove":
        this.remove();
        break;
      case "close":
        this.close();
        break;
    }
  }

  open(config) {
    if(this.component) {
      this.component.$node.addClass("active");
    }
    super.open(config);
  }

  close() {
    if(this.component) {
      this.component.$node.removeClass("active");
    }
    super.close();
  }

  remove() {
    $(document).trigger("ContentMenuSelectionRemove", this.component);
  }
}


module.exports = ContentMenu;
