import React from "react";
import { Line } from 'react-chartjs-2';

const USD_LABEL = 'USD Balance'
const BTC_LABEL = 'BTC Balance'
const BTC_USD_LABEL = 'BTC/USD Price'

const OPTIONS = {
  scales: {
    yAxes: [
      {
        id: USD_LABEL,
        type: 'linear',
        position: 'left',
      },
      {
        id: BTC_LABEL,
        type: 'linear',
        position: 'left',
      },
      {
        id: BTC_USD_LABEL,
        type: 'linear',
        position: 'right',
      }
    ]
  }
}

const Balances = ({ finishTimes, usdBalances, btcBalances, btcUsdPrices }) => {
  const usdDataset = dataset(USD_LABEL, '#02c802', usdBalances)
  const btcDataset = dataset(BTC_LABEL, '#ffb326', btcBalances)
  const btcUsdDataset = dataset(BTC_USD_LABEL, '#6fafff', btcUsdPrices)
  const data = {
    labels: finishTimes,
    datasets: [usdDataset, btcDataset, btcUsdDataset]
  }

  return <Line data={data} options={OPTIONS} />
};

function dataset(label, borderColor, data) {
  return {
    label: label,
    yAxisID: label,
    fill: false,
    borderColor: borderColor,
    data: data
  }
}

export default Balances;
