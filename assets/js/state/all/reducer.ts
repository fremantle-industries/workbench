import { Actions } from '../actions'

export interface State {
  finishTimes: any[],
  usdBalances: any[],
  btcBalances: any[],
  btcUsdPrices: any[]
}

const INITIAL_STATE: State = {
  finishTimes: [],
  usdBalances: [],
  btcBalances: [],
  btcUsdPrices: []
}

export function all(state: State = INITIAL_STATE, action: Actions) {
  switch (action.type) {
    case 'FETCH_ALL_SUCCEEDED':
      return {
        finishTimes: action.finishTimes,
        usdBalances: action.usdBalances,
        btcBalances: action.btcBalances,
        btcUsdPrices: action.btcUsdPrices
      }
    default:
      return state
  }
}
