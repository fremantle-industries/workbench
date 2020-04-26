// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.scss";

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html";

// Phoenix Live View
import { Socket } from "phoenix";
import LiveSocket from "phoenix_live_view";
import NProgress from "nprogress";

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"
import { hooks } from "./hooks";

window.addEventListener('phx:page-loading-start', info => NProgress.start())
window.addEventListener('phx:page-loading-stop', info => NProgress.done())

const liveSocket = new LiveSocket("/live", Socket, { hooks: hooks });
liveSocket.connect();
