import { FetchAllSucceededAction } from './all/actions'
import { FetchBalanceDaysSucceededAction } from './day/actions'
import { FetchBalanceHoursSucceededAction } from './hour/actions'

export type Actions =
  FetchAllSucceededAction
  | FetchBalanceDaysSucceededAction
  | FetchBalanceHoursSucceededAction
