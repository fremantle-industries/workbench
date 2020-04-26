import { combineReducers } from 'redux'
import { all } from './all/reducer'
import { day } from './day/reducer'
import { hour }from './hour/reducer'

export const reducer = combineReducers({
  all,
  day,
  hour,
})
