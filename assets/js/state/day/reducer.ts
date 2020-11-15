import { Actions } from "../actions"

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

/* eslint-disable-next-line default-param-last */
export function day(state = INITIAL_STATE, action: Actions): State {
  switch (action.type) {
    case "FETCH_BALANCE_DAYS_SUCCEEDED":
      return {
        days: action.days,
        usdMin: action.usdMin,
        usdMax: action.usdMax,
      }
    default:
      return state
  }
}
