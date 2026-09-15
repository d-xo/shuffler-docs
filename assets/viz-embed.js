// Child-side height reporter for embedded visualizations.
// Include this from any standalone viz that will be embedded via <iframe class="viz">.
// It posts the document height to the parent whenever it changes so the iframe
// can be sized to its content. Harmless when the viz is opened directly (no parent).
(function () {
  function height() {
    var d = document.documentElement, b = document.body;
    return Math.max(d.scrollHeight, b ? b.scrollHeight : 0);
  }
  function send() {
    parent.postMessage({ type: "viz-height", height: height() }, "*");
  }
  window.addEventListener("load", send);
  if (window.ResizeObserver) {
    new ResizeObserver(send).observe(document.documentElement);
  } else {
    window.addEventListener("resize", send);
  }
})();
