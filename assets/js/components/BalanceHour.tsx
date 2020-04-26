import React from 'react';
import { connect, MapStateToProps } from 'react-redux';
import { Line, ChartData } from 'react-chartjs-2';
import * as chartjs from 'chart.js'

interface OwnProps {
}

interface StateProps {
  hours: any[]
  usdMin: any[]
  usdMax: any[]
}

interface Props extends OwnProps, StateProps {}

const BalanceHour: React.FC<Props> = ({ hours, usdMin, usdMax }) => {
  const usdMinDataset: chartjs.ChartDataSets = dataset('USD Min Balance', Color.Min, usdMin)
  const usdMaxDataset: chartjs.ChartDataSets = dataset('USD Max Balance', Color.Max, usdMax)
  const data: ChartData<chartjs.ChartData> = {
    labels: hours,
    datasets: [usdMaxDataset, usdMinDataset]
  }

  return <Line data={data} options={OPTIONS} />
};

enum Color {
  Min = '#820082',
  Max = '#ff00ff'
}

enum AxisId {
  Usd = 'usd'
}

const USD_AXIS: chartjs.ChartYAxe = {
  id: AxisId.Usd,
  type: 'linear',
  position: 'left',
  ticks: {
    callback: (value: any, _index: any,  _values: any) => `$${value}`
  }
}

const OPTIONS: chartjs.ChartOptions = {
  scales: {
    yAxes: [USD_AXIS]
  }
}

function dataset(label: string, borderColor: Color, data: any[]): chartjs.ChartDataSets {
  return {
    label: label,
    fill: false,
    borderColor: borderColor,
    data: data
  }
}

interface AppState {
  hour: {
    hours: any[]
    usdMin: any[]
    usdMax: any[]
  }
}

const mapStateToProps: MapStateToProps<StateProps, OwnProps, AppState> = state  => {
  return {
    hours: state.hour.hours,
    usdMin: state.hour.usdMin,
    usdMax: state.hour.usdMax,
  }
}

export default connect(mapStateToProps)(BalanceHour)
