import { createStore as createReduxStore, applyMiddleware } from 'redux'
import { composeWithDevTools } from 'redux-devtools-extension'
import { reducer } from './state'

const composeEnhancers = composeWithDevTools({})

export const createStore = () => {
  return createReduxStore(
    reducer,
    composeEnhancers(applyMiddleware(...[])),
  )
}
