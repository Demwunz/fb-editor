import { DefaultPage } from './page_default';
import { EditableContentPage } from './page_editable_content';
import { FormOverviewPage } from './page_form_overview';
import { FormListPage } from './page_form_list';
import { PublishController } from './controller_publish'


// Always runs when document ready.
//
$(document).ready(function() {
  switch(controllerAndAction()) {
    case "ServicesController#index":
    case "ServicesController#create":
         new FormListPage();
    break;

    case "ServicesController#edit":
    case "PagesController#create":
         new FormOverviewPage();
    break;

    case "PagesController#edit":
         new EditableContentPage();
    break;

    case "PublishController#index":
         new PublishController();
    break;

    default:
         console.log(controllerAndAction());
         new DefaultPage();
  }
});


function controllerAndAction() {
  var controller = app.page.controller.charAt(0).toUpperCase() + app.page.controller.slice(1);
  return controller + "Controller#" + app.page.action;
}
