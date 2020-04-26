import React from 'react';
import ReactDOM from 'react-dom';
import { Provider } from 'react-redux';
import { createStore } from './createStore';
import BalanceAll from './components/BalanceAll';
import BalanceDay from './components/BalanceDay';
import BalanceHour from './components/BalanceHour';

const store = createStore()

export const hooks = {};

hooks.BalanceAll = {
  mounted() {
    Object.assign(this, { store })

    this.dispatchAction()

    ReactDOM.render(
      <Provider store={store}>
        <BalanceAll />
      </Provider>,
      this.el.querySelector(':first-child')
    )
  },

  updated() {
    this.dispatchAction()
  },

  dispatchAction() {
    const finishTimes = JSON.parse(this.el.dataset.finishTimes);
    const usdBalances = JSON.parse(this.el.dataset.usdBalances);
    const btcBalances = JSON.parse(this.el.dataset.btcBalances);
    const btcUsdPrices = JSON.parse(this.el.dataset.btcUsdPrices);

    this.store.dispatch({
      type: 'FETCH_ALL_SUCCEEDED',
      finishTimes,
      usdBalances,
      btcBalances,
      btcUsdPrices
    })
  }
};

hooks.BalanceDay = {
  mounted() {
    Object.assign(this, { store })

    this.dispatchAction()

    ReactDOM.render(
      <Provider store={store}>
        <BalanceDay />
      </Provider>,
      this.el.querySelector(':first-child')
    )
  },

  updated() {
    this.dispatchAction()
  },

  dispatchAction() {
    const days = JSON.parse(this.el.dataset.days);
    const usdMin = JSON.parse(this.el.dataset.usdMin);
    const usdMax = JSON.parse(this.el.dataset.usdMax);

    this.store.dispatch({
      type: 'FETCH_BALANCE_DAYS_SUCCEEDED',
      days,
      usdMin,
      usdMax,
    })
  }
}

hooks.BalanceHour = {
  mounted() {
    Object.assign(this, { store })

    this.dispatchAction()

    ReactDOM.render(
      <Provider store={store}>
        <BalanceHour />
      </Provider>,
      this.el.querySelector(':first-child')
    )
  },

  updated() {
    this.dispatchAction()
  },

  dispatchAction() {
    const hours = JSON.parse(this.el.dataset.hours);
    const usdMin = JSON.parse(this.el.dataset.usdMin);
    const usdMax = JSON.parse(this.el.dataset.usdMax);

    this.store.dispatch({
      type: 'FETCH_BALANCE_HOURS_SUCCEEDED',
      hours,
      usdMin,
      usdMax,
    })
  }
}
