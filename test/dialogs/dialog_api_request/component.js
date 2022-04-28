require('../../setup');

describe("DialogApiRequest", function() {

  const helpers = require("./helpers.js");
  const c = helpers.constants;

  describe("Component", function() {
    // Note: Due to component makeup, the component is actually the
    // parent/container element to original target $node.
    var created;

    before(function(done) {
      var response = `<div class="component component-dialog" id="` + c.COMPONENT_ID + `">
                        <h3>Heading content here</h3>
                        <p>Message content here</p>
                      </div>`;

      helpers.setupView();
      created = helpers.createDialog(response, done);
    });

    after(function() {
      helpers.teardownView();
      created.$node.remove();
      created = {};
    });

    it("should have the basic HTML in place", function() {
      var $dialog = $("#" + c.COMPONENT_ID);
      var $container = $dialog.parent('[role=dialog]');

      expect($dialog.length).to.equal(1);
      expect($dialog.get(0).nodeName.toLowerCase()).to.equal("div");
      expect($dialog.hasClass("component-dialog")).to.be.true;
    });

    it("should have the component class name present", function() {
      var $dialog = $("#" + c.COMPONENT_ID);
      var $container = $dialog.parent('[role=dialog]');
      expect($container.hasClass(c.CLASSNAME_COMPONENT)).to.be.true;
    });

    it("should apply CSS classnames passed in config", function() {
      var $dialog = $("#" + c.COMPONENT_ID);
      var $container = $dialog.parent('[role=dialog]');
      expect($container.hasClass(c.CLASSNAME_1));
      expect($container.hasClass(c.CLASSNAME_2));
    });

    it("should make the $node public", function() {
      var $dialog = $("#" + c.COMPONENT_ID);
      expect(created.dialog.$node).to.exist;
      expect(created.dialog.$node.length).to.equal(1);
      expect(created.dialog.$node.get(0)).to.equal($dialog.get(0));
    });

    it("should make the instance available as data on the $node", function() {
      var $dialog = $("#" + c.COMPONENT_ID);
      expect($dialog.data("instance")).to.equal(created.dialog);
    });

    it("should make the $container public", function() {
      expect(created.dialog.$container).to.exist;
      expect(created.dialog.$container.length).to.equal(1);
      expect(created.dialog.$container.hasClass(c.CLASSNAME_COMPONENT)).to.be.true;
    });

    describe("without buttons", function() {
      const COMPONENT_ID = "dialog-without-buttonss";
      const CLASSNAME_BUTTON_TEMPLATE = "button-in-template";
      var createdWithoutButtons;

      before(function(done) {
        var response = `<div class="component component-dialog" id="` + COMPONENT_ID + `">
                        <h3>Heading content here</h3>
                        <p>Message content here</p>
                        <button class="button-in-template">Text for template button</button>
                      </div>`;

        helpers.setupView();
        createdWithoutButtons = helpers.createDialog(response, done, {
          closeOnClickSelector: ".button-in-template"
        });
      });

      after(function() {
        helpers.teardownView();
        createdWithoutButtons.$node.remove();
        createdWithoutButtons = null;
      });

      it("should not use config.buttons when using config.closeOnClickSelector", function() {
        var $dialog = $("#" + COMPONENT_ID);
        var $buttonInTemplate = $dialog.find("." + CLASSNAME_BUTTON_TEMPLATE);
        var $buttonInConfig = helpers.findButtonByText($dialog, c.TEXT_BUTTON_OK);
        var $buttons = $dialog.find("button");
        expect($buttons.length).to.equal(1);
        expect($buttonInTemplate.length).to.equal(1);
        expect($buttonInConfig.length).to.equal(0);
      });
    });

  });
});
