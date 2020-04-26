import { Actions } from '../actions'

export interface State {
  days: any[],
  usdMin: any[],
  usdMax: any[],
}

const INITIAL_STATE: State = {
  days: [],
  usdMin: [],
  usdMax: [],
}

export function day(state = INITIAL_STATE, action: Actions) {
  switch (action.type) {
    case 'FETCH_BALANCE_DAYS_SUCCEEDED':
      return {
        days: action.days,
        usdMin: action.usdMin,
        usdMax: action.usdMax
      }
    default:
      return state
  }
}
