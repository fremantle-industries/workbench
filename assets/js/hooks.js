import React from "react";
import ReactDOM from "react-dom";
import Balances from "./components/Balances";

export const hooks = {};

hooks.Balances = {
  mounted() {
    const finishTimes = parseJson(this.el, "phx-value-finish-times");
    const usdBalances = parseJson(this.el, "phx-value-usd-balances");
    const btcBalances = parseJson(this.el, "phx-value-btc-balances");
    const btcUsdPrices = parseJson(this.el, "phx-value-btc-usd-prices");

    ReactDOM.render(
      <Balances
        finishTimes={finishTimes}
        usdBalances={usdBalances}
        btcBalances={btcBalances}
        btcUsdPrices={btcUsdPrices}
      />,
      this.el
    );
  }
};

function parseJson(el, key) {
  return JSON.parse(el.getAttribute(key));
}
