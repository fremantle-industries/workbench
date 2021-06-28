// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.css"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"

// Phoenix Live View
import {Socket} from "phoenix"
import * as phoenixLiveView from "phoenix_live_view"
import * as NProgress from "nprogress"

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"
import {hooks} from "./hooks"

// let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
// const liveSocket = new phoenixLiveView.LiveSocket("/live", Socket, {_csrf_token: csrfToken, hooks: hooks})
const liveSocket = new phoenixLiveView.LiveSocket("/live", Socket, {hooks: hooks})

window.addEventListener("phx:page-loading-start", () => NProgress.start())
window.addEventListener("phx:page-loading-stop", () => NProgress.done())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
// window.liveSocket = liveSocket
