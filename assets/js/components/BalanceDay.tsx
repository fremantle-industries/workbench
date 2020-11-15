import * as React from "react"
import { connect, MapStateToProps } from "react-redux"
import * as reactChartjs from "react-chartjs-2"
import * as chartjs from "chart.js"

enum Color {
  Min = "#820082",
  Max = "#ff00ff"
}

/* eslint-disable-next-line @typescript-eslint/no-empty-interface */
interface OwnProps {
}

interface StateProps {
  days: any[]
  usdMin: any[]
  usdMax: any[]
}

interface Props extends OwnProps, StateProps {}

const BalanceDay: React.FC<Props> = ({ days, usdMin, usdMax }) => {
  const usdMinDataset: chartjs.ChartDataSets = dataset("USD Min Balance", Color.Min, usdMin)
  const usdMaxDataset: chartjs.ChartDataSets = dataset("USD Max Balance", Color.Max, usdMax)
  const data: reactChartjs.ChartData<chartjs.ChartData> = {
    labels: days,
    datasets: [usdMaxDataset, usdMinDataset],
  }

  return <reactChartjs.Line data={data} options={OPTIONS} />
}

enum AxisId {
  Usd = "usd"
}

const USD_AXIS: chartjs.ChartYAxe = {
  id: AxisId.Usd,
  type: "linear",
  position: "left",
  ticks: {
    callback: (value) => `$${value}`,
  },
}

const OPTIONS: chartjs.ChartOptions = {
  scales: {
    yAxes: [USD_AXIS],
  },
}

function dataset(label: string, borderColor: Color, data: any[]): chartjs.ChartDataSets {
  return {
    label: label,
    fill: false,
    borderColor: borderColor,
    data: data,
  }
}

interface AppState {
  day: {
    days: any[],
    usdMin: any[],
    usdMax: any[],
  }
}

const mapStateToProps: MapStateToProps<StateProps, OwnProps, AppState> = state => {
  return {
    days: state.day.days,
    usdMin: state.day.usdMin,
    usdMax: state.day.usdMax,
  }
}

export default connect(mapStateToProps)(BalanceDay)
