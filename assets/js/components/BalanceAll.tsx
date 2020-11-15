import * as React from "react"
import { connect, MapStateToProps } from "react-redux"
import * as reactChartjs from "react-chartjs-2"
import * as chartjs from "chart.js"

enum Color {
  Usd = "#50ee61",
  Btc = "#ffc332",
  BtcUsd = "#727DF5"
}

enum AxisId {
  Usd = "usd",
  Btc = "btc",
  BtcUsd = "btc_usd"
}

/* eslint-disable-next-line @typescript-eslint/no-empty-interface */
interface OwnProps {
}

interface StateProps {
  finishTimes: any[]
  usdBalances: any[]
  btcBalances: any[]
  btcUsdPrices: any[]
}

interface Props extends OwnProps, StateProps {}

const BalanceAll: React.FC<Props> = ({ finishTimes, usdBalances, btcBalances, btcUsdPrices }) => {
  const usdDataset: chartjs.ChartDataSets = dataset("USD Balance", AxisId.Usd, Color.Usd, usdBalances)
  const btcDataset: chartjs.ChartDataSets = dataset("BTC Balance", AxisId.Btc, Color.Btc, btcBalances)
  const btcUsdDataset: chartjs.ChartDataSets = dataset("BTC/USD Price", AxisId.BtcUsd, Color.BtcUsd, btcUsdPrices)
  const data: reactChartjs.ChartData<chartjs.ChartData> = {
    labels: finishTimes,
    datasets: [usdDataset, btcDataset, btcUsdDataset],
  }

  return <reactChartjs.Line data={data} options={OPTIONS} />
}

const USD_AXIS: chartjs.ChartYAxe = {
  id: AxisId.Usd,
  type: "linear",
  position: "left",
  ticks: {
    callback: (value) => `$${value}`,
  },
}
const BTC_AXIS: chartjs.ChartYAxe = {
  id: AxisId.Btc,
  type: "linear",
  position: "left",
  ticks: {
    callback: (value) => `₿${value}`,
  },
}
const BTC_USD_AXIS: chartjs.ChartYAxe = {
  id: AxisId.BtcUsd,
  type: "linear",
  position: "right",
  ticks: {
    callback: (value) => `$${value}`,
  },
}

const OPTIONS: chartjs.ChartOptions = {
  animation: { duration: 0 },
  scales: {
    yAxes: [USD_AXIS, BTC_AXIS, BTC_USD_AXIS],
  },
}

function dataset(label: string, yAxisID: AxisId, borderColor: Color, data: any[]): chartjs.ChartDataSets {
  return {
    label: label,
    yAxisID: yAxisID,
    fill: false,
    borderColor: borderColor,
    data: data,
  }
}

interface AppState {
  all: {
    finishTimes: any[]
    usdBalances: any[]
    btcBalances: any[]
    btcUsdPrices: any[]
  }
}

const mapStateToProps: MapStateToProps<StateProps, OwnProps, AppState> = state => {
  return {
    finishTimes: state.all.finishTimes,
    usdBalances: state.all.usdBalances,
    btcBalances: state.all.btcBalances,
    btcUsdPrices: state.all.btcUsdPrices,
  }
}

export default connect(mapStateToProps)(BalanceAll)
