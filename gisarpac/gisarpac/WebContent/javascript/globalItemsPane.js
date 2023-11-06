function resizeGlobalItemsPane(view) {
  window.frames[0].location.href=
    "Layout.do?command=ResizeGlobalItemsPane&view=" + view;
}
function showGlobalItemsPane() {
  hideSpan("globalItemsShow");
  showSpan("globalItemsHide");
  showSpan("rightcol");
}
function hideGlobalItemsPane() {
  hideSpan("globalItemsHide");
  hideSpan("rightcol");
  showSpan("globalItemsShow");
}
